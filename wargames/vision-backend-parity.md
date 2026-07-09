# Wargame: Vision Backend Parity (MediaPipe → Apple Vision)

**Mission:** The kill test (`wargames/workout-tracker-verification.md`) tunes
thresholds on **MediaPipe desktop** landmarks; production (ADR-1,
`wargames/output/architecture-adr.md`) consumes **Apple Vision**
`VNDetectHumanBodyPoseRequest` landmarks — 19 joints vs 33, different noise,
different joint placement. ADR risk R5's corpus byte-match validates the state
machine on *identical* signals; it cannot detect signal drift from the backend
swap. Prove or kill: **thresholds and trust detectors tuned on MediaPipe
transfer to Vision-derived signals on the same corpus.**

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** coding model on a
Mac (Vision framework runs on macOS — no device needed).

**Deliverable:** `wargames/output/vision-parity-report.md` + a Vision
extraction tool in the kill-test codebase.

## HARD GATE — recon flags

- **R0:** The kill-test corpus exists on disk (≥25 labeled clips per ENG §5)
  AND kill-test Steps 1–3 have produced frozen thresholds A/B with recorded
  metrics. Not yet → halt; this mission consumes those artifacts. (It does
  NOT require the friends pass / full WIN — it can run in parallel with
  kill-test Step 4.)
- **R1:** The machine is a Mac with Xcode CLT; a 10-line Swift snippet
  running `VNDetectHumanBodyPoseRequest` on one image succeeds. Fail → halt,
  report environment.
- **R2:** ENG evaluator (`evaluate.py`) reproduces its recorded MediaPipe
  metrics on the corpus before any Vision work (baseline integrity).

## Battle plan

### Step 1 — Vision extraction tool
Swift CLI: video file in → per-frame CSV out with the SAME schema the
MediaPipe harness emits (joint x/y + confidence, frame timestamp), restricted
to the joints the Verifier consumes (hips, knees, ankles + whatever the trust
detectors read). Map Vision joint names → the harness's landmark columns;
document the mapping table in the report. Batch over the corpus.
- **Expected observation:** CSVs for every clip; schema-identical so
  `evaluate.py` ingests them unchanged.
- **Counter-move:** a Verifier-required signal has no Vision equivalent
  (e.g., a trust detector reading a joint Vision lacks) → adapt the detector
  per the ADR's module map (trust logic is part of the Signals layer, so a
  Vision-specific trust variant is legitimate); log every adaptation — each
  one is a port-divergence risk made visible.

### Step 2 — Signal comparison
For each clip: overlay MediaPipe vs Vision hip-drop-ratio traces (one PNG per
clip); compute per-clip correlation and the per-frame ratio delta
distribution. Compare trust-flag rates (untrusted-frame % per clip, both
backends).
- **Expected observation:** in good-light front/side clips, traces visually
  congruent and ratio deltas small relative to the A/B hysteresis gap
  (report the delta p95 vs |B−A|); Vision untrusted rate not wildly above
  MediaPipe's.
- **Counter-move:** systematic offset (Vision hip consistently higher/lower)
  → that's a calibration-normalization job, not a failure: verify the
  standing-calibration ratio absorbs it (it should by construction); if it
  does, note and continue; if not, the ratio definition needs a per-backend
  constant — escalate as a finding, not a silent patch.

### Step 3 — Frozen-threshold replay
Run `evaluate.py` on the Vision CSVs with the MediaPipe-tuned A/B **frozen —
no retuning**. Produce the same metrics table: recall on good-faith reps,
shallow rejection, negative-clip counts.
- **Expected observation:** Vision metrics within 5 points of MediaPipe
  metrics on every category, and negatives still count **0**.
- **Counter-move:** recall drops but shallow-rejection holds → check whether
  Step 2 found a systematic offset that calibration failed to absorb before
  touching thresholds.
- **Fork F1:** metrics fail the 5-point band but a fresh grid-search on
  Vision CSVs (tuning-set clips only, same protocol as ENG Step 3) recovers
  them → verdict "transfers with re-tune": production thresholds get tuned
  on Vision, MediaPipe remains a dev-harness convenience. Condition: the
  re-tuned held-out metrics meet ENG's original targets.
- **Fork F2:** even re-tuned Vision misses ENG targets → ADR-1 reverses to
  MediaPipe (the ADR names this reversal path in risk R2). The report states
  it as the recommendation with the metrics table as evidence.

## Abort conditions

- **A1:** R0/R1/R2 gate failures.
- **A2:** Vision trust/confidence behaves pathologically on the corpus
  (e.g., >50% untrusted frames in good-light clips after mapping) — the
  backend can't see the signals at all; skip to F2's recommendation
  immediately with the evidence.

## Verification runs

- **V1:** Determinism — re-run the Vision extraction + evaluation twice;
  byte-identical outputs.
- **V2:** Baseline untouched — re-run the MediaPipe evaluation after all
  work; metrics identical to R2's baseline (no accidental harness edits).
- **V3:** Mapping audit — for 3 random frames across 3 clips, manually
  render both backends' hip/knee/ankle points over the video frame; the
  mapping table's correspondences must be visibly correct (catches a
  left/right or hip-center mapping bug that correlation stats can hide).

## Red-team pass

1. **Weakest assumption:** the calibration ratio absorbs cross-backend
   offsets. It absorbs *scale*, but a backend that places "hip" at a
   different anatomical point changes the ratio's *dynamics*, not just its
   offset. *Fix:* Step 2's delta-vs-hysteresis-gap comparison measures
   exactly this before Step 3 interprets metric changes.
2. **Likely screw-up:** coordinate-system mismatch — Vision uses normalized
   coordinates with a bottom-left origin (y up), MediaPipe top-left (y
   down). Silent sign flip inverts everything. *Fix:* V3's visual render
   audit exists for this; Step 1's mapping table must state the y-flip
   explicitly.
3. **Quiet retuning:** the executor "fixes" Step 3 by nudging thresholds.
   *Fix:* Step 3 says frozen in bold; retuning is only legal inside F1's
   named protocol with held-out evaluation.
4. **False reassurance from correlation:** high correlation with a lag or
   clipped bottoms still breaks the state machine. *Fix:* the metrics replay
   (Step 3) is the verdict; Step 2 is diagnosis only — the plan's order
   enforces it.
5. **Scope creep into the device benchmark:** fps on iPhone 11 is ADR-8's
   open question, not this mission. *Fix:* stated out of scope here; desktop
   Vision parity and device fps are separate questions with separate exits.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
