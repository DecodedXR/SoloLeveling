# Wargame: Glute Bridge Verification Pipeline (Pro Exercise)

**Mission:** Prove or kill the glute-bridge state machine via the corpus
protocol that validated squats. Supine posture — the same pose-model risk
class as sit-ups, so this mission is sequenced AFTER the sit-up row resolves
and inherits its evidence. Own signals, state machine, corpus.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for
all code/analysis; `[HUMAN]` steps are the user with a phone.

**Deliverable:** `wargames/output/glutebridge-report.md` + the evaluated
pipeline in the kill-test codebase.

## HARD GATE — recon flags (check first, in order)

- **R0:** `LEDGER.md` shows the squat kill test WIN AND the sit-up row
  (`wargames/situp-pipeline.md`) **resolved**. Sit-up WIN → the supine
  posture is proven; the R2 scout below shrinks to a formality (run it
  anyway — bridge geometry differs at the top). Sit-up aborted on A1
  (supine invisible) → this mission is presumptively dead; run R2 only to
  confirm, expect to report a kill without recording a corpus.
- **R1:** Harness + `evaluate.py` reproduce recorded metrics for all WIN
  corpora. Fail → halt.
- **R2:** Bridge scout: `[HUMAN]` records ONE 20s clip — lying flat, 4–5
  bridges, side view, phone at floor level ~2m away. Hips/knees/shoulders
  must be trusted lying flat AND at the top of the bridge (hips high, body
  arched — a shape neither squat nor sit-up produced). Untrusted majority →
  report; kill signal.
- **R3:** If LEDGER row 12 (Vision parity) landed, extract this corpus
  through both backends (V4). Unresolved → MediaPipe-only, replay owed.

## Signal design (binding — position, never velocity)

- **Calibration:** the sit-up's 2s lying-flat hold, extended: lying hip-y,
  shoulder-y, knee-y, pixel thigh length (hip→knee).
- **Primary signal:** hip-rise ratio
  `(lying_hip_y − hip_y) / thigh_length_px` — thigh length is the natural
  normalizer because a full bridge lifts the hip toward the shoulder–knee
  line, a distance set by thigh geometry.
- **Joint evidence (anti-cheat):** hip-rise AND shoulders stay grounded
  within a band of lying shoulder-y (kills the "arch the whole back /
  shoulder-stand" substitution and rolling) AND knees stay bent (knee-y
  band — kills the straight-leg reverse-plank substitution). Bands
  generous; verification, not form coaching (C14).
- **Hysteresis state machine:** LYING → RISING (ratio > A) → height-valid
  (max ratio ≥ B) → DESCENDING → LYING (ratio < A). Untrusted frames freeze
  state. Single-leg bridges: ACCEPT (harder variant, same hip signal); the
  machine must not require both ankles trusted. Weighted hip thrusts
  (shoulders on a bench): OUT of v1 scope — different calibration geometry;
  a bench-thrust clip is a negative and the setup gate prescribes
  floor-only.
- **The depth-line policy (surfaced, not buried):** B separates a full
  bridge (hips reach the shoulder–knee line) from a pelvic-tilt pulse. As
  with sit-ups' crunch line: corpus labels partial pulses as their own
  class, the report carries the acceptance table at B and a looser B′, and
  the final line is a human product call with data attached.

## Battle plan

### Step 0 `[HUMAN]` — Corpus (~1 evening, AFTER R2 passes)
Views: side ×majority + 45° ×3 + 3 front clips (to prove failure — supine
front view is foreshortened). Qualities: clean ×5, deliberate partial
pulses ×5 (labeled `partial`), paused-at-top, fast, single-leg ×3, one set
to failure; conditions: good light/dim, mat/floor. Negatives (must count
0): lying still 60s, sit-ups (the roster neighbor — a sit-up set must NOT
count as bridges: shoulders leave the ground, exactly what the shoulder
band forbids; label it), leg raises, rolling over, getting up off the
floor, bench hip thrust ×1. Labels CSV with `class`
(`full`, `partial`, `negative`).
- **Expected observation:** ≥28 clips + labels on desktop.
- **Counter-move:** missing matrix cell → record before Step 3 tunes.

