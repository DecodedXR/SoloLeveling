# Architecture Decision Records — Verified-XP Fitness Leveler (iOS v1)

Derived from ENG (`wargames/workout-tracker-verification.md`), SPEC
(`wargames/output/product-spec.md`), SUB
(`wargames/output/features-subscription-spec.md`). Executed against the wargame
plan `wargames/architecture.md`.

**Date:** 2026-07-09 · **Executor:** Claude Opus 4.8

**Recon:** R1 pass (ENG/SPEC/SUB all readable). R2 pass (WebSearch returned live
results for `MediaPipe pose landmarker iOS 2026`). R3 pass — BOTH candidate pose
backends exist and run on-device: MediaPipe Tasks PoseLandmarker for iOS
(`MediaPipeTasksVision`, 33 landmarks, LIVE_STREAM mode) and Apple Vision
`VNDetectHumanBodyPoseRequest` (19 joints, 2D, per-joint confidence, iOS 14+).
No abort tripped (A0/A1/A2 all clear — see §3 ADR-1 and §6).

**Binding rules carried:** B1 (on-device; events sync, never video —
server-side inference is disqualified at criteria). B2 (Verifier ports as a pure
function, no UI/camera imports). B3 (native option wins at parity; third-party
only on a named cited capability gap). B4 (append-only log; XP is a fold;
storage must make re-fold cheap and migration-free).

---

## 1. Decision list & criteria

