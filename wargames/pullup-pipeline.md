# Wargame: Pull-Up Verification Pipeline (Pro Exercise)

**Mission:** Prove or kill the pull-up state machine via the corpus protocol
that validated squats. Pull-up is the Pro exercise NAMED in the paywall copy
(SUB §3.5 string 1: "Pull-ups are a Pro exercise") — if this pipeline dies,
that string changes, so the report must say so explicitly. Own signals,
state machine, corpus; prior pipelines are process templates only.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for
all code/analysis; `[HUMAN]` steps are the user with a phone AND a pull-up
bar (doorframe or gym).

**Deliverable:** `wargames/output/pullup-report.md` + the evaluated pipeline
in the kill-test codebase.

## HARD GATE — recon flags (check first, in order)

- **R0:** `LEDGER.md` shows the squat kill test WIN. Not WIN → halt.
- **R1:** Harness + `evaluate.py` reproduce recorded squat metrics. Fail →
  halt.
- **R2:** Hanging-pose scout: `[HUMAN]` records ONE 20s clip — dead hang,
  3–4 pull-ups, drop off — front-ish view, camera far enough that bar + full
  body stay in frame. Run the harness; shoulders/elbows/wrists/nose must be
  trusted at the hang AND at the top. Arms-overhead-hanging is atypical
  training data for pose models; untrusted majority → report before any
  corpus recording (kill signal).
- **R3:** A bar the human can access repeatedly exists (doorframe bar or a
  gym where propping a phone is acceptable). No → this mission parks until
  it does; report, don't improvise.
- **R4:** If LEDGER row 12 (Vision parity) landed, extract this corpus
  through both backends (V4). Unresolved → MediaPipe-only, replay owed.

## Signal design (binding — position, never velocity)

- **Calibration:** 2s **dead-hang hold** at set start: capture hang
  shoulder-y, wrist-y, nose-y, pixel arm length (shoulder→wrist). The wrist
  line at hang IS the bar proxy — no bar detection needed; hands don't leave
  the bar mid-set, so wrist-y is stable ground truth for "bar height."
- **Primary signal:** shoulder-rise ratio
  `(hang_shoulder_y − shoulder_y) / arm_length_px`.
- **Top-of-rep line:** nose-y above wrist-y (chin-over-bar's landmark-space
  equivalent; nose is the most stable face landmark). This is a *line*, not
  a ratio — it's anchored to the bar proxy, so camera geometry cancels.
- **Joint evidence (anti-cheat):** shoulder-rise AND elbow flexion (elbow
  angle closes below a generous bound at the top). A jump-and-grab or a
  chin-poke (craning the neck to sneak the nose over the line) rises without
  meaningful elbow flexion — the evidence pair kills both lazy cheats.
- **Hysteresis state machine:** HANG → RISING (ratio > A) → top-valid
  (nose above wrist line AND elbow flexion) → LOWERING → HANG (ratio < A).
  Untrusted frames freeze state. **Kipping/butterfly: ACCEPT** (v1 verifies
  motion, not strictness); chin-ups (supinated grip): ACCEPT — the machine
  reads no grip signal. Band-assisted: ACCEPT (motion is identical).
- **Framing reality:** bar + full body in frame means a wider shot → smaller
  landmarks → more noise. If full body doesn't fit (low doorframe bar in a
  small room), waist-up framing is acceptable — the machine reads nothing
  below the hip; Step 1 confirms trust holds at waist-up framing.

## Battle plan

