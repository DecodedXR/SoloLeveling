# Wargame: Jumping Jack Verification Pipeline (Pro Exercise)

**Mission:** Prove or kill the jumping-jack state machine via the corpus
protocol that validated squats. Standing posture (no scout gate), but the
FASTEST exercise on the roster (~2 reps/s honest cadence) — the mission's
center of gravity is whether 30fps sampling and the frame-level lie
detectors survive genuinely fast limbs, not whether the pose layer can see
the body. Own signals, state machine, corpus.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for
all code/analysis; `[HUMAN]` steps are the user with a phone.

**Deliverable:** `wargames/output/jumpingjack-report.md` + the evaluated
pipeline in the kill-test codebase.

## HARD GATE — recon flags (check first, in order)

- **R0:** `LEDGER.md` shows the squat kill test WIN. Not WIN → halt.
- **R1:** Harness + `evaluate.py` reproduce recorded squat metrics. Fail →
  halt.
- **R2:** Frame-rate check: confirm the corpus phone records ≥30fps
  (kill-test R2 already verified this) and note the actual fps of one test
  clip. At 30fps a 0.5s rep gives ~15 frames/cycle — workable; if clips
  land at 15fps (aliasing territory: ~7 frames/cycle) → record 60fps if the
  phone supports it, else flag the sampling risk before the corpus evening.
- **R3:** If LEDGER row 12 (Vision parity) landed, extract this corpus
  through both backends (V4). Unresolved → MediaPipe-only, replay owed.

## Signal design (binding — position, never velocity)

- **Calibration:** the standing calibration, extended: standing hip-y,
  ankle-y, pixel leg length, PLUS ankle x-separation at rest and nose-y.
- **Signals (two, both required per rep):**
  - **Leg spread ratio:** `|ankle_L_x − ankle_R_x| / leg_length_px` — feet
    together (≈ calibration value) vs apart.
  - **Arm raise line:** wrist-y above nose-y (arms overhead) — a line
    anchored to the body, not a tuned ratio.
- **Hysteresis state machine:** CLOSED (feet together, wrists below
  shoulders) → OPENING → OPEN-valid (spread ≥ B AND both wrists above
  nose-y) → CLOSING → CLOSED (spread ≤ A). A < B hysteresis on spread;
  the arm line is evidence at OPEN, not a second tuned threshold. Untrusted
  frames freeze state. Half-jacks (arms only or legs only): NOT valid — the
  rep is the compound; half-jack clips are the `shallow` class here.
- **Front view is the primary view** (spread lives in x; side view collapses
  it — the inverse of the lunge situation). Side clips are recorded to
  prove failure and inform the setup prescription, not to pass.
- **Per-exercise detector caps (the load-bearing change):** the teleport
  cap tuned for squat hips WILL false-fire on honest jack wrists (a hand
  legitimately traverses ~40% of frame height in ~150ms). Detector caps
  become per-exercise config: Step 1 measures the honest per-frame
  displacement distribution for wrists/ankles from clean clips and sets the
  jack caps above the honest p99, below physical absurdity. The state-freeze
  rule is unchanged — only the caps move. Squat/push-up/sit-up caps are NOT
  touched (V3 proves it).

## Battle plan

### Step 0 `[HUMAN]` — Corpus (~1 evening)
Views: front ×majority + 3 side clips (to prove failure) + 45° ×3.
Qualities: clean ×5 at natural cadence, deliberately fast ×3 (max cadence —
the aliasing probe), slow/deliberate ×2, half-jacks arms-only ×3 and
legs-only ×3 (labeled `shallow`), one set to failure (cadence decay);
conditions: good light/dim. Negatives (must count 0): standing arm swings
without jumping... (careful: arms-overhead + no spread = half-jack, already
`shallow`), jogging in place, arm circles, stretching side bends, walking
through frame, star jumps to a stop (single jump then stand ×3). Labels CSV
with `class` (`full`, `shallow`, `negative`).
- **Expected observation:** ≥28 clips + labels on desktop.
- **Counter-move:** missing matrix cell → record before Step 3 tunes.

