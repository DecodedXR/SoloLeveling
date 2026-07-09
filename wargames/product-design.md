# Wargame: Product Design Spec — How the Verified-XP Leveler Actually Works

**Mission:** Produce the intricate product design for the app in this market:
core loop, progression & XP economy (with real numbers), screen map, v1 scope,
free/Pro split. The design must be *derived* from the two prior documents, not
invented — every feature traces to a source or a stated rule.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** any cheap model.
No web access needed; no `[HUMAN]` steps. Everything required is in the three
input files below.

**Deliverable:** `wargames/output/product-spec.md` with exactly the section
structure in Step 6. Nothing else counts as done.

---

## Input files (the executor's ONLY sources — read all three first)

- **ENG** = `wargames/workout-tracker-verification.md` — engineering wargame.
  Its SOLVE/DESIGN-AROUND/ACCEPT/KILL lists are binding constraints.
- **MKT** = `wargames/output/market-analysis-report.md` — market analysis.
  Its banned-terms list (§1), competitor complaints (§2 table), positioning
  (§4), and monetization rule (§5.5) are binding constraints.
- **STD** = `SUCCESS.md` — context only; no constraints for this mission.

## Recon flags (check before Step 1)

- **R1:** All three files exist and are readable at the paths above. Any
  missing → halt, report which.
- **R2:** ENG contains a section titled `## Priority list` with SOLVE /
  DESIGN AROUND / ACCEPT / KILL groups, and MKT §1 contains a banned-terms
  list. If either is absent, the constraint extraction in Step 1 has no
  source → halt, report.

---

## Battle plan

### Step 1 — Extract the constraint ledger
Read ENG and MKT. Produce a numbered constraint list `C1..Cn` (verbatim quotes
+ source cite), covering at minimum:
- ENG: private XP in v1 (no leaderboard) and the threat-model fork; start-button
  sessions + arming gate (no free-running detection); generous depth line +
  live "too shallow" feedback; prescribed camera setup gate; append-only event
  log priced into XP by a pure function; on-device processing, sync events
  never video; rigor parity between vision and GPS paths; everything in ENG's
  KILL list is forbidden in the spec.
