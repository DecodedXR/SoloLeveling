# Push-Up Stranger Supplement — screened online corpus

Role: **Step 3 held-out transfer check** for the push-up pipeline (same role
the 11-clip stranger corpus played for squats). NOT a substitute for the
Step 0 self-recorded tuning corpus — thresholds are still tuned on protocol
recordings only.

## What was hunted

17 YouTube candidates downloaded across 6 search queries; screened via 5-frame
contact strips + MediaPipe extraction + shoulder-y trace review
(`pushup_screen.py`, a deliberately-naive peak counter used only for label
cross-checks). **11 keepers**, 6 rejects (2 animated characters, 2 multi-person
frames, 1 front-view close-up, 1 picture-in-picture edit).

## Keepers (clips in `pushup_stranger/`, landmarks in `pushup_stranger_out/`,
labels in `pushup_stranger_labels.csv`)

| Category | Clips | Ground truth |
|---|---|---|
| fast | hIkeJVV-Djk (world-record 1-min pace) | **76 exact** — on-screen counter, trace agrees (84 naive − 8 intro/outro) |
| clean long set | RC_nkWWV0NU (side, dim, mat), xoCKHx8Yyj4 (45°, carpet) | 100 each — title claim + trace agree; VERIFY flags set |
| failure | 9MBgbodCaaQ (drops to knees at failure), BcEzywmVv0E | 10 (titled) / ~69 (trace est., VERIFY) |
| knees-down | __71lgdtiB8 (45°), zsJDXwa5atE (side, weakest) | ~10 / ~3, VERIFY |
| negative: burpee | lcN5Iic2F-w, zcLETpKUNaI | must count 0 (red-team's sneaky negative) |
| negative: plank | pvIjsG5Svck (clean), pSHjTRCQxIw (has cuts — garbage-input stressor) | must count 0 |

## Notes for Step 3 use

- 4 labels carry VERIFY flags — a ~10-minute watch-and-count pass before the
  supplement is used to score recall. Negatives and the counter-verified fast
  clip need no verification.
- `segment` column gives the usable window (seconds); outside it is intro/
  outro noise (walk-ins, talking, logo cards).
- Every keeper body is a stranger; between them: 2 female / 5 male subjects,
  mat/floor/carpet, dim and bright, side and 45°.
- Fatigue data is unusually good: 9MBgbodCaaQ shows lengthening inter-rep
  rests then shallow struggle-partials — exactly the depth-line policy data
  the squat campaign needed a dedicated clip for.

## What this does NOT cover (still needs the `[HUMAN]` Step 0 evening)

Deliberate shallow sets, paused-at-bottom, plank-calibration starts,
floor-level prescribed camera geometry, crawl-into-frame / lying-down
negatives, front-view failure proof, and all tuning-set cells.
