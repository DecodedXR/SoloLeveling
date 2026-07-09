# Wargame: Feature Set & Subscription Design

**Mission:** Expand the product spec's MoSCoW into a full feature specification
(per-feature: what it is, acceptance criteria, free/Pro assignment, dependency)
and design the subscription end-to-end: tier contents, pricing, trial policy,
paywall placement and copy rules, upgrade moments, lapse behavior, and a
unit-economics sanity table. Offline mission — no web access needed.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** any cheap model.

**Deliverable:** `wargames/output/features-subscription-spec.md` with exactly
the section structure in Step 6.

---

## Input files (the executor's ONLY sources — read all four first)

- **SPEC** = `wargames/output/product-spec.md` — constraint ledger C1–C20,
  MoSCoW (§5.1), free/Pro split rule (§5.2), XP economy (§3), screens (§4).
- **MKT** = `wargames/output/market-analysis-report.md` — §2 competitor price
  models & complaint themes, §5.5 monetization rule, §1 banned terms.
- **PROD** = `PRODUCT.md` (project root) — voice ("the arbiter never begs"),
  design principles, anti-references. Governs all paywall/upsell copy rules.
- **ENG** = `wargames/workout-tracker-verification.md` — only for dependency
  flags (`GATED ON KILL TEST`) and the leaderboard threat-model fork.

## Recon flags (check before Step 1)

- **R1:** All four files readable at those paths. Missing → halt, report which.
- **R2:** SPEC §5.1 MoSCoW table and §5.2 free/Pro rule present; SPEC §1 has
  constraints C16 ("free tier must contain a complete loop"), C17 ("Pro gates
  breadth, never the core loop"), C18 (no honor-system XP). Absent → halt.

## Binding rules (carry into every step)

- **B1:** Free tier is forever-playable to rank C with daily quests — C16/C17
  are inviolable. Any design needing a core-loop gate to make Pro viable = abort A2.
- **B2:** Paywall copy obeys PROD voice: terse, exact, never pleading. No
  streak-guilt, no countdown-pressure dark patterns, no fake discounts. The
  arbiter never begs — it states what Pro contains.
- **B3:** Pricing anchors to MKT §5.5: ~$5–8/mo, ~$40–60/yr. Pick exact points
  by rule in Step 3, don't re-survey.
- **B4:** No banned term (MKT §1) in any feature name or copy example.
- **B5:** Vision-dependent features carry `GATED ON KILL TEST` flags (SPEC C13).

---

## Battle plan

### Step 1 — Feature inventory with acceptance criteria
Expand every SPEC §5.1 Must/Should/Could row into a feature card:
`ID | name | one-paragraph description | 2–4 acceptance criteria (checkable,
user-visible) | tier (Free/Pro) | dependencies (other features, kill test) |
SPEC/ENG trace`. Also add the supporting features implied by SPEC §4 screens
but not named in the MoSCoW (onboarding goal picker, settings/privacy screen,
streak display) — each still needs a trace to a screen or constraint.
- **Expected observation:** ≥18 feature cards; every card has a trace; every
  vision card carries the gate flag; tier column exactly matches SPEC §5.2
  (free: squat+push-up flows, runs/walks, quests, streaks, levels, ranks→C,
  2 stats; Pro: extra exercises, advanced stats/history, ranks B→S +
  cosmetics, form scoring).
- **Counter-move:** a card's tier is ambiguous in SPEC → assign by C17's rule
  (breadth→Pro, loop→Free) and mark `RULE-ASSIGNED` so a human can review the
  judgment calls in one pass.

### Step 2 — The wall test (free-tier integrity)
Walk six scripted journeys against the Step 1 inventory, writing 3–6 lines
each: (J1) day-1 new user completes first verified set and levels up without
seeing a paywall; (J2) week-2 free user plays daily quests + runs; (J3) free
user reaches the rank-C ceiling — what do they see at the B-promotion moment
(must be a state, not a wall: rank C persists, XP keeps accruing, promotion
shown as Pro content, loop untouched); (J4) free user on a 30-day streak gets
full streak bonus (multipliers are loop, not breadth); (J5) Pro subscriber
lapses — keeps rank/level/history already earned, loses breadth access going
forward, XP history never deleted (event log is append-only, SPEC C5);
(J6) free user who never does vision (kill-test failure world) still has a
complete GPS/steps loop.
- **Expected observation:** all six journeys pass with no hard wall and no
  dark-pattern moment; J3 and J5 name the exact screen/state shown.
- **Counter-move:** a journey hits a wall → fix the Step 1 tier assignment
  (move the blocking feature to Free), never weaken B1; re-run the journey.

### Step 3 — Subscription design
Produce, by rule:
1. **Tier sheet:** Free vs Pro contents (from Step 1), one line each.
2. **Price points:** monthly = the midpoint of MKT's $5–8 band rounded to
   x.99 ($6.99); annual = the yearly price whose monthly-equivalent is a
   40–50% discount vs monthly AND sits inside MKT's $40–60 band (compute and
   show: $6.99×12 = $83.88 → annual $44.99–$49.99 qualifies; pick $44.99).
   No lifetime tier in v1 (MKT shows it only on the weakest competitor;
   one-line justification required).
