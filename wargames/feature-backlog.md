# Wargame: Feature Design Backlog — flesh out the under-specified features

**Mission:** Every feature the specs *name* but do not *design* gets designed to
a buildable standard, plus one bounded scan for net-new v1.x candidates. This is
a paper mission (read + write docs); it touches no code, no thresholds, no
economy numbers.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheaper model, blind.

**Deliverable:** `wargames/output/feature-backlog-spec.md` (one file) + a
LEDGER.md row.

---

## Inputs (exact paths — read all five before Step 1; A3 if any is missing)

| Handle | Path | What you take from it |
|---|---|---|
| SPEC | `wargames/output/product-spec.md` | Constraint ledger C1–C20 (§1), XP economy (§3), screen map (§4), MoSCoW (§5.1) |
| SUB | `wargames/output/features-subscription-spec.md` | Feature cards F1–F22 (§1), wall test J1–J6 (§2), paywall negative list (§3.4), copy rules + pleading-verb ban (§3.5) |
| PROD | `PRODUCT.md` | Brand voice ("arbiter"), anti-references (no streak-guilt, no cheerleader tone), accessibility gates (reduced-motion, non-color-alone, haptic/audio verdicts) |
| MKT | `wargames/output/market-analysis-report.md` | §1 banned-terms list and allowed vocabulary; §2 competitor complaints |
| DSGN | `DESIGN.md` | Design-system vocabulary (colors, type, elevation) — cite it in ceremony/cosmetic descriptions, do not restyle it |

**Also read (exclusion boundaries, do not duplicate their content):**
`wargames/exercise-roster-scope.md` (exercise roster is DECIDED — out of scope
here), `wargames/beta-measurement.md` (economy/band changes live there),
`LEDGER.md` (row #8 push-up status; pipelines are out of scope here).

## Binding invariants (copy these into the deliverable header; every design
must obey all five — they are the abort tripwires of §Aborts)

- **I1 (C18/C5):** No new XP source, no new multiplier, no change to any number
  in SPEC §3.1–§3.3. The pricing table is **read-only**. Cosmetics, quests,
  ceremonies, notifications, and form scores confer **zero** XP beyond what
  SPEC §3.1 already prices.
- **I2 (C8):** Nothing designed here may change rep validity, raise honest
  false rejections, or add adaptive per-user thresholds.
- **I3 (C15/B4):** No MKT §1 banned term in any name or copy string. All new
  vocabulary comes from MKT §1's allowed list (hunter, rank, quest, gate, XP,
  ascend) or is neutral English.
- **I4 (B2/PROD):** All copy in arbiter voice — terse, exact, never pleading.
  No exclamation marks, no emoji, no streak-guilt, no countdowns, none of SUB
  §3.5's pleading verbs (unlock/unleash/supercharge/don't-miss).
- **I5 (C16/C17):** Nothing designed here may add a wall on the free loop.
  Free/Pro assignment of every new element follows C17: core loop → Free,
  breadth → Pro.

## "Buildable standard" (the definition of done for every D-item)

A design is buildable when a Swift engineer could implement it without asking a
single product question: (a) all content **enumerated** (no "e.g." lists — the
actual quest names, the actual cosmetic items, the actual notification
strings); (b) all states and transitions named; (c) all edge cases in the
item's checklist below resolved in writing; (d) every element trace-tagged to a
C# constraint or an input-file section; (e) all user-facing strings collected
in one Copy Appendix at the end of the deliverable.

---

## Recon flags (check in order, before Step 1)

- **R1:** All five input files exist and are readable at the paths above.
  Missing/moved → **A3, halt**.
- **R2:** SPEC §1 contains a 20-row constraint table (C1–C20) and SUB §1
  contains feature cards F1–F22. Absent → **A3, halt** (the trace system this
  plan depends on is gone).
- **R3:** MKT §1 contains an explicit banned-terms list (≥4 terms) and an
  allowed-terms list. Absent → **A3, halt** (V2 sweep would be unrunnable).
