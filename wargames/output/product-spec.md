# Product Design Spec — Verified-XP Fitness Leveler (v1)

Derived from ENG (`wargames/workout-tracker-verification.md`) and MKT
(`wargames/output/market-analysis-report.md`). Every feature carries a trace
tag `[C#]` to the constraint ledger in §1. Anything that could not be traced was
cut, not justified.

Recon: R1 pass (both source files + STD readable). R2 pass (ENG `## Priority
list` present with SOLVE/DESIGN AROUND/ACCEPT/KILL; MKT §1 banned-terms list
present). No abort tripped. F1 not triggered (effort-time parity holds at 1.11×).

---

## 1. Constraint ledger

Constraints extracted verbatim (or tightly paraphrased with the quote) from ENG
and MKT. 20 constraints, each with a file+section cite. 0 UNSOURCED → A1 not
triggered.

| # | Constraint | Source |
|---|---|---|
| C1 | **Private XP in v1, no leaderboard.** "If XP is private (no leaderboard, no payouts), a cheater defeats only themselves and the correct security budget is ≈ zero." Adding a leaderboard "flips" the threat model — a product fork, noted not built. | ENG §2 |
| C2 | **Start-button sessions + arming gate; no free-running segmentation.** "A start button costs one tap." Armed only when full body visible + landmarks trusted + standing pose held ~1s. | ENG §4; Priority KILL |
| C3 | **Generous depth line + live "too shallow" feedback (fatigue UX).** Cycle completed without depth → explicit "too shallow — didn't count." | ENG §1; §4; DESIGN AROUND |
| C4 | **Prescribed camera setup gate.** Refuse to arm until "full body is in frame, all leg landmarks trusted, and stable for ~1s. Prescribe: phone ~2m away, roughly hip height, front-facing or side-on." | ENG §3 |
| C5 | **Append-only event log priced into XP by a pure function.** "append-only *event* log … The ledger prices events into XP as a pure function. Repricing = re-fold the log." | ENG §6 |
| C6 | **On-device everything; sync events, never video.** "On-device everything … sync events, never video. Privacy, offline, zero server cost." | ENG §6 |
| C7 | **Rigor parity across vision/GPS paths.** "match rigor to threat model on *both* paths (i.e., both casual in v1: pace-plausibility check on GPS ≈ IMU check on vision)." | ENG §6 |
| C8 | **KILL list forbidden in the spec:** trajectory/DTW template matching; open-set "is the user exercising" detection; adaptive per-user thresholds; any anti-cheat that raises honest false rejections. | ENG Priority KILL |
| C9 | **Untrusted frames freeze the state machine.** "Bad frames get marked *untrusted*; the state machine is forbidden to change state on untrusted frames. It holds state and waits." | ENG §3 |
| C10 | **Rep = full monotone state cycle.** `STANDING → DESCENDING → [depth ≥ B?] → ASCENDING → STANDING`; valid only on cycle completion with depth met. | ENG §4 |
| C11 | **IMU still-phone check.** Phone bob is "the laziest cheat, so it's the one that will actually happen" — accelerometer variance over threshold → set paused ("keep the phone still"). | ENG §2 |
| C12 | **Each verified exercise needs its own state machine.** Squat is the proven pipeline; a second exercise (e.g. push-up) "needs its own state machine." | ENG §3; §5 corpus |
| C13 | **Camera-loop features are conditional on the ENG kill test passing.** "No app until it passes." Vision features ship `GATED ON KILL TEST`. | ENG Verdict; kill test |
| C14 | **Form-quality coaching is out of v1.** "v1 answers 'did the hip go down past the line and back up,' not 'was it good form.' Form coaching is a different product." | ENG §1 ACCEPT |
| C15 | **Banned terms never in UI copy, feature names, or product vocabulary:** "Solo Leveling", "Sung Jinwoo"/"Jinwoo"/"Cha Hae-In", "Arise", "KARMA"/"ARISE Overdrive", "Shadow Monarch"/"Ashborn"/"Monarch(s)", and franchise-styled "The System". | MKT §1 |
| C16 | **Free tier must contain a complete loop.** Arise's top complaint is "paywall blocks trial"; the free tier must be a full, forever-playable loop. | MKT §2 (Arise complaint); §5.5 |
| C17 | **Free + subscription; Pro = breadth, never the core loop.** Pro gates additional verified exercises, advanced stats/history, higher-rank cosmetics + form scoring. Free reaches rank C and completes daily quests forever. | MKT §5.5; §2 |
| C18 | **Positioning promise "XP you actually earned" — no honor-system XP source may exist in v1.** The enemy is honor-system XP; every XP source must be sensor/camera-verified. | MKT §4 |
| C19 | **Rank ladder E→S is allowed vocabulary.** "rank / rank up (E→S)" is a generic, collision-free genre term. | MKT §1 allowed terms |
| C20 | **Quest board / daily quests are a validated core-loop pattern.** The 4.8★ levelers (Arise, Solo X) run "daily quests → XP" as their core loop. | MKT §2 core-loop column |