3. **Trial policy by rule:** the free tier IS the trial of the core loop
   (C16). Offer a 7-day Pro trial only at moments of demonstrated intent
   (rule below), never as a launch interstitial.
4. **Paywall placement rules:** paywall may appear only at breadth boundaries —
   (a) tapping a locked Pro exercise, (b) the rank-B promotion moment,
   (c) tapping locked advanced history. It may never appear at app open,
   set end, quest completion, or streak events. List these as testable rules.
5. **Copy rules + 3 example paywall strings** in the arbiter voice (B2), e.g.
   pattern: state what Pro contains, one line, no exclamation marks, no
   pleading verbs (unlock-your-potential language is banned); each example
   swept against MKT §1 banned terms.
6. **Lapse policy:** from J5 — earned progression is never clawed back;
   breadth re-locks; one-line win-back rule (a single state notice, no
   nag cadence).
- **Expected observation:** all six artifacts present; arithmetic for the
  annual price shown; every rule testable (a reviewer could pass/fail a
  build against it).
- **Counter-move:** the two price rules conflict (no annual point satisfies
  both) → widen to the nearest x.99 inside the MKT band and show the delta.
- **Fork F1 — thin-Pro launch:** count launch-day Pro items that are NOT
  gated on the kill test. If < 2 (i.e., if vision fails, Pro is nearly
  empty), add a section "Contingency: free-only launch" specifying that Pro
  ships only when ≥4 Pro items are live, with the feature list re-cut
  accordingly. Condition is the count, not judgment.

### Step 4 — Upgrade-moment map
For each paywall placement in Step 3.4, write: the user state at that moment,
what they just did (demonstrated intent), what the paywall shows, and the
decline path (must return to exactly where they were, zero loss). Add the
7-day Pro trial trigger rule: offered at most once, only after the user has
(a) completed ≥5 sessions AND (b) hit a breadth boundary organically.
- **Expected observation:** every paywall moment has a decline path; trial
  trigger is a testable conjunction; no moment violates Step 3.4's negative
  list.
- **Counter-move:** any moment lacks a clean decline path → redesign that
  moment, not the rule.

### Step 5 — Unit-economics sanity table
Compute a table from stated inputs (all inputs written down, all genius-set
and marked revisable): free→Pro conversion 2% / 4% / 6% scenarios; monthly
price $6.99 with 70/30 then 85/15 App Store cut (year-2 subscriber rate);
annual mix assumption 40% of subscribers. Output: revenue per 10,000 free
users per month under each scenario. No growth projections, no CAC — organic-
only launch per MKT §6. This is a sanity table, not a forecast; it must say so.
- **Expected observation:** a 3-scenario table with the arithmetic visible
  and the inputs labeled as assumptions.
- **Counter-move:** none needed beyond arithmetic care — if any cell can't be
  computed from the stated inputs, an input is missing; add it explicitly
  rather than implying it.

