# Wargame: Solo-Leveling-Style Fitness Tracker — Market Analysis & App Store Marketing

**Mission:** The product is the gamified workout tracker from
`wargames/workout-tracker-verification.md` (camera-verified reps + GPS/steps/
running path, XP ledger), framed as a *Solo Leveling*-style "level up in real
life" experience. Produce: (1) an analysis of the current market for gamified /
anime-leveling fitness apps, and (2) a concrete App Store marketing plan (ASO,
positioning, launch channels, monetization recommendation).

**Date:** 2026-07-08 · **Genius:** fable-5 · **Executor:** any cheap model with
`WebSearch`/`WebFetch`. No `[HUMAN]` steps — this mission is fully blind-executable.

**Deliverable:** one file, `wargames/output/market-analysis-report.md`, with the
exact section structure defined in Step 6. Nothing else counts as done.

---

## Context the executor must know (no other context will be given)

- The app: users do real workouts; a phone camera + pose detection verifies
  reps (binary valid/invalid → XP); GPS + step counter verifies runs/walks.
  XP is private in v1 (no leaderboard). On-device processing, no video upload.
- The unique wedge to test against the market: **verified XP** — most gamified
  fitness apps award points on the honor system or raw step counts; this app
  makes the camera the referee.
- "Solo Leveling" is a Korean web novel / hit anime (A-1 Pictures, aired
  2024–2025) owned by Kakao Entertainment / D&C Media, with an official game
  "Solo Leveling: ARISE" by Netmarble. **The IP is trademarked. The app cannot
  use the name, characters, or distinctive marks.** The mission is to ride the
  *aesthetic and fantasy* ("you are the hunter who levels up") legally, the way
  "soulslike" games ride Dark Souls.

## Recon flags (check before Step 1; any failure → halt and report)

- **R1:** `WebSearch` returns live results (test query: `"gamified fitness app" 2026`).
  Fail → abort A0, the whole mission is web research.
- **R2:** Apple App Store pages are fetchable via `WebFetch` on
  `https://apps.apple.com/us/app/...` URLs found in search. Fail → fall back to
  search-snippet data only, and mark every affected datapoint `(snippet-only)`.
- **R3:** Confirm today's date from the environment and stamp it in the report
  header. Market data older than 2024 must be labeled with its year — a 2023
  market-size figure presented as current is a defect.

---

## Battle plan

### Step 1 — IP and naming constraints memo
Search: `Solo Leveling trademark Kakao Netmarble`, `Solo Leveling Arise official
game`, `app store removed app trademark anime name`. Write a short memo:
who owns the IP, what the official game is, and a **banned-terms list** for app
name/subtitle/keywords (at minimum: "Solo Leveling", "Sung Jinwoo", "Arise",
"Shadow Monarch"; add anything the search shows is distinctive/registered).
Terms like "level up", "hunter", "quest", "rank", "dungeon", "gate" are generic
fantasy vocabulary — allowed unless a search result shows a specific registration
conflict for fitness apps.
- **Expected observation:** memo names the IP owner(s) and lists ≥4 banned
  terms and ≥6 allowed genre terms, each with a one-line justification.
- **Counter-move:** if ownership is unclear from search, state "ownership
  unresolved — treat all franchise-distinctive terms as banned" and continue;
  ambiguity widens the banned list, it never blocks the mission.
- **Fork F1:** if an *official* Solo Leveling fitness app exists (search:
  `official Solo Leveling fitness app`) → the positioning pivots from
  "the Solo Leveling fitness app that doesn't exist yet" to "the *verified*
  alternative"; flag this prominently in Step 6's positioning section.
  Condition: an app store listing published by Netmarble/Kakao or licensed
  partner, in the Health & Fitness or Games category, matching the fitness
  use case. Fan-made apps do NOT trigger F1.

### Step 2 — Competitor sweep
Build a competitor table. Search each cluster; for every app found, `WebFetch`
its App Store page when possible.

Clusters and seed queries (run all; add follow-ups the results suggest):
1. **Solo-Leveling-inspired levelers:** `solo leveling workout app`,
   `solo leveling inspired fitness app iOS`, `hunter leveling workout app`.
2. **RPG/gamified fitness:** `RPG fitness app iPhone`, plus check these by
   name: Habitica, Zombies Run, Walkr, Fitness RPG, Pikmin Bloom, Ring Fit
   (as console benchmark), Gymrats, Strava (gamification features only).
