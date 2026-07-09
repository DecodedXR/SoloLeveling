# Wargame: v1 Build Campaign

**Mission:** Build v1 as ordered, demo-able milestones. Each milestone ends
in a runnable check a non-engineer can perform. The executor is a coding
model working milestone by milestone; this plan is the campaign map.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** coding model
(milestones M0–M5), human for device testing marked `[HUMAN]`.

## HARD GATE — recon flags

- **R0:** `LEDGER.md` shows the squat kill test = **WIN**, AND
  `wargames/output/architecture-adr.md` exists with ADRs 1–9 decided (a
  "spike" decision for ADR-1 counts as NOT decided — the spike must have run
  and its exit criteria met, per its own ADR text). Either missing → halt.
  Exception fork **F0**: if the kill test is a recorded LOSS/ABORT, this plan
  runs in **GPS-only mode**: skip M3–M4, M5 ships without vision, the SUB
  spec's thin-Pro reality applies (2 Pro items) — note it in every milestone
  report.
- **R1:** Inputs readable: SPEC, SUB, `architecture-adr.md`, `PRODUCT.md`,
  `DESIGN.md`, and (unless F0) the kill-test corpus + Python reference
  implementation with its recorded metrics.
- **R2:** Toolchain: Xcode + chosen deps resolve a hello-world build on the
  ADR-8 device floor simulator. Fail → fix toolchain before any feature code.

## Binding rules

- **B1:** Milestone order is fixed; no milestone starts until the previous
  one's check passes. No horizontal slicing (all-screens-half-done is the
  failure mode this plan exists to prevent).
- **B2:** The Verifier module ports the Python reference 1:1; corpus fixture
  tests (checked-in CSVs → expected events) are the acceptance gate. Code
  review does not substitute for corpus parity.
- **B3:** Every screen obeys `DESIGN.md` named rules (Earned Ember, Arbiter
  Speaks Mono, 2-Meter, Glow Is a Verb, No-Purple) and `PRODUCT.md` voice.
  UI copy drawn only from allowed vocabulary; banned-term sweep per milestone.
- **B4:** Event log append-only from M1 onward; any migration = design bug.

## Milestones

### M0 — Walking skeleton
App boots on device floor: navigation shell for the 12 SPEC §4 screens
(placeholder content), event-log storage (ADR-4) with a `debug_event`
write/read, ledger fold returning XP=0, StoreKit 2 stub behind a flag.
- **Check:** app launches on simulator; a debug screen shows "events: 1,
  XP: 0" after tapping a debug button; unit test folds 3 fixture events.
- **Counter-move:** any ADR choice fails in practice here (dep won't build,
  API deprecated) → amend the ADR with the discovered fact, don't hack around.

### M1 — GPS/steps loop (complete, shippable alone)
Run/walk flow end-to-end: start run → CoreLocation/pedometer per ADR-5 →
pace-plausibility check (SPEC C7: implausible pace segments flagged, XP only
on plausible ones) → run summary → events → XP/level/rank fold → Home/quest
board with real daily quests + streaks → Profile with level/rank E→C/stats.
- **Check `[HUMAN]`:** a real outdoor walk earns XP; a car ride earns 0
  (plausibility rejects); quest completes; streak increments next day;
  force-quit mid-run loses no events.
- **Counter-move:** car ride earns XP → plausibility thresholds too loose;
  tune against the recorded traces from this same test, re-run.

### M2 — Progression & economy
Full SPEC §3 pricing table (10 XP/rep priced but dormant until M4, 300 XP/km,
quest ×1.25, streak ladder, ×2.0 cap), level curve, rank gates, rank-C free
ceiling behavior (SUB J3 state: XP accrues, promotion presented as Pro).
- **Check:** unit tests reproduce SPEC §3.4's simulation table exactly
  (Casual→D at 2.67 weeks of synthetic events); J3 state renders; repricing
  test: change a base price in config, re-fold, no migration.
- **Counter-move:** simulation mismatch → the fold, not the spec, is wrong;
  diff event-by-event against the spec table.