### Step 6 — Assemble the spec
Write `wargames/output/features-subscription-spec.md` with exactly:
`## 1. Feature inventory` (cards table) · `## 2. Wall test` (six journeys +
verdicts) · `## 3. Subscription design` (tier sheet, prices w/ arithmetic,
trial, paywall rules, copy rules + examples, lapse policy) · `## 4. Upgrade-
moment map` · `## 5. Unit-economics sanity table` · `## 6. Open questions`
(≥3, incl. "conversion assumptions are genius-set" and the F1 status) ·
`## 7. Trace index` (feature/rule → source).
- **Expected observation:** file exists, all 7 sections non-empty, no
  `(untraced)` rows.
- **Counter-move:** a section can't fill → the owning step's counter-move was
  skipped; go back.

---

## Abort conditions

- **A1:** R1/R2 fail — inputs missing or SPEC's constraint anchors absent.
- **A2:** Any point where Pro viability requires gating the core loop
  (violating C16/C17/B1). That's a business-model contradiction above the
  executor's pay grade. Halt, name the conflict.
- **A3:** Fewer than 4 total Pro items exist even in the kill-test-passes
  world. Then there is no subscription to design and the mission premise
  fails; halt and report (distinct from F1, which handles the kill-test-fails
  world as a contingency section).

## Verification runs (distinct from the work)

Scope note (learned from run #3): V-sweeps apply to *deliverable* content —
feature names, tier sheet, copy examples, paywall rules — not to citations of
constraints or competitor names inside trace/rationale text.

- **V1 — wall re-test from the artifact:** re-walk J1, J3, and J5 using ONLY
  the finished spec's sections 1+3+4 (not Step 2's notes). Same verdicts must
  fall out. If the spec alone can't reproduce a journey, the spec is missing
  a rule it relied on.
- **V2 — tier-consistency sweep:** every feature appears in exactly one tier;
  nothing in the Free list appears as Pro-gated in any paywall rule or copy
  example; every Pro item traces to C17's breadth categories.
- **V3 — copy sweep:** the 3 paywall strings + all UI-facing copy examples
  contain zero MKT §1 banned terms, zero exclamation marks, and no pleading
  verbs (unlock/unleash/supercharge/don't-miss); arbiter voice per B2.
- **Mission proven** when the spec exists with all 7 sections and V1–V3 pass.

---

## Red-team pass (attacking this plan)

1. **Weakest assumption:** conversion inputs (2/4/6%) and the 40% annual mix
   are invented. *Fix folded in:* Step 5 must label every input as a
   genius-set assumption and §6 must carry it as an open question; the table
   is named a sanity check, not a forecast, in the deliverable itself.
2. **Most likely executor screw-up:** writing generic growth-hacker paywall
   advice (countdown timers, discount pops) from training data — it directly
   violates B2 and the brand. *Fix folded in:* Step 3.4's *negative* list
   (where paywalls may never appear) and V3's banned-verb sweep make the
   violation mechanically detectable.
3. **Second: tier drift.** Features quietly appearing in both tiers or Pro
   creep into the loop (e.g. "streak insurance" as Pro — a dark pattern AND a
   loop gate). *Fix folded in:* V2's exactly-one-tier sweep + the wall test's
   J4 explicitly checks multipliers stay free.
4. **The rank-B moment is the danger spot:** it's simultaneously a designed
   paywall placement and the highest-emotion progression moment — one bad
   design turns it into "the app stole my promotion." *Fix folded in:* J3
   requires rank C to persist, XP to keep accruing, and the moment to read as
   a state, not a wall; V1 re-tests J3 from the artifact alone.
5. **Thin-Pro blindness:** if the kill test fails, Pro is ~empty and the
   whole subscription design is theater. *Fix folded in:* F1's countable
   condition forces a free-only-launch contingency section; A3 catches the
   even-worse world where Pro is thin regardless.
6. **Arithmetic theater in Step 5:** *Fix folded in:* inputs enumerated,
   arithmetic shown per cell row, and the annual-price rule in Step 3 has its
   own worked computation requirement.

---

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
