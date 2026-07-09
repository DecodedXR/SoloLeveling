# Signals layer design — Apple Vision → Verifier adapter

Scope: the module between Capture (AVFoundation frames → Vision body-pose
observations) and the Verifier (ADR-9 pure module, `PoseFrame` in). This is
where every backend-specific fact is absorbed so the Verifier stays byte-tied
to the Python reference. Written before M3 so the port lands on a decided
design instead of improvisation.

## 1. Joint mapping — Vision 19 → PoseFrame 33-slot layout

The Verifier consumes MediaPipe-indexed slots. Vision provides named joints.
The Verifier reads ONLY these 8 slots; all other slots are set to NaN
(never read — NaN keeps any accidental future read loud).

| PoseFrame slot | MediaPipe name | Vision `JointName` |
|---|---|---|
| 11 | left_shoulder | `.leftShoulder` |
| 12 | right_shoulder | `.rightShoulder` |
| 23 | left_hip | `.leftHip` |
| 24 | right_hip | `.rightHip` |
| 25 | left_knee | `.leftKnee` |
| 26 | right_knee | `.rightKnee` |
| 27 | left_ankle | `.leftAnkle` |
| 28 | right_ankle | `.rightAnkle` |

Left/right: Vision names joints anatomically (the subject's left), matching
MediaPipe's convention. The Verifier is L/R-symmetric everywhere (means and
either-side checks), so even a swapped mapping cannot change output — but map
correctly anyway.

## 2. Coordinate transform — THE inversion trap

- MediaPipe (what all thresholds were frozen against): normalized, origin
  **top-left, y grows DOWN**. A deep squat has hip-y INCREASING.
- Vision `VNRecognizedPoint`: normalized, origin **bottom-left, y grows UP**.

The adapter MUST emit `y_pose = 1.0 − y_vision`. Getting this wrong doesn't
crash — it silently makes standing look deep and squats look like standing,
which is ENG red-team #2 ("y-axis orientation") and risk R6. The capture
smoke test (§6) exists to catch exactly this before any tuning discussion.

x is passed through unchanged. Front-camera mirroring flips x consistently
within a session; the Verifier's only x uses (ankle-drift |Δx|, shin length)
are mirror-invariant, so no de-mirroring is required.

## 3. Confidence semantics — the run #12 risk, named

`MIN_VIS = 0.5` was frozen against **MediaPipe `visibility`**. Vision's
per-point `confidence` is a different scale from a different model — 0.5 does
NOT mean the same thing. This is precisely the `vision-backend-parity`
wargame's subject (ledger run #12) and must not be resolved by feel.

Adapter contract: map `confidence` into the PoseFrame visibility slot
UNCHANGED, and treat the trust threshold as a **per-backend constant**
(`visionMinConfidence`, initially 0.5) that run #12's protocol validates:
record Vision-derived CSVs in the corpus schema (via the §5 debug recorder),
replay through the Python evaluator at frozen thresholds, and only then
accept or adjust the per-backend constant. Adjusting it is a calibration of
the ADAPTER, not a retune of the Verifier (whose thresholds stay frozen).

## 4. Batch → live: VerifierSession

The port's `Verifier.count()` is batch (whole clip in). The live set needs
streaming. M3 refactors — mechanically, no logic changes — into:

```
VerifierSession(calibration: Calibration, a:, b:)
  .ingest(_ frame: PoseFrame) -> Verdict?   // nil, .repCounted, .tooShallow, ...
```

- `Verifier.count()` is then reimplemented as `calibrate() + session.ingest`
  over the array — the corpus parity test keeps guarding the refactor. This
  is the invariant: batch and streaming share one state machine.
- Live calibration comes from the ARMING GATE (C2/C4): user stands ~1s with
  all 8 joints trusted → that window IS the calibration (stand hip, leg,
  shin, torso). The corpus harness's highest-stable-window scan is a
  batch-only convenience and is NOT ported to live — arming replaces it.
  (The stranger corpus proved why: walk-around videos break window-scanning,
  and the armed-session protocol is what makes calibration trustworthy.)
- "Too shallow" verdict (C3): a completed cycle whose min ratio never reached
  B. In batch this is silently not-a-rep; live MUST surface it (SPEC §4
  screen 5). The session emits it as a distinct verdict — an addition ON TOP
  of the state machine, never a change to what counts.

## 5. Debug pose recorder (build in M3, tiny)

A debug-only capture mode that writes Vision output as corpus-schema CSVs
(t + 33 × x,y,z,visibility; z = NaN — Vision is 2D and the Verifier never
reads z). This one small tool gives us: the run #12 Vision-parity corpus,
live-vs-corpus divergence forensics for M4's counter-move, and future
exercise corpora recorded straight from the phone.

## 6. Capture smoke test (M3 check, before fixtures matter)

One person, one squat, phone propped: hip-y plot from the debug recorder must
dip DOWN in Vision-space→PoseFrame space (i.e. ratio positive at depth), shin
length ~constant, all 8 joints ≥ threshold while standing. Catches the y-flip,
mirroring, and rotation classes in one minute.

## 7. IMU + GPS inputs (unchanged pass-throughs)

- CoreMotion accelerometer variance → `imuStill: Bool` at ~10 Hz; false
  pauses the session ("keep the phone still", C11). Never enters the
  Verifier — it gates frame delivery, mirroring the corpus assumption of a
  propped phone.
- Frame drops / app backgrounding: missing frames are NOT synthesized; the
  session simply doesn't ingest (state holds, C9). The observed-fraction rep
  validity (MIN_OBSERVED) then correctly voids reps the camera didn't see.

## Open items for M3 (decided-by-then, not now)

1. Vision request rate: every frame at 30fps vs every-Nth under thermal
   pressure (ADR-8 R1 mitigation) — measure first on the floor device.
2. `visionMinConfidence` final value — owned by run #12's replay protocol.
3. Whether Vision's `.root` (mid-hip) joint is more stable than the L/R hip
   mean — only revisit if the Vision-parity replay shows hip jitter.