- **R4:** Search `wargames/` (filenames + content, e.g.
  `grep -ril "cosmetic\|quest catalog\|notification" wargames/`) for an
  existing document that already designs any D-item below to the buildable
  standard. Found → drop that D-item from Step 2, log which file covers it in
  the deliverable's header. (Genius pre-check 2026-07-09: none exists; the
  only hits are one-line mentions.)

## Battle plan

### Step 1 — Gap table (prove each item is actually thin)
For each D-item in Step 2, quote (verbatim, with file + section) the one-line
mention that is its entire current spec. Put this table at the top of the
deliverable.
- **Expected observation:** 7 rows (D1–D7), each with a verbatim quote + cite;
  any R4-dropped item listed as DROPPED with the covering file.
- **Counter-move:** can't find a quote for an item → the feature isn't in the
  specs at all; move it to Step 3 (net-new candidates) instead of Step 2, and
  note the move.

### Step 2 — Design each D-item to the buildable standard

Work the items in this order (independent; if one aborts per I1–I5, continue
with the rest and report the abort in the deliverable).

**D1 — Daily quest system** (thin line: SPEC §2.3 "1–3 daily quests … seeded
from the user's onboarding goal"; SUB F10). Required outputs:
1. A **quest template catalog**: ≥12 templates spanning squat, push-up,
   run, walk/steps, and mixed; each template = name, requirement expressed in
   verified events only (e.g. "N valid squat reps", "K km verified run"),
   difficulty parameter, and which onboarding goals seed it.
2. A **deterministic generation rule**: how many quests appear per day (within
   SPEC's 1–3), how difficulty scales from the user's own event-log history
   (a pure function of the log per C5 — e.g. percentile of last-14-days
   volume; **never** an adaptive verification threshold, I2), and the day-0
   rule when no history exists (seeded from the F20 goal).
3. **Completion/expiry semantics:** quest day boundary = local midnight;
   define the timezone-change rule (a day counts once; travel can shorten,
   never double, a day) and state it in one sentence.
4. **Always-completable rule:** every day's board must contain ≥1 quest
   completable in ≤20 minutes with zero equipment (streaks depend on quest
   completion per SPEC §2.3 — a board of monsters is streak-guilt by another
   name, PROD anti-reference).
5. **GPS-only world variant (J6):** the generation rule must produce a full
   board when vision features are absent. State which templates survive.
- **Expected observation:** all 5 outputs present; every template's
  requirement is measurable from event types listed in SPEC §3.1; no new XP
  anywhere (quest bonus stays exactly ×1.25 per SPEC §3.1).
- **Counter-move:** a wanted template can't be expressed in verified events →
  cut the template (I1 is absolute), list it under "cut, needs new verified
  event type" in the deliverable's v2 notes. Fewer than 12 valid templates →
  **fork FT3**.

**D2 — Onboarding goal picker content** (thin line: SPEC §4 scr.1 "Goal picker
(seeds quests)"; SUB F20). Required outputs: enumerate exactly 4 goals (e.g.
strength-leaning, endurance-leaning, habit/consistency, general — executor
picks final naming within I3/I4), each with: display name, one-line arbiter-
voice description, and the D1 template-seed mapping for day 0. Include the
"no goal chosen" default (= general).
- **Expected observation:** 4 goals + default, each mapped to ≥2 D1 templates;
  strings in the Copy Appendix.
- **Counter-move:** a goal can't seed 2 templates → extend the D1 catalog,
  don't drop the goal.

**D3 — Rank promotion ceremony + cosmetics catalog** (thin lines: PROD "the
biggest visual ceremony in the app is a rank promotion"; SUB F18 "cosmetics
each rank earns"). Required outputs:
1. **Ceremony sequence:** numbered screen-state list (trigger → full-screen
   takeover allowed here, it is between-workout posture → badge reveal →
   persistent change), with duration bounds per state (total ≤8 s), what is
   tappable-to-skip, and the **reduced-motion variant** (crossfade, never
   skipped entirely — PROD accessibility, verbatim requirement).
2. **Cosmetics catalog:** for each rank E→S, enumerate the cosmetic set it
   earns (badge + at least one of: profile frame, home-screen accent, app
   icon variant — executor enumerates concrete items using DSGN vocabulary).
   Free ranks E–C earn cosmetics too (ceremony is core loop, I5); B→S
   cosmetics are Pro (SUB F18). Every item is visual-only: **zero gameplay or
   XP effect (I1), never signaled by color alone (PROD)**.
3. **Lapse rule restated:** earned cosmetics survive Pro lapse (SUB J5 —
   earned is never clawed back); cite it, don't redesign it.
- **Expected observation:** ceremony has ≥4 named states with durations +
  reduced-motion variant; catalog has a concrete itemized row for all 6 ranks.
- **Counter-move:** ceremony wants sound/haptics → allowed, but the mapping
  must land in D7's table (one source of truth), referenced from here.

**D4 — Advanced stats/history split** (thin line: SUB F16 "full stat timeline
+ per-session breakdowns"). Required outputs: two enumerated view lists —
**Free basic** (current level, rank, current Strength/Endurance values,
current streak, last-7-days XP total, per-set summary at set end) and **Pro
advanced** (full XP timeline, stat history graphs, per-session breakdown
archive, personal records list, calendar heatmap) — plus the lapse behavior
(views re-lock, log intact, SUB J5) and the rule that both views are pure
folds of the event log (C5; no view may require data the log doesn't hold —
if one does, name the missing event *field* in v2 notes rather than adding it).
- **Expected observation:** both lists enumerated; every view annotated with
  the event-log fields it folds from.
- **Counter-move:** a view needs un-logged data → move that view to the v2
  notes list; do not extend the event schema in this mission.

**D5 — Camera-verified form scoring (F19) design-or-descope** (thin line: SUB
F19; SPEC §5.1 "Could"). Required outputs: define the Pro form score as a
**pure function of per-rep data the verifier already logs** (per-rep min
ratio/depth, rep duration, per-set depth consistency). Design: per-exercise
score formula sketch (squat, push-up), 0–100 scale, where it surfaces (set
summary + Pro history), and the hard boundary sentences: "a form score never
changes rep validity or XP (I1, I2)" and "scores state measurements, not
coaching cues (C14)".
- **Expected observation:** score defined using only fields visible in the
  existing event flow (rep timestamp + min-ratio are proven logged — see
  `count_reps.py` output shape, reps as `(min_ratio, timestamp)`); boundary
  sentences present verbatim.
- **Counter-move / fork FT1:** if a proposed metric needs landmark data or new
  per-frame computation the verifier does not already emit → **descope that
  metric** to the v2 notes; if *no* metric survives, mark F19 "DESCOPED to
  v2 — needs verifier event-schema extension" in the deliverable and move on.
  Do not extend the verifier from a paper mission.

**D6 — Notifications & re-engagement** (thin line: SPEC §6.4 mentions
"quest/notification copy" only). Required outputs: enumerate the **complete**
allowed notification set — at most 3 types: (1) daily quest-board-ready, at a
user-chosen time, opt-in at onboarding, default **off**; (2) Pro lapse state
notice, the exact SUB §3.6 string, shown once ever; (3) rank-promotion earned
(fires only on a verified promotion event). For each: exact copy string
(Copy Appendix), trigger, frequency cap, and opt-out path. Then the **negative
list** (verbatim in deliverable): no streak-loss/streak-guilt notifications,
no countdowns, no re-engagement drip ("we miss you"), no paywall
notifications, no notification not on the enumerated list.
- **Expected observation:** exactly ≤3 types, each with all 4 fields; negative
  list present; all strings pass I3/I4.
- **Counter-move:** a wanted type violates the negative list → it does not
  ship; log it in v2 notes with the violated rule. (The arbiter never begs.)

**D7 — Haptic/audio verdict channel** (thin line: PROD accessibility "verdict
feedback also delivered via haptic/audio"; SUB F6c). Required outputs: one
mapping table — events {valid rep, rejected rep (too shallow), untrusted
freeze enter, freeze recover, armed, set end, quest complete, rank promotion}
→ {haptic pattern (name iOS UIKit/CoreHaptics primitive), sound (short
neutral tone, described in words), and the rule each pattern must be
distinguishable eyes-free}. Plus: all sounds respect the silent switch;
haptics work with screen locked is **not** promised (session requires open
app per C2) — say so; per-channel toggles in Settings (F21).
- **Expected observation:** 8-row table, every row has haptic + audio + a
  one-line eyes-free distinguishability rationale; no verdict is signaled by
  color alone anywhere in D3–D7 (PROD gate).
- **Counter-move:** two events end up with indistinguishable patterns →
  differentiate by repetition count (single/double/triple), not intensity —
  intensity is not reliably perceivable mid-exercise.

### Step 3 — Net-new candidate scan (bounded ideation)
Mine exactly two sources — MKT §2's competitor-complaint column and PROD's
design principles — for **at most 5** net-new feature candidates not present
in SUB F1–F22 and not on SPEC §5.1's Won't list. Each candidate gets one card,
≤120 words: name (I3-clean), what it does, tier per I5, trace (the MKT
complaint or PROD principle it answers), and a verdict line: **BACKLOG**
(obeys I1–I5, buildable on the existing event log) or **CUT** (name the
violated invariant / Won't row). Anything social/leaderboard/comparison-shaped
is auto-CUT with a C1 cite (**fork FT2**) — the threat model fork belongs to
v2, not to this document.
- **Expected observation:** 1–5 cards, every card verdicted, zero cards
  touching C8/C1/Won't items without a CUT verdict.
- **Counter-move:** fewer than 1 credible candidate → write "no net-new
  candidates survived the invariants" and move on; padding is worse than an
  empty section.

### Step 4 — Assemble deliverable + invariant sweep
Assemble `wargames/output/feature-backlog-spec.md` in this order: header
(invariants I1–I5 restated + R4 drops) → Step 1 gap table → D1–D7 sections →
Step 3 cards → v2 notes (everything descoped/cut, each with its reason) →
Copy Appendix (every user-facing string from D1–D7 in one table: string,
surface, trace) → trace index (element → C#/source, zero untraced rows).
Then run V1–V4 below and paste their results at the bottom of the deliverable.
- **Expected observation:** file exists; contains all sections; V1–V4 outputs
  pasted.
- **Counter-move:** any V-run fails → fix the deliverable and re-run that V;
  only then write the LEDGER row.

### Step 5 — LEDGER row
Append one row to `LEDGER.md` (next number after the last numbered row):
mission `wargames/feature-backlog.md`, genius fable-5, executor = your model
name, score 8/8, outcome WIN/PARTIAL (PARTIAL if any D-item aborted per
I1–I5 or FT1 descoped F19 entirely), notes = one line per fork/abort hit.
- **Expected observation:** `git diff LEDGER.md` shows exactly one added row.
- **Counter-move:** none needed; this step cannot meaningfully fail.

## Fork triggers
- **FT1** (in D5): form-score metric needs data the verifier doesn't emit →
  descope the metric; no surviving metric → mark F19 descoped-to-v2. Condition
  is mechanical: the metric's inputs are not in the per-rep event tuple.
- **FT2** (in Step 3): candidate implies XP comparison between users → CUT
  with C1 cite. Condition: any surface where one user sees another's XP/rank.
- **FT3** (in D1): fewer than 12 templates expressible in verified events →
  ship the catalog with however many are valid (≥6) and log the shortfall;
  <6 → the quest system is thinner than SPEC assumes; flag as a finding, do
  not invent unverifiable quests.

## Abort conditions
- **A1:** A design cannot work without a new XP source/multiplier or an
  economy-number change (I1). Halt **that item**, record it in v2 notes with
  "blocked on economy decision → `wargames/beta-measurement.md` owns bands";
  continue the mission.
- **A2:** Any required name/string cannot be written without a banned term or
  pleading voice (I3/I4). Rename first; truly impossible → halt the item and
  flag for the human legal/copy pass (SPEC §6.4).
- **A3:** R1/R2/R3 recon failure — the source-of-truth files moved or lost
  their structure. Halt the whole mission and report; do not reconstruct
  constraints from memory.

## Verification runs
- **V1 — Trace sweep:** every design element row in the deliverable's trace
  index has a non-empty trace; grep the deliverable for `(untraced)` → zero
  hits. Zero elements exist that are absent from the trace index (spot-check:
  every D-section heading appears in the index).
- **V2 — Banned-terms sweep:** for each term on MKT §1's banned list, grep the
  deliverable (case-insensitive) → zero hits. Also grep the pleading-verb list
  from SUB §3.5 (unlock, unleash, supercharge, don't miss) and `!` in the Copy
  Appendix strings → zero hits.
- **V3 — Economy invariant check:** the deliverable contains no XP number that
  is not already in SPEC §3.1–§3.3 (mechanical check: list every "XP" mention
  in the deliverable; each must be a citation of an existing SPEC value, not a
  new one). Confirm quest bonus is stated as ×1.25 and only ×1.25; confirm the
  ×2.0 compound cap is untouched.
- **V4 — Wall-test replay:** re-walk SUB §2's J1–J6 with the new designs
  layered on (do they still pass verbatim?), plus two new journeys written in
  the same format: **J7** — user declines all notifications at onboarding:
  loses zero XP, zero quests, zero streak capability (notifications are
  informational only). **J8** — free user promotes E→D: gets the full ceremony
  and the D-rank cosmetic with no paywall shown (promotion is not on SUB
  §3.4's allowed-paywall list; only the *rank-B* moment is). All 8 pass →
  mission objective met.
- **Proven** when V1–V4 pass and the deliverable + LEDGER row exist.

## Red-team pass
1. **Weakest point: "fully fleshed out" is a judgment call.** *Fix:* the
   buildable standard (a)–(e) + per-item required-output checklists make done
   mechanical; every Expected observation counts artifacts, not vibes.
2. **Most likely executor screw-up: making quests/cosmetics "exciting" by
   inventing XP rewards.** This is the single most probable failure — every
   gamification instinct pushes toward it and it silently breaks C18/C5 and
   the S-rank guard. *Fix:* I1 is stated three times (invariants, D1, D3), and
   V3 mechanically greps for new XP numbers.
3. **Scope bleed into decided territory** (exercise roster, economy bands,
   pipelines, leaderboards). *Fix:* explicit exclusion reads up front; FT2
   auto-cuts social; A1 routes economy wishes to beta-measurement.
4. **Copy drift into cheerleader tone across 30+ new strings.** *Fix:* single
   Copy Appendix so V2 sweeps one table, not strings scattered through prose.
5. **D5 could quietly grow the verifier** ("just log one more field"). A paper
   mission must not create engineering work as a side effect. *Fix:* FT1
   descopes instead; the deliverable may only *request* schema fields in v2
   notes.
6. **Notification design is where dark patterns re-enter dressed as
   retention.** *Fix:* D6 is designed as a closed enumerated set with a
   verbatim negative list; anything not on the list does not ship — the
   burden is on adding, not removing.
7. **J8 gap found by this red-team:** the specs never said whether free-rank
   promotions (E→D→C) get the ceremony/cosmetics or whether those are Pro —
   an executor could plausibly gate them and wall the loop's best moment.
   *Fix:* folded into D3 ("Free ranks E–C earn cosmetics too") and V4's J8.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
