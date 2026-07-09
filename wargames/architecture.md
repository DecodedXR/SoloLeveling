# Wargame: Tech Stack & Architecture (iOS v1)

**Mission:** Produce the architecture decision record (ADR) set for the iOS v1
build: pose backend, UI framework, event-log storage, activity/steps source,
sync, subscription infra, minimum iOS version, and the port strategy for the
kill-test state machine. Every decision made by criteria table, not taste.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** any model with
`WebSearch`/`WebFetch` (needed to check current SDK realities).

**Deliverable:** `wargames/output/architecture-adr.md`, section structure in Step 6.

## Input files (read all before Step 1)

- **ENG** = `wargames/workout-tracker-verification.md` — the pipeline being
  ported (calibration, ratio state machine, lie detectors, §6 architecture calls).
- **SPEC** = `wargames/output/product-spec.md` — constraints C5 (append-only
  event log, pure pricing fold), C6 (on-device, sync events never video),
  C7 (GPS pace plausibility), C11 (IMU check); screen map (§4).
- **SUB** = `wargames/output/features-subscription-spec.md` — tiers/prices
  (StoreKit surface), lapse policy (entitlement behavior).

## Recon flags (check before Step 1)

- **R1:** The three input files are readable. Missing → halt.
- **R2:** WebSearch returns live results for `MediaPipe pose landmarker iOS 2026`.
  No web → halt (A0): SDK facts from memory go stale fast.
- **R3:** Confirm via search that BOTH candidate pose backends still exist and
  run on-device: MediaPipe Tasks PoseLandmarker for iOS, and Apple Vision body
  pose (`VNDetectHumanBodyPoseRequest` / newer equivalent). Record versions/dates.

## Binding rules

- **B1:** On-device everything; events sync, never video (SPEC C6). Any option
  requiring server-side inference is disqualified at the criteria stage.
- **B2:** The verification state machine ports as a **pure function** (frames of
  normalized signals in → events out), identical logic to the kill-test Python,
  so corpus results remain the spec. Any architecture that entangles the state
  machine with UI or camera APIs fails this rule.
- **B3:** Prefer the platform-native option when it meets requirements at parity
  (fewer deps, smaller binary); third-party wins only on a named, cited capability gap.
- **B4:** Event log is append-only; XP/stats/ranks are folds over it (SPEC C5).
  Storage choice must make "re-fold the log" cheap and migration-free.

## Battle plan

### Step 1 — Decision list & criteria
Fix the ADR list: ADR-1 pose backend · ADR-2 UI framework · ADR-3 camera
capture pipeline · ADR-4 event-log storage · ADR-5 steps/run source ·
ADR-6 sync strategy (v1) · ADR-7 subscription infra · ADR-8 min iOS version /
device floor · ADR-9 state-machine port strategy. For each, write the criteria
up front (requirements from ENG/SPEC, e.g. ADR-1 needs: hips/knees/ankles
landmarks + per-landmark confidence + ≥30fps on-device on a mid-range iPhone).
- **Expected observation:** 9 ADRs listed, each with ≥3 checkable criteria
  citing a source constraint.
- **Counter-move:** a criterion can't be traced → drop it (invented requirement).

### Step 2 — Research the volatile facts (web)
For ADR-1 (the only genuinely uncertain one) and any ADR where R3-style drift
is plausible: search current docs for MediaPipe iOS pose (landmark set, fps,
delegate/GPU support, binary size) vs Apple Vision body pose (landmark set —
does it include hips/knees/ankles with confidence? 2D vs 3D, fps, min iOS).
Also confirm StoreKit 2 current API generation and CloudKit/HealthKit basics.
Every fact gets a URL + access date.
- **Expected observation:** a fact table for ADR-1 with ≥6 cited rows; no
  cited fact older than 2024 unless marked.
- **Counter-move:** docs unfetchable → mark `(snippet-only)` and keep the
  claim only if two independent snippets agree; otherwise list as unknown and
  carry it into the ADR as an explicit spike task.

### Step 3 — Write the ADRs
Each ADR: context (2–3 lines) → options (≥2) → criteria table (options ×
criteria, pass/fail/notes) → decision → consequences (≥2, incl. one risk).
Decisions follow B1–B4 mechanically; where the criteria table ties, B3 breaks
the tie toward native.
Expected shape (executor verifies, not assumes): ADR-2 SwiftUI; ADR-3
AVFoundation capture feeding the pose backend, IMU via CoreMotion (SPEC C11);
ADR-4 SQLite (GRDB) or equivalent single-file append-only table — criteria:
append-only ergonomics, fold speed over ~100k events, migration-free
repricing (B4); ADR-5 HealthKit/CMPedometer for steps + CoreLocation for
runs with the pace-plausibility check (SPEC C7); ADR-6 v1 = local-first with
iCloud/CloudKit event sync or explicitly "no sync in v1" — decided by
criteria (cost, account-less operation), not assumed; ADR-7 StoreKit 2;
ADR-8 the floor that keeps the chosen pose backend ≥30fps per Step 2 facts.
- **Expected observation:** 9 ADRs, every decision's winning row actually
  passes all its criteria; ADR-1's decision cites Step 2 facts, not memory.
