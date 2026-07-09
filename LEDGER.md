# LEDGER — Wargame Run Log

Every wargame run gets a row. Win or abort, it goes here. The ledger is how you
learn which missions need better recon and which models can be trusted to
execute blind.

| # | Date | Mission | Genius model | Executor model | 8-Pt score | Outcome | Notes |
|---|------|---------|--------------|----------------|-----------|---------|-------|
| 1 | YYYY-MM-DD | `<mission>` | fable-5 | haiku-4.5 | 8/8 | WIN / ABORT / PARTIAL | `<what happened>` |
| 2 | 2026-07-08 | `wargames/workout-tracker-verification.md` | fable-5 | TBD | 8/8 | PENDING | Kill-test plan for rep-verification core assumption; Steps 0/4 are human-only (record corpus, friends pass) |
| 3 | 2026-07-08 | `wargames/market-analysis-aso.md` | fable-5 | opus-4.8 | 8/8 | WIN | V1–V3 pass, no aborts; F1/F2 not triggered (verified-XP wedge is open). Plan defect logged: V2 sweep scope vs Step 4.1's required competitor citations — clarify V2 scope in future plans |
| 4 | 2026-07-09 | `wargames/product-design.md` | fable-5 | opus-4.8 | 8/8 | WIN | V1–V3 pass, no aborts/forks; 20 sourced constraints, economy bands held first pass (Casual→D 2.67 wk, Committed→S 6.44 mo at max multipliers). Minor plan defects: screen-count wording, S-check multiplier regime implicit |
| 5 | 2026-07-09 | `wargames/features-subscription.md` | fable-5 | opus-4.8 | 8/8 | WIN | All 6 wall-test journeys pass, V1–V3 pass, no aborts; F1 not triggered (2 non-gated Pro items: advanced history, ranks B→S). $6.99/mo, $44.99/yr (46.4% discount). Defects: F1 count needs gating-classification judgment; J5×rank-badge case underspecified (resolved: badge kept) |
| 6 | 2026-07-09 | `wargames/architecture.md` | fable-5 | opus-4.8 | 8/8 | WIN | V1–V3 pass, no aborts. ADR-1: **Apple Vision wins** on fact table (19 joints incl. hips/knees/ankles + per-joint confidence, 2 sources — falsified the red-team memory assumption); no spike needed. Stack: SwiftUI, AVFoundation, GRDB/SQLite append-only, CMPedometer+CoreLocation, no sync v1, StoreKit 2, iOS 16/iPhone 11 floor w/ fps exit criterion, pure-Swift Verifier w/ corpus byte-match. Defect: F1's ≥30fps not doc-provable for first-party frameworks — resolved via ADR-8 measurement exit criterion |
| 7 | 2026-07-09 | `wargames/appstore-compliance.md` | fable-5 | opus-4.8 | 8/8 | WIN | V1–V3 pass, no aborts; F1 not fired (no camera-motion-specific clause exists; 1.4.1 + 5.1.2(vi) govern). 16 guideline rows, 7 risks, 23 checklist items, zero snippet-only cites; V3 caught a real coverage gap (G15) and fixed it. Defects: V2 "deliverable strings" scope; ADR doc needed but not in named inputs |
| 8 | 2026-07-09 | `wargames/pushup-pipeline.md` | fable-5 | TBD | 8/8 | GATED | HARD GATE R0: squat kill test must be WIN. R2 one-clip prone scout before corpus evening; V3 squat regression mandatory |
| 9 | 2026-07-09 | `wargames/v1-build.md` | fable-5 | TBD | 8/8 | GATED | HARD GATE R0: kill test WIN + ADRs decided. M0–M5 milestones, each with a runnable check; F0 = GPS-only campaign if kill test loses |
| 10 | 2026-07-09 | `wargames/beta-measurement.md` | fable-5 | TBD | 8/8 | GATED | HARD GATE R0: v1 build WIN. Answers Q1–Q4 (bands, verification-vs-retention A/B, false-reject rate, conversion); 4-week frozen window; honor arm is beta-only |
| 11 | 2026-07-09 | `wargames/launch.md` | fable-5 | TBD | 8/8 | GATED | HARD GATE R0: build + beta WIN w/ go. Name memo (human/legal signs), fresh trend/collision checks, 30-day content calendar, review playbook; F1 pivots hook if trend post-peak |
| 12 | 2026-07-09 | `wargames/vision-backend-parity.md` | fable-5 | TBD | 8/8 | GATED | Emerged from run #6: kill test tunes on MediaPipe, production runs Apple Vision — ADR R5's byte-match can't catch signal drift. Frozen-threshold replay on Vision CSVs; F1 = transfers-with-retune, F2 = ADR-1 reverses to MediaPipe. Gated on corpus + kill-test Steps 1–3 |
| 13 | 2026-07-09 | `wargames/situp-pipeline.md` | fable-5 | TBD | 8/8 | GATED | Third exercise, first Pro (F17); completes the meme routine. HARD GATE R0: squat WIN + push-up row resolved. R2 supine one-clip scout is the kill gate; crunch depth-line policy (F3) is a mandatory human call with B/B′ data; V3 regresses squat+push-up corpora; V4 Vision replay if run #12 landed |
| 14 | 2026-07-09 | `wargames/lunge-pipeline.md` | fable-5 | TBD | 8/8 | GATED | Cheapest roster add: reuses squat calibration + hip-drop signal, no scout clip. New: stance evidence (ankle separation) to keep squats from scoring as lunges; F2 = drop separation if no view carries it (abuse value zero under uniform C5 pricing). GATE R0: squat WIN |
| 15 | 2026-07-09 | `wargames/pullup-pipeline.md` | fable-5 | TBD | 8/8 | GATED | Named in paywall copy — A1 abort changes the SUB §3.5 string. Dead-hang calibration, wrist line as bar proxy (untunable top line), elbow-flexion evidence kills jump-assist + chin-poke. R2 hanging-pose scout; R3 bar access; band-assisted reps fold weaker friends into Step 4. GATE R0: squat WIN |
| 16 | 2026-07-09 | `wargames/jumpingjack-pipeline.md` | fable-5 | TBD | 8/8 | GATED | Fastest exercise (~2 reps/s): center of gravity is 30fps sampling + teleport-cap false-fires on honest fast limbs → per-exercise detector caps (V3 regresses ALL prior corpora because the refactor touches shared code). F2 = honest-undercount exit with 60fps recovery path. GATE R0: squat WIN |
| 17 | 2026-07-09 | `wargames/glutebridge-pipeline.md` | fable-5 | TBD | 8/8 | GATED | Supine #2; inherits sit-up posture evidence, R2 scout checks the arch apex specifically. Shoulder-grounded band keeps sit-ups from scoring as bridges (reciprocal negative noted for sit-up harness); partial-pulse depth line = human call with B/B′ data (F3). GATE R0: squat WIN + sit-up row resolved |
| — | 2026-07-09 | `wargames/exercise-roster-scope.md` | fable-5 | n/a | n/a | MEMO | Roster scope decisions: burpee (multi-phase + framing, revisit after 3 shipped WINs + per-exercise caps), plank (needs duration-event contract + XP price first), weighted lifts (permanently out — camera can't verify load), mountain climbers/high knees (template-ready, deferred for breadth) |

**Outcome legend**
- **WIN** — verification runs passed, objective met.
- **ABORT** — an abort condition tripped; executor halted as designed (this is a
  success of the wargame, not a failure).
- **PARTIAL** — objective partly met; note which counter-move or fork was hit.

**Rule:** if a run failed because the executor had to improvise, the fault is in
the wargame (point 8), not the executor. Fix the plan, re-run.
