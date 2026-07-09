# Wargame: Gamified Workout Tracker — Binary Rep Verification

**Mission:** Single phone camera + MediaPipe pose → binary verdict per candidate
rep ("valid squat, yes/no") → XP ledger. Separate GPS/accelerometer path for
non-vision tasks, same ledger. Find the failure modes before code exists, then
produce the smallest build that proves or kills the core assumption.

**Date:** 2026-07-08 · **Genius:** fable-5 · **Executor:** any cheap model + the
human (video recording steps are human-only and marked `[HUMAN]`).

---

## Verdict up front

The core assumption is **probably right, with one reframe**: "template" must
mean *a hand-coded state machine on 1–2 normalized signals* (hip height ratio,
knee angle), not trajectory matching (DTW against a recorded reference rep).
Trajectory matching is the fancy version and it is strictly worse here — more
fragile to tempo, pauses, and body proportions, and harder to debug. A
state machine with hysteresis on calibrated hip height is boring, ~100 lines,
and is what every commercial rep counter actually ships.

**Harder than it looks:** the pose layer at squat depth (confident hallucinated
landmarks), and fatigue-degraded reps (the false-reject happens at the exact
moment the user is most emotionally invested).
**Easier than it looks:** segmentation (solved by a start button + arming
gate, not ML), anti-cheat (solved by not caring, see §2), and the dataset
(dozens of clips, not thousands).

The kill test is a weekend of desktop Python on recorded video. No app until
it passes.

---

## §1 — The verification threshold

