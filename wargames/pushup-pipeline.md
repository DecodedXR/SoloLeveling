# Wargame: Push-Up Verification Pipeline (Second Exercise)

**Mission:** Prove or kill the push-up state machine using the same corpus
protocol that validated squats. Push-up is v1's second free exercise (SPEC
C12); it gets its own signals, state machine, and corpus — the squat pipeline
is the template for *process*, not for thresholds.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for all
code/analysis; `[HUMAN]` steps are the user with a phone.

**Deliverable:** `wargames/output/pushup-report.md` + the evaluated pipeline
in the kill-test codebase.

## HARD GATE — recon flags (check first, in order)

- **R0:** `LEDGER.md` shows the squat kill test (`wargames/workout-tracker-
  verification.md`) with outcome **WIN**. Anything else → **halt immediately**:
  this mission reuses its harness, corpus protocol, and proven normalization
  approach. Running before the squat verdict wastes the corpus evening.
- **R1:** The squat extraction harness + evaluator (`evaluate.py` per ENG V1)
  exist and run on the squat corpus reproducing its recorded metrics. Fail →
  halt; the foundation moved.
- **R2:** MediaPipe landmark quality for prone/horizontal bodies is unknown
  territory vs standing — before recording a full corpus, run the harness on
  ONE scout clip (`[HUMAN]`: a single 20s push-up clip, side view) and check
  landmarks are trusted for shoulders/elbows/wrists/hips at the bottom of the
  rep. Untrusted majority → this is the kill-signal analog of ENG A1; report
  before any further recording.

## Signal design (binding, from ENG's principles — position, never velocity)

- **Calibration:** 2s **plank hold** at set start (analog of standing
  calibration): capture shoulder-y, wrist-y, hip-y, pixel arm length.
- **Primary signal:** shoulder-drop ratio
  `(shoulder_y − plank_shoulder_y) / (plank_shoulder_y − wrist_y)` — camera
  and body-size normalized, same construction as the squat hip-drop ratio.
- **Joint evidence (anti-bob, ENG §2 analog):** shoulder-drop AND elbow
  flexion AND hip stays within a band of the shoulder-hip line (kills the
  hips-up "tent bob" and the hips-sag cheat *as verification*, not form
  coaching — the band is generous).
- **Hysteresis state machine:** PLANK → DESCENDING (ratio > A) → depth-valid
  (min ratio ≥ B) → ASCENDING → PLANK. Untrusted frames freeze state. Knees-
  down push-ups: ACCEPT as valid (v1 verifies motion, not difficulty) — the
  state machine must not depend on leg landmarks beyond the hip band.

## Battle plan

### Step 0 `[HUMAN]` — Corpus (~half evening, AFTER R2 scout passes)
**AMENDED 2026-07-09:** the screened stranger supplement
(`wargames/output/pushup-stranger-supplement.md`, 11 clips) pre-funds the
cells the internet can provide — clean long sets ×2, fast ×1 (exact counter
GT), failure ×2, knees ×2, negatives ×4 (burpee ×2, plank ×2). Strangers stay
**held out** from tuning (transfer-check role, as in squats). Self-record only
the irreplaceable ~13 protocol clips: shallow ×5 (side + one 45°, light/dim
spread), clean-with-2s-plank-calibration ×2 (side, 45°), paused-at-bottom ×1,
front ×3 (prove it fails), negatives ×2 (crawl into frame; lie down & get up).
Labels CSV same schema as squats.
- **Expected observation:** 13 protocol clips + labels on desktop; stranger
  VERIFY flags (4 clips) resolved by watching.
- **Counter-move:** missing matrix cell → record before Step 2 tunes.
  Calibration or normalization fails to transfer between protocol and
  stranger geometry → that is a Step 3 finding, not a reason to tune on
  strangers.

### Step 1 — Extend harness
Add shoulder/elbow/wrist signal extraction + plank calibration to the
existing harness (reuse, don't fork). Per-clip PNGs of shoulder-drop ratio.
- **Expected observation:** rep oscillations visible by eye in ≥80% of side-
  view clips; negative clips flat.
- **Counter-move:** invisible in side view good light → check y-axis/indices
  first; still invisible → kill-signal, abort A1.

### Step 2 — State machine + lie detectors
Implement per the signal design. Same detectors (bone-length, teleport,
left/right coherence adapted to arms). Hand-check rep timestamps on 3 clips.
- **Expected observation:** timestamps match video by eye.
- **Counter-move:** double counts → widen A/B; missed paused reps → hunt for
  a time/velocity term (forbidden).

### Step 3 — Tune & cross-validate
Grid-search A/B on side-view good-light **protocol clips only**; freeze;
evaluate held-out conditions AND the stranger supplement (frozen thresholds,
no retune — the transfer check). Same targets as squats: ≥95% recall
good-faith, ≥90% shallow rejection, **0** negative counts.
- **Expected observation:** targets met on held-out conditions.
- **Counter-move:** fatigue-set failures → lower B (policy, not code);
  45°-only failures → prescribe side view in-app (fork F1, condition ≥80%
  side AND <50% at 45°).

### Step 4 `[HUMAN]` — Friends pass
3–5 people, frozen thresholds, no retuning: plank calibration + 2 sets + 1
negative. ≥90% agreement per person, 0 phantoms.
- **Counter-move:** one fails → inspect their ratios (depth-line policy);
  most fail → normalization not transferring, abort A2.

## Fork triggers
- **F1:** 45° unusable (condition above) → side-view-only prescription.
- **F2:** knees-down reps systematically rejected by the hip-band check
  (condition: >30% of knees-down reps fail on hip-band, not depth) → widen
  the band for v1 and log it; accessibility beats strictness.

## Abort conditions
- **A1:** Signal invisible in side-view good light (Step 1) — pose layer
  can't see prone reps; push-up drops from v1, squat+GPS ship alone. Report.
- **A2:** Friends pass fails broadly — plank calibration doesn't transfer.
- **A3:** R0/R1/R2 gate failures.

## Verification runs
- **V1:** `evaluate.py` prints the metrics table for the push-up corpus;
  targets met.
- **V2:** Re-run twice → byte-identical (determinism).
- **V3:** Squat regression — re-run the squat corpus through the extended
  harness; squat metrics unchanged from their recorded values (the extension
  didn't break the proven pipeline).
- **Proven** when V1–V3 pass and Step 4 hits its observation.

## Red-team pass
1. **Weakest assumption:** MediaPipe on horizontal bodies — training data is
   mostly upright humans; confident hallucination risk is *higher* prone.
   *Fix:* R2's one-clip scout gates the corpus evening; Step 1's by-eye check
   remains the cheap tripwire.
2. **Likely screw-up:** copy-pasting squat thresholds A/B. *Fix:* Step 3
   requires a fresh grid-search; the plan states thresholds are per-exercise.
3. **Camera-on-the-floor geometry:** push-ups happen at floor level; the
   prescribed phone height differs from squats. *Fix:* Step 0's matrix uses
   floor-level side placement; the setup-gate prescription for push-ups is an
   *output* of Step 3's condition analysis, recorded in the report.
4. **Regression blindness:** extending the harness could silently break squat
   extraction. *Fix:* V3 is a mandatory squat regression run.
5. **Burpees are the sneaky negative:** they contain a genuine push-up-like
   descent. *Fix:* in the negative corpus explicitly; if they count, that's a
   finding for the report (maybe they *should* count) — flagged as a product
   question, not silently accepted.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
