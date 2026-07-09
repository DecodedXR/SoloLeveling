# Wargame: Launch Execution

**Mission:** Take the beta-validated build to public App Store launch:
finalize the name (human/legal call from the ASO candidates), produce the
store listing package, the first 30 days of organic content, the submission
sequence, and the review-response playbook. This plan turns the MKT §5–§6
strategy into dated, executable artifacts.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model with
`WebSearch`/`WebFetch` for collision re-checks; `[HUMAN]` for legal sign-off,
account actions, and posting.

**Deliverable:** `wargames/output/launch-plan.md`, structure in Step 6.

## HARD GATE — recon flags

- **R0:** LEDGER shows v1-build = WIN and beta-measurement = WIN with a "go"
  recommendation in `wargames/output/beta-report.md`. A "no-go" or missing
  row → halt: launching against a no-go is a human override, not an executor
  decision.
- **R1:** Inputs readable: MKT (§5 ASO plan, §6 channels), SUB (prices),
  `wargames/output/appstore-compliance.md` (pre-submission checklist),
  `PRODUCT.md` (voice), beta-report (any revised numbers supersede spec
  numbers — check §5 verdicts and use the revised bands/prices if changed).
- **R2:** WebSearch live — name collisions and trend recency must be
  re-checked at launch time, not trusted from the 2026-07 snapshot.

## Battle plan

### Step 1 — Name finalization package `[HUMAN decision, executor prepares]`
Re-run collision + trademark-snippet checks on the MKT §5.2 five candidates
(HunterFit, Proof of Grind, RepProof, GateRunner, Realm Reps) with fresh
dates; add ranked recommendation by rule (shortest + cluster-1 keyword
adjacency + zero collision). Output a one-page decision memo ending in a
signature line: name + legal sign-off checkbox (MKT risk #2 requires legal
review of final copy — this memo is where it happens).
- **Expected observation:** 5 fresh collision results + 1 recommendation;
  memo explicitly blocks Steps 3+ until the human signs.
- **Counter-move:** a candidate now collides → strike it, promote by the
  same rule; all five collide → generate per MKT §5.2's counter-move
  procedure (allowed-terms recombination, 15 max).

### Step 2 — Trend recency re-check
Re-run MKT §3's recency test (majority of top trend results ≤12 months?).
- **Expected observation:** verdict STRONG / POST-PEAK with ≥4 dated cites.
- **Fork F1:** POST-PEAK → the launch content plan (Step 4) pivots from
  trend-surfing to the anti-cheat/verification hook as primary ("the app
  that rejects fake reps" leads; the fantasy becomes flavor, not hook), and
  the keyword tiers re-rank (Tier C differentiators promoted over Tier A
  fantasy terms). Condition: the recency test result, not judgment.

### Step 3 — Store listing package
Using the signed name: title+subtitle (≤30 chars each), keyword field
(100 chars, built from MKT §5.3 tiers as re-ranked by F1), description
(arbiter voice, banned-terms clean), the 6-screenshot narrative from MKT
§5.4 as concrete copy blocks + capture list for the designer/build, preview-
video shot list (15–30s: the rejection moment is the hook per MKT §6),
privacy labels + reviewer notes copied consistent with the compliance doc.
- **Expected observation:** every asset banned-term-swept; subtitle/keywords
  contain zero banned terms and ≥3 Tier-B category terms; reviewer notes
  include the camera demo video plan.
- **Counter-move:** copy exceeds char limits → cut adjectives before
  keywords; the keyword field never contains the app name (wasted chars —
  rule, not taste).

### Step 4 — 30-day organic content calendar
From MKT §6 channels (as modified by F1): 12 TikTok posts (3/wk — the first
is the split-screen rejection hook), 4 YouTube videos (week 1: "I let an app
referee my workouts for 30 days" format), 4 Reddit posts (value-first,
community rules respected — the executor must include a "read each
subreddit's self-promo rules first" checklist item). Each item: hook line,
format, channel, day, and the single metric it's judged by (views is not a
metric that feeds a decision; use follows/installs-attributed where
readable). Paid UA: not at launch (MKT §6) — restated with the condition to
revisit (LTV measured from beta Q4 data exceeding blended CAC estimate).
- **Expected observation:** 20 dated items, each with hook + metric; zero
  banned terms in any hook.
- **Counter-move:** a channel's rules prohibit the planned format → swap to
  the compliant format, log the change; never post against community rules.

### Step 5 — Submission sequence & review playbook
Ordered checklist: freeze build → run the full compliance pre-submission
checklist (every item, recorded) → submit with reviewer notes + demo video →
monitor. Playbook: for each of the compliance doc's 6 rejection risks, the
prepared response (what to change, what to appeal, the appeal template in
arbiter-adjacent professional voice). Include the timing rule: submit ≥2
weeks before any content-calendar date that mentions availability, and the
day-1 contingency ("in review" on launch day → content items that assumed
availability shift by rule, not scramble).
- **Expected observation:** the sequence references the compliance checklist
  by item count (all items, none waived); every rejection risk has a
  prepared response.
- **Counter-move:** an unprepared rejection arrives → that's a compliance-doc
  gap; the response is written, AND the compliance doc gets the missing row
  (feedback loop named in the playbook).

### Step 6 — Assemble
`wargames/output/launch-plan.md`: `## 1. Name decision memo` · `## 2. Trend
verdict` · `## 3. Store listing package` · `## 4. 30-day content calendar` ·
`## 5. Submission sequence & review playbook` · `## 6. Open questions` ·
`## Sources` (fresh dated URLs).

## Abort conditions
- **A0:** No web (R2) — stale collision/trend data makes Steps 1–2 fiction.
- **A1:** R0 gate — beta no-go or missing.
- **A2:** Legal declines all name candidates (Step 1 memo returns unsigned
  with objections) — halt; naming restarts as a human-led process.

## Verification runs
- **V1:** Banned-term sweep across ALL deliverable copy (listing, hooks,
  appeal templates); citations exempt. Zero hits.
- **V2:** Char-limit audit: title, subtitle, keyword field measured and
  printed with their counts.
- **V3:** Dependency audit: every content item that assumes the app is live
  sits ≥1 day after the submission sequence's earliest realistic approval
  date; the day-1 contingency covers the rest.

## Red-team pass
1. **Weakest assumption:** the July-2026 market snapshot still holds at
   launch time. *Fix:* Steps 1–2 mandate fresh checks; F1 exists because the
   trend may have peaked by then.
2. **Likely screw-up:** the executor writes growth-hacker copy (urgency,
   emoji, "don't miss out") that violates the arbiter voice. *Fix:* V1 +
   the SUB spec's pleading-verb ban applies to marketing copy explicitly here.
3. **Reddit self-immolation:** value-less promo posts get the account
   banned and the brand marked. *Fix:* Step 4's community-rules checklist
   item + value-first format requirement.
4. **Launch-day review limbo:** *Fix:* Step 5's timing rule + day-1
   contingency are explicit, dated, and rule-driven.
5. **Name memo bottleneck:** everything downstream waits on a human
   signature. *Fix:* the memo is Step 1 and the plan orders Steps 2, 4
   (undated drafts) to proceed in parallel while awaiting signature; only
   Step 3's final assets block on the name.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