---

## 2. Core loop

Four flows. Every element is trace-tagged. There is **zero honor-system XP
source** — every XP event originates from a verified rep cycle or a
plausibility-checked GPS/step record `[C18]`.

### 2.1 Set flow (vision)
Open app → pick exercise → **Start Set** `[C2]` → **setup gate** (full body in
frame, all leg landmarks trusted, stable ~1s; prescribed phone ~2m, hip height)
`[C4]` → **3-2-1 countdown** → **armed** (standing pose held ~1s) `[C2]` → live
**rep counter with per-rep verdict**: valid rep on a full monotone
`STANDING→DESCENDING→depth→ASCENDING→STANDING` cycle → `+XP`; cycle without depth
→ inline **"too shallow — didn't count"** `[C3][C10]`. Untrusted frames **freeze
the counter** ("hold on…") and never emit a verdict `[C9]`; phone bob (IMU
variance) pauses the set with "keep the phone still" `[C11]` → **End Set** → set
summary (reps, XP, best-depth stat). Exercise behavior (thresholds, state
machine) is owned by ENG §1/§3/§4 and is *referenced*, not re-specified here.

### 2.2 Run/walk flow (GPS)
**Start Run** → live pace / distance / steps → **pace-plausibility check** (same
casual rigor as the IMU check on the vision path — reject bike/drive pace)
`[C7][C18]` → **End** → run summary → XP. On-device; only the route summary
event syncs, never a video/track upload `[C6]`.

### 2.3 Daily loop
A **quest board** of 1–3 daily quests (e.g. "30 verified squats", "2 km run")
seeded from the user's onboarding goal `[C20]`. Quest completion = bonus XP
(×1.25, see §3). A **streak** = consecutive calendar days with ≥1 completed
quest; streak drives a capped bonus (§3). All quest progress is measured from
verified events only `[C18]`.

### 2.4 Session-to-session
Verified events fold into: **levels** (XP curve, §3), **rank promotions
E→D→C→B→A→S** `[C19]`, and **2 stats** derived *only* from the event log, never
hand-entered `[C5][C18]`:
- **Strength** — grows from valid vision rep events.
- **Endurance** — grows from verified GPS/step distance events.

All progression is a pure fold over the append-only event log `[C5]`; repricing
or retuning re-folds the log and never migrates data.

---

## 3. Progression & XP economy

**Design rules honored:** effort-time parity (rule 1), pure pricing function
`XP = f(event log)` (rule 2) `[C5]`, early-fast/late-slow level curve (rule 3),
rank→level bands (rule 4), and a worked simulation inside the acceptance bands
(rule 5).

### 3.1 Pricing function `XP = f(event log)` `[C5]`

| Event type | Base XP | Verified by |
|---|---|---|
| Valid vision rep (squat / push-up) | **10 XP / rep** | depth + trust state machine (ENG §1/§3/§4) `[C10]` |
| Verified run/walk (GPS) | **300 XP / km** | pace-plausibility check (ENG §6) `[C7]` |
| Verified step walk (no GPS fix) | **≈0.3 XP / step** (priced to the 300 XP/km line, ~1000 steps/km) | step counter, distance-equivalent `[C7]` |

**Multipliers** (applied by the ledger; the base pricing is data, the numbers are
tuned):

| Multiplier | Value | Rule |
|---|---|---|
| Quest bonus | ×1.25 on XP earned toward a completed daily quest | `[C20]` |
| Streak bonus | ×1.0 (0–2 days) · ×1.1 (3–6) · ×1.25 (7–29) · ×1.5 (30+), capped ×1.5 | `[C20]` |
| **Compound cap** | **×2.0 total** (inflation guard) | max realizable = 1.25 × 1.5 = **1.875 ≤ 2.0** ✓ |

