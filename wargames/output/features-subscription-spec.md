# Feature Set & Subscription Spec — Verified-XP Fitness Leveler (v1)

Derived only from SPEC (`wargames/output/product-spec.md`), MKT
(`wargames/output/market-analysis-report.md`), PROD (`PRODUCT.md`), and ENG
(`wargames/workout-tracker-verification.md`).

**Recon:** R1 pass (all four files readable). R2 pass (SPEC §5.1 MoSCoW + §5.2
free/Pro rule present; C16/C17/C18 present). No abort (A1/A2/A3) tripped.
**Fork F1:** NOT triggered — 2 launch-day Pro items are not gated on the kill
test (≥2 threshold met); no free-only-launch contingency section written (see §6).

Binding rules carried throughout: B1 (free tier forever-playable to rank C;
C16/C17 inviolable), B2 (arbiter voice — terse, exact, never pleading), B3
(price anchors MKT §5.5), B4 (no MKT §1 banned term in names/copy), B5
(vision features carry `GATED ON KILL TEST`, SPEC C13).

---

## 1. Feature inventory

22 feature cards. Every card carries a trace. Every vision-dependent card
carries `GATED ON KILL TEST`. Tier column matches SPEC §5.2; cards not literally
enumerated in §5.2 are marked `RULE-ASSIGNED` (assigned by C17: loop→Free,
breadth→Pro) for one-pass human review.

