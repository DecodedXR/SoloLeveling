# Wargame: Lunge Verification Pipeline (Pro Exercise)

**Mission:** Prove or kill the lunge state machine via the corpus protocol
that validated squats. Lunge is a Pro-roster exercise (SUB F17: ships only
when its state machine passes the corpus protocol). It is the **cheapest
possible roster add**: standing body, same standing calibration, same
hip-drop primary signal as squats — only the thresholds, stance evidence,
and corpus are new. Own thresholds; never reuse squat A/B.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for
all code/analysis; `[HUMAN]` steps are the user with a phone.

**Deliverable:** `wargames/output/lunge-report.md` + the evaluated pipeline
in the kill-test codebase.

## HARD GATE — recon flags (check first, in order)

- **R0:** `LEDGER.md` shows the squat kill test WIN. Not WIN → halt (this
  reuses its harness, calibration, and normalization wholesale).
- **R1:** Harness + `evaluate.py` reproduce recorded squat metrics. Fail →
  halt; foundation moved.
- **R2:** NO scout clip needed — standing bodies are the pose model's home
  territory and the squat WIN already proves the posture. (This is the only
  roster exercise with no scout gate; that's why it's first after sit-ups.)
- **R3:** If LEDGER row 12 (Vision parity) landed, this corpus extracts
  through both backends (V4). Unresolved → MediaPipe-only, Vision replay
  recorded as owed in the report.

## Signal design (binding — position, never velocity)

- **Calibration:** the squat's 2s standing calibration, unchanged: standing
  hip-y, ankle-y, pixel leg length.
- **Primary signal:** the squat's hip-drop ratio
  `(hip_y − standing_hip_y) / (standing_hip_y − ankle_y)` — identical
  construction; lunge-specific A/B thresholds from a fresh grid-search
  (an honest lunge bottoms out shallower in hip-y than a squat; copied
  squat thresholds would reject nearly everything).
- **Stance evidence (what makes it a lunge, not a squat):** at depth-valid,
  the two ankles are horizontally separated by more than a stance threshold
  S (ratio of pixel leg length, tuned in Step 3) — a feet-together dip fails
  stance and doesn't count *as a lunge*. Use x-separation in front view and
  the near/far ankle-y disagreement in side view (side view collapses x;
  Step 1 measures which view carries stance signal — that finding shapes the
  in-app setup prescription).
- **Hysteresis state machine:** STANDING → DESCENDING (ratio > A) →
  depth-valid (min ratio ≥ B AND stance ≥ S) → ASCENDING → STANDING.
  Untrusted frames freeze state. Alternating vs same-leg lunges: BOTH count
  (v1 verifies motion, not programming); the per-rep record notes which leg
  led (front-view ankle x-order) as a stat, never a gate.
- **Walking lunges:** OUT of v1 scope — the subject translates across frame,
  breaking the fixed-calibration geometry. In-app setup prescribes
  stationary lunges; walking lunges are a negative clip (below) and must
  count 0 under the stationary machine or the finding is reported.

## Battle plan

### Step 0 `[HUMAN]` — Corpus (~1 evening)
Matrix per ENG §5: views front + side + 45°; qualities: clean alternating
×5, clean same-leg ×3, deliberately shallow ×5, paused-at-bottom, fast, one
honest set to failure; conditions: good light/dim, shorts/sweatpants.
Negatives (must count 0): walking through frame, squats (a squat set must
NOT count as lunges — stance evidence is the separator; label it), standing
weight-shifts side to side, step-ups onto a chair, walking lunges across
frame, tying shoes. Labels CSV: `filename, valid_reps, notes` + `class`
(`lunge`, `shallow`, `negative`).
- **Expected observation:** ≥28 clips + labels on desktop.
- **Counter-move:** missing matrix cell → record before Step 3 tunes.