**Effort-time parity (rule 1).** Throughput assumptions: ~5 valid reps per
verified active minute; recreational run pace 9 km/h (0.15 km/min).
- Vision: 5 reps/min × 10 = **50 XP/verified-min**.
- GPS: 0.15 km/min × 300 = **45 XP/verified-min**.
- A 30-min rep session = 1500 XP; a 30-min run = 1350 XP → **ratio 1.11×**,
  well within the 2× band. The ENG §6 "loose path pays better" failure is
  designed out `[C7]`.

### 3.2 Level curve (rule 3)

Closed form, L = 1..50:

> **Cumulative XP to reach level L:  `CumXP(L) = 500 · L · (L − 1)`**
> **Cost of level L → L+1:  `1000 · L`** (early levels cheap, later levels
> progressively dearer — early-fast, late-slow.)

| L | CumXP(L) | L | CumXP(L) | L | CumXP(L) |
|---|---|---|---|---|---|
| 1 | 0 | 12 | 66,000 | 30 | 435,000 |
| 2 | 1,000 | 15 | 105,000 | 35 | 595,000 |
| 3 | 3,000 | 20 | 190,000 | 36 | 630,000 |
| 5 | 10,000 | 21 | 210,000 | 40 | 780,000 |
| 8 | 28,000 | 25 | 300,000 | 45 | 990,000 |
| 9 | 36,000 | 28 | 378,000 | 50 | 1,225,000 |

(The 100-squat meme routine = 1000 base XP = one full early level.)

### 3.3 Rank gates (rule 4) `[C19]`

| Rank | Level band | XP to reach (rank floor) |
|---|---|---|
| E | 1 – 4 | 0 |
| D | 5 – 8 | 10,000 |
| C | 9 – 11 | 36,000 |
| B | 12 – 20 | 66,000 |
| A | 21 – 35 | 210,000 |
| S | 36 – 50 | 630,000 |

Free tier reaches **rank C** and plays the full loop forever; higher ranks are a
Pro progression surface, never a wall on the core loop `[C16][C17]`.

### 3.4 Simulation check (rule 5 — worked arithmetic)

**Persona XP/week** (worked from the pricing table + throughput above):
- **Casual** — 3 sessions/week × 20 min = 60 verified min. Base = 60 × 50 =
  **3,000 XP/wk**. Completes the daily quest each session (×1.25); works out on
  non-consecutive days so streak stays ×1.0. **Effective = 3,000 × 1.25 =
  3,750 XP/wk.**
- **Committed** — 6 × 40 min = 240 verified min. Base = 240 × 50 =
  **12,000 XP/wk**. Adversarial *fastest* case for the S guard: quest ×1.25 ×
  30-day streak ×1.5 = ×1.875. **Fast = 12,000 × 1.875 = 22,500 XP/wk.**

| Rank (floor XP) | Casual @ 3,750/wk | Committed @ 22,500/wk (fastest) |
|---|---|---|
| E (0) | 0 | 0 |
| D (10,000) | **2.67 wks** | 0.44 wks |
| C (36,000) | 9.6 wks (2.2 mo) | 1.6 wks |
| B (66,000) | **17.6 wks ≈ 4.05 mo** | 2.9 wks |
| A (210,000) | 56.0 wks (12.9 mo) | 9.3 wks (2.1 mo) |
| S (630,000) | 168 wks | **28.0 wks ≈ 6.44 mo** |

**Acceptance bands — all hold on the first pass (0 tuning rounds):**
- Casual reaches **D in 2–4 weeks** → 2.67 wks ✓
- Casual reaches **B in 3–6 months** → 4.05 mo ✓
- Committed **cannot reach S under 6 months** → 6.44 mo ✓ (even at the max
  ×1.875 multiplier)

Because parity (rule 1) and the bands hold simultaneously, **F1 (relax parity to
3×) was not triggered** and **A2 (unsatisfiable bands) was not tripped**.

---

## 4. Screen map

12 v1 screens. Every screen serves a §2 flow. The two binding UX rules appear
verbatim as design notes on the live set screen.