| ID | Name | Description | Acceptance criteria (checkable, user-visible) | Tier | Dependencies | Trace |
|---|---|---|---|---|---|---|
| F1 | Squat rep verification (vision) | Camera + pose state machine judges each squat valid/invalid on a full monotone cycle; valid rep = +10 XP. | (a) A full-depth squat cycle shows `+10 XP`; (b) a shallow cycle shows "too shallow — didn't count"; (c) no XP without a completed cycle. | Free | F5, F6, F7, F8, F9; kill test | SPEC §5.1 Must, C10/C13 |
| F2 | Push-up rep verification (vision) | Second verified exercise with its own state machine; valid rep = +10 XP. | (a) Valid push-up = `+10 XP`; (b) partial rep rejected inline; (c) counts only on cycle completion. | Free | F5–F9; own state machine; kill test | SPEC §5.1 Must, C12/C13 |
| F3 | Run/walk tracking (GPS) | Live pace/distance/steps with a pace-plausibility check; 300 XP/km. | (a) A verified km = 300 XP; (b) bike/drive pace is rejected as implausible; (c) only the route summary event syncs, never a track upload. | Free | F9, F15 | SPEC §2.2/§5.1 Must, C7 |
| F4 | Step-walk tracking (no GPS fix) | Step counter priced to the distance line (~0.3 XP/step). | (a) Steps accrue XP at ~0.3/step; (b) works with no GPS fix; (c) same plausibility rigor as GPS. | Free | F9, F15 | SPEC §3.1, C7 |
| F5 | Setup gate + arming | Refuses to arm until full body in frame, landmarks trusted, standing pose held ~1s. | (a) Cannot start a set until the gate passes; (b) walking in / adjusting phone cannot arm; (c) prescribes phone ~2m, hip height. | Free `RULE-ASSIGNED` | kill test | SPEC §4 scr.4, C2/C4/C13 |
| F6 | Live per-rep verdict + "too shallow" | Inline, non-modal verdict per rep; rejection states why. | (a) Rejection shows reason inline; (b) never interrupts the set with a modal; (c) verdict also via haptic/audio. | Free `RULE-ASSIGNED` | F1/F2; kill test | SPEC §4 scr.5, C3/C10/C13 |
| F7 | Untrusted-frame freeze | Bad frames freeze the counter ("hold on…"); state machine never changes on untrusted frames. | (a) Untrusted frames show freeze, not a verdict; (b) state resumes when frames recover; (c) no phantom rep during freeze. | Free `RULE-ASSIGNED` | F1/F2; kill test | SPEC §4 scr.5, C9/C13 |
| F8 | IMU still-phone check | Accelerometer variance over threshold pauses the set ("keep the phone still"). | (a) Phone bob pauses the set; (b) still phone never triggers it; (c) resume requires phone still. | Free `RULE-ASSIGNED` | F1/F2; kill test | SPEC §5.1 Must, C11/C13 |
| F9 | Append-only event log + pure XP ledger | Every XP point folds from an append-only event log via a pure pricing function; repricing = re-fold. | (a) No XP source exists outside the log; (b) history is never mutated/deleted; (c) retune re-folds without data migration. | Free `RULE-ASSIGNED` | — | SPEC §2.4/§3.1, C5/C18 |
| F10 | Daily quest board | 1–3 daily quests seeded from the onboarding goal; completion = ×1.25 XP. | (a) Quests seed from the chosen goal; (b) completion applies ×1.25; (c) progress counts verified events only. | Free | F9, F20 | SPEC §2.3/§5.1 Must, C20 |
| F11 | Levels / XP curve | `CumXP(L)=500·L·(L−1)`, L=1..50; early-fast/late-slow. | (a) 1000 base XP = level 1→2; (b) level shown on profile; (c) XP keeps accruing at every level. | Free | F9 | SPEC §3.2 |
| F12 | Ranks E→C | Rank ladder E→D→C; free ceiling is rank C. | (a) Rank badge advances E→D→C; (b) rank C persists forever; (c) no wall on the loop at C. | Free | F11 | SPEC §3.3/§5.1 Must, C16/C17/C19 |
| F13 | Streaks + streak bonus | Consecutive-day streak drives a capped multiplier (×1.0/1.1/1.25/1.5, cap ×1.5). | (a) 30-day streak yields ×1.5; (b) multiplier shown; (c) compound cap ×2.0 never exceeded. | Free | F9, F10 | SPEC §3.1/§5.1 Must, C20 |
| F14 | Strength & Endurance stats | Two stats derived only from the event log (never hand-entered). | (a) Strength grows from vision reps; (b) Endurance grows from GPS/steps; (c) no manual entry field exists. | Free | F9 | SPEC §2.4, C5/C18 |
| F15 | On-device processing / events-sync-never-video | All processing on-device; only events sync, never video/track. | (a) Works offline; (b) no video leaves the device; (c) settings screen states this. | Free `RULE-ASSIGNED` | — | SPEC §2/§4 scr.11, C6 |
| F16 | Advanced stats / history | Full stat timeline + per-session breakdowns over time. | (a) Free shows basic current stats; (b) advanced timeline/breakdown is Pro-gated; (c) data survives lapse (view re-locks, log intact). | Pro | F9, F14 | SPEC §5.1 Should, C17 |
| F17 | Additional verified exercises | Verified exercises beyond squat + push-up, each with its own state machine. | (a) Squat + push-up always free; (b) further exercises Pro-gated; (c) each new exercise ships only when its state machine passes the corpus protocol. | Pro | F5–F9; each own state machine; kill test | SPEC §5.1 Should, C12/C13/C17 |
| F18 | Ranks B→S progression + cosmetics | Rank promotions B→A→S and the cosmetics each rank earns. | (a) Rank C is the free ceiling; (b) B→S promotions are Pro; (c) earned rank is never clawed back on lapse. | Pro | F11, F12 | SPEC §5.1 Should, C17/C19 |
| F19 | Camera-verified form scoring | Camera-verified form scoring (not core form-coaching, which is out of v1). | (a) Present only for Pro; (b) scores are camera-verified, not honor-system; (c) absent for free users. | Pro | F1/F2; kill test | SPEC §5.1 Could, C14/C17 |
| F20 | Onboarding goal picker | Pick a goal (seeds quests) + learn the camera setup. | (a) Goal choice seeds the first quest board; (b) camera-setup tutorial shown; (c) reachable once at first run. | Free `RULE-ASSIGNED` | — | SPEC §4 scr.1, C20/C4 |
| F21 | Settings / Privacy screen | States the trust model: on-device, events sync never video. | (a) States "processing on-device; events sync, never video"; (b) reachable from home; (c) no honor-system toggle exists. | Free `RULE-ASSIGNED` | F15 | SPEC §4 scr.11, C6 |
| F22 | Streak display | Streak counter surfaced on home + profile. | (a) Current streak shown on home; (b) shown on profile; (c) no streak-guilt pop-up (PROD anti-reference). | Free `RULE-ASSIGNED` | F13 | SPEC §4 scr.2/9, C20 |