Nine ADRs. Each criterion cites a source constraint (ENG §, SPEC C#, SUB §).
Untraceable criteria were dropped per Step 1 counter-move (none needed).

| ADR | Decision area | Criteria (each cites a source) |
|---|---|---|
| **ADR-1** | Pose backend | (a) returns hips + knees + ankles landmarks (ENG §1 hip-drop ratio, §4 cycle); (b) per-landmark confidence to drive lie detectors (ENG §3 untrusted-frame hold, C9); (c) ≥30fps on-device on the mid-range floor (ENG §5 "15fps + fast reps = aliasing"; R3); (d) fully on-device, no server inference (B1, SPEC C6); (e) near side-leg usable in side view (ENG §3 far-leg occlusion) |
| **ADR-2** | UI framework | (a) native, first-party, no added dep (B3); (b) can host a live camera preview layer (SPEC §4 scr.5); (c) reactive per-rep verdict + freeze states (SPEC §4 scr.5, C3/C9); (d) declarative screen map for 12 screens (SPEC §4) |
| **ADR-3** | Camera capture pipeline | (a) per-frame buffers to the pose backend at ≥30fps (ENG §5); (b) camera-plane setup control for the gate (ENG §3, C4); (c) concurrent IMU access for the still-phone check (SPEC C11); (d) on-device only, no upload (C6) |
| **ADR-4** | Event-log storage | (a) append-only ergonomics, never mutate history (SPEC C5, SUB F9); (b) fold speed over ~100k events (B4); (c) migration-free repricing = re-fold (B4, C5); (d) on-device, single-file, offline (C6) |
| **ADR-5** | Steps/run source | (a) step count without GPS fix (SPEC §3.1 F4); (b) GPS distance/pace for runs (SPEC §2.2, C7); (c) pace-plausibility to reject bike/drive (SPEC C7, ENG §6); (d) degrades if permission denied (SUB J6, risk) |
| **ADR-6** | Sync strategy (v1) | (a) zero server cost (ENG §6, C6); (b) account-less operation — app has no login (SUB tiers, no account system); (c) offline-first (C6); (d) re-fold/migration-free (B4) |
| **ADR-7** | Subscription infra | (a) current-generation StoreKit API (SUB §3); (b) on-device entitlement check, no server (B1, C6); (c) auto-renewable sub + entitlement gating (SUB §3.1/§3.6); (d) restore/lapse handling (SUB J5, §3.6) |
| **ADR-8** | Min iOS / device floor | (a) floor keeps ADR-1 backend ≥30fps (ENG §5; Step 2 facts); (b) supports ADR-1/2/7 minimum OS (Vision iOS 14, StoreKit 2 iOS 15, mature SwiftUI iOS 16); (c) ANE headroom for pose + camera + IMU concurrently (C11) |
| **ADR-9** | State-machine port strategy | (a) pure function: normalized signals in → events out (B2); (b) zero imports from UI/camera/pose frameworks (B2); (c) reproduces the Python corpus outputs exactly (ENG §5, red-team #3) |

---

## 2. Fact table (ADR-1) — the only genuinely uncertain decision

All facts web-verified 2026-07-09. F1's decision rests **exclusively** on this
table, never on memory of the SDKs (red-team #1). No cited fact older than 2024
except where marked with its original date (BlazePose model card, 2021 — marked).

| # | Fact | MediaPipe Tasks PoseLandmarker (iOS) | Apple Vision `VNDetectHumanBodyPoseRequest` (2D) | Source + access date |
|---|---|---|---|---|
| 1 | Landmark set incl. hips/knees/ankles | **Yes** — 33 landmarks incl. hips, knees, ankles | **Yes** — 19 named joints incl. hips, knees, ankles | MP iOS guide; Kamil Tustanowski (Vision), 2026-07-09 |
| 2 | Per-landmark confidence | **Yes** — `visibility` + `presence` + x/y/z per landmark | **Yes** — a confidence value per point (filter e.g. >0.1) | MP iOS guide; Vision search snippet + Tustanowski (2 independent), 2026-07-09 |
| 3 | 2D vs 3D | 2D image coords **+** low-quality 3D world z (ENG §3 says the z is low-quality) | **2D** only (x/y CGPoint); separate `VNDetectHumanBodyPose3DRequest` is single-image, **not** real-time | MP iOS guide; WWDC23 111241; Tustanowski, 2026-07-09 |
| 4 | On-device / no server | **Yes** — runs locally via MediaPipeTasksVision | **Yes** — first-party on-device (Neural Engine), no server | MP iOS guide; Apple Vision docs, 2026-07-09 |
| 5 | Real-time / live mode | **Yes** — `LIVE_STREAM` mode; tracking reduces per-frame latency | **Yes** — introduced WWDC20 "Detect Body and Hand Pose"; Action & Vision app demoed real-time fitness body pose (exact fps figure snippet-only) | MP iOS guide; WWDC20 10653 / 10099, 2026-07-09 |
| 6 | Benchmarked fps (on-device GPU/ANE) | Lite ~31 fps, Full ~40 fps (TFLite GPU, Pixel 3); Heavy ~19 fps GPU *(BlazePose model card, dated 2021)* | ANE-accelerated real-time; no published fps figure — **(snippet-only)**, confirm on device floor per ADR-8 exit criterion | BlazePose GHUM model card (2021); WWDC20 10653, 2026-07-09 |
| 7 | GPU/HW acceleration | Metal GPU delegate on iOS | Neural Engine (ANE) / GPU, automatic | MP search results; WWDC20 10653, 2026-07-09 |
| 8 | Binary/model footprint | Bundled model: Lite 3 MB / Full 6 MB / Heavy 26 MB *(2021 card)* + MediaPipeTasksVision framework | **Zero** added binary — ships in the OS | BlazePose model card (2021); Apple Vision docs, 2026-07-09 |
| 9 | Dependency / maturity | Third-party CocoaPod; "Solutions Preview is an early release … still preview status as of 2026" | First-party, GA since iOS 14 (stable ≥5 yrs) | MP iOS guide; Vision docs, 2026-07-09 |
| 10 | Min iOS | Per MediaPipe iOS setup (recent Xcode/iOS) | **iOS 14** (2D body pose); iOS 17 (3D) | MP iOS guide; Tustanowski; WWDC23, 2026-07-09 |

**Infra facts (ADR-4/5/6/7) — web-verified 2026-07-09:**

| Fact | Finding | Source + date |
|---|---|---|
| StoreKit 2 is current API generation | `Product.products`, `Transaction.currentEntitlements`, Swift concurrency, JWS-signed transactions; still current + extended at WWDC25 (iOS 26 `SubscriptionOfferView`) | Apple StoreKit; DEV WWDC25 recap, 2026-07-09 |
| CloudKit private DB | Requires an active iCloud account; uses the **user's** iCloud quota (not developer); free sync within generous limits; queues offline | Apple CloudKit docs; fatbobman; hackingwithswift, 2026-07-09 |
| CMPedometer | Step count + cadence + distance from the motion coprocessor; 7 days history; no GPS needed; `NSMotionUsageDescription` required | DevFright; Simform, 2026-07-09 |
| HealthKit background delivery | Background delivery is fragile (observer callbacks can stop when detached) — a reason to prefer CMPedometer/CoreLocation live over HealthKit background for the active-session path | Apple forums (HealthKit), 2026-07-09 |
| CoreLocation + fitness | CoreLocation + HealthKit combine for run tracking; CoreLocation gives live pace/distance for the plausibility check | AppCoda; WWDC20 10656, 2026-07-09 |

---

## 3. ADRs 1–9

### ADR-1 — Pose backend: **Apple Vision `VNDetectHumanBodyPoseRequest` (2D)**

**Context.** The vision path needs hip/knee/ankle positions with confidence to
run the ENG hip-drop-ratio state machine and its lie detectors. Fully on-device
(B1/C6). This is the one volatile decision — decided by the §2 fact table only.

**Options.** (A) Apple Vision 2D body pose; (B) MediaPipe Tasks PoseLandmarker.

| Criterion (source) | A: Vision 2D | B: MediaPipe | Notes |
|---|---|---|---|
| (a) hips/knees/ankles (ENG §1/§4) | **Pass** (fact 1) | Pass (fact 1) | both include the leg chain |
| (b) per-landmark confidence (ENG §3, C9) | **Pass** (fact 2) | Pass (fact 2) | Vision: confidence/point; MP: visibility+presence |
| (c) ≥30fps on floor device (ENG §5) | **Pass** — ANE real-time (facts 5,7); exact fps snippet-only → ADR-8 exit criterion | Pass — Lite ~31fps GPU (fact 6) | neither has a floor-device number; both are real-time-designed |
| (d) on-device, no server (B1/C6) | **Pass** (fact 4) | Pass (fact 4) | |
| (e) near-leg usable side view (ENG §3) | **Pass** — 2D per-joint, use near leg | Pass | 2D is sufficient; ENG's primary signal is hip-height **ratio**, robust to yaw |

**Decision.** **Apple Vision 2D.** The table ties on every functional criterion
(a–e); **B3 breaks the tie toward native.** Vision adds **zero binary** (fact 8)
vs MediaPipe's 3–26 MB model + CocoaPod, is **GA/stable since iOS 14** vs
MediaPipe's self-described **"preview status as of 2026"** (fact 9), and needs
no third-party dependency. MediaPipe could only win on a *named, cited capability
gap* (B3): its extras are 33 landmarks and a 3D world-z — but ENG needs neither
(it uses hip-**height ratio**, and §3 calls MediaPipe's world-z "low-quality").
No gap ENG requires → native wins.

**Fork F1 resolution.** F1 clause 1 fires: Step 2 shows Vision **does** provide
hips/knees/ankles **with per-joint confidence** at real-time on-device → choose
Vision (B3). The red-team's "weakest assumption" (memory says Vision lacks
per-joint confidence) is **falsified by fact 2 (two independent sources)**. The
spike path (F1 clause 3) does **not** fire — evidence is not conflicting; the
only soft point is an exact fps figure (fact 6, snippet-only), which is a
measurement to confirm on the floor device (ADR-8 exit criterion), not a
landmark/confidence gap. A1 not tripped — a backend delivers the set at usable fps.

**Consequences.** (1) Zero pose-model binary, no App-Store thinning concern,
no preview-SDK churn risk. (2) **Risk:** the exact on-device fps on the floor
device is snippet-only — must be measured (ties to ADR-8; risk register R1).
(3) If a future exercise needs a joint Vision's 19 lacks or true 3D at video
rate, revisit (Vision 3D is single-image today, fact 3).

---

### ADR-2 — UI framework: **SwiftUI**

**Context.** 12 screens (SPEC §4), reactive per-rep verdict + freeze states
(C3/C9), one live camera screen.

**Options.** (A) SwiftUI; (B) UIKit.

| Criterion (source) | A: SwiftUI | B: UIKit |
|---|---|---|
| (a) native, no dep (B3) | Pass | Pass |
| (b) hosts camera preview (§4 scr.5) | Pass — `AVCaptureVideoPreviewLayer` via `UIViewRepresentable` | Pass — native |
| (c) reactive verdict/freeze (C3/C9) | **Pass** — `@Observable` state drives inline states | Pass — manual |
| (d) declarative 12-screen map (§4) | **Pass** — less boilerplate | Pass — more |

**Decision.** **SwiftUI**, with a thin `UIViewRepresentable` wrapper for the
`AVCaptureVideoPreviewLayer` on the live-set screen. Both are native (B3 neutral);
SwiftUI wins on reactive state ergonomics for the verdict/freeze UX (c) and the
declarative screen map (d).

**Consequences.** (1) Camera preview needs one interop wrapper (small, known).
(2) **Risk:** the live-set screen mixes SwiftUI + AVCapture; keep pose overlay
rendering off the main thread to protect fps (ties to ADR-8).

---

### ADR-3 — Camera capture pipeline: **AVFoundation (`AVCaptureSession`) → Vision; IMU via CoreMotion**

**Context.** Feed per-frame buffers to ADR-1 at ≥30fps; provide the setup-gate
control (C4); read the IMU concurrently for the still-phone check (C11).

**Options.** (A) AVFoundation `AVCaptureSession` + `AVCaptureVideoDataOutput`;
(B) higher-level `VNVideoProcessor`/ARKit.

| Criterion (source) | A: AVFoundation | B: ARKit/other |
|---|---|---|
| (a) ≥30fps frame buffers (ENG §5) | Pass — direct `CMSampleBuffer` | Pass, heavier |
| (b) camera-plane control for gate (C4) | **Pass** — full session config | Partial — ARKit constrains |
| (c) concurrent IMU (C11) | Pass — CoreMotion `CMMotionManager` in parallel | ARKit fuses motion, less direct |
| (d) on-device, no upload (C6) | Pass | Pass |

**Decision.** **AVFoundation** capture (`AVCaptureVideoDataOutput`,
`.builtInWideAngleCamera`) delivering `CMSampleBuffer` frames straight into the
Vision request handler; **CoreMotion `CMMotionManager`** reads accelerometer
variance in parallel for the C11 still-phone check. B3: both native; AVFoundation
is the lower-level, lighter, more controllable path and ARKit's scene machinery
is unneeded overhead for a fixed-camera fitness setup.

**Consequences.** (1) The setup gate (C4) is enforced here (full body in frame,
trusted landmarks, ~1s stability) before arming. (2) **Risk:** frame format /
orientation must match Vision's expected input; a mismatch silently inverts the
signal (ENG red-team #2 analog) — covered by ADR-9 corpus tests + a capture smoke test.

---

### ADR-4 — Event-log storage: **SQLite via GRDB (single-file append-only table)**

**Context.** Append-only event log; XP/levels/ranks/stats are pure folds (C5,
B4); ~100k events over a heavy user's history; on-device, offline (C6).

**Options.** (A) SQLite via GRDB; (B) Core Data; (C) flat JSON/NDJSON file.

| Criterion (source) | A: GRDB/SQLite | B: Core Data | C: JSON file |
|---|---|---|---|
| (a) append-only, never mutate (C5) | **Pass** — INSERT-only table | Partial — ORM invites mutation | Pass |
| (b) fold speed ~100k events (B4) | **Pass** — indexed scan, fast | Partial — object hydration cost | Fail — full parse each fold |
| (c) migration-free repricing (B4) | **Pass** — re-fold rows, schema stable | Fail — model versioning/migrations | Pass |
| (d) single-file, offline (C6) | Pass | Pass | Pass |

**Decision.** **SQLite via GRDB**, one append-only `events` table
(`id, session_id, source, task, evidence_json, ts`). XP is a pure fold in
application code; repricing re-runs the fold, never migrates data (B4). Core Data
fails (b)/(c) — its migration model is exactly the "repricing = migration" trap
B4 forbids. Raw JSON fails (b) at 100k events. GRDB is a small, well-worn
dependency (B3: no native equivalent gives indexed folds; SQLite ships in iOS,
GRDB is the thin idiomatic wrapper).

**Consequences.** (1) Re-fold is cheap and total — retuning XP prices needs zero
migration. (2) Append-only + monotonic `session_id` also delivers ENG §2's
replay-attack defense for free. (3) **Risk:** an accidental UPDATE/DELETE would
break the audit; enforce via a repository API that only exposes INSERT + read.

---

### ADR-5 — Steps/run source: **CMPedometer (steps) + CoreLocation (runs), HealthKit optional-read only**

**Context.** Steps without a GPS fix (F4); GPS distance/pace for runs with the
pace-plausibility check (C7); degrade on permission denial (SUB J6).

**Options.** (A) CMPedometer + CoreLocation direct; (B) HealthKit as the primary
source.

| Criterion (source) | A: CMPedometer + CoreLocation | B: HealthKit primary |
|---|---|---|
| (a) steps w/o GPS (F4) | **Pass** — CMPedometer motion coprocessor | Pass, but background delivery is fragile |
| (b) live GPS pace/distance (C7) | **Pass** — CoreLocation live | Partial — HK is a store, not live feed |
| (c) plausibility check (C7) | **Pass** — live pace vs cap in-session | Weaker — post-hoc |
| (d) degrade on denial (J6) | Pass — GPS-less step path still runs | Pass |

**Decision.** **CMPedometer** for steps (priced to the distance line, F4) +
**CoreLocation** for live run pace/distance feeding the pace-plausibility check
(C7). **HealthKit is optional-read only** (import existing workouts if the user
grants it), never the active-session source — its background delivery is fragile
(fact table) and it is a store, not a live feed. B3: all native.

**Consequences.** (1) The plausibility check runs live on CoreLocation pace,
matching IMU-rigor parity on the vision path (C7). (2) **Risk:** background run
tracking hits iOS background-execution limits — needs the location background
mode + graceful pause (risk register R3). (3) Motion-permission denial disables
steps but the GPS run path (and the whole GPS/step loop, SUB J6) still works.

---

### ADR-6 — Sync strategy (v1): **No cross-device sync in v1 — local-first; append-only log is the sync-ready substrate; CloudKit private-DB event mirror is the named v2 path**

**Context.** C6 mandates on-device, "events sync, never video," zero server
cost. The product has **no account system** (SUB tiers are StoreKit entitlements,
not logins) and is single-user private XP (C1). Decided by criteria, not assumed
(Step 3 explicitly forbids assuming this one).

**Options.** (A) No cross-device sync in v1 (local SQLite only); (B) CloudKit
private-DB event sync; (C) custom backend sync.

| Criterion (source) | A: local-only | B: CloudKit | C: custom server |
|---|---|---|---|
| (a) zero server cost (C6) | **Pass** | Pass — user's iCloud quota | **Fail** — server cost |
| (b) account-less operation (no login) | **Pass** | **Fail** — needs iCloud sign-in | Fail — needs accounts |
| (c) offline-first (C6) | Pass | Pass — queues offline | Partial |
| (d) re-fold/migration-free (B4) | Pass | Pass — mirror the append log | Pass |

**Decision.** **No cross-device sync in v1.** Option C is disqualified at the
criteria stage (B1/C6 — a server violates zero-cost/on-device). Between A and B,
criterion (b) account-less operation is decisive: the app requires no login, and
CloudKit's private DB **requires an active iCloud account** (fact table). B3 +
simplicity: v1 works fully on one device; the append-only event log is already
the perfect sync substrate, so **CloudKit private-DB event mirror is named as the
opt-in v2 path** (mirrors events only — never video, C6 — and degrades gracefully
when iCloud is signed out). No B-rule collision (A2 clear): syncing *events* via
CloudKit would satisfy C6, so nothing forces a video upload.

**Consequences.** (1) Zero sync surface in v1 — no server, no account, no merge
logic to get wrong. (2) **Trade-off/risk:** a user switching phones loses history
in v1 (mitigation: ship the CloudKit event-mirror in v2; the append-only design
makes it a pure add-on, no migration). (3) StoreKit entitlements already sync
across a user's devices via their Apple ID independently of this (ADR-7).

---

### ADR-7 — Subscription infra: **StoreKit 2**

**Context.** Free + auto-renewable Pro (SUB §3); on-device entitlement gating
(B1/C6); restore + lapse handling (SUB §3.6, J5).

**Options.** (A) StoreKit 2; (B) StoreKit 1; (C) third-party (RevenueCat).

| Criterion (source) | A: StoreKit 2 | B: StoreKit 1 | C: RevenueCat |
|---|---|---|---|
| (a) current API generation (SUB §3) | **Pass** — current, extended WWDC25 (fact table) | Legacy | wraps SK2 |
| (b) on-device entitlement, no server (B1/C6) | **Pass** — `Transaction.currentEntitlements`, JWS-verified locally | Needs receipt validation | adds a server dep |
| (c) sub + gating (§3.1/§3.6) | Pass | Pass | Pass |
| (d) restore/lapse (J5) | **Pass** — `Transaction.updates`, `currentEntitlements` | manual | Pass |

**Decision.** **StoreKit 2.** B3: native, current generation, JWS-signed
transactions verified **on-device** (no server receipt validation — satisfies
C6/B1). RevenueCat adds a third-party server dependency for what
`Transaction.currentEntitlements` does locally — no capability gap justifies it
(B3). Entitlement gating maps directly to SUB's breadth-only Pro model.

**Consequences.** (1) No subscription server to run (matches ADR-6's zero-server
posture). (2) Lapse handling (SUB §3.6 — earned progression kept, breadth
re-locks) is a pure entitlement check over the local event log; no clawback logic
touches the log (C5). (3) **Risk:** on-device-only verification is acceptable for
private XP (no server-side value at stake, ENG §2) — revisit if XP ever becomes
competitive/redeemable (the ENG §2 product fork).

---

### ADR-8 — Min iOS / device floor: **iOS 16 minimum; device floor iPhone 11 (A13, 2019)**

**Context.** The floor must keep ADR-1 (Vision) ≥30fps while AVFoundation capture
(ADR-3) and CoreMotion (C11) run concurrently, and satisfy the minimum OS of
ADR-1/2/7.

**Options.** (A) iOS 15 / iPhone XS (A12); (B) iOS 16 / iPhone 11 (A13);
(C) iOS 17 / iPhone 12 (A14).

| Criterion (source) | A: iOS15/A12 | B: iOS16/A11→A13 | C: iOS17/A14 |
|---|---|---|---|
| (a) Vision ≥30fps headroom (ENG §5; facts 5–7) | Tight | **Pass** — A13 ANE headroom | Pass, excludes more users |
| (b) meets ADR-1/2/7 min OS (Vision iOS14, SK2 iOS15, SwiftUI-mature iOS16) | Partial — SwiftUI less mature | **Pass** — all satisfied | Pass |
| (c) ANE for pose+camera+IMU concurrently (C11) | A12 ANE, tighter | **Pass** — A13 | Pass |

**Decision.** **iOS 16 minimum, device floor iPhone 11 (A13).** iOS 16 clears
every dependency's minimum with mature SwiftUI; A13 gives Neural-Engine headroom
to run Vision body pose + AVCapture + CoreMotion together at ≥30fps. iOS 15/A12
is workable but tight on SwiftUI maturity and ANE headroom; iOS 17 needlessly
sheds users.

**Exit criterion (from ADR-1 fact 6, snippet-only fps).** Before locking the
floor, **measure Vision `VNDetectHumanBodyPoseRequest` fps on an iPhone 11**
running the live AVCapture + IMU pipeline. Pass = **sustained ≥30fps** with the
full leg-joint set trusted. If the A13 misses ≥30fps, raise the floor to
iOS 17/iPhone 12 (A14); if even A14 misses, that is a Step 2 fps re-open, not an
ADR-1 reversal (Vision still uniquely wins landmarks+confidence+native).

**Consequences.** (1) Covers the large majority of active 2026 iPhones. (2)
**Risk:** old-device fps is the top technical risk (register R1); the exit
criterion is the gate. (3) The floor is a fps decision, not a feature decision —
re-derivable from a benchmark.

---

### ADR-9 — State-machine port strategy: **pure Swift value module, corpus-validated, zero framework imports**

**Context.** The kill-test verification state machine (ENG §1/§3/§4) must port to
Swift **as a pure function** — frames of normalized signals in → events out —
with logic identical to the Python reference so the corpus results remain the
spec (B2).

**Options.** (A) Pure Swift `struct`/`enum` value module, no framework imports;
(B) state machine embedded in the SwiftUI view model / camera controller.

| Criterion (source) | A: pure module | B: embedded in UI/camera |
|---|---|---|
| (a) signals in → events out (B2) | **Pass** — pure function over a signal frame | Fail — entangled with capture |
| (b) zero UI/camera/pose imports (B2) | **Pass** — imports only Foundation | **Fail** — imports AVFoundation/SwiftUI |
| (c) reproduces Python corpus (ENG §5) | **Pass** — same inputs → same events, testable headless | Fail — can't run corpus headless |

**Decision.** **Pure Swift value module** (`Verifier`): input is a
`SignalFrame` (normalized hip-drop ratio, per-joint trust flags, timestamp);
output is `[RepEvent]`. It imports **only Foundation** — no UIKit, SwiftUI,
AVFoundation, Vision, or CoreMotion (B2). Option B is disqualified by B2 directly.
The Python corpus harness remains the reference implementation; the Swift port's
**acceptance criterion is byte-for-byte agreement with the Python outputs on the
checked-in corpus CSVs** (ENG §5, red-team #3).

**Consequences.** (1) The Verifier is unit-testable headless against corpus
fixtures with no simulator/camera. (2) Normalization + lie detectors (bone-length,
teleport, L/R coherence) live in the **Signals** layer *before* the Verifier, so
the Verifier only ever sees normalized ratios + trust flags (ENG §3, module map
§4). (3) **Risk:** silent port divergence at edge cases (register R5) — mitigated
only by the shared corpus fixture tests, not code review.

---

## 4. Module map & seams

One pipeline, six modules. The Verifier is the ported kill-test core and has
**zero imports** from UI/camera/pose frameworks (B2). Every SPEC §4 screen maps
onto these modules (below).

```
 ┌───────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌────────┐   ┌──────┐
 │  Capture  │──▶│ Signals  │──▶│ Verifier │──▶│ EventLog │──▶│ Ledger │──▶│  UI  │
 │ AVFound.  │   │ normalize│   │  PURE    │   │ append-  │   │ pure XP│   │SwiftUI│
 │ CoreMotion│   │ calibrate│   │  state   │   │ only     │   │  fold  │   │       │
 │ CoreLoc.  │   │ lie-detct│   │ machines │   │ GRDB     │   │        │   │       │
 └───────────┘   └──────────┘   └──────────┘   └──────────┘   └────────┘   └──────┘
   Vision pose      (ENG §1/§3)   (ported 1:1     (C5/B4)      (C5 pure fn)  (C3/C9)
   feeds Signals                  from Python)
```

**Seams — data crossing (typed, one line) + the test double for each side:**

| Seam | Data crossing (typed) | Test double |
|---|---|---|
| Capture → Signals | `PoseFrame { landmarks:[Joint(x,y,confidence)], imuVariance:Double, ts }` | feed recorded `PoseFrame` fixtures (no camera) / stub Signals with a canned frame |
| Signals → Verifier | `SignalFrame { hipDropRatio:Double, trusted:Bool, ts }` — **exactly the ENG signals, nothing rawer** | corpus CSV rows → `SignalFrame` (drives Verifier headless) / stub Signals output |
| Verifier → EventLog | `RepEvent { source, task, evidence:{minRatio, repTimestamps}, sessionId, ts }` | in-memory event sink / replay a fixed event list into the log |
| EventLog → Ledger | `[Event]` (append-only rows) | seed a known event set, assert the fold |
| Ledger → UI | `LedgerState { xp, level, rank, strength, endurance }` (pure fold output) | snapshot a `LedgerState`, render SwiftUI previews |
| Capture(IMU) → Signals | `imuVariance:Double` (C11 still-phone) | inject high/low variance to assert pause |
| Capture(GPS) → Signals→Ledger | `RunSummary { distanceKm, pace, plausible:Bool }` (C7) | inject bike-pace to assert rejection |

**Verifier isolation (B2):** the Verifier imports only Foundation; it never sees
raw landmarks, pixels, or `CMSampleBuffer` — only `SignalFrame`. The Python
corpus harness stays the reference; the Swift Verifier must reproduce its outputs
on the checked-in corpus CSVs (ENG §5).

**SPEC §4 screen → module coverage (Step 4 expected observation):**

| Screen (SPEC §4) | Modules it reads |
|---|---|
| 1 Onboarding | UI + Ledger (goal seeds quests) |
| 2 Home/Quest board | Ledger (quests, streak) |
| 3 Exercise picker | UI + StoreKit entitlement (Pro lock) |
| 4 Setup-gate | Capture + Signals (trust/stability) |
| 5 Live set | Capture + Signals + **Verifier** + UI (verdict/freeze C3/C9) |
| 6 Set summary | EventLog + Ledger |
| 7 Run screen | Capture(GPS) + Signals (plausibility C7) |
| 8 Run summary | EventLog + Ledger |
| 9 Profile | Ledger (level/rank/stats) |
| 10 Progression/history | EventLog + Ledger |
| 11 Settings/Privacy | UI (states C6 trust model) |
| 12 Paywall | StoreKit (ADR-7) |

No screen needs data no module produces (Step 4 counter-move not triggered) — the
live-set screen reads Verifier output directly rather than reaching around the
pipeline.

---

## 5. Risk register

All five mandatory risks present, each with a named trigger signal + mitigation.

| # | Risk | Trigger signal | Mitigation |
|---|---|---|---|
| **R1** | **Pose fps on old devices** (ties ADR-8; ADR-1 fact 6 is snippet-only) | Measured Vision fps < 30 on the floor device (iPhone 11) with camera+IMU running | ADR-8 exit criterion: benchmark first; raise floor to A14 if it misses. Cap pose to every-Nth-frame + hold-state on skips before dropping a device |
| **R2** | **MediaPipe binary-size / App-Store thinning** (mandatory "if chosen") | — | **Inapplicable — MediaPipe was NOT chosen** (ADR-1 = Vision, zero added binary, fact 8). Stated per Step 5 counter-move rather than omitted. Would re-apply only if ADR-1 reverses to MediaPipe |
| **R3** | **Background-time limits for run tracking** | iOS suspends the app mid-run; GPS samples stop | CoreLocation background mode + significant-location fallback; pause-and-resume the run; the append-only log tolerates gaps |
| **R4** | **HealthKit / motion permission denial** | User denies motion (CMPedometer) or Health access | Degrade gracefully — GPS run path + full GPS/step loop still work (SUB J6); no feature hard-depends on HealthKit (ADR-5 keeps it optional-read) |
| **R5** | **Port divergence Python ↔ Swift Verifier** | Swift Verifier output differs from Python on any corpus clip | **Shared corpus fixture tests** — corpus CSVs checked into the repo; Swift tests must match Python outputs **exactly** (ADR-9 acceptance criterion). The corpus, not code review, is the referee (red-team #3) |
| R6 | Camera-orientation / signal inversion (ENG red-team #2 analog) | Reps count inverted / not at all in a smoke test | Capture smoke test + the corpus fixtures catch axis/orientation before tuning |

---

## 6. Open questions

1. **Vision on-device fps on the floor device is snippet-only (ADR-1 fact 6).**
   *Spike / exit criterion (ADR-8):* measure `VNDetectHumanBodyPoseRequest`
   sustained fps on an iPhone 11 running live AVCapture + CoreMotion with the full
   leg-joint set trusted. Pass = ≥30fps. *Resolves when:* the benchmark runs and
   the floor is confirmed or raised to A14. (This is the one measurement F1's
   Vision decision defers — it does not reopen the landmark/confidence verdict.)
2. **Vision features are gated on the ENG kill test (SPEC C13).** If the squat
   kill test dies, the entire vision pipeline (ADR-1/3, half of ADR-9) does not
   ship and v1 falls back to the GPS/step loop (SUB J6). *Resolves when:* the ENG
   weekend kill test passes V1–V3 and the friends pass.
3. **CloudKit event-mirror timing (ADR-6 v2 path).** v1 has no cross-device sync;
   history is lost on device switch. *Resolves when:* the CloudKit private-DB
   event mirror is scheduled for v2 (pure add-on over the append-only log, no
   migration).

---

## Sources

All accessed **2026-07-09** (dates in-line where a source predates 2024).

- MediaPipe Pose Landmarker — iOS guide: https://developers.google.com/edge/mediapipe/solutions/vision/pose_landmarker/ios
- MediaPipe Pose Landmarker — overview guide: https://developers.google.com/edge/mediapipe/solutions/vision/pose_landmarker
- BlazePose GHUM 3D model card (dated 2021 — fps/model-size figures): https://storage.googleapis.com/mediapipe-assets/Model%20Card%20BlazePose%20GHUM%203D.pdf
- Apple Vision `VNDetectHumanBodyPoseRequest`: https://developer.apple.com/documentation/vision/vndetecthumanbodyposerequest
- Apple — Detecting Human Body Poses in Images: https://developer.apple.com/documentation/vision/detecting-human-body-poses-in-images
- Vision body pose (19 joints, confidence, 2D, iOS 14) — K. Tustanowski: https://medium.com/@kamil.tustanowski/detecting-body-pose-using-vision-framework-caba5435796a
- WWDC20 "Detect Body and Hand Pose with Vision" (10653): https://developer.apple.com/videos/play/wwdc2020/10653/
- WWDC20 "Explore the Action & Vision app" (10099 — real-time fitness body pose): https://developer.apple.com/videos/play/wwdc2020/10099/
- WWDC23 "Explore 3D body pose and person segmentation in Vision" (111241 — 3D is single-image, 17 joints): https://developer.apple.com/videos/play/wwdc2023/111241/
- StoreKit 2 — Apple Developer: https://developer.apple.com/storekit/
- WWDC25 StoreKit recap (iOS 26 SubscriptionOfferView — SK2 current): https://dev.to/arshtechpro/wwdc-2025-whats-new-in-storekit-and-in-app-purchase-31if
- CloudKit `privateCloudDatabase` (iCloud account required, user quota): https://developer.apple.com/documentation/CloudKit/CKContainer/privateCloudDatabase
- CloudKit sync / CKRecord (free, generous limits) — Hacking with Swift: https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset
- CMPedometer step counting — DevFright: https://www.devfright.com/how-to-use-the-cmpedometer-for-counting-steps/
- HealthKit background-delivery caveat — Apple Developer Forums: https://developer.apple.com/forums/tags/healthkit
- CoreLocation + HealthKit fitness tracking — AppCoda: https://www.appcoda.com/healthkit-introduction/