### Step 0 `[HUMAN]` — Corpus (~1 evening at the bar, AFTER R2 passes)
Views: front + 45° (side view puts one arm behind the head — include 3 side
clips to measure, not to rely on). Qualities: clean ×5, deliberate
partial/half reps ×5 (labeled `shallow`), paused-at-top, kipping ×3,
chin-up grip ×2, one set to failure; conditions: good light/dim.
Negatives (must count 0): dead hang 60s, scapular shrugs (small pulls,
labeled — they feed the top-line policy the way crunches fed sit-ups'),
jump-and-grab then drop ×3, swinging without pulling, standing under the
bar scrolling phone, one chin-poke clip (crane the neck at half height).
Labels CSV with `class` (`full`, `shallow`, `negative`).
- **Expected observation:** ≥28 clips + labels on desktop.
- **Counter-move:** missing matrix cell → record before Step 3 tunes. Grip
  fatigue limits clip count per session → two shorter sessions beat one; the
  set-to-failure clip records LAST.

### Step 1 — Extend harness
Add shoulder-rise + dead-hang calibration + nose/wrist line extraction
(reuse, don't fork). Per-clip PNGs: shoulder-rise ratio with the wrist line
overlaid.
- **Expected observation:** rep oscillations visible by eye in ≥80% of
  front/45° clips; dead-hang negative flat; jump-and-grab shows a spike
  without sustained elbow flexion.
- **Counter-move:** invisible in front good light → axis/index check, then
  abort A1.

### Step 2 — State machine + lie detectors
Implement per signal design; detectors adapted to arms (bone-length via arm
length, teleport, left/right shoulder coherence). Hand-check 3 clips.
- **Expected observation:** timestamps match by eye; chin-poke clip counts 0
  (elbow evidence working); jump-and-grab counts 0.
- **Counter-move:** double counts → widen hysteresis; missed paused-at-top →
  forbidden-term hunt.

### Step 3 — Tune & cross-validate
Grid-search A + elbow-flexion bound on front-view good-light; the nose/wrist
top line is NOT tuned (it's the definition of the rep, anchored to the bar
proxy). Freeze; evaluate held-out. Targets: ≥95% recall good-faith reps,
≥90% partial rejection, **0** negatives.
- **Expected observation:** targets met held-out; kipping and chin-up clips
  inside the recall pool.
- **Counter-move:** fatigue-set failures → the failure mode here is honest
  reps that stop short of the line (fatigue = can't finish the pull, unlike
  squat fatigue = shallow depth); if recall on the failure set craters, that
  is CORRECT behavior — the reps genuinely didn't finish. Report it as UX
  input (live "almost" feedback), not as a threshold problem. Only loosen
  the elbow bound, never the nose/wrist line.

### Step 4 `[HUMAN]` — Friends pass
3–5 people who can do ≥3 pull-ups (recruit accordingly — this is the one
exercise where the friend pool needs a capability screen; note it in the
report if the pool shrinks below 3), frozen thresholds: hang calibration +
2 sets + 1 negative (jump-and-grab). ≥90% agreement, 0 phantoms.
- **Counter-move:** one fails → ratio inspection; most fail → abort A2.

## Fork triggers
- **F1:** Side view unusable (expected) → front/45° prescription in the
  app's pull-up setup gate. Condition: ≥80% recall front AND <50% side.
- **F2:** Waist-up framing required (full body never fits with the bar) →
  the pull-up setup gate drops the full-body requirement for this exercise;
  the IMU still-phone check carries more anti-cheat weight and the report
  says so. Condition: Step 1 trust at waist-up ≥ trust at full-body.
- **F3:** Scapular shrugs count as reps at the frozen config (>20% of shrug
  clips scoring) → the nose/wrist line should make this near-impossible;
  if it happens anyway the calibration captured a compressed hang — add a
  hang-quality check to calibration (arms straight: elbow angle open) and
  re-run Step 3 once. Second failure → report as a finding.

## Abort conditions
- **A1:** Signal invisible in front-view good light (Step 1) — pose layer
  can't track hanging bodies; pull-up drops from the roster AND the paywall
  string changes (say so in the report). Halt.
- **A2:** Friends pass fails broadly — hang calibration doesn't transfer.
- **A3:** R0–R3 gate failures.

## Verification runs
- **V1:** `evaluate.py` prints the pull-up metrics table; targets met.
- **V2:** Re-run twice → byte-identical.
- **V3:** Regression — all prior WIN corpora re-run; metrics unchanged.
- **V4:** *(if Vision CLI exists)* frozen-threshold Vision replay within the
  parity band; else owed. NOTE for Vision: 19-joint set must include nose,
  wrists, elbows, shoulders — it does (face + arms are Vision's strong
  suit); record the mapping rows in the report.
- **Proven** when V1–V3 (+V4) pass and Step 4 hits its observation.

## Red-team pass
1. **Weakest assumption:** pose trust on arms-overhead hanging bodies — R2's
   scout gates the corpus evening; the by-eye Step 1 check is the second
   tripwire.
2. **Likely screw-up:** tuning the nose/wrist top line to hit recall — that
   redefines the exercise to make the numbers pass. *Fix:* Step 3 states
   the line is untunable; only A and the elbow bound move.
3. **The bar proxy drifts:** hands re-grip mid-set, moving wrist-y. *Fix:*
   the line uses calibration wrist-y, not live wrist-y; a re-grip that
   shifts hands more than the bone-length detector tolerates marks frames
   untrusted (state freeze), which is the correct failure mode.
4. **Doorframe-bar clearance:** head approaches the top of frame at the top
   of the rep; a cropped head kills the nose landmark exactly at the moment
   of truth. *Fix:* Step 0's framing instruction — headroom above the bar of
   at least one head-height; the setup gate inherits this as a rule.
5. **Capability-screened friends pass:** requiring pull-up-capable friends
   shrinks n and biases toward strong bodies. *Fix:* named openly in Step 4;
   band-assisted reps are valid, so weaker friends can test with a band —
   which ALSO tests the machine on assisted motion. Fold that in rather
   than shrinking n.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
