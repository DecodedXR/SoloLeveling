# Wargame: Sit-Up Verification Pipeline (Third Exercise, First Pro)

**Mission:** Prove or kill the sit-up state machine using the corpus protocol
that validated squats. Sit-up is the first **Pro** exercise (SUB F17: squat +
push-up always free, further exercises Pro-gated, each ships only when its
state machine passes the corpus protocol). It completes the meme routine
(100 push-ups / 100 sit-ups / 100 squats / 10 km run — MKT §3), which is why
it goes before pull-ups. Own signals, own state machine, own corpus; the
squat/push-up pipelines are templates for *process*, never for thresholds.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for all
code/analysis; `[HUMAN]` steps are the user with a phone.

**Deliverable:** `wargames/output/situp-report.md` + the evaluated pipeline in
the kill-test codebase.

## HARD GATE — recon flags (check first, in order)

- **R0:** `LEDGER.md` shows the squat kill test **WIN** AND the push-up row
  (`wargames/pushup-pipeline.md`) **resolved** (WIN, or aborted with the
  reason recorded). Squat not WIN → halt. Push-up aborted on A1 (pose layer
  blind to prone bodies) → do NOT halt, but treat R2 below as near-certain to
  fail: supine is even further from the pose model's training distribution
  than prone. Run R2 before any other work and expect to report a kill.
- **R1:** The extraction harness + `evaluate.py` exist and reproduce the
  recorded squat metrics (and push-up metrics if push-up is WIN). Fail →
  halt; the foundation moved.
- **R2:** Supine-body scout: `[HUMAN]` records ONE 20s sit-up clip, side view,
  phone at floor level ~2m away. Run the harness; check shoulders/hips/knees
  are trusted (lie detectors clean) both lying flat and at the top of the
  sit-up. Untrusted majority in either posture → report before any corpus
  recording; this is the kill signal.
- **R3:** If LEDGER row 12 (`wargames/vision-backend-parity.md`) is WIN or
  transfers-with-retune, the Vision extraction CLI exists — this corpus gets
  extracted through BOTH backends from day one (see V4). Row 12 unresolved →
  proceed MediaPipe-only and record in the report that the Vision replay is
  owed before the exercise ships.

## Signal design (binding, from ENG's principles — position, never velocity)

- **Calibration:** 2s **lying-flat hold** at set start (analog of standing
  calibration): capture lying shoulder-y, hip-y, knee-y, and pixel torso
  length (shoulder→hip).
- **Primary signal:** shoulder-rise ratio
  `(lying_shoulder_y − shoulder_y) / torso_length_px` — camera- and body-size
  normalized, same construction as the squat hip-drop ratio. **Shoulder**, not
  nose/head: a neck-yank moves the head a lot and the shoulder a little, so
  the signal choice itself defeats the laziest cheat.