- **Counter-move:** no option passes all criteria for an ADR → the criteria
  over-constrain; relax the *least-sourced* criterion first, document the
  relaxation, re-run the table.
- **Fork F1 (pose backend):** if Step 2 shows Apple Vision provides
  hips/knees/ankles with confidence at ≥30fps on the device floor →
  choose Vision (B3). If it lacks landmarks/confidence or fps → MediaPipe.
  If evidence is genuinely conflicting → decision becomes "spike: benchmark
  both on-device for one day," written as ADR-1's decision with exit criteria.

### Step 4 — Module map & seams
One diagram-as-text: Capture (camera/IMU/GPS) → Signals (normalization,
calibration, lie detectors) → **Verifier (pure state machines, ported 1:1
from kill test)** → Event Log (append-only) → Ledger (pure XP fold) → UI.
For each seam: the data crossing it (typed, one line) and the test double
used to test each side alone. State explicitly: Verifier has zero imports
from UI/camera frameworks (B2); the Python corpus harness remains the
reference implementation, and the port must reproduce corpus outputs.
- **Expected observation:** every SPEC §4 screen maps onto modules; the
  Verifier's inputs are exactly the normalized signals ENG defines (hip-drop
  ratio, trust flags), nothing rawer.
- **Counter-move:** a screen needs data no module produces → add the seam,
  don't let UI reach around the pipeline.

### Step 5 — Risk register
≥5 risks with trigger + mitigation, mandatorily including: pose-backend fps
on old devices (ties to ADR-8), MediaPipe binary-size/App-Store thinning if
chosen, background-time limits for run tracking, HealthKit permission
denial fallback, port-divergence between Python reference and Swift Verifier
(mitigation: shared corpus fixture tests — corpus CSVs checked into the repo,
Swift tests must match Python outputs exactly).
- **Expected observation:** ≥5 risks, each with a named trigger signal.
- **Counter-move:** none; if a mandatory risk seems inapplicable, say why
  rather than omitting.

### Step 6 — Assemble
Write `wargames/output/architecture-adr.md`: `## 1. Decision list & criteria`
· `## 2. Fact table (ADR-1)` · `## 3. ADRs 1–9` · `## 4. Module map & seams`
· `## 5. Risk register` · `## 6. Open questions` (≥2, incl. any spike) ·
`## Sources` (URLs + access dates).
- **Expected observation:** all 7 sections non-empty; every ADR decision
  traceable to criteria; sources dated.
- **Counter-move:** unfillable section → owning step's counter-move skipped; go back.

## Abort conditions

- **A0:** No web access (R2). SDK decisions from memory are stale — halt.
- **A1:** Step 2 shows NEITHER pose backend can deliver the ENG landmark set
  with confidence on-device at usable fps. The platform assumption under the
  whole product is wrong — halt, report evidence (this would also invalidate
  the kill-test plan's R1).
- **A2:** Any B-rule collision that criteria relaxation can't resolve without
  violating SPEC constraints (e.g. sync requires uploading video). Halt, name it.

## Verification runs

- **V1 — criteria audit:** for 3 ADRs chosen by rule (ADR-1, ADR-4, ADR-8),
  re-check that the winning option passes every criterion using only the
  fact table/sources in the artifact. A decision resting on an uncited fact fails.
- **V2 — constraint sweep:** search the artifact for violations of B1/B2/B4:
  any server inference, any Verifier→UI import, any storage design requiring
  migration to reprice XP. Zero hits.
- **V3 — citation spot-check:** re-fetch 3 of the Step 2 URLs (every 2nd);
  each must still support its fact-table row. 403/404 → mark `(snippet-only)`
  and confirm via a second source or downgrade the dependent decision to a spike.

## Red-team pass

1. **Weakest assumption:** Apple Vision's landmark/confidence story — memory
   says it lacks per-joint confidence granularity MediaPipe has; if the
   executor trusts memory either way, ADR-1 is fiction. *Fix:* Step 2 makes
   ADR-1 fact-table-only; F1's conditions are stated on the facts; V1 audits it.
2. **Most likely screw-up:** skipping the criteria tables and writing essay-
   style "we chose X because it's modern." *Fix:* V1 fails any decision whose
   winning row doesn't pass all criteria; the table format is mandatory.
3. **Port divergence is the silent killer:** a Swift re-implementation that's
   "basically the same" as the Python reference will drift at edge cases the
   corpus was built to catch. *Fix:* Step 4/5 mandate corpus fixture tests as
   the port's acceptance criterion — the corpus, not code review, is the referee.
4. **Over-architecting:** 9 ADRs could balloon into microservice fantasy.
   *Fix:* B3 (native at parity) + the module map is one pipeline, six modules,
   no more; anything beyond the listed ADRs is out of scope by construction.
5. **Spike dodge:** F1's "benchmark both" exit is the executor's escape hatch
   from deciding. *Fix:* F1 allows it only on *conflicting evidence*, and the
   spike ADR must include exit criteria (fps threshold, landmark checklist)
   so the spike is a decision procedure, not a deferral.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
