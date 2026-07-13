# SoloLeveling - a verified-XP fitness leveler

**The phone camera is the referee.** SoloLeveling is a dark game-HUD fitness app
where you level up from real effort - and only real effort. Pose detection judges
every rep valid or invalid, GPS and step data verify runs and walks, and every
XP point folds from an **append-only log of proven work**. There is no
honor-system XP source anywhere in the product. The promise is literally *"XP you
actually earned."*

> `SoloLeveling` is the internal codename. The shipping product uses its own
> collision-free vocabulary (hunter, rank, quest, gate, ascend) and never any
> franchise-trademarked terms - that ban is a release gate, not a style note.

---

## The idea

Anime-fitness levelers are everywhere, and they all share one flaw: the XP is
fake. You tap a button, you get points, you cheat yourself. SoloLeveling closes
that hole - the only way XP enters the ledger is through a sensor-verified event:

- **Reps (vision).** Start a set, pass the setup gate (full body in frame, all
  leg landmarks trusted, held stable ~1s at a prescribed ~2 m / hip height), then
  a per-rep verdict fires on each completed cycle. A rep counts only on a full
  monotone `STANDING → DESCENDING → (depth met) → ASCENDING → STANDING` cycle.
  Too shallow → *"didn't count."* Bad frames are marked **untrusted** and the
  state machine is forbidden to advance on them - it holds and waits. An IMU
  still-phone check kills the laziest cheat (bobbing the phone).
- **Runs & walks (GPS/steps).** Verified by a pace-plausibility check - the same
  rigor bar as the vision path, matched to the same (casual, private-XP) threat
  model.

Everything runs **on-device**; the app syncs *events, never video* - privacy,
offline capability, and zero server cost fall out of that one rule. Because the
ledger is an append-only event log priced into XP by a **pure function**,
re-tuning the economy is just re-folding the log.

## Progression

- **Ranks E → S**, a quest board with daily quests, and stat panels - the
  dopamine surfaces browsed up close between workouts.
- **Free tier is a complete, forever-playable loop** (reaches rank C, daily
  quests never wall). **Pro is breadth, never the core loop** - more verified
  exercises, higher ranks (B → S), advanced history, and form scoring.
- v1 answers *"did the hip go past the line and back?"* - not *"was the form
  good?"* Form coaching is a deliberately separate, later product.

## Design

A near-black "Forge Ledger" instrument: color is *earned*, not decorative, with
ember gold as the single voice of value - it appears exactly when something was
proven (a verified rep, a filled bar, a rank promotion). Two postures:
distance-legible **instrument** screens during a workout (readable from 2 m,
sweaty, mid-set) and ceremonial **progression** screens between them. WCAG AA is
a gate (≥4.5:1 body text, no color-only signaling), and every ceremony animation
ships a reduced-motion crossfade alternative. Full system in
[`DESIGN.md`](./DESIGN.md).

## Repo layout

```
ios/SoloCore/          Pure Swift package - the deterministic core (no UI, no I/O):
  Sources/SoloCore/      Economy.swift (XP = fold of the event log), Quests.swift,
                         RunPlausibility.swift (GPS pace check), Verifier.swift
  Tests/SoloCoreTests/   Economy / Quests / RunPlausibility + Verifier parity tests
ios/SoloApp/           SwiftUI app - EventStore, screens, DebugScreen, ProStub
extract.py             Vision Step 1 - MediaPipe pose landmarker → per-clip CSV + plot
count_reps.py          Vision Step 2 - calibration + hysteresis rep-counting state machine
evaluate.py            Vision Step 3 - grid-search & freeze thresholds against labels
labels.csv,            Hand-labeled rep corpus (squat + push-up) the pipeline is scored on
  pushup_stranger_labels.csv
fixtures/              verifier_expected.json - the golden vectors the Swift ↔ Python
                       parity test (VerifierParityTests) checks the two implementations against
PRODUCT.md, DESIGN.md  Product brief + design system (canonical intent)
missions/, wargames/,  The wargame-driven planning method used to build this - each feature
  SUCCESS.md, LEDGER.md  was fought on paper (predicted, counter-moved, proven 8/8) before code
```

The vision pipeline is prototyped and frozen in Python, then the **verifier is
re-implemented in Swift** and locked to the Python reference by a parity test
over shared golden vectors - so the on-device judge provably matches the
corpus-validated one.

## Build & test

```bash
# Deterministic core - no simulator needed:
cd ios/SoloCore && swift test

# App: open ios/SoloApp in Xcode and run on a device/simulator.

# Vision pipeline (needs Python + mediapipe/opencv/numpy; download the pose
# landmarker model referenced at the top of extract.py):
python extract.py corpus/ out/     # clips -> landmark CSVs
python count_reps.py out/          # count reps with the state machine
python evaluate.py                 # score against labels.csv, freeze thresholds
```

## How this was built

Every non-trivial feature was **wargamed before it was coded**: a genius model
writes a battle plan that predicts what will happen, plans the counter-moves, and
proves the win against the 8-Point Standard in [`SUCCESS.md`](./SUCCESS.md); a
cheaper model then executes the plan. Engineering truth lives in
`wargames/workout-tracker-verification.md`, product truth in
`wargames/output/product-spec.md`, and every run is logged in
[`LEDGER.md`](./LEDGER.md).