| # | Screen | Purpose | Key elements | Serves |
|---|---|---|---|---|
| 1 | Onboarding | Pick a goal and learn the camera setup | Goal picker (seeds quests `[C20]`); camera-setup tutorial per ENG §3 prescription `[C4]` | 2.1, 2.3 |
| 2 | Home / Quest board | The daily hub | 1–3 daily quests, streak counter, "Start" entry points | 2.3 |
| 3 | Exercise picker | Choose a verified exercise | Squat + push-up (Pro exercises locked) `[C12][C17]` | 2.1 |
| 4 | Setup-gate | Refuse to arm until the frame is trustworthy | Full-body/trust/stability checks, phone-placement guide `[C4]` | 2.1 |
| 5 | Live set | Count and judge reps in real time | Rep counter, per-rep verdict, best-depth `[C3][C9][C10][C11]` | 2.1 |
| 6 | Set summary | Close out a set | Reps, XP, best-depth stat, quest progress | 2.1, 2.3 |
| 7 | Run screen | Track a verified run/walk | Live pace/distance/steps, plausibility state `[C7]` | 2.2 |
| 8 | Run summary | Close out a run | Distance, pace, XP, quest progress | 2.2, 2.3 |
| 9 | Profile | Show progression | Level, rank E→S, Strength/Endurance stats, streak `[C5][C19]` | 2.4 |
| 10 | Progression / history | Level & stat history over time (advanced history is Pro) | XP timeline, stat graphs `[C17]` | 2.4 |
| 11 | Settings / Privacy | State the trust model | On-device statement: "processing on-device; events sync, never video" `[C6]` | all |
| 12 | Paywall | Sell Pro breadth, never the loop | Pro = more verified exercises, advanced stats/history, form scoring, higher-rank cosmetics `[C17]` | 2.4 |

**Binding UX design notes on Screen 5 (Live set), verbatim:**
- **Rejection UX:** a rejected rep must show *why* ("too shallow") and never
  interrupt the set — feedback is inline, not modal `[C3]`.
- **Trust UX:** untrusted frames freeze the counter with a subtle "hold on…"
  state, never a rep verdict — the freeze IS the designed failure mode `[C9]`.

---

## 5. v1 scope & free/Pro split

### 5.1 MoSCoW

| Priority | Item | Note / trace |
|---|---|---|
| **Must** | Squat pipeline (vision) | `GATED ON KILL TEST` `[C13]` |
| **Must** | Second verified exercise: push-up | own state machine; `GATED ON KILL TEST` `[C12][C13]` |
| **Must** | Runs / walks (GPS + steps) with pace-plausibility | `[C7]` |
| **Must** | Setup gate + arming; no free-running segmentation | `[C2][C4]` |
| **Must** | Live per-rep verdict + "too shallow" + untrusted-freeze | `[C3][C9][C10]` |
| **Must** | IMU still-phone check | `[C11]` |
| **Must** | Append-only event log + pure XP pricing ledger | `[C5]` |
| **Must** | Quests, levels, ranks **E→C**, streaks | `[C16][C19][C20]` |
| **Must** | On-device processing; events sync, never video | `[C6]` |
| **Must** | Complete **free** loop (playable & levelling forever to rank C) | `[C16][C17]` |
| **Should** | Advanced stats / history | Pro `[C17]` |
| **Should** | Additional verified exercises beyond squat+push-up | Pro; each needs its own state machine `[C12][C17]` |
| **Should** | Ranks **B→S** progression + cosmetics | Pro `[C17]` |
| **Could** | Camera-verified form scoring | Pro *only*; not core form-coaching `[C14][C17]` |
| **Won't** | Trajectory/DTW matching | ENG KILL `[C8]` |
| **Won't** | Free-running "is the user exercising" detection | ENG KILL `[C8]` |
| **Won't** | Adaptive per-user thresholds | ENG KILL `[C8]` |
| **Won't** | Any anti-cheat that raises honest false rejections | ENG KILL `[C8]` |
| **Won't** | Leaderboards / any social XP comparison | ENG §2 threat-model fork — v2 only, flips the whole §2 security posture `[C1]` |
| **Won't** | Form-quality coaching (as a core product) | ENG ACCEPT `[C14]` |
| **Won't** | Wearables | out of v1 scope (ENG §6 keeps two on-device paths) |
| **Won't** | Android (if iOS-first) | platform-sequencing note; camera pipeline ports after iOS |

### 5.2 Free / Pro split rule (MKT §5.5) `[C17]`