- MKT: banned terms (never in UI copy, feature names, or spec text as product
  vocabulary); free core loop (Arise's top complaint is "paywall blocks
  trial" — the free tier must contain a complete loop); free + subscription
  with camera-verified advanced exercises behind Pro; rank ladder E→S is
  allowed vocabulary; positioning promise "XP you actually earned" — no
  honor-system XP source may exist in v1.
- **Expected observation:** ≥14 constraints, each with a file+section cite.
- **Counter-move:** a listed item can't be found in the source → mark it
  `UNSOURCED` and still include it (this plan is then the cite); >3 UNSOURCED
  → the input files changed since planning, halt and report (abort A1).

### Step 2 — Core loop design
Specify the moment-to-moment and day-to-day loop as numbered flows:
1. **Set flow (vision):** open app → pick exercise → Start Set → setup gate
   (per ENG §3: full body, trusted landmarks, stable ~1s) → 3-2-1 → live rep
   counter with per-rep verdict (valid `+XP` / "too shallow — didn't count")
   → end set → set summary (reps, XP, best-depth stat).
2. **Run/walk flow (GPS):** Start Run → live pace/distance/steps → pace-
   plausibility check (ENG §6) → end → summary → XP.
3. **Daily loop:** a **quest board** of 1–3 daily quests (e.g. "30 verified
   squats", "2 km run") chosen from the user's onboarding goal; quest
   completion = bonus XP; streak = consecutive days with ≥1 completed quest.
4. **Session-to-session:** level-ups, rank promotions (E→D→C→B→A→S), and stat
   growth (define 2–4 stats, e.g. Strength from rep events, Endurance from
   GPS events — derived from the event log, never entered by hand).
Every element must carry a trace tag `[C#]` to a Step 1 constraint or a MKT
evidence cite (e.g. quest board ← MKT §2 core-loop column of the 4.8★ apps).
- **Expected observation:** all four flows present; zero honor-system XP
  sources; every element trace-tagged.
- **Counter-move:** an element has no trace → cut it or find its cite;
  untraceable elements are scope invention, the #1 executor failure here.

### Step 3 — XP economy with real numbers (the hard step)
Design rules (binding — the numbers are tuned, the rules are not):
1. **Effort-time parity:** XP per activity is proportional to verified effort
   time; a 30-min verified rep session and a 30-min run must land within 2×
   of each other's XP. (Prevents the ENG §6 "loose path pays better" failure.)
2. **Pure pricing function:** XP = f(event log). Show f as a table:
   `event type → base XP → multipliers (quest bonus, streak bonus ≤1.5×)`.
   No multiplier may compound above 2× total (inflation guard).
3. **Level curve:** cumulative XP to reach level L grows so early levels come
   fast and later ones slow. Give the closed-form or table for L=1..50.
4. **Rank gates:** ranks E→S map to level bands; write the bands down.
5. **Simulation check (mandatory, show the arithmetic):** define two personas —
   *Casual* (3 sessions/week, ~20 min each) and *Committed* (6/week, ~40 min).
   Compute weeks to each rank for both. **Acceptance bands:** Casual reaches
   D in 2–4 weeks and B in 3–6 months; Committed cannot reach S in under
   6 months. Tune base XP / curve until both bands hold; show the final pass.
- **Expected observation:** pricing table + level curve + rank bands + a
  worked simulation table where both personas land inside the bands.
- **Counter-move:** bands can't all hold → adjust the level curve first, base
  XP second, never the bands; if 3 tuning rounds still fail, the bands
  conflict mathematically → abort A2 with the arithmetic shown.
- **Fork F1:** if effort-time parity (rule 1) and the acceptance bands
  cannot hold simultaneously (condition: 3 failed tuning rounds where the
  binding constraint is parity), relax parity to 3× — document the relaxation
  and its ENG §6 risk in the spec's Risks section.

### Step 4 — Screen map & UX flows
List every v1 screen (~10–14) as: name, purpose (one sentence), key elements,
and which flow(s) from Step 2 it serves. Must include: onboarding (goal pick +
camera-setup tutorial per ENG §3 prescription), quest board / home, exercise
picker, setup-gate screen, live set screen (rep counter + verdict feedback),
set summary, run screen, run summary, profile (level/rank/stats/streak),
settings (privacy: on-device statement), paywall. Two UX rules are binding:
- **Rejection UX:** a rejected rep must show *why* ("too shallow") and never
  interrupt the set — feedback is inline, not modal (ENG §1 fatigue UX).
- **Trust UX:** untrusted frames freeze the counter with a subtle "hold on…"
  state, never a rep verdict (ENG §3 — the freeze IS the designed failure mode).
- **Expected observation:** every screen serves a Step 2 flow; the two UX
  rules appear verbatim as design notes on the live set screen.
- **Counter-move:** a screen serves no flow → cut it (scope invention again).

### Step 5 — v1 scope cut & free/Pro split
Produce a MoSCoW table (Must/Should/Could/Won't). Hard rules:
- **Won't (v1):** everything in ENG's KILL list; leaderboards & any social XP
  comparison (ENG §2 threat-model fork — list as v2-with-flip-consequences);
  form-quality coaching (ENG ACCEPT); wearables; Android-if-iOS-first note.
- **Must:** the complete free loop — at minimum 2 verified exercises
  (squat + one more from ENG's pipeline, e.g. push-up flagged as needing its
  own state machine), runs/steps, quests, levels/ranks E→C, streaks.
- **Pro split rule (MKT §5.5):** Pro = additional verified exercises, advanced
  stats/history, higher-rank progression cosmetics. The free tier must allow
  reaching rank C and completing daily quests forever — the paywall gates
  breadth, never the core loop (Arise complaint, C-constraint from Step 1).
- **Expected observation:** MoSCoW table complete; free tier passes the test
  "a user who never pays can level up daily without hitting a wall"; every
  Won't cites its source.
- **Counter-move:** a Must item depends on unproven tech beyond ENG's kill
  test (squat pipeline) → keep it Must but flag `GATED ON KILL TEST` — the
  spec ships with the dependency named, not hidden.

### Step 6 — Assemble the spec
Write `wargames/output/product-spec.md` with exactly:
`## 1. Constraint ledger` · `## 2. Core loop` · `## 3. Progression & XP
economy` (incl. the simulation table) · `## 4. Screen map` · `## 5. v1 scope
& free/Pro split` · `## 6. Open questions & risks` (≥3, each naming what
resolves it; include the F1 relaxation here if triggered) ·
`## 7. Trace index` (every feature → constraint/cite; anything untraced was
supposed to be cut).
- **Expected observation:** file exists, all 7 sections non-empty, trace
  index has no `(untraced)` rows.
- **Counter-move:** a section can't be filled → its step's counter-move was
  skipped; go back, don't pad.

---

## Abort conditions

- **A1:** Input files missing/changed such that >3 constraints are UNSOURCED
  (Step 1). The spec would be built on a moved foundation. Halt, report which.
- **A2:** XP acceptance bands mathematically unsatisfiable after 3 tuning
  rounds AND the F1 parity relaxation (Step 3). That means the economy design
  goals conflict — a genius-level decision, not an executor tuning problem.
  Halt with the arithmetic.
- **A3:** Any resolution of a design question would require violating an ENG
  KILL-list item or a MKT banned term. Halt and name the collision — do not
  quietly pick one.

## Verification runs (distinct from the work)

- **V1 — KILL/banned sweep:** search the finished spec for every ENG KILL-list
  concept (trajectory/DTW matching, free-running detection, adaptive per-user
  thresholds, honest-user-punishing anti-cheat) and every MKT banned term.
  Zero hits as *product features/vocabulary* required (mentions inside the
  constraint ledger or Won't column are citations, not hits).
- **V2 — economy re-computation:** recompute the Casual persona's
  weeks-to-rank-D from the pricing table and level curve *from scratch*
  (not by copying Step 3's table); result must match Step 3 within rounding
  and sit inside the 2–4 week band. A mismatch = arithmetic was faked.
- **V3 — trace audit:** pick every 5th row of the trace index; confirm the
  cited source actually contains the claimed constraint/evidence. ≥90% must
  hold; failures get fixed or the feature cut.
- **Mission proven** when the spec exists with all 7 sections, V1–V3 pass,
  and no abort tripped.

---

## Red-team pass (attacking this plan)

1. **Weakest assumption:** the XP acceptance bands (2–4 weeks to D, no S
   under 6 months) are my judgment, not market data. If they're wrong, the
   economy is tuned to a fiction. *Fix folded in:* bands are stated as
   explicit inputs in the spec's Open Questions ("bands are genius-set;
   validate against beta retention"), so they're revisable data, not hidden
   dogma — and A2 stops the executor from torturing math to satisfy bad bands.
2. **Most likely executor screw-up:** inventing delightful features with no
   source (pets, gacha, social feeds) — cheap models pad specs. *Fix folded
   in:* the trace-tag requirement on every element, the trace index section,
   and V3's audit; untraced = cut, by rule.
3. **Second most likely:** faking the Step 3 simulation (writing a table that
   "passes" without arithmetic). *Fix folded in:* V2 recomputes one persona
   from scratch and must match — a faked table won't survive an independent
   recomputation.
4. **Copying franchise mechanics too literally:** "daily quest / penalty
   zone / system messages" styled as the show's System is an IP smell even
   with clean vocabulary. *Fix folded in:* Step 1 carries MKT's banned terms
   into UI copy; the spec's quest/notification copy must use its own voice —
   V1 sweeps vocabulary, and Open Questions must carry a "final legal review
   of UI copy" item (MKT risk #2 already requires this).
5. **Spec drifts into algorithm design:** re-specifying thresholds/state
   machines already owned by ENG. *Fix folded in:* Step 2 and 4 reference ENG
   sections instead of restating them; the spec is product behavior, ENG is
   mechanism — stated here so the executor doesn't duplicate (and drift from)
   the engineering source of truth.
6. **Sequencing risk:** this spec assumes the ENG kill test passes. If the
   kill test dies, the camera loop dies. *Fix folded in:* Step 5's
   `GATED ON KILL TEST` flag and an Open Questions item naming the dependency;
   the spec must remain honest that verified-vision features are conditional.

---

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