3. **Money/stakes-verified fitness:** Sweatcoin, StepBet, Paceline — these
   compete on the "your effort must be real" axis, our wedge.
4. **AI rep-counting / camera fitness:** `AI rep counter app`,
   `camera workout form app` (e.g. anything like Tempo/Onyx/Kaia/Peloton Guide
   successors) — these compete on the verification tech without the game layer.

Per app, record in a fixed-schema table:
`name | cluster | price model (free/sub/IAP, $ amounts) | App Store rating & review count | last update year | core loop in one sentence | does it VERIFY effort? (honor / sensor / camera) | top 2 complaint themes from reviews/search`.
- **Expected observation:** ≥12 apps total, ≥2 per cluster, no schema cell
  blank (unknown → write `unknown`, never omit).
- **Counter-move:** a cluster yields <2 apps after 3 query variants → record
  the queries tried and the finding "cluster thin" — a thin cluster is itself
  market data (whitespace), not a failure.
- **Fork F2:** if any competitor already does **camera-verified reps + XP**
  (condition: an app whose store listing or reviews describe camera rep
  verification feeding a leveling system), the Step 6 positioning must switch
  from "first verified-XP leveler" to a direct comparison against that app:
  add a row-by-row feature/price comparison and a differentiation argument.

### Step 3 — Demand signals for the Solo Leveling fitness fantasy
The bet is that the *fantasy* has organic demand. Verify it:
- Search: `solo leveling workout routine`, `Sung Jinwoo workout TikTok`,
  `solo leveling training arc reddit`, `anime workout trend 2025 2026`.
- Record: does a "Solo Leveling workout" trend exist (yes/no + 3 cited
  examples with URLs); which platforms carry it (TikTok/YouTube/Reddit);
  is it growing, flat, or post-peak (judge by content dates: majority of top
  results from the last 12 months = alive; majority older = post-peak).
- Also grab 2–3 headline figures on gamified-fitness / fitness-app market size
  and growth from named research firms, with year labels per R3.
- **Expected observation:** a verdict line — `Fantasy demand: STRONG / WEAK /
  POST-PEAK` — backed by ≥5 cited sources with dates.
- **Counter-move:** conflicting market-size figures → report the range with
  both sources; never average silently.

### Step 4 — App Store (ASO) plan
Using Steps 1–3 outputs, produce:
1. **Category call:** Health & Fitness vs Games, with the deciding reason
   (rule: if top-3 comparable levelers sit in Health & Fitness, follow them;
   the store category of competitors is data from Step 2, not opinion).