- **Free (forever):** full set flow (squat + push-up), full run/walk flow,
  quests, streaks, levels, ranks **through C**, Strength/Endurance stats. Passes
  the test *"a user who never pays can level up daily without hitting a wall"*
  `[C16]`.
- **Pro (subscription, ~$5–8/mo or ~$40–60/yr):** additional verified exercises,
  advanced stats/history, higher-rank progression **B→S** + cosmetics, and
  camera-verified form scoring. **Pro gates breadth, never the core loop.**

The two `Must` vision items depend on the ENG squat kill test; they ship
**`GATED ON KILL TEST`** — the dependency is named, not hidden `[C13]`.

---

## 6. Open questions & risks

1. **XP acceptance bands are genius-set, not market data.** The 2–4 wk-to-D and
   no-S-under-6-mo bands are judgment. *Resolves when:* beta cohort retention is
   measured and the bands are validated (or re-set) against real progression —
   they are revisable inputs, not dogma.
2. **Camera-verification retention is unproven for a game loop.** Mandatory
   verification may add friction pure honor-system levelers avoid (MKT §7.4).
   *Resolves when:* a beta measures the verified-XP arm vs an honor-system arm.
3. **Vision features are conditional on the ENG kill test** `[C13]`. If the
   squat kill test dies, the camera loop dies and v1 falls back to the GPS/step
   loop only. *Resolves when:* the ENG weekend kill test passes V1–V3 and the
   friends pass.
4. **Legal review of all UI copy** (MKT §7.2 / red-team #4). The aesthetic is
   legal only while copy stays on the §1 allowed vocabulary; quest/notification
   copy must use its own voice. *Resolves when:* legal signs off on final store
   + in-app copy and the banned-terms sweep stays clean per release.
5. **Second-exercise (push-up) pipeline risk** `[C12]`. Push-up needs its own
   state machine distinct from the squat pipeline. *Resolves when:* the push-up
   state machine passes the same corpus protocol ENG §5 prescribes for squats.

*F1 (parity → 3× relaxation) was not triggered and therefore requires no entry
here; parity holds at 1.11×.*

---

## 7. Trace index

Every feature → its constraint/cite. No `(untraced)` rows.

| # | Feature | Trace |
|---|---|---|
| 1 | Private XP, no leaderboard in v1 | C1 (ENG §2) |
| 2 | Start-button + arming gate; no free-running segmentation | C2 (ENG §4) |
| 3 | Generous depth line + live "too shallow" feedback | C3 (ENG §1) |
| 4 | Prescribed camera setup gate | C4 (ENG §3) |
| 5 | Append-only event log + pure XP pricing function | C5 (ENG §6) |
| 6 | On-device processing; sync events, never video | C6 (ENG §6) |
| 7 | Rigor parity across vision/GPS paths | C7 (ENG §6) |
| 8 | KILL-list items excluded (Won't column) | C8 (ENG Priority KILL) |
| 9 | Untrusted-frame freeze on live set screen | C9 (ENG §3) |
| 10 | Rep = full monotone state cycle | C10 (ENG §4) |
| 11 | IMU still-phone check | C11 (ENG §2) |
| 12 | Push-up as a distinct second state machine | C12 (ENG §3/§5) |
| 13 | Vision features `GATED ON KILL TEST` | C13 (ENG Verdict) |
| 14 | Form-quality coaching excluded from core v1 | C14 (ENG §1 ACCEPT) |
| 15 | Banned terms absent from UI/product vocabulary | C15 (MKT §1) |
| 16 | Complete free loop, no paywall on core loop | C16 (MKT §2/§5.5) |
| 17 | Free+sub; Pro gates breadth; free reaches rank C | C17 (MKT §5.5) |
| 18 | No honor-system XP source ("XP you actually earned") | C18 (MKT §4) |
| 19 | Rank ladder E→S | C19 (MKT §1 allowed terms) |
| 20 | Quest board / daily quests | C20 (MKT §2 core-loop column) |
| 21 | Strength / Endurance stats from event log only | C5 + C18 |
| 22 | Level curve `CumXP(L)=500·L·(L−1)` | Step 3 rule 3 (plan) |
| 23 | Rank→level bands E→S | Step 3 rule 4 + C19 |
| 24 | Quest ×1.25 / streak ≤×1.5 / ×2.0 compound cap | Step 3 rule 2 + C20 |
| 25 | Pro form scoring (Could) | C17 + C14 |
