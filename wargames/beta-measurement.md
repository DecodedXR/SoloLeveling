# Wargame: Beta & Measurement Plan

**Mission:** Design and run the TestFlight beta that answers the four open
questions the specs deliberately left as assumptions: (Q1) are the XP
acceptance bands right? (Q2) does mandatory verification help or hurt
retention? (Q3) what is the real-world false-reject rate? (Q4) do the
conversion assumptions (2/4/6%) have any basis? Deliverable is a measurement
plan first, then a results report with go/no-go reads.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** cheap model for
instrumentation spec + analysis; `[HUMAN]` recruits testers and ships builds.

**Deliverables:** `wargames/output/beta-plan.md` (Steps 1–3), then
`wargames/output/beta-report.md` (Step 5) after the beta window.

## HARD GATE — recon flags

- **R0:** A v1 build exists that passed the v1-build campaign's V1–V3
  (LEDGER row for `wargames/v1-build.md` = WIN, or F0/GPS-only noted — in
  F0 mode, Q2/Q3 are unanswerable; the plan runs Q1/Q4 only and says so).
- **R1:** Inputs readable: SPEC §3.4 (the bands), SUB §5 (conversion
  assumptions), `wargames/output/product-spec.md` §6 (the open questions).
- **R2:** Privacy constraint check: all analytics events must satisfy C6 —
  event metadata only, never video/frames; no third-party ad/tracking SDKs
  (compliance doc risk #4). Any metric needing more → cut the metric.

## Battle plan

### Step 1 — Metric & event dictionary
Define every analytics event (name, properties, when fired) needed to
compute exactly these metrics and no more: D1/D7/D30 retention; sessions/wk
per user; weeks-to-rank-D distribution (Q1 vs the 2–4 wk band); per-set
rejected-rep rate and untrusted-freeze rate (Q3 proxy for false rejects);
set-abandonment-after-rejection rate (the fatigue-UX tripwire from ENG §1);
quest completion + streak length distributions; paywall views by placement,
trial starts, conversions (Q4). Each metric: formula from events + the
decision it feeds.
- **Expected observation:** every metric traces to Q1–Q4 or a named spec
  tripwire; every event passes R2; no vanity metrics (a metric feeding no
  decision is cut by rule).
- **Counter-move:** a Q can't be computed from allowable events → record it
  as unanswerable-by-telemetry and assign it to the Step 3 interview script.

### Step 2 — Cohort design (the Q2 experiment)
Two TestFlight arms, same build, flag-controlled: **A (verified)** — ship
config; **B (honor)** — identical UI but reps count on cycle completion
without the depth gate (verification theater retained: verdicts still show).
Q2 read: D7/D30 retention and sessions/wk, A vs B. Rules: arm assignment
random at first launch, persisted; minimum n per arm 40 (below → report
directional only, no causal claim — stated in the plan up front); the honor
arm is BETA-ONLY and dies at launch (C18 stays inviolable in production —
this is an experiment about the wedge, not a product option). Ethics line:
beta welcome note says "some capabilities vary during beta."
- **Expected observation:** the arm spec is implementable as one flag on the
  depth-check; power/n caveat stated; sunset date for arm B written down.
- **Counter-move:** if flagging the depth gate touches more than the
  Verifier config (i.e., leaks into UI code paths), the experiment costs too
  much — drop arm B, answer Q2 via interviews only, log the downgrade.

### Step 3 — Beta ops `[HUMAN]` + qualitative script
Recruitment: 30–80 testers from the MKT §6 channels (anime-fitness
communities; the recruit post follows arbiter voice + banned-terms rules).
4-week window. Weekly build cadence at most. Interview script (8 questions)
targeting what telemetry can't see: did rejections feel fair? (Q3), did
progression pace feel right? (Q1), would you pay / what for? (Q4).
- **Expected observation:** plan document complete; recruit copy swept clean.
- **Counter-move:** recruitment under 30 after two weeks → widen to general
  fitness testers, tag cohort source so fandom vs general reads separate.

### Step 4 — The window (4 weeks, no retuning)
Thresholds, XP economy, and paywall placements are FROZEN for the window
(the beta measures the shipped design, not a moving target). Hotfixes
allowed only for crashes/data loss; every hotfix logged in the report.
- **Expected observation:** ≤1 non-crash change over the window; freeze log clean.
- **Counter-move:** a genuine design flaw surfaces mid-window (e.g., mass
  churn at a specific screen) → note it, keep the freeze, shorten the window
  to 3 weeks minimum rather than retune mid-measurement.

### Step 5 — Analysis & report
`wargames/output/beta-report.md`: per-question verdicts with the arithmetic:
Q1 — observed weeks-to-D distribution vs the 2–4 band → keep/revise bands
(revision proposal computed, not vibed); Q2 — A vs B retention with n and
the causal-claim caveat; Q3 — rejected-rep rate split by "user agreed it was
fair" (interviews) vs not → false-reject estimate; if >10% of rejections
read unfair, that's the ENG fatigue-UX tripwire → threshold/B-policy review
(the one sanctioned retune, AFTER the window); Q4 — trial starts + stated
willingness → keep/revise the 2/4/6% scenarios. Plus: go/no-go recommendation
for public launch with the three biggest risks.
- **Expected observation:** four verdicts, each with data shown; every
  revision proposal traces to a number.
- **Counter-move:** insufficient data for a verdict → the verdict is
  "unanswered — extend beta / larger n," never a guess dressed as a finding.

## Fork triggers
- **F1:** Arm B retention ≥ arm A by a clear margin (D30 delta >10pts,
  n≥40/arm) — the wedge assumption itself is challenged. The report must
  escalate this as a strategy question (verification as *trust marketing* vs
  retention driver), not bury it. Condition: the stated delta, not judgment.

## Abort conditions
- **A1:** R0/R2 gate failures.
- **A2:** Beta surfaces a data-loss or privacy bug (events containing frame
  data). Stop the beta, fix, restart the window.

## Verification runs
- **V1:** Event dictionary audit — implement-side check that every shipped
  analytics event appears in the dictionary and vice versa (no shadow
  telemetry).
- **V2:** Recompute two report metrics (weeks-to-D median, A/B D7) from raw
  event exports independently of the analysis notebook; must match.
- **V3:** Freeze audit — build diff log over the window shows only logged
  hotfixes.

## Red-team pass
1. **Weakest assumption:** n. 30–80 testers won't power a clean A/B. *Fix:*
   the minimum-n rule + mandatory directional-only caveat is in the plan
   text; F1's threshold requires n≥40/arm to fire.
2. **Likely screw-up:** mid-beta threshold tinkering because early testers
   complain. *Fix:* Step 4 freeze is absolute with a logged-hotfix-only
   exception; V3 audits it.
3. **The honor arm leaks into production:** *Fix:* arm B's sunset date is a
   written deliverable of Step 2; C18 is cited as inviolable in the same
   paragraph.
4. **Survivorship in interviews:** only engaged testers answer. *Fix:* Step 3
   script must include reaching ≥5 churned testers (defined: no session in
   7+ days); their answers reported separately.
5. **Metric sprawl:** *Fix:* the no-vanity-metrics rule — every metric names
   its decision or dies at Step 1.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