### Step 1 — Extend harness
Add hip-rise + extended lying calibration extraction (reuse, don't fork).
Per-clip PNGs of the hip-rise ratio.
- **Expected observation:** rep oscillations visible by eye in ≥80% of
  side-view clips; lying-still negative flat (breathing must not oscillate
  hip-y — if it does, A's floor sits above measured breathing amplitude,
  same rule as sit-ups).
- **Counter-move:** invisible in side view good light → axis/index check;
  still invisible → abort A1.

### Step 2 — State machine + lie detectors
Implement per signal design; detectors via thigh length, teleport,
left/right hip coherence. Hand-check 3 clips.
- **Expected observation:** timestamps match by eye; the sit-up negative
  counts 0 (shoulder band working); the bench-thrust clip counts 0
  (calibration geometry mismatch → untrusted or below-threshold, either is
  acceptable — record which).
- **Counter-move:** double counts → widen A/B; missed paused-at-top →
  forbidden-term hunt.

### Step 3 — Tune & cross-validate
Grid-search A/B on side-view good-light; freeze; evaluate held-out.
Targets: ≥95% recall good-faith bridges, ≥90% partial rejection, **0**
negatives. Produce the B/B′ partial-acceptance table.
- **Expected observation:** targets met held-out; table present;
  single-leg clips inside the recall pool.
- **Counter-move:** fatigue failures → lower B (policy); 45°-only failures
  → side-view prescription (fork F1).

### Step 4 `[HUMAN]` — Friends pass
3–5 people, frozen thresholds: lying calibration + 2 sets + 1 negative
(a few sit-ups). ≥90% agreement, 0 phantoms, 0 sit-ups counted.
- **Counter-move:** one fails → ratio inspection (hip mobility varies;
  depth-line policy); most fail → thigh-length normalization not
  transferring, abort A2.

## Fork triggers
- **F1:** 45° unusable → side-view-only prescription in the bridge setup
  gate. Condition: ≥80% recall side AND <50% at 45°.
- **F2:** Single-leg bridges systematically rejected (>30% fail on
  something other than depth) → the evidence bands are reading the raised
  leg; restrict evidence to the grounded side and re-run Step 3 once;
  accessibility beats strictness.
- **F3:** Partial-pulse acceptance at tuned B exceeds 50% (line doesn't
  separate) → escalate the depth line to the human as BLOCKING before
  ship, with both tables. Condition: measured rate, not judgment.

## Abort conditions
- **A1:** Signal invisible in side-view good light (Step 1) — with a
  sit-up WIN on the books this points at bridge-top geometry specifically;
  report which posture region loses trust. Halt.
- **A2:** Friends pass fails broadly.
- **A3:** R0/R1/R2 gate failures.

## Verification runs
- **V1:** `evaluate.py` prints the bridge metrics table; targets met.
- **V2:** Re-run twice → byte-identical.
- **V3:** Regression — all prior WIN corpora re-run; metrics unchanged.
- **V4:** *(if Vision CLI exists)* frozen-threshold Vision replay within
  the parity band; else owed.
- **Proven** when V1–V3 (+V4) pass and Step 4 hits its observation.

## Red-team pass
1. **Weakest assumption:** pose trust at the TOP of the bridge — an arched
   body with hips as the apex appears in no prior corpus; the sit-up WIN
   proves lying-flat, not the arch. *Fix:* R2's scout explicitly checks the
   top-of-bridge posture, not just supine rest.
2. **Likely screw-up:** treating partial pulses as `shallow` rejects and
   tuning the line without surfacing the policy. *Fix:* own label class +
   mandatory B/B′ table + F3's blocking escalation — same mechanism that
   worked for the sit-up crunch line.
3. **Sit-up cross-counting:** the roster's two supine exercises live in the
   same picker; a user doing sit-ups under "bridge" (or vice versa) must
   not score. *Fix:* sit-ups are a mandatory bridge negative here, and the
   report notes the reciprocal check for the sit-up harness (bridges as a
   sit-up negative) as one added regression clip.
4. **Hip landmark occlusion at apex:** at the top, the pelvis is the
   highest point with clothing bunched — hip landmark quality may dip at
   the exact evaluation moment. *Fix:* height-valid holds across brief
   untrusted gaps (freeze, not reset), and Step 2's hand-check verifies no
   rep is eaten by a one-frame dip.
5. **Breathing false-arms redux:** supine rest oscillates the torso.
   *Fix:* Step 1's lying-still flatness requirement with A floored above
   measured breathing amplitude — inherited verbatim from the sit-up plan
   because it bit there first.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