### M3 — Vision pipeline port *(skip under F0)*
Verifier in Swift: calibration, hip-drop ratio, lie detectors, hysteresis
state machine — 1:1 from Python. Camera capture (ADR-3) + IMU check feeding
it. No UI yet beyond a debug overlay.
- **Check:** corpus fixture tests — Swift Verifier output matches Python
  reference on every corpus CSV (B2, exact event-for-event match); on-device
  fps ≥ the ADR-8 floor on the oldest supported device available `[HUMAN]`.
- **Counter-move:** fixture mismatch → bisect signal-by-signal (calibration
  → ratio → trust → state) against Python intermediates; never "close enough."

### M4 — Live set experience *(skip under F0)*
Screens 3–6: exercise picker, setup gate (refuses to arm per C4), 3-2-1,
live set (2-Meter mono numerals, inline verdicts, untrusted-freeze "hold
on…", IMU "keep the phone still"), set summary. Push-up included only if its
own wargame recorded WIN; otherwise squat-only (condition, not judgment).
- **Check `[HUMAN]`:** perform a real set: shallow reps rejected with the
  verdict shown, deep reps count, walking away pauses, phone-bob pauses;
  reduced-motion setting swaps ceremonies for crossfades.
- **Counter-move:** live behavior diverges from corpus behavior → frames are
  reaching the Verifier different from the harness (resolution/rotation/fps);
  fix capture normalization, never retune thresholds live.

### M5 — Monetization & polish
Paywall per SUB (placements, decline paths, trial trigger conjunction,
restore), lapse behavior (badge kept, breadth re-locks), Settings/privacy
screen (C6 statement), onboarding, rank-promotion ceremony (Glow Is a Verb;
reduced-motion path), full banned-term sweep, `/impeccable critique` pass on
Home, Live set, and Profile with P0/P1 findings fixed.
- **Check `[HUMAN]`:** sandbox purchase + restore + lapse each behave per
  SUB §3.6/§4; paywall never appears on the Step 3.4 negative list moments
  (scripted walkthrough of all four); critique P0s = 0.
- **Counter-move:** any paywall appears on a negative-list moment → that's a
  build bug against a testable rule; fix, re-walk the script.

## Fork triggers
- **F0:** kill test LOSS → GPS-only build (defined in R0).
- **F1:** M3 fps floor unreachable on ADR-8's device floor → raise the floor
  one device generation, amend ADR-8, note the market-size consequence; do
  NOT degrade the Verifier (dropping lie detectors to gain fps is forbidden —
  they're the product's honesty).

## Abort conditions
- **A1:** M3 fixture parity unachievable after signal-by-signal bisection —
  the port strategy itself is flawed; halt, report the diverging signal.
- **A2:** Any milestone check requires violating a SPEC C-constraint to pass.
  Halt, name the collision.

## Verification runs (campaign-level, after M5)
- **V1:** Re-run every milestone check top to bottom on a clean install.
- **V2:** The SUB wall-test journeys J1–J6 executed on-device `[HUMAN]`
  against the build; all six must pass as specified.
- **V3:** Full-app banned-term + DESIGN.md-named-rule sweep (grep UI strings
  + screenshot review): zero banned terms, no purple, no unearned ember.

## Red-team pass
1. **Weakest assumption:** live camera frames ≈ corpus video frames. M4's
   counter-move exists precisely because they won't be (rotation, resolution,
   dropped frames). *Fix:* capture normalization is its own named fix target;
   threshold retuning against live vibes is explicitly forbidden.
2. **Likely screw-up:** milestone bleed — starting M4 UI while M3 fixtures
   fail. *Fix:* B1 is absolute; each milestone's check is the gate.
3. **Economy drift:** hand-tweaking XP values during build "because it feels
   slow." *Fix:* M2's check pins the build to SPEC §3.4's table; changes go
   through the spec, not the code.
4. **F0 morale trap:** GPS-only mode could quietly die instead of shipping.
   *Fix:* F0 explicitly keeps M0–M2+M5 as a complete shippable campaign; M1
   is designed to be a full product alone.
5. **Polish becomes rebuild:** M5's impeccable pass could balloon. *Fix:*
   scope is P0/P1 findings on three named screens only; the rest is post-v1.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