| Failure | Mechanism | Bites? | Fix cost | Call |
|---|---|---|---|---|
| Fixed absolute thresholds break across bodies | Long femurs, short torsos, tall/short users hit different apparent depths for the same true squat | **Certain** (the moment user #2 exists) | Cheap | **SOLVE** — normalize everything |
| Camera height/angle shifts apparent depth | Phone on floor vs on a table changes hip-drop pixels and apparent knee angle | **Certain** | Cheap | **SOLVE** — same normalization + setup gate |
| Rep 1 cold start | No per-user data before the first rep | Certain, but only matters if you treat it as a learning problem | Cheap | **SOLVE** — it's a calibration problem, not a learning problem |
| Fatigue-degraded reps rejected | Reps 8–10 get shallower/slower/lean forward; a strict threshold rejects rep 10 of 10 — worst possible UX moment | **High** | Cheap | **DESIGN AROUND** — generous threshold + live depth feedback |
| Paused reps break segmentation | Pause at the bottom kills any velocity/tempo-based rep model | High if you use velocity; zero if you don't | Free | **SOLVE by construction** — state machine on *position*, never velocity/duration |
| Partial reps | Where is the depth line? Any line has boundary cases | Certain | Product decision, not code | **DESIGN AROUND** — pick a generous line, show it live |
| Users who squat badly | Knee valgus, heels up, forward lean | Certain | Expensive to judge, free to ignore | **ACCEPT** — v1 answers "did the hip go down past the line and back up," not "was it good form." Form coaching is a different product. |

**The calibration story (this resolves most of the table):**
Session start = a 2-second **standing calibration**. Capture: standing hip-y,
ankle-y, and pixel limb lengths. Every subsequent signal is a *ratio* against
this frame — e.g. `hip_drop = (hip_y − standing_hip_y) / (standing_hip_y −
ankle_y)`. Now body proportions, camera distance, and camera height mostly
cancel. Rep 1 is judged against a population-default ratio threshold (tune on
your own corpus, ~0.30–0.45 hip-drop ratio for "deep enough"; the exact number
is an output of the kill test, not an input). No per-user learning in v1 —
adaptive thresholds that drift toward whatever the user does are also a cheat
vector and a debugging nightmare.

**Threshold values with hysteresis:** descend-armed below ratio A (e.g. 0.15),
depth-valid below B (e.g. 0.35), rep-complete back above A. Two thresholds,
never one — single-threshold counters double-count on jitter.

---

## §2 — Adversarial

**Threat model first, attacks second.** This is a self-improvement app. If XP
is private (no leaderboard, no payouts), a cheater defeats only themselves and
the correct security budget is ≈ zero. Every anti-cheat measure is a
false-rejection generator aimed at honest users, and false rejections kill
retention far faster than cheaters kill anything. **Bias hard toward
accepting.** If you ever add a leaderboard or rewards with real value, this
whole section flips — that is a fork trigger for the *product*, note it now.

| Attack | Works? | Defense | Defense cost to honest users | Call |
|---|---|---|---|---|
| Point camera at a video of squats | Yes, defeats everything | Liveness detection / face match | Expensive, creepy, and still beatable | **ACCEPT.** Un-defendable at this budget. Cheaper to make cheating pointless (private XP) than impossible. |
| Friend does the reps | Yes | Face ID per rep | Same | **ACCEPT** |
| Bob torso without bending knees | Partially | Require *joint* evidence: hip-drop AND knee-flexion AND hip stays roughly above ankles. Pure vertical torso bob fails knee flexion. | ~Free — it's the same state machine reading two signals instead of one | **SOLVE** — cheapest real defense in the project |
| Move the phone up/down to fake hip drop | Yes vs vision alone | Read the phone IMU during the set; accelerometer variance above threshold → set flagged/paused ("keep the phone still") | ~Free, and it *helps* honest users whose phone slips | **SOLVE** — this is the laziest cheat, so it's the one that will actually happen |
| Squat 2 inches and grind XP | Partially | That's just the depth threshold (§1) | Already paid | Covered |
| Replay same recorded session to the ledger | Yes if ledger trusts client blindly | Event log with timestamps + monotonic session IDs | Cheap | **SOLVE** at the ledger, not the camera |

**Rule of thumb that falls out:** defend against *accidents and laziness*
(phone bob, jitter, shallow grinding), accept anything requiring deliberate
effort (video replay, body doubles). A person motivated enough to set up a
squat video in front of their phone has already spent more will than ten
squats cost.

---

## §3 — The pose layer (where MediaPipe lies to you)

| Failure | Mechanism | Bites? | Detectable? | Call |
|---|---|---|---|---|
| Confident hallucination at squat depth | At the bottom, thighs occlude hips, arms cross the body; the model outputs a *plausible* pose with high visibility scores. Visibility is a learned prediction, **not calibrated confidence** — it lies hardest exactly when the model is guessing. | **High** — this is the #1 technical risk in the project | Partially | **SOLVE with detectors, not trust** |
| Keypoint jitter → derivative garbage | Frame-to-frame noise; any velocity you compute is noise amplified | Certain if you differentiate | Yes | **SOLVE by construction** — don't differentiate. Position + hysteresis. If you must smooth, One-Euro filter or EMA on landmark positions. |
| Monocular projection error off-perpendicular | 2D joint angles are only true in the camera plane; at 45° the knee angle you compute is fiction. MediaPipe's "world landmarks" z is low-quality. | High if you allow arbitrary angles | Sort of | **DESIGN AROUND** — constrain the input. Prescribe setup (see below). Prefer hip-*height* ratio (robust to yaw) over knee *angle* (fragile to yaw) as the primary signal. |
| Far-leg occlusion in side view | Side view is the best depth view but the far leg is hallucinated | Medium | Yes — use the near leg only | Cheap **SOLVE** |
| Baggy clothes, low light, old-phone frame drops | Landmark quality collapses; 15fps + fast reps = aliasing | Medium at home, low in a gym | Partially | **DESIGN AROUND** — setup gate checks it before the set starts |

**The lie detectors (all cheap, all frame-level):**
1. **Bone-length consistency** — pixel limb lengths from the calibration frame
   shouldn't change more than ~20–30% mid-set (perspective aside). Spike =
   hallucination.
2. **Teleport check** — landmark velocity above a physical cap (a hip does not
   move 40% of frame height in 33ms) = bad frame.
3. **Left/right coherence** — hips/knees disagreeing wildly on y = guessing.
Bad frames get marked *untrusted*; the state machine is forbidden to change
state on untrusted frames. It holds state and waits. This converts "confident
wrong answer" into "brief freeze," which is the correct failure mode.

**The cheapest fix in the whole project is constraining the input:** a setup
screen that refuses to arm until full body is in frame, all leg landmarks
trusted, and stable for ~1s. Prescribe: phone ~2m away, roughly hip height,
front-facing or side-on. You are allowed to demand this; every fitness app
does.

---

## §4 — Segmentation

**The trap:** trying to detect "user is now doing squats" from continuous
video. That is open-ended activity recognition — a genuinely hard problem you
do not have. **Do not buy it.** A start button costs one tap.

**The design that makes segmentation a non-problem:**
1. User taps **Start Set** → setup gate (§3) → 3-2-1 countdown.
2. **Armed** only when: full body visible + landmarks trusted + standing pose
   (hip-drop ratio < A) held ~1s. Walking in, adjusting the phone, scrolling —
   none of it can arm the machine, so none of it can count.
3. Rep = full state cycle: `STANDING → DESCENDING (ratio > A) → [depth check:
   min ratio ≥ B?] → ASCENDING → STANDING (ratio < A)`. Valid rep on cycle
   completion with depth met; cycle completed *without* depth → explicit
   "too shallow — didn't count" feedback (this is also your fatigue UX from §1).
4. Pose lost mid-set (user walks off, picks up phone) → PAUSED, state machine
   frozen, resume requires re-arming. No false counts possible by
   construction because a count requires a full monotone cycle through trusted
   frames.

| Failure | Bites? | Call |
|---|---|---|
| Free-running segmentation on continuous video | Would be the hardest part of the project | **KILL** — replaced by start button + arming gate, cost ≈ zero |
| Sitting into a chair counts as a squat | Only if it completes a stand→deep→stand cycle — sitting doesn't come back up | Mostly self-solving; put "sit down and stand up" in the negative test corpus to prove it |
| Double-count on jitter at threshold | Certain with one threshold | Hysteresis (A ≠ B), already in §1 |

---

## §5 — The data problem

**Highest-leverage engineering decision in the project:** build the pipeline to
run on **recorded video files**, not live camera only. Every algorithm change
then re-runs against the entire corpus in seconds. Live-only development means
re-squatting every time you tune a threshold — that alone can kill the project
via friction.

**Smallest decisive corpus (~30–40 clips, one evening to record):**

| Axis | Values |
|---|---|
| View | front, side, ~45° |
| Rep quality | clean ×5, deliberately shallow ×5, paused-at-bottom, fast/bouncy, one honest set to failure (fatigue) |
| Conditions | good light, dim room; shorts, sweatpants |
| **Negatives** (must yield 0 reps) | walk through frame, stand and scroll phone, sit into chair and stand up, pick up phone, tie shoes, lunges, deadlift-ish hip hinge |

Label per clip: total valid reps, which rep indices were invalid and why
(shallow / not-a-rep). Watching and counting = minutes per clip. That's the
whole labeling story.

**Honest validation with n=1 subject:** you cannot cross-validate across
people, so don't pretend. Cross-validate across **conditions**:
leave-one-condition-out — tune thresholds on front-view clips, test on side
view; tune on fresh reps, test on the fatigue set. If a threshold tuned in
condition X transfers to condition Y on the *same body*, the calibration
normalization is doing its job; if it doesn't transfer across your own camera
angles, it will never transfer across bodies — kill signal. Then, before
building any real app, get **3–5 other humans for 5 minutes each** (one
calibration + two sets + one negative). n=4 strangers exposes 80% of the
proportion/clothing variance that matters. Your solo thresholds *will* be
overfit to your femurs; the calibration ratio is the transfer mechanism, and
friends-testing is the only way to know it worked.

**Metrics:** per-rep agreement with human count. Targets: ≥95% recall on
good-faith reps, ≥90% rejection of deliberate shallows, **zero** counted reps
across all negative clips. (False XP is worse than missed XP — a missed rep
annoys; a phantom rep teaches the user the app is a toy.)

---

## §6 — Architecture

**The two-path split is right.** Vision and GPS share no signal processing;
forcing them into one "verification engine" abstraction would be architecture
astronautics. Keep them as two producers. The real risks are at the seams:

| Seam risk | Bites? | Call |
|---|---|---|
| **Verification-rigor asymmetry** — GPS path is trivially cheatable (bike/drive a "run"). If vision is strict and GPS is loose, users learn the loose path pays better and your vision rigor is wasted effort. | High, but only matters under the §2 threat model | **DESIGN AROUND** — match rigor to threat model on *both* paths (i.e., both casual in v1: pace-plausibility check on GPS ≈ IMU check on vision). Revisit both together if XP ever becomes competitive. |
| **XP pricing across paths** — is a 5k worth 10 squats or 1000? | Certain, but it's economy design, not architecture | **ACCEPT for v1** — pick numbers, tune later. Ledger design makes retuning free (below). |
| **Paths writing XP directly** — if each path computes and writes XP, pricing changes and audits become migrations | Certain eventually | **SOLVE now, it's free:** append-only *event* log — `{source: vision|gps, task, evidence: {rep timestamps | route summary}, session_id, ts}`. The ledger prices events into XP as a pure function. Repricing = re-fold the log. Also gives you replay-attack defense (§2) and debugging for free. |
| On-device vs server | — | On-device everything (MediaPipe already is); sync events, never video. Privacy, offline, zero server cost. |

---

## Priority list

**SOLVE (cheap, load-bearing):**
1. Standing-calibration normalization + ratio-based hysteresis state machine (§1) — this *is* the product.
2. Frame-level lie detectors + "hold state on untrusted frames" (§3).
3. Start-button + arming gate; no free-running segmentation (§4).
4. Video-file replay harness + labeled corpus before any app code (§5).
5. IMU still-phone check (§2) and event-log ledger (§6) — both near-free.

**DESIGN AROUND:** generous depth line with live "too shallow" feedback
(fatigue UX); prescribed camera setup; rigor parity across vision/GPS paths.

**ACCEPT:** video-replay and body-double cheats; form quality judging; XP
economy balance in v1.

**KILL:** trajectory/DTW template matching; open-set "is the user exercising"
detection; adaptive per-user thresholds; any anti-cheat that raises honest
false rejections.

---

## Battle plan: the kill test

Objective: prove or kill "binary verification against a template is robust
enough" in ~a weekend, on desktop, before writing app code. Executor = cheap
model for all code/analysis steps; `[HUMAN]` steps are the user with a phone.

**Recon flags (check before Step 2):**
- R1: MediaPipe Pose (`mediapipe` pip package, Tasks API, `pose_landmarker`)
  installs and runs on the user's desktop Python ≥3.9. If the current package
  API differs from expectations, consult the official MediaPipe Python docs
  rather than guessing.
- R2: Phone records ≥30fps video and files transfer to desktop.
- R3: A space with ~2m camera-to-body distance exists at home.
  → Any recon flag failing = report back before proceeding, the plan's
  environment assumption is wrong.

### Step 0 `[HUMAN]` — Record the corpus (~1 evening)
Record the §5 matrix with the normal phone camera app: ~25 squat clips + ~8
negative clips, each 20–60s, full body in frame, phone propped still. Name
files `view_condition_desc.mp4` (e.g. `front_dim_shallow.mp4`). Write
`labels.csv`: `filename, valid_reps, notes`.
- **Expected observation:** ≥30 files + labels.csv on desktop.
- **Counter-move:** missing a matrix cell → record it before Step 3 tunes on
  an incomplete matrix; proceed with Steps 1–2 meanwhile.

### Step 1 — Extraction harness
Python script: video file in → per-frame CSV out (33 landmarks × x,y,z,
visibility + frame timestamp). Batch-run over the corpus directory. Plot
hip-y (mean of landmarks 23,24) vs time per clip, one PNG per clip.
- **Expected observation:** script exits 0 on every clip; in the PNGs for
  squat clips, rep cycles are visible **by eye** as clean oscillations in
  ≥80% of clips; negative-clip plots show no squat-like oscillation.
- **Counter-move:** oscillations invisible in front/side good-light clips →
  check landmark indices and y-axis orientation first (y grows downward);
  still invisible → **this is kill-signal #1**, see abort conditions.
- **Fork F1:** oscillations clean in front+side but garbage at 45° → drop 45°
  support, prescribe front/side in the app, continue. (Condition: ≥80% clean
  in front+side AND <50% at 45°.)

### Step 2 — Calibration + state machine (~100 lines)
Implement: standing calibration from first stable second; hip-drop ratio;
lie detectors (bone-length ±30%, teleport cap, untrusted-frame state hold);
hysteresis state machine A/B; per-clip output = counted reps + per-rep min
ratio + timestamps.
- **Expected observation:** runs on all clips; on 3 hand-checked clips the
  reported rep timestamps match the video when eyeballed.
- **Counter-move:** double counts → widen A/B gap; missed paused reps →
  verify no time/velocity term crept into the state machine (position-only).

### Step 3 — Tune and cross-validate on conditions
Grid-search A, B on front-view good-light clips only. Freeze. Evaluate on
everything else, per §5 protocol. Produce a table: per-clip predicted vs
labeled reps, plus totals for recall (good reps), shallow rejection, negative
false counts.
- **Expected observation:** ≥95% recall on good-faith reps in held-out
  conditions, ≥90% shallow rejection, 0 negative-clip counts.
- **Counter-move:** fails only in dim clips → acceptable, prescribe lighting,
  note in report. Fails on fatigue set specifically → lower B (generous
  depth), re-run — this is the §1 fatigue call, resolved by policy not code.
- **Fork F2:** shallow rejection <90% but recall fine → depth line is the
  problem, not the pipeline; report both candidate B values with their
  tradeoff table and let the human pick. (Condition-driven, not taste.)

### Step 4 `[HUMAN]` — Friends pass (go/no-go for app phase)
3–5 other people, 5 min each: calibration + 2 sets + 1 negative behavior.
Run the frozen Step-3 thresholds — **no retuning allowed**.
- **Expected observation:** ≥90% rep agreement per friend, 0 phantom reps.
- **Counter-move:** one friend fails, rest pass → inspect their clips'
  hip-drop ratios; if their honest depth sits below B, that's the depth-line
  policy again (F2), not a kill. Most friends fail → calibration
  normalization isn't transferring: **kill-signal #2**.

**Abort conditions (stop, don't push forward):**
- A1: Step 1 signal is not visible by eye in good conditions → the pose
  layer can't see squats on this hardware; no downstream cleverness fixes an
  invisible signal. Halt, report, project pivots or dies.
- A2: Step 3 negative clips produce *any* counted reps that detector/hysteresis
  tuning can't zero without dropping good-rep recall below 90% → the false-XP
  floor is too high for a trust-based product. Halt, report.
- A3: Step 4 fails across most friends → verification doesn't transfer across
  bodies; the single-subject template assumption is false. Halt, report.

**Verification runs (distinct from the work):**
- V1: `python evaluate.py corpus/ labels.csv` prints the Step-3 metrics table;
  passing thresholds printed above are met.
- V2: Re-run V1 twice → byte-identical output (determinism; no hidden state).
- V3: Feed one squat clip *renamed and relabeled* as a negative → evaluator
  correctly reports it as a mismatch (proves the evaluator isn't vacuous).
- **Mission proven** when V1–V3 pass and Step 4 hits its observation. Only
  then does app code begin (on-device port of the same state machine + arming
  UI + event ledger).

---

## Red-team pass (attacking this plan)

1. **Weakest assumption:** that hip-drop *ratio* transfers across camera pitch.
   A phone on the floor tilting up compresses vertical ratios nonlinearly.
   *Fix folded in:* corpus already varies camera height implicitly across
   clips — Step 3's held-out-condition eval will surface it; if it bites, the
   counter-move is prescribing "phone at ~hip height" in the setup gate
   (input constraint, §3), not more math.
2. **Most likely executor screw-up:** y-axis direction (image y grows
   downward) and landmark indexing — silently inverts the state machine.
   *Fix folded in:* Step 1's by-eye plot check exists precisely to catch this
   before any tuning; Step 2 requires hand-checking rep timestamps against
   video on 3 clips.
3. **Overfitting theater:** Step 3 could quietly tune on all clips and report
   great numbers. *Fix folded in:* tuning set is named explicitly (front-view
   good-light only), Step 4 forbids retuning, and V3 checks the evaluator
   itself.
4. **Human-dependency stall:** Steps 0 and 4 need the human; a blind executor
   could wait forever. *Fix folded in:* both are marked `[HUMAN]` with
   file-presence as the handoff signal; executor proceeds with Steps 1–2
   scaffolding on any subset of clips already present.
5. **MediaPipe API drift:** the Tasks API has churned before. *Fix folded in:*
   recon flag R1 says verify against current official docs before writing the
   harness, don't code from memory.
6. **What breaks under load:** nothing here — the whole point is that v1 has
   no scale surface. The load risk is *product* load (leaderboards changing
   the §2 threat model), flagged as a product fork trigger, not deferred
   silently.

---

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