### Step 1 — Extend harness + measure honest velocity
Add ankle-spread + wrist/nose extraction (reuse, don't fork). Per-clip PNGs:
spread ratio and wrist-minus-nose y on one time axis. THEN compute the
per-frame displacement distribution (wrists, ankles) across clean clips and
set the jack teleport caps (p99 honest + margin); record the numbers in the
report.
- **Expected observation:** open/close oscillations visible by eye in ≥80%
  of front clips; with squat-tuned caps a large fraction of honest fast
  frames would be flagged (measured, not assumed) and with jack caps the
  untrusted rate in clean clips drops below 10%.
- **Counter-move:** oscillations invisible in front good light → axis/index
  check, then abort A1. Untrusted rate still >10% after cap adjustment →
  the pose layer is dropping/blurring fast limbs; check the fast-cadence
  clips separately — if only max-cadence clips fail, that's fork F2, not an
  abort.

### Step 2 — State machine + lie detectors
Implement per signal design with per-exercise caps. Hand-check 3 clips —
counting jacks by eye is fast; check FULL clips, not samples.
- **Expected observation:** counts match video; jogging-in-place counts 0
  (no spread), single star jumps count ≤1 each by the cycle rule (and the
  label says whether that 1 is valid — a full single jack IS a rep).
- **Counter-move:** double counts at speed → widen A/B gap first; if the
  gap can't close it, the sampling is aliasing (fork F2).

### Step 3 — Tune & cross-validate
Grid-search A/B (spread) on front-view good-light; freeze; evaluate
held-out. Targets: ≥95% recall good-faith jacks, ≥90% half-jack rejection,
**0** negatives.
- **Expected observation:** targets met held-out, including the
  natural-cadence clips; max-cadence clips reported separately.
- **Counter-move:** failures concentrated in max-cadence clips → fork F2;
  failures spread across cadences → the signal design is wrong, report.

### Step 4 `[HUMAN]` — Friends pass
3–5 people, frozen config: calibration + 2 sets (~20 jacks each) + 1
negative (jog in place). ≥90% agreement, 0 phantoms.
- **Counter-move:** one fails → inspect spread ratios (leg-length
  normalization); most fail → abort A2.

## Fork triggers
- **F1:** Side view unusable (expected by design) → front-view prescription
  in the jack setup gate. Condition: ≥80% recall front AND <50% side.
- **F2:** Max-cadence clips fail targets but natural-cadence clips pass
  (condition: recall ≥95% at natural, <80% at max) → ship with a cadence
  note: the in-app live counter's "hold pace" guidance and the report's
  honest statement that reps beyond ~2.5/s may undercount — undercounting
  is the acceptable failure direction (missed XP annoys; phantom XP is the
  product-killer). If the phone records 60fps, a 60fps re-extraction of the
  fast clips is run first to check whether sampling alone recovers them.
- **F3:** The arm line (wrist above nose) rejects >20% of honest reps
  (people's honest jacks don't fully raise arms overhead) → lower the line
  to wrist-above-shoulder and re-run Step 3 once; the report records both
  lines' tables — depth-line policy, human decides the definition.

## Abort conditions
- **A1:** Spread signal invisible in front-view good light (Step 1).
- **A2:** Friends pass fails broadly.
- **A3:** R0/R1 gate failures.

## Verification runs
- **V1:** `evaluate.py` prints the jack metrics table; targets met.
- **V2:** Re-run twice → byte-identical.
- **V3:** Regression — all prior WIN corpora re-run through the harness
  WITH the per-exercise cap config in place; prior metrics unchanged (this
  V-run exists specifically because the cap refactor touches shared code).
- **V4:** *(if Vision CLI exists)* frozen-threshold Vision replay within
  the parity band; else owed. NOTE: Vision on fast motion is unmeasured
  territory — if V4 runs, report its untrusted-rate delta on the fast clips
  explicitly.
- **Proven** when V1–V3 (+V4) pass and Step 4 hits its observation.

## Red-team pass
1. **Weakest assumption:** 30fps sampling survives 2 reps/s. *Fix:* R2
   checks fps up front; Step 0 records max-cadence probes; F2 is the
   honest-undercount exit with a 60fps recovery path.
2. **Likely screw-up:** loosening the SHARED teleport cap to stop the
   false-fires, silently weakening squat/push-up/sit-up hallucination
   defense. *Fix:* per-exercise caps by design; V3 re-runs all prior
   corpora because the refactor touches shared code.
3. **Motion blur at the extremes:** hands blur at the top, ankles at
   landing; landmarks wobble exactly at the OPEN evaluation moment. *Fix:*
   OPEN-valid needs spread AND arm line on the SAME trusted frame — but the
   state machine holds OPEN-candidacy across a short untrusted gap (state
   freeze, not state reset), so one blurred frame doesn't eat a rep;
   Step 2's full-clip hand-check catches it if it does.
4. **The jogging negative is adversarially close:** feet leave the ground,
   arms pump — but ankles never spread and wrists never pass the nose; two
   independent gates must both fail for a phantom. *Fix:* it's in the
   negative corpus; if it scores, that's an A-level finding reported, never
   tuned away silently.
5. **Landing-impact camera shake:** jumping near a propped phone shakes it;
   the IMU still-phone check may flag honest sets. *Fix:* Step 0's setup
   places the phone ≥2m away on stable ground (not a bed/soft surface —
   say so in the corpus instructions); if friends-pass phones get shaken,
   that's setup-gate prescription input, recorded in the report.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
