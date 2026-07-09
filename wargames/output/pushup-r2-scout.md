# Push-Up R2 Scout — MediaPipe prone landmark quality

**Verdict: PASS** — prone/horizontal bodies are NOT a kill signal. The corpus
evening (Step 0) is unblocked.

**Gate context:** `wargames/pushup-pipeline.md` R2 required a one-clip side-view
scout before recording a full corpus, because MediaPipe's training data is
mostly upright humans and confident hallucination risk was flagged as *higher*
prone (red-team item 1).

## Clip

No human clip was available pre-Mac-session, so the stranger-corpus precedent
(run #2 transfer check) was reused: YouTube `T5Qiv5xbaOk` ("1 Minute Push Up
Test") — static camera, clean side view, continuous 45-rep set, outdoor
daylight. 30 fps, push-up segment ≈ 72–128 s. This is a *stronger* scout than a
self-recorded clip: it also samples a stranger body.

## Findings (push-up segment, 1681 frames, 0 NaN frames)

Per-landmark visibility (whole set / at the 44 detected rep bottoms):

| Landmark | Set mean | Bottoms mean | Bottoms min |
|---|---|---|---|
| L/R shoulder | 1.000 / 0.999 | 0.999 / 0.999 | 0.999 |
| L elbow (near) | 0.946 | 0.912 | 0.878 |
| R elbow (far)  | 0.105 | 0.080 | 0.066 |
| L wrist (near) | 0.938 | 0.900 | 0.830 |
| R wrist (far)  | 0.201 | 0.155 | 0.126 |
| L/R hip | 0.997 / 0.995 | 0.997 / 0.995 | 0.992 |

- **Shoulders + hips: fully trusted at every rep bottom** (≥0.99). The primary
  signal (shoulder-drop ratio) and the hip-band check rest on the two most
  reliable joint groups.
- **Arms follow the known side-view pattern:** near side trusted, far side
  occluded — same as squat legs, already handled by the "at least one side"
  policy. **Design note for Step 2:** for elbows use near-side / max-of-L-R,
  NOT the mean-of-L/R used for hips (mean at bottoms = 0.496, straddles the
  0.5 threshold; near side alone = 0.91).
- **Signal amplitude is huge:** shoulder-y swings 0.164 normalized units,
  ≈0.68 of the plank shoulder-to-wrist span — a naive 5-frame-smoothed peak
  finder recovers **44 of the overlay's 45 reps** with zero tuning. Step 1's
  "oscillations visible by eye" bar is cleared by a wide margin
  (`pushup-r2-scout-shoulder.png`).
- **Near-forearm bone length stable** (std/mean ≈ 13%, inside the ±30% lie-
  detector band) — the bone-length detector can use the near forearm as the
  prone analog of the shin.

## What this does NOT prove

- Nothing about thresholds A/B (Step 3 grid-searches fresh, per red-team 2).
- One body, one camera height, good light — the corpus matrix still runs.
- Floor-level camera geometry for the in-app prescription is still a Step 0/3
  output (red-team 3).

## Next

Step 0 corpus evening (`[HUMAN]`, ~1 evening): ≥28 clips per the matrix in the
plan, then Steps 1–3 on Windows. Independent of the Mac session.