*Excluded (SPEC §5.1 Won't — not cards): trajectory/DTW matching, free-running
detection, adaptive thresholds, honest-false-reject anti-cheat (all ENG KILL,
C8); leaderboards/social XP (C1); core form-coaching (C14); wearables; Android
if iOS-first.*

---

## 2. Wall test

Six scripted journeys walked against the §1 inventory. All six pass with no hard
wall and no dark-pattern moment (B1/B2 held). J3 and J5 name the exact
screen/state.

**J1 — Day-1 new user, first verified set.**
New user finishes onboarding (F20), picks squat (free), passes the setup gate
(F5), arms, and completes a full-depth cycle → `+10 XP` (F1/F6). Ten reps = 100
XP toward level 1→2 (F11). Set summary shows reps/XP/best-depth. No paywall
appears at set end (negative list, §3.4). **Verdict: PASS — no wall.**

**J2 — Week-2 free user, quests + runs.**
Home shows the quest board seeded from the user's goal (F10/F22). User completes
"30 verified squats" (×1.25 quest bonus) and a 2 km run (F3, 600 XP + ×1.25 on
quest portion). All flows are free; no paywall at quest completion or streak
events (negative list). **Verdict: PASS — no wall.**

**J3 — Free user hits the rank-C ceiling (B-promotion moment).**
User reaches level 11 (top of rank C) and keeps earning; at the level-12 XP
threshold the app would promote to rank B. Because B→S is Pro (F18), this is the
one designed paywall at a breadth boundary (§3.4b). **Exact screen/state:** the
Paywall screen (SPEC §4 scr.12) presents "rank B–S is Pro." Rank C badge
persists on the Profile, the XP bar keeps filling, the level number keeps
climbing past 11, and every loop surface (sets, runs, quests, streaks, stats)
stays fully playable. It reads as a state (a Pro progression surface), not a
wall on the loop. Decline returns to Profile with zero loss.
**Verdict: PASS — state, not wall.**

**J4 — Free user on a 30-day streak.**
Streak reaches 30 days → ×1.5 streak multiplier applies to earned XP (F13).
Multipliers are core-loop, not breadth, so they stay free (B1; red-team #3).
Compound cap ×2.0 is respected (1.25 × 1.5 = 1.875 ≤ 2.0). No streak-guilt or
countdown copy (B2/PROD anti-reference). **Verdict: PASS — multipliers free.**

**J5 — Pro subscriber lapses.**
A user who reached rank A on Pro lets the subscription lapse. **Exact
screen/state:** Profile shows the earned rank A badge and full level preserved
(earned progression never clawed back, §3.6); Pro-exercise tiles in the picker
re-lock (F17); the advanced-history view re-locks behind the paywall (F16) but
the underlying event log is intact and untouched (append-only, C5) — resubscribe
restores the view with no data loss. Core loop (squat/push-up/run/quests/streaks/
Strength+Endurance) works fully at their level. Going forward, further B→S
promotions re-require Pro. **Verdict: PASS — earned kept, breadth re-locks.**

**J6 — Free user who never does vision (kill-test-failure world).**
With no camera loop, the user runs the complete GPS/step loop: runs/walks +
steps (F3/F4) → XP → run-seeded quests (F10) → levels (F11) → ranks E→C (F12) →
streaks (F13) → Endurance stat (F14). A full, forever-playable free loop exists
without any vision feature. **Verdict: PASS — complete GPS/step loop.**

**All six journeys pass.** No journey hit a wall, so no Step-1 tier move was
needed (counter-move not triggered).

---

## 3. Subscription design

### 3.1 Tier sheet

| Tier | Contents (one line each) |
|---|---|
| **Free (forever)** | Squat + push-up set flow; run/walk + step flow; daily quests; streaks + bonus multipliers; levels 1–50; ranks E→C; Strength + Endurance stats; on-device, events-sync-never-video. |
| **Pro (subscription)** | Additional verified exercises (F17); advanced stats/history (F16); ranks B→S progression + cosmetics (F18); camera-verified form scoring (F19). Pro gates breadth, never the core loop. |

### 3.2 Price points (by rule, with arithmetic)

- **Monthly:** midpoint of MKT's $5–8 band = $6.50, rounded to x.99 = **$6.99/mo**.
- **Annual (worked):** $6.99 × 12 = **$83.88**. A 40–50% discount → annual in
  $83.88×0.50 = $41.94 to $83.88×0.60 = $50.33. Intersect with MKT's $40–60
  band → $41.94–$50.33. **Pick $44.99/yr:** discount = 1 − 44.99/83.88 = **46.4%**
  (inside 40–50%) and $44.99 is inside $40–60. ✓
- **No conflict** between the two annual rules, so the widen-to-nearest-x.99
  counter-move was not needed.
- **No lifetime tier in v1:** MKT §2 shows a lifetime option only on Solo X —
  the weakest listed comparable (20 ratings) — so it is not a signal worth
  copying; a subscription also better matches the ongoing-content (new verified
  exercises) model.

### 3.3 Trial policy (by rule)

- The **free tier IS the trial** of the core loop (C16) — it is forever-playable
  to rank C, so the loop needs no separate trial.
- A **7-day Pro trial** is offered only at a moment of demonstrated intent
  (trigger rule in §4), **never** as a launch interstitial.

### 3.4 Paywall placement rules (testable)

Paywall **may appear only at a breadth boundary**:
- (a) tapping a **locked Pro exercise** in the picker;
- (b) the **rank-B promotion moment**;
- (c) tapping **locked advanced history**.

Paywall **may never appear** at: app open · set end · quest completion · streak
events. (Each rule is pass/fail against a build.)

### 3.5 Copy rules + example strings (arbiter voice, B2)

**Rules:** state what Pro contains in one line; always show price; no exclamation
marks; no pleading verbs (unlock / unleash / supercharge / don't-miss /
"unlock-your-potential" language); no countdown/urgency; no fake discounts; no
streak-guilt. The arbiter never begs — it states what Pro contains. Every string
swept against MKT §1 banned terms.

1. *(locked exercise)* "Pull-ups are a Pro exercise. Pro adds every verified
   exercise beyond squat and push-up. $6.99/mo or $44.99/yr."
2. *(rank-B moment)* "Rank C is the free ceiling. Pro carries ranks B through S
   and the cosmetics each rank earns. $6.99/mo or $44.99/yr."
3. *(advanced history)* "Advanced history is Pro. Pro keeps your full stat
   timeline and per-session breakdowns. $6.99/mo or $44.99/yr."

### 3.6 Lapse policy

Earned progression (rank, level, stats, XP history) is **never clawed back**
(C5). On lapse, **breadth re-locks**: Pro exercises and the advanced-history
view re-lock; further B→S promotions re-require Pro. **Win-back rule:** a single
state notice — "Your Pro exercises and ranks B–S are paused. Resume anytime." —
shown once, with **no nag cadence** (B2).

---

## 4. Upgrade-moment map

Every paywall moment has a clean decline path (returns to exactly where the user
was, zero loss). No moment is on §3.4's negative list.

| Moment | User state | Demonstrated intent (what they just did) | Paywall shows | Decline path |
|---|---|---|---|---|
| (a) Locked Pro exercise | In exercise picker | Tapped a locked Pro-exercise tile | §3.5 string 1 (exercise breadth + price) | Return to picker; squat + push-up still available; zero loss |
| (b) Rank-B promotion | At level-12 XP threshold, rank C | Crossed the rank-C ceiling by earning XP | §3.5 string 2 (ranks B–S + cosmetics + price) | Return to Profile; rank C intact; XP keeps accruing; zero loss |
| (c) Locked advanced history | In progression/history screen | Tapped the advanced-history view | §3.5 string 3 (advanced history + price) | Return to basic history; zero loss |

**7-day Pro trial trigger (testable conjunction):** offered **at most once**, and
only after the user has (a) completed **≥5 sessions** AND (b) **hit a breadth
boundary organically** (one of the three moments above). Never a launch
interstitial. All three moments and the trial trigger comply with §3.4's
negative list.

---

## 5. Unit-economics sanity table

**This is a sanity table, not a forecast.** No growth projections, no CAC —
organic-only launch per MKT §6.

**Inputs (all genius-set assumptions, all revisable):**
- Free→Pro conversion: **2% / 4% / 6%** (scenarios).
- Monthly price: **$6.99**; annual price: **$44.99** (monthly-equiv $44.99/12 = **$3.749**).
- Annual mix: **40%** of subscribers annual, 60% monthly.
- App Store cut: **70/30** (year-1) then **85/15** (year-2 subscriber rate → developer keeps 85%).
- Cohort base: **10,000 free users**, output = revenue **per month**.

**Blended gross revenue per subscriber per month** =
0.60 × $6.99 + 0.40 × $3.749 = $4.194 + $1.500 = **$5.6937**.

| Conversion | Subscribers /10k | Gross /mo (subs × $5.6937) | Net @ 70% (×0.70) | Net @ 85% (×0.85) |
|---|---|---|---|---|
| 2% | 200 | 200 × 5.6937 = **$1,138.73** | **$797.11** | **$967.92** |
| 4% | 400 | 400 × 5.6937 = **$2,277.47** | **$1,594.23** | **$1,935.85** |
| 6% | 600 | 600 × 5.6937 = **$3,416.20** | **$2,391.34** | **$2,903.77** |

Every cell is computable from the stated inputs; no input was missing (counter-
move not needed). Inputs are labeled assumptions and re-carried in §6.

---

## 6. Open questions

1. **Conversion and mix are genius-set, not market data.** The 2/4/6%
   conversion and the 40% annual mix in §5 are invented assumptions, not
   measured. *Resolves when:* a beta cohort's real conversion and annual/monthly
   mix are measured and the table is re-run.
2. **F1 (thin-Pro) status.** Fork F1 was **NOT triggered**: launch-day Pro items
   not gated on the kill test = **2** — advanced stats/history (F16) and ranks
   B→S + cosmetics (F18) — meeting the ≥2 threshold, so **no free-only-launch
   contingency section was written**. A3 (fewer than 4 total Pro items) also not
   tripped: 4 total Pro items (F16–F19) exist in the kill-test-passes world. If
   F16 or F18 is later re-cut, re-run F1's count.
3. **Is ranks-B→S alone a strong enough Pro anchor?** If vision ships but form
   scoring (F19) lags, two of four Pro items are vision-gated; the non-vision
   value rests on progression + history. *Resolves when:* beta measures Pro
   conversion attributable to each Pro item.
4. **Price sensitivity untested.** $6.99/mo sits above Arise ($4.99) and Solo X
   ($2.99) floors (MKT §2); the audience's willingness at this point is unproven.
   *Resolves when:* price A/B or beta purchase data exists.
5. **Trial conversion unproven.** The intent-gated 7-day trial (§4) is a design
   bet; its lift over no-trial is unmeasured. *Resolves when:* beta measures
   trial-start and trial→paid rates.

---

## 7. Trace index

Feature / rule → source. No `(untraced)` rows.

| Item | Source |
|---|---|
| F1 Squat verification | SPEC §5.1 Must; C10/C13 (ENG §4/Verdict) |
| F2 Push-up verification | SPEC §5.1 Must; C12/C13 (ENG §3/§5) |
| F3 Run/walk (GPS) | SPEC §2.2/§5.1 Must; C7 (ENG §6) |
| F4 Step-walk | SPEC §3.1; C7 |
| F5 Setup gate + arming | SPEC §4 scr.4; C2/C4 (ENG §3/§4) |
| F6 Per-rep verdict / "too shallow" | SPEC §4 scr.5; C3/C10 (ENG §1) |
| F7 Untrusted-frame freeze | SPEC §4 scr.5; C9 (ENG §3) |
| F8 IMU still-phone check | SPEC §5.1 Must; C11 (ENG §2) |
| F9 Append-only log + pure ledger | SPEC §2.4/§3.1; C5/C18 (ENG §6) |
| F10 Daily quest board | SPEC §2.3; C20 (MKT §2) |
| F11 Levels / XP curve | SPEC §3.2 |
| F12 Ranks E→C | SPEC §3.3; C16/C17/C19 (MKT §5.5/§1) |
| F13 Streaks + bonus | SPEC §3.1; C20 |
| F14 Strength/Endurance stats | SPEC §2.4; C5/C18 |
| F15 On-device / events-sync-never-video | SPEC §4 scr.11; C6 (ENG §6) |
| F16 Advanced stats/history (Pro) | SPEC §5.1 Should; C17 (MKT §5.5) |
| F17 Additional verified exercises (Pro) | SPEC §5.1 Should; C12/C13/C17 |
| F18 Ranks B→S + cosmetics (Pro) | SPEC §5.1 Should; C17/C19 |
| F19 Form scoring (Pro) | SPEC §5.1 Could; C14/C17 |
| F20 Onboarding goal picker | SPEC §4 scr.1; C20/C4 |
| F21 Settings/Privacy screen | SPEC §4 scr.11; C6 |
| F22 Streak display | SPEC §4 scr.2/9; C20 |
| Free-loop integrity (wall test) | B1; C16/C17 (MKT §2/§5.5) |
| Price points $6.99 / $44.99 | B3; MKT §5.5 (§2 price bands) |
| Paywall placement + negative list | B2; PROD design principles; C17 |
| Copy rules / arbiter voice | B2; PROD "Brand Personality"/anti-references |
| No banned terms in names/copy | B4; C15 (MKT §1) |
| `GATED ON KILL TEST` flags | B5; C13 (ENG Verdict) |
| Lapse = no clawback, breadth re-locks | J5; C5 (ENG §6) |
| Unit-economics assumptions | §5 (genius-set); MKT §6 (organic-only) |