2. **5 candidate app names + subtitles**, each ≤30 chars (Apple's limit),
   zero banned terms (Step 1), and for each: run an App Store search
   (`site:apps.apple.com "<name>"` or store search via WebFetch) and mark
   `collision: yes/no`. At least 3 candidates must be collision-free.
3. **Keyword strategy:** ~20 keywords/phrases ranked in 3 tiers —
   (a) fantasy terms fans actually search (from Step 3 evidence, e.g. what
   the trend content is titled), (b) category terms (workout tracker, rep
   counter, step counter, running), (c) differentiator terms (AI rep counter,
   verified workout). Each keyword gets a one-line "why" citing a step.
4. **Screenshot/preview narrative:** an ordered list of 6 store screenshots
   as text descriptions, first 3 must communicate: the fantasy (level-up UI),
   the proof (camera counting a rep), the scope (running/steps too). This is
   copywriting, not design — text only.
5. **Monetization recommendation:** pick ONE primary model from the Step 2
   evidence (rule: recommend the model most common among the ≥4.5-star apps
   in clusters 1–2; if tied, prefer free + subscription because the camera
   feature is a credible paywall). State the rule was applied.
- **Expected observation:** all 5 artifacts present; every name candidate has
  a collision check result; every keyword has a tier and a why.
- **Counter-move:** all 5 names collide → generate 5 more from the allowed-
  terms list and re-check; repeat once more if needed (15 total max), then
  ship the best 5 with collisions flagged for human decision.

### Step 5 — Launch-channel plan (beyond the store)
From Step 3's platform findings, list the top 3 organic channels with one
concrete first action each (e.g. "TikTok: post split-screen of camera
rejecting a shallow squat — the verification moment is the hook"; the actual
three must come from where Step 3 found the trend living, not this example).
Include one line on why paid UA is or isn't advised at launch given Step 2
price-model findings.
- **Expected observation:** 3 channels, each traceable to a Step 3 citation.
- **Counter-move:** Step 3 found no living trend → channels default to the
  general gamified-fitness communities found in Step 2 reviews/search, and
  the report must say the fantasy-led angle is unproven.

### Step 6 — Assemble the report
Write `wargames/output/market-analysis-report.md` with exactly these sections:
`## 1. IP & naming constraints` (Step 1 memo) · `## 2. Competitor landscape`
(Step 2 table + 3-sentence whitespace summary) · `## 3. Demand signals`
(Step 3 verdict + citations) · `## 4. Positioning` (one paragraph: who it's
for, the enemy [honor-system XP], the promise [XP you earned for real]; adjust
per F1/F2 if triggered) · `## 5. ASO plan` (Step 4 artifacts) ·
`## 6. Launch channels` (Step 5) · `## 7. Risks & unknowns` (≥3 items, each
with the signal that would resolve it) · `## Sources` (every URL used, with
access date).
- **Expected observation:** file exists, all 8 sections non-empty, every
  factual claim in sections 1–3 has a source in `## Sources`.
- **Counter-move:** any section can't be filled from prior steps → the prior
  step's counter-move was skipped; go back and run it, don't pad.

---

## Abort conditions (stop, don't push forward)

- **A0:** R1 fails — no live web access. Nothing here can be done from memory;
  a report written from training data would be confidently stale. Halt.
- **A1:** Step 1 finds the IP owner actively enforcing against *fantasy-
  adjacent* fitness apps (evidence: ≥2 reports of takedowns of apps that used
  no trademarked terms). The whole aesthetic positioning is then legally
  radioactive, which is a product decision above the executor's pay grade.
  Halt and report the evidence.
- **A2:** Step 2 + Step 3 jointly show the niche is saturated AND post-peak
  (condition: ≥3 direct Solo-Leveling-style levelers with >10k ratings each,
  AND Step 3 verdict = POST-PEAK). Finishing the ASO plan for a dead trend
  wastes the run; halt after writing sections 1–3 and report.

## Verification runs (distinct from the work)

- **V1 — citation audit:** for 5 randomly-chosen claims in sections 1–3
  (pick every 3rd claim from the top), re-fetch the cited URL and confirm it
  supports the claim. ≥4/5 must hold; a failed one gets corrected or cut.
- **V2 — banned-term sweep:** search the final report's section 5 (names,
  subtitles, keywords) for every banned term from section 1. Zero hits
  required. This proves the ASO plan obeys the legal memo it sits next to.
- **V3 — collision spot-check:** re-run the store search for the top-ranked
  name candidate; result must match its recorded `collision` value.
- **Mission proven** when the report exists with all sections, V1–V3 pass,
  and no abort tripped.

---

## Red-team pass (attacking this plan)

1. **Weakest assumption:** that search-visible signals (ratings, TikTok posts)
   proxy for market reality; download numbers are mostly hidden. *Fix folded
   in:* the schema uses rating *count* (public, comparable) not downloads, and
   Section 7 must list "true download/revenue figures unknown" as a standing
   unknown rather than letting estimates masquerade as data.
2. **Most likely executor screw-up:** writing the report from training-data
   memory of these well-known apps instead of live fetches — stale prices and
   dead apps presented as current. *Fix folded in:* R3 date-stamping rule,
   `last update year` as a mandatory schema column (forces a live check), and
   V1's re-fetch audit.
3. **Second most likely screw-up:** using "Solo Leveling" in the ASO
   deliverables because the mission title says it. *Fix folded in:* Step 1
   runs first and produces a machine-checkable banned list; V2 sweeps the
   final artifact against it.
4. **Hallucinated citations:** cheap models invent plausible URLs. *Fix folded
   in:* V1 re-fetches real URLs; any 404/mismatch is corrected or the claim is
   cut — the audit is part of the run, not optional.
5. **Scope creep into strategy fan-fiction:** monetization and channel picks
   could drift into taste. *Fix folded in:* Steps 4–5 pick by stated rules
   over Step 2/3 evidence (follow the ≥4.5-star cohort; channels must trace to
   citations), so two different executors converge on the same calls.
6. **Fork ambiguity:** "does a competitor do camera-verified XP" could be
   judged loosely. *Fix folded in:* F2's condition requires the store listing
   or reviews to describe it — a marketing page saying "AI-powered" alone does
   not trigger the fork.

---

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
