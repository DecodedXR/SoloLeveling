# Feature Design Backlog Spec — the named-but-thin features, designed

Executed per `wargames/feature-backlog.md`. Inputs: SPEC
(`wargames/output/product-spec.md`), SUB
(`wargames/output/features-subscription-spec.md`), PROD (`PRODUCT.md`), MKT
(`wargames/output/market-analysis-report.md`), DSGN (`DESIGN.md`).

**Recon:** R1 pass (all five inputs readable). R2 pass (SPEC §1 C1–C20 table
present; SUB §1 F1–F22 cards present). R3 pass (MKT §1 banned list = 6 term
groups, allowed list = 6 terms). R4 pass — no existing document designs any
D-item to the buildable standard; zero drops.

## Binding invariants (restated; every design below obeys all five)

- **I1 (C18/C5):** No new XP source, multiplier, or economy-number change.
  SPEC §3.1–§3.3 is read-only. Nothing here confers XP beyond what SPEC
  already prices.
- **I2 (C8):** Nothing here changes rep validity, raises honest false
  rejections, or adds adaptive per-user verification thresholds.
- **I3 (C15/B4):** No MKT §1 banned term anywhere. New vocabulary from the
  allowed list (hunter, rank, quest, gate, XP, ascend) or neutral English.
- **I4 (B2/PROD):** All copy in arbiter voice — terse, exact, never pleading.
  No exclamation marks, emoji, streak-guilt, countdowns, or pleading verbs.
- **I5 (C16/C17):** No wall on the free loop. Core loop → Free, breadth → Pro.

---

## 1. Gap table (Step 1 — the entire current spec of each item, verbatim)

| # | Item | The one-line mention that is its whole spec | Cite |
|---|---|---|---|
| D1 | Daily quest system | "A **quest board** of 1–3 daily quests (e.g. '30 verified squats', '2 km run') seeded from the user's onboarding goal" | SPEC §2.3; SUB F10 |
| D2 | Onboarding goals | "Goal picker (seeds quests `[C20]`)" — the goals are never enumerated | SPEC §4 scr.1; SUB F20 |
| D3 | Rank ceremony + cosmetics | "the biggest visual ceremony in the app is a rank promotion" / "Rank promotions B→A→S and the cosmetics each rank earns" — no ceremony design, no cosmetics list | PROD Design Principles §3; SUB F18 |
| D4 | Advanced history split | "Full stat timeline + per-session breakdowns over time" — views never enumerated | SUB F16 |
| D5 | Form scoring | "Camera-verified form scoring (not core form-coaching, which is out of v1)" — no metric defined | SUB F19; SPEC §5.1 Could |
| D6 | Notifications | "quest/notification copy must use its own voice" — the notification set itself does not exist anywhere | SPEC §6.4 |
| D7 | Haptic/audio verdicts | "verdict feedback also delivered via haptic/audio so mid-set users never need to watch the screen" — no event mapping | PROD Accessibility; SUB F6(c) |

---

## 2. D1 — Daily quest system

### 2.1 Quest template catalog (12 templates)

Requirements are expressed **only** in event types SPEC §3.1 prices: valid
vision reps (squat, push-up), verified GPS km, verified steps. Difficulty
tiers are per-template parameters; §2.2 picks the tier. Names use allowed
vocabulary (I3). Trace for all rows: C20 (quest loop), C18 (verified events
only), C5 (measured as a pure fold of the event log).

| ID | Name | Requirement (verified events) | Tiers (low/mid/high) | Seeded by goals |
|---|---|---|---|---|
| Q1 | Squat Quota | N valid squat reps today | 20 / 30 / 50 | Strength, General |
| Q2 | Push-Up Quota | N valid push-up reps today | 15 / 25 / 40 | Strength, General |
| Q3 | Hundred Grind | 100 valid reps today, any mix of squat + push-up | 100 (single tier) | Strength |
| Q4 | Distance Gate | K km verified run today | 1 / 2 / 5 | Endurance, General |
| Q5 | Step Quota | S verified steps today | 4,000 / 7,000 / 10,000 | Habit, Endurance |
| Q6 | Double Set | 2 separate verified sets today, ≥10 valid reps each | fixed | Habit, Strength |
| Q7 | Run and Reps | 1 km verified run + 20 valid reps today | fixed | General |
| Q8 | Long Walk | K km verified walk (GPS or step-equivalent per SPEC §3.1) | 1 / 2 / 3 | Habit, Endurance |
| Q9 | Split Discipline | N valid squats AND M valid push-ups today | 15+10 / 25+15 / 40+25 | Strength, General |
| Q10 | Long Set | One set containing ≥25 valid reps of one exercise | fixed | Strength |
| Q11 | Opener | One verified set of ≥5 valid reps (any exercise) | fixed | all (anchor slot, §2.2) |
| Q11w | Opener (steps) | ≥2,000 verified steps | fixed | all (anchor in GPS-only world) |