- **Joint evidence (anti-cheat, ENG §2 analog — accidents and laziness only):**
  shoulder-rise AND hip stays anchored within a band of its calibration y
  (kills the rocking/hip-bridge bob) AND knees remain bent (knee-y band from
  calibration — kills the straight-leg fold-up that isn't a sit-up). Bands
  are generous; this is verification, not form coaching (C14).
- **Hysteresis state machine:** LYING → RISING (ratio > A) → height-valid
  (max ratio ≥ B) → DESCENDING → LYING. Untrusted frames freeze state.
  Feet anchored vs free: BOTH accepted (v1 verifies motion, not difficulty),
  so the state machine must not read ankle landmarks except as optional trust
  evidence.
- **The depth-line policy (product decision, surfaced not buried):** B decides
  whether a *crunch* counts. Default for tuning: B = full sit-up (torso passes
  ~45° equivalent, i.e. ratio computed from the corpus's clean clips). The
  report MUST include the crunch acceptance rate at the chosen B and at one
  lower "crunches count" candidate B′ — the final line is a product call for
  the human, with data attached. Do not silently pick.

## Battle plan

### Step 0 `[HUMAN]` — Corpus (~1 evening, AFTER R2 scout passes)
Matrix mirrors ENG §5: views side + 45° (front view is near-useless supine —
include 3 front clips only to *prove* it, informing the in-app setup
prescription); qualities: clean full sit-ups ×5, deliberate crunches ×5
(labeled as their own class — they feed the depth-line policy, they are not
"shallow rejects"), paused-at-top, fast, feet-anchored ×3, feet-free ×3, one
set to failure; conditions: light/dim, mat/floor. Negatives (must count 0):
lying still 60s, getting up off the floor once and walking away, leg raises,
glute bridges, rolling over, sitting upright and staying there. Labels CSV
same schema as squats, plus a `class` column (`full`, `crunch`, `negative`).
- **Expected observation:** ≥28 clips + labels on desktop.
- **Counter-move:** missing matrix cell → record before Step 2 tunes.

### Step 1 — Extend harness
Add shoulder-rise + lying calibration extraction to the existing harness
(reuse, don't fork — third exercise in one harness). Per-clip PNGs of the
shoulder-rise ratio.
- **Expected observation:** rep oscillations visible by eye in ≥80% of
  side-view clips; negative clips flat; the lying-still negative in
  particular must be flat (a breathing chest must not oscillate the signal —
  if it does, the shoulder landmark is too noisy at rest and A needs headroom
  above breathing amplitude, measured not guessed).
- **Counter-move:** invisible in side-view good light → check y-axis
  orientation and landmark indices first; still invisible → kill signal,
  abort A1.

### Step 2 — State machine + lie detectors
Implement per the signal design. Same detectors (bone-length via torso
length, teleport, left/right shoulder coherence). Hand-check rep timestamps
on 3 clips against the video.
- **Expected observation:** timestamps match by eye; the getting-up negative
  produces at most a RISING entry and never a count (it rises once and never
  returns to LYING — the cycle requirement kills it by construction; confirm).
- **Counter-move:** double counts → widen the A/B hysteresis gap; missed
  paused-at-top reps → hunt for an accidental time/velocity term (forbidden).

### Step 3 — Tune & cross-validate
Grid-search A/B on side-view good-light clips only; freeze; evaluate on
held-out conditions. Targets identical to squats: ≥95% recall on good-faith
full sit-ups, ≥90% rejection of the sub-B class, **0** negative counts.
Compute the crunch table for B and B′ per the depth-line policy.
- **Expected observation:** targets met held-out; crunch table present.
- **Counter-move:** fatigue-set failures → lower B (policy, not code);
  45°-only failures → prescribe side view in-app (fork F1, condition ≥80%
  recall side AND <50% at 45°).

### Step 4 `[HUMAN]` — Friends pass
3–5 people, frozen thresholds, no retuning: lying calibration + 2 sets + 1
negative each. ≥90% agreement per person, 0 phantoms.
- **Counter-move:** one person fails → inspect their ratios (their build vs
  the depth line: a policy question); most fail → torso-length normalization
  not transferring, abort A2.

## Fork triggers
- **F1:** 45° unusable (condition in Step 3) → side-view-only prescription in
  the app's setup gate for sit-ups.
- **F2:** hip-anchor band rejects >30% of honest feet-free reps (hips
  naturally shift more without anchoring) → widen the band for v1 and log it;
  accessibility beats strictness (same rule as push-up's knees-down fork).
- **F3:** crunch acceptance at tuned B exceeds 50% (the depth line doesn't
  actually separate the classes) → the verdict escalates the depth-line
  policy to the human as BLOCKING before ship: either B rises (stricter, more
  false rejects) or crunches are declared valid (rename/scope note in-app).
  Condition: the measured rate, not judgment.

## Abort conditions
- **A1:** Signal invisible in side-view good light (Step 1) — pose layer
  can't see supine reps; sit-up drops from the Pro roster, report and stop.
- **A2:** Friends pass fails broadly — calibration doesn't transfer.
- **A3:** R0/R1/R2 gate failures (R2 untrusted-majority is the expected kill
  path if the pose layer is supine-blind).

## Verification runs
- **V1:** `evaluate.py` prints the sit-up metrics table; targets met.
- **V2:** Re-run twice → byte-identical (determinism).
- **V3:** Regression — re-run the squat corpus AND the push-up corpus (if
  push-up is WIN) through the extended harness; metrics unchanged from their
  recorded values.
- **V4:** *(only if R3 found the Vision CLI)* Extract the sit-up corpus via
  Vision, replay frozen thresholds per the parity protocol
  (`wargames/vision-backend-parity.md` Step 3); metrics within its 5-point
  band. Skipped → the report's first open question is "Vision replay owed
  before ship."
- **Proven** when V1–V3 (+V4 if applicable) pass and Step 4 hits its
  observation.

## Red-team pass
1. **Weakest assumption:** the pose model on supine bodies — even further
   from upright training data than prone, and at the bottom of the rep the
   body is a horizontal line with self-occluded far side. *Fix:* R2's
   one-clip scout gates the corpus evening; the push-up A1 outcome (if any)
   pre-loads the expectation.
2. **Likely screw-up:** the executor treats crunches as "shallow rejects" and
   tunes B to reject them without surfacing the policy. *Fix:* the corpus
   labels crunches as their own class; the depth-line policy section makes
   the B/B′ table a mandatory deliverable and the final line a human call.
3. **Head-tracking shortcut:** nose/ear landmarks are more stable than
   shoulders supine, and a lazy implementation would use them — making the
   neck-yank cheat score reps. *Fix:* the signal design names shoulder and
   names why; V1's table plus Step 2's hand-check would show yank clips
   counting if it's violated (add one neck-yank clip to the negatives).
4. **Breathing oscillation false-arms:** at rest the chest moves; a tight A
   double-counts a nap. *Fix:* Step 1's lying-still negative must be flat,
   and A's floor is set above measured breathing amplitude.
5. **Regression blindness across three exercises:** the harness now serves
   squat, push-up, sit-up. *Fix:* V3 runs BOTH prior corpora; V4 keeps the
   Vision-parity guarantee from silently rotting on new exercises.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