### Step 1 — Extend harness
Add ankle x-separation + per-leg ankle-y tracking to the existing harness
(reuse, don't fork). Per-clip PNGs: hip-drop ratio AND stance separation on
the same time axis.
- **Expected observation:** rep oscillations visible by eye in ≥80% of
  front/side clips; stance separation clearly elevated during lunge clips vs
  the squat negatives; negative clips flat or stance-failing.
- **Counter-move:** hip oscillation invisible → axis/index check, then abort
  A1. Stance signal not separating lunges from squats in EITHER view →
  the stance-evidence design fails; report before Step 2 (fork F2 decides).

### Step 2 — State machine + lie detectors
Implement per the signal design; reuse detectors (bone-length, teleport,
left/right coherence). Hand-check rep timestamps on 3 clips.
- **Expected observation:** timestamps match video by eye; the squat
  negative counts 0 (stance gate working).
- **Counter-move:** double counts → widen A/B; missed paused reps → hunt for
  forbidden time/velocity terms.

### Step 3 — Tune & cross-validate
Grid-search A/B/S on front-view good-light; freeze; evaluate held-out.
Targets: ≥95% recall good-faith lunges, ≥90% shallow rejection, **0**
negatives (squat clips and walking lunges included).
- **Expected observation:** targets met held-out.
- **Counter-move:** fatigue failures → lower B (policy); one view carries
  stance but the other doesn't → in-app setup prescribes the working view
  (fork F1).

### Step 4 `[HUMAN]` — Friends pass
3–5 people, frozen thresholds: calibration + 2 sets + 1 negative (their
negative should be a few squats). ≥90% agreement, 0 phantoms, 0 squats
counted.
- **Counter-move:** one fails → ratio inspection (depth-line policy); most
  fail → abort A2.

## Fork triggers
- **F1:** stance evidence works in only one view (Step 3 condition) →
  prescribe that view in the app's lunge setup gate.
- **F2:** stance evidence separates lunges from squats in NO view (Step 1) →
  drop the squat-vs-lunge separation as a machine concern: the user selected
  "lunge" in the picker, so mislabeled squats are user error, not cheating —
  ship depth-only with the squat-negative requirement removed, and record
  the decision + its abuse surface (squatting into the lunge picker earns
  the same XP either way; C5 pricing is uniform, so the abuse value is zero).

## Abort conditions
- **A1:** Hip-drop signal invisible in good light (Step 1) — would
  contradict the squat WIN; suspect harness regression first, then halt.
- **A2:** Friends pass fails broadly.
- **A3:** R0/R1 gate failures.

## Verification runs
- **V1:** `evaluate.py` prints the lunge metrics table; targets met.
- **V2:** Re-run twice → byte-identical.
- **V3:** Regression — squat corpus (+ push-up/sit-up corpora if those rows
  are WIN) re-run through the extended harness; metrics unchanged.
- **V4:** *(if Vision CLI exists per R3)* frozen-threshold Vision replay
  within the parity band, else "owed" in the report.
- **Proven** when V1–V3 (+V4) pass and Step 4 hits its observation.

## Red-team pass
1. **Weakest assumption:** stance separation is measurable in side view —
   x collapses and ankle-y disagreement may be noise-level. *Fix:* Step 1
   measures per-view separability BEFORE tuning; F1/F2 are the named exits.
2. **Likely screw-up:** copying squat A/B "since it's the same signal."
   *Fix:* stated twice (mission + signal design); Step 3 mandates a fresh
   grid-search including S.
3. **Squats scored as lunges:** the abuse case with zero XP value (uniform
   pricing) but real trust cost if visible. *Fix:* squat clips are mandatory
   negatives; F2 documents the fallback's reasoning if separation fails.
4. **Walking-lunge drift:** subjects drift across frame breaking
   calibration geometry silently. *Fix:* out of scope by design; the
   walking-lunge negative clip proves the machine doesn't phantom-count it.
5. **Back-knee ambiguity:** honest depth varies with mobility; the back
   knee needn't touch the floor. *Fix:* generous B per the fatigue policy;
   the friends-pass counter-move routes disagreement to depth-line policy,
   not code.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