Cut during design: any pace-based quest (pace is a plausibility check, not a
priced event — and pressuring speed serves nothing the log rewards); any
"deeper than X" depth quest (valid/invalid is the only depth line the product
speaks, C3/C14). Both recorded in §9 v2 notes.

### 2.2 Deterministic generation rule (pure function of event log + local date)

- **Board size: 3 quests/day** (within SPEC's 1–3), filled as three slots:
  - **Slot 1 — Anchor:** always Q11 (Q11w when no vision features exist).
    This satisfies the **always-completable rule**: ≤20 minutes, zero
    equipment, every day, so a streak never requires a monster board.
  - **Slot 2 — Goal slot:** next template in the user's goal seed list
    (D2 mapping), cycling in catalog order by `dayIndex mod listLength`,
    where `dayIndex` = days since account creation in local dates. A
    template may not repeat in slots 2/3 within 3 days; on collision, skip
    to the next template in the cycle.
  - **Slot 3 — Breadth slot:** same cycling rule over the templates of the
    *other* modality than slot 2 (rep quest ↔ distance quest), so both
    Strength and Endurance stats (SPEC §2.4) see work.
- **Difficulty tier:** the smallest tier ≥ 60% of the user's trailing-14-day
  median daily volume for that event type, computed as a pure fold of the
  event log (C5). No history or median 0 → lowest tier. This tunes *targets*,
  never verification thresholds — I2 untouched.
- **GPS-only world (J6):** eligible templates = Q4, Q5, Q8, Q11w. Slot 1 =
  Q11w; slots 2–3 cycle Q4/Q5/Q8. A full 3-quest board exists with zero
  vision features.

### 2.3 Completion, expiry, day boundary

- Quest day = **device-local calendar date**; the board regenerates at local
  midnight and unfinished quests expire silently (no failure copy, no guilt —
  PROD anti-reference).
- **Timezone rule (one sentence):** a local calendar date counts at most once
  — if travel makes the same local date occur twice, completions credit the
  first occurrence only; travel can shorten a day, never double it.
- Completion applies **exactly ×1.25** to XP earned toward the completed
  quest, per SPEC §3.1 — no other reward of any kind (I1).

---

## 3. D2 — Onboarding goal picker (content)

Exactly 4 goals + a default. Choice seeds slot 2's template list (§2.2) on
day 0; from day 14 the difficulty tiers self-adjust from the log. No goal is
a commitment — the picker can be revisited in Settings (F21). Trace: C20,
SPEC §4 scr.1.

| Goal | Display name | Arbiter-voice description | Day-0 slot-2 seed list |
|---|---|---|---|
| G1 | Build Strength | "Reps. The camera is the judge." | Q1(low), Q2(low), Q6, Q10 |
| G2 | Build Endurance | "Distance. GPS and steps are the proof." | Q4(low), Q5(low), Q8(low) |
| G3 | Show Up Daily | "Short verified work, every day." | Q11, Q5(low), Q6 |
| G4 | General Training | "Both paths. Reps and distance." | Q1(low), Q4(low), Q9(low) |
| — | *(none chosen)* | defaults to G4 General Training | as G4 |

Every goal seeds ≥2 catalog templates (D2 expected observation met). All
strings collected in §10 Copy Appendix.

---

## 4. D3 — Rank promotion ceremony + cosmetics catalog

### 4.1 Ceremony sequence

**Trigger rule:** the promotion folds from the ledger the moment the rank
floor (SPEC §3.3) is crossed, but the ceremony **never fires mid-set or
mid-run** (PROD: drama never leaks into the instrument). It queues and plays
on the next between-workout surface (set/run summary dismissal, home, or
profile). Total duration ≤8 s; any tap from S2 onward jumps to S5 (cosmetics
still granted). Trace: C19, PROD Design Principle 3, DSGN ceremony budget.

| State | Duration | What happens | Reduced-motion variant (PROD gate — never skipped) |
|---|---|---|---|
| S1 Dim | 0.5 s | Current surface dims to Forge Black (DSGN neutral) | Immediate cut, no dim animation |
| S2 Verdict line | 1.5 s | Mono face (DSGN "Arbiter Speaks Mono"): "RANK D — EARNED." over the old badge | Same text, static |
| S3 Badge forge | 3 s | New rank badge renders in the display face with a decaying ember-gold bloom (DSGN "Glow Is a Verb") | **Crossfade** old badge → new badge; static ember accent, no bloom |
| S4 Ledger line | 2 s | "Rank D. 10,000 XP. Verified." + list of cosmetics earned (§4.2) | Same, static |
| S5 Return | — | Profile, new badge persistent | Same |

Haptic/audio for the ceremony = the "rank promotion" row of D7's table (§8) —
one source of truth, referenced not restated.

### 4.2 Cosmetics catalog (every item visual-only: zero XP, zero gameplay — I1)

Free ranks E–C earn cosmetics too — the ceremony is core loop (I5); B→S items
are Pro (SUB F18). Earned items survive Pro lapse (SUB J5 — cited, not
redesigned). Every badge differs by **shape + engraving + letter**, never
color alone (PROD gate). Vocabulary is DSGN's forge register; zero banned
terms (I3).

| Rank | Tier | Badge | Additional cosmetics earned |
|---|---|---|---|
| E | Free | **Ash Badge** — matte iron ring, engraved E | default dark profile frame |
| D | Free | **Iron Badge** — iron ring, single hairline ember underline, engraved D | profile frame "Iron Border" (thin iron line) |
| C | Free | **Steel Badge** — polished steel ring, one ember notch, engraved C | profile frame "Steel Border"; home-panel divider style "Steel Divider" |
| B | Pro | **Forged Badge** — ember-inlaid ring, engraved B | app icon variant "Forge Mark"; profile frame "Forged Border" |
| A | Pro | **Tempered Badge** — double ring with ember inlay, engraved A | home accent "Tempered Edge" (static ember hairline on panel edges — no resting glow, DSGN rule); icon variant "Tempered Mark" |
| S | Pro | **Ascendant Badge** — full ember crest, engraved S | icon variant "Ascendant Mark"; profile frame "Ascendant Border"; display-face rank numeral styling on profile |

---

## 5. D4 — Advanced stats/history split

Both columns are **pure folds of the append-only event log** (C5). Fields
available per event: type, timestamp, and per-type payload (rep events:
exercise + per-rep min depth ratio; run events: km + duration; step events:
count), plus priced XP. Every view below names its fields. Trace: SUB F16,
C5/C17/C18.

| Free basic (always) | Folds from |
|---|---|
| Profile: current level, rank, Strength/Endurance values, current streak | all events → §SPEC 3 fold |
| Last-7-days XP total | event XP, timestamp |
| Set summary at set end: reps, XP, best depth | rep events of that set |
| Run summary at run end: distance, pace, XP | that run's event |

| Pro advanced (re-locks on lapse; log intact — SUB J5) | Folds from |
|---|---|
| Full XP timeline graph (all-time) | event XP, timestamp |
| Strength / Endurance history graphs | rep + distance events over time |
| Session archive: every past set/run, with per-rep depth detail | per-rep min-ratio, timestamps |
| Personal records: best depth, longest run, most reps in a set / in a day | folds of the above |
| Calendar heatmap of verified activity | event timestamps |

No view requires un-logged data → the counter-move (move view to v2 notes)
was not needed. **Rule restated:** on lapse the *views* re-lock; the log is
never mutated (C5); resubscribing restores the views with zero loss.

---

## 6. D5 — Camera-verified form scoring (F19): design (FT1 not fired)

**Inputs check (FT1):** every metric below uses only the per-rep tuple the
verifier already emits — `(timestamp, min_depth_ratio)` per valid rep (the
proven event shape of the squat/push-up pipelines). No new landmark data, no
per-frame computation, no verifier change. **FT1 condition not met → F19
ships as designed, Pro-only (SUB F19).**

**Score = pure function of one set's valid-rep tuples, 0–100:**

- **Depth margin (weight 50):** how far past the validity line B the set's
  reps traveled — `clamp01((mean(min_ratio) − B) / (R_ref − B)) × 100`,
  where B is the exercise's frozen validity threshold and R_ref is a frozen
  per-exercise reference depth set from the corpus at implementation.
  Frozen constants, identical for every user — **not** adaptive (I2).
- **Depth consistency (weight 25):** `100 × clamp01(1 − CV(min_ratio) / CV_ref)`
  — a set of even depths scores high, ragged depths score low.
- **Tempo regularity (weight 25):** same construction over inter-rep
  intervals from the timestamps.

Surfaces: set summary (Pro slot) and the Pro session archive (§5). Display
format (mono face, D7 silent — no verdict sound for a score): see Copy
Appendix.

**Boundary sentences (binding, verbatim from the plan):** "a form score never
changes rep validity or XP (I1, I2)" and "scores state measurements, not
coaching cues (C14)". The score has no advice attached — it is a measurement,
in the arbiter's voice.

Descoped to v2 notes (§9): any accuracy metric ("valid / attempted") —
rejected reps are not currently events in the log; requesting a
rejection-event field is a v2 schema note, not a change made here.

---

## 7. D6 — Notifications & re-engagement (a closed set)

The complete allowed set — **three types, nothing else exists**. All strings
in the Copy Appendix; all pass I3/I4. Trace: PROD anti-references, SUB §3.6,
B2.

| # | Type | Trigger | Copy | Frequency cap | Opt state |
|---|---|---|---|---|---|
| N1 | Quest board ready (push) | User-chosen time of day | "Today's quests are posted." | ≤1/day | Opt-in at onboarding, **default OFF**; toggle in Settings (F21) |
| N2 | Pro lapse notice (**in-app banner, not push** — conservative reading of SUB §3.6 "state notice") | First app open after lapse | "Your Pro exercises and ranks B–S are paused. Resume anytime." (SUB §3.6, verbatim) | **Once ever** | Not configurable; it is a state notice |
| N3 | Rank promotion earned (push) | User backgrounds the app while a promotion ceremony (§4.1) is queued unplayed | "Rank D earned. The ceremony is waiting." | ≤1 per promotion | Opt-in at onboarding, default ON (promotions are rare, earned facts); toggle in Settings |

**Negative list (verbatim, binding):** no streak-loss or streak-guilt
notifications; no countdowns; no re-engagement drip ("we miss you"); no
paywall notifications; no notification of any kind that is not N1–N3. The
burden of proof is on adding to this list, never on removing.

---

## 8. D7 — Haptic/audio verdict channel (one mapping table)

Mid-set events are differentiated by **repetition count and texture**, never
intensity (intensity is unreliable mid-exercise). Sounds are short neutral
tones, respect the silent switch (ambient audio session), and every event
remains fully legible on screen (haptic/audio is an additional channel, PROD
accessibility — nothing is color-alone or sound-alone). Haptics require the
open in-app session (C2) — background/locked operation is **not** promised.
Per-channel toggles (haptics / sounds, independently) live in Settings (F21).
Trace: PROD Accessibility, SUB F6(c), C2.

| Event | Haptic (iOS primitive) | Sound | Eyes-free distinguishability |
|---|---|---|---|
| Valid rep | `UIImpactFeedbackGenerator(.rigid)`, single | Single short mid "tick" | The only single rigid tap in a live set |
| Rejected rep (too shallow) | `.heavy`, double tap | Two-note descending buzz | Only double pattern; falling pitch = denied |
| Untrusted freeze enter | `UINotificationFeedbackGenerator(.warning)` | Brief low hum | Soft sustained texture ≠ any tap pattern |
| Freeze recover | `.light`, single | Short rising tone | Rising pitch = resumed; light ≠ rigid rep tap |
| Armed (set live) | `.medium`, single | Two-note ascending confirm | Pre-set context + two-note audio (rep tick is one note) |
| Set end | `UINotificationFeedbackGenerator(.success)` (triple) | Resolved two-note close | Only triple pattern in the session |
| Quest complete | `.success` | Single ember chime | Fires on between-workout surfaces only — never inside a set |
| Rank promotion | CoreHaptics custom: three rising transients | Short ceremony stinger ≤1.5 s | Unique; occurs only inside the §4.1 ceremony |

No two mid-set events share a pattern count and texture → the counter-move
(differentiate by repetition count) was applied at design time to
armed-vs-valid-rep (resolved by note count).

---

## 9. Net-new candidate scan (Step 3 — 5 cards, ≤120 words each)

Mined only from MKT §2's complaint column and PROD's design principles.

**W1 — Verified Set Share Card · BACKLOG · Free.** Export a set/run summary
as an image (rank badge, reps/distance, XP, "camera-verified" line) to the
share sheet. One-way, user-initiated, outside the app — no in-app surface
ever shows another user's XP/rank, so FT2's condition is not met. Feeds the
TikTok trend channel (MKT §3, §6 organic-only launch) with proof-shaped
content competitors can't make (honor-system XP has nothing to show).
Renders from existing summary data; visual-only (I1). Copy swept (I3/I4).

**W2 — Quest Board Widget · BACKLOG · Free.** Read-only home-screen widget:
today's three quests + completion state, mono face, Forge Black. A
between-workout dopamine surface (PROD two-postures) that pulls the user in
without a single notification. Pure fold of the log + today's board (C5);
no interaction, no XP display inflation.

**W3 — XP Receipt View · BACKLOG · Free.** Tap any XP total → the exact
verified events behind it (event, timestamp, base XP, multipliers applied).
Directly answers the Sweatcoin complaint class "step/coin discrepancies"
(MKT §2): the arbiter shows its arithmetic. Pure ledger fold (C5); makes
C18's promise ("XP you actually earned") inspectable. No new data, no new
numbers — a view of existing pricing only.

**W4 — Rest-Day Streak Shield · CUT (I1).** "One protected rest day per
week keeps the streak" changes streak semantics, which changes the streak
multiplier's effective value — an economy change. SPEC §3.1 is read-only
here; streak/band changes belong to `wargames/beta-measurement.md`. Cut,
routed there.

**W5 — Compare With Friends · CUT (C1, FT2 auto-cut).** Any surface where
one user sees another's XP/rank flips the threat model ("a leaderboard
flips the security budget" — SPEC C1). v2-fork territory, not backlog.

---

## 10. v2 notes (everything descoped or cut, with reasons)

| Item | Reason | Routed to |
|---|---|---|
| Pace-based quest templates | Pace is a plausibility check, not a priced event; speed pressure serves nothing the log rewards | dropped |
| Depth-quality quest templates ("N reps deeper than X") | The product speaks one depth line: valid/invalid (C3/C14) | dropped |
| Form-score accuracy metric (valid/attempted) | Rejected reps are not logged events; needs a rejection-event schema field | v2 event-schema request |
| Per-frame form metrics (e.g. hip-band steadiness over a rep) | Requires per-frame data the verifier does not emit per FT1 | v2, only if the verifier ever logs it |
| Weekly summary notification | Not on D6's closed list; adding it re-opens the drip door | v2 discussion, default no |
| Rest-day streak shield (W4) | Economy change (I1) | `wargames/beta-measurement.md` |
| Friends comparison (W5) | C1 threat-model flip | v2 fork per SPEC C1 |

---

## 11. Copy Appendix (every user-facing string introduced by this spec)

| String | Surface | Trace |
|---|---|---|
| "Build Strength" / "Reps. The camera is the judge." | Goal picker | D2, C20 |
| "Build Endurance" / "Distance. GPS and steps are the proof." | Goal picker | D2, C20 |
| "Show Up Daily" / "Short verified work, every day." | Goal picker | D2, C20 |
| "General Training" / "Both paths. Reps and distance." | Goal picker | D2, C20 |
| Quest names: "Squat Quota", "Push-Up Quota", "Hundred Grind", "Distance Gate", "Step Quota", "Double Set", "Run and Reps", "Long Walk", "Split Discipline", "Long Set", "Opener" | Quest board | D1, C20/I3 |
| Quest requirement format: "N valid reps", "K km verified", "S verified steps" | Quest board | D1, C18 |
| "RANK {X} — EARNED." | Ceremony S2 | D3, C19 |
| "Rank {X}. {N} XP. Verified." | Ceremony S4 | D3, C19/C5 |
| Cosmetic names: Ash/Iron/Steel/Forged/Tempered/Ascendant Badge; Iron/Steel/Forged/Ascendant Border; Forge/Tempered/Ascendant Mark; Steel Divider; Tempered Edge | Profile, home, icon picker | D3, DSGN/I3 |
| "Today's quests are posted." | Notification N1 | D6 |
| "Your Pro exercises and ranks B–S are paused. Resume anytime." | Banner N2 | SUB §3.6 verbatim |
| "Rank {X} earned. The ceremony is waiting." | Notification N3 | D6, C19 |
| "Form {score} — depth {d}, consistency {c}, tempo {t}" | Pro set summary | D5, C14 |

---

## 12. Trace index

| Element | Trace |
|---|---|
| D1 quest catalog + generation + day boundary | C20, C18, C5; SPEC §2.3/§3.1; I1/I2 |
| D1 always-completable anchor slot | PROD anti-reference (no streak-guilt); SPEC §2.3 streak rule |
| D2 goals G1–G4 + default | C20; SPEC §4 scr.1; SUB F20 |
| D3 ceremony sequence + queue-never-interrupt rule | PROD Principles 2–3; DSGN ceremony budget; C19 |
| D3 cosmetics catalog, free E–C / Pro B–S | SUB F18; I1/I5; DSGN vocabulary; PROD non-color-alone |
| D3 lapse survival | SUB J5 / §3.6 (cited) |
| D4 free/Pro view lists | SUB F16; C5/C17/C18 |
| D5 form score (3 metrics, frozen constants) | SUB F19; C14; I1/I2; FT1 check |
| D6 notification set N1–N3 + negative list | PROD anti-references; SUB §3.6; B2 |
| D7 haptic/audio mapping | PROD Accessibility; SUB F6(c); C2 |
| W1–W3 backlog cards | MKT §2/§3/§6; C5/C18; PROD postures |
| W4–W5 cuts | I1; C1 (FT2) |

Every row above carries a trace; the trace column has no empty cells.

---

## 13. Verification runs (results)

**V1 — Trace sweep: PASS.** Grep for the untraced marker → 0 hits. Every
D-section (D1–D7) and every W-card appears in the §12 trace index; no design
element exists outside it; no empty trace cells.

**V2 — Banned-terms sweep: PASS.** Case-insensitive grep for every MKT §1
banned term group (solo leveling / jinwoo / cha hae / arise / karma / shadow
monarch / ashborn / monarch) → 0 hits each. Pleading verbs (unlock, unleash,
supercharge) → 0 hits. "miss" → 2 hits, both benign ("dismissal"; the
negative list *quoting* the forbidden "we miss you" pattern). Exclamation
marks in copy strings → 0.

**V3 — Economy invariant check: PASS.** Every XP number in this document is a
citation of an existing SPEC value: ×1.25 quest bonus (SPEC §3.1, stated as
the only quest reward), "10,000 XP" (SPEC §3.3 rank-D floor, used as the
ceremony example). Quest tiers (rep counts, km, steps) are targets, not XP
prices. Form-score numbers are measurements, not XP. No new source, no new
multiplier, compound cap untouched.

**V4 — Wall-test replay: PASS (8/8).**
- **J1** (day-1 first set): unchanged — D1's board adds an always-completable
  anchor; nothing new interposes before the first `+10 XP`. PASS.
- **J2** (week-2 quests + runs): D1 keeps quest bonus at exactly ×1.25;
  board is 3 quests within SPEC's 1–3. PASS.
- **J3** (rank-C ceiling): unchanged — D3's ceremony fires for free E→C
  promotions; the rank-B paywall moment stays exactly SUB §3.4(b). PASS.
- **J4** (30-day streak): D1's anchor quest makes every day's streak
  achievable in ≤20 min; no streak-guilt copy anywhere (D6 negative list).
  PASS.
- **J5** (Pro lapse): D3 cosmetics and D4 views follow SUB J5 verbatim —
  earned items survive, views re-lock, log intact; N2 lapse notice shown
  once, in-app. PASS.
- **J6** (GPS-only world): D1 generates a full 3-quest board from Q4/Q5/Q8/
  Q11w with zero vision features; D2 goals still seed it. PASS.
- **J7 (new)** — user declines all notifications at onboarding: N1/N3 stay
  off; quests still generate daily, streaks still count, XP unaffected —
  notifications are informational only, never load-bearing. PASS.
- **J8 (new)** — free user promotes E→D: full §4.1 ceremony plays, Iron
  Badge + Iron Border granted, **no paywall shown** (E→D is not on SUB
  §3.4's allowed-moment list; only the rank-B moment is). PASS.

**Forks/aborts:** FT1 not fired (all form-score inputs already logged). FT2
fired once as designed (W5 auto-CUT, C1). FT3 not fired (12 templates ≥ 12).
A1 fired once as designed (W4 routed to beta-measurement). A2/A3 not
tripped.
