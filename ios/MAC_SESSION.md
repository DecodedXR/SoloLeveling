# Mac Session Runbook — get the most out of limited Mac hours

Everything authorable off-Mac is already in this repo. The Mac session is
assembly + verification. Work top to bottom; each step has a bail-out note if
time runs short.

## Before you sit down (on Windows, already done / verify)

- [ ] Repo pushed to GitHub (`git push`) — the Mac pulls from there.
- [ ] `out/` landmark CSVs published on the `csv-transfer` branch (32 CSVs;
      done — see wargames/mac-session-prep.md). On the Mac, after cloning:
      `git fetch origin csv-transfer && git checkout origin/csv-transfer -- out/`
      Then `ls out/*.csv | wc -l` must print 32. Without them the parity test
      skips. (The repo is public — no token needed to fetch.)
- [ ] This runbook + `fixtures/verifier_expected.json` committed.

## 0. Prereq check (5 min — do this FIRST)

```sh
xcodebuild -version        # Xcode 15+ needed for iOS 16 target
xcrun simctl list devices | head   # any iPhone simulator present?
```

**If Xcode is NOT installed: STOP and reassess** — the download is 8–12 GB and
can eat the whole session. Fallback plan: install only Command Line Tools
(`xcode-select --install`, ~1 GB), which gives `swift test` — do step 1 (the
parity gate, the most valuable check) and skip the app shell.

## 1. Verifier parity — the B2 gate (15 min)

```sh
git clone <repo-url> && cd SoloLeveling
# put out/ in the repo root (OneDrive sync or copy)
cd ios/SoloCore
swift test
```

**Expected:** `testCorpusParity` passes, printing `parity: 32 clips checked`.
This proves the Swift Verifier == Python reference and closes M3's core risk
(register R5). If any clip mismatches: do NOT fix Swift by feel — record the
failing clip name, we bisect signal-by-signal against Python intermediates
later (plan M3 counter-move).

## 2. Xcode app project — M0 shell (45 min)

1. Xcode → New Project → iOS App, name `SoloApp`, interface SwiftUI,
   minimum deployment **iOS 16.0**. Save into `ios/` (next to `SoloApp/`).
2. Delete the template `ContentView.swift`; add the existing files from
   `ios/SoloApp/` (SoloApp.swift, EventStore.swift, DebugScreen.swift,
   ProStub.swift) to the app target. Add `LedgerFoldTests.swift` to the
   test target.
3. Add packages:
   - File → Add Package Dependencies → `https://github.com/groue/GRDB.swift`
     (exact-version pin it; latest release).
   - Add Local... → select `ios/SoloCore` → link `SoloCore` to the app target.
4. Build & run on an iPhone simulator (any iOS 16+ device).

**M0 check (from the wargame plan):**
- [ ] App launches; 12 screens navigate.
- [ ] Debug screen: tap "Write debug_event" → shows `events: 1, XP: 0`
      (tap again → `events: 2` — proves persistence).
- [ ] `LedgerFoldTests` passes (Cmd-U).

Expect small compile fixes — these files were written without a Swift
compiler for the Apple SDKs. Fix forward, commit each fix.

## 3. Before leaving the Mac (15 min — DO NOT SKIP)

```sh
git add -A && git commit -m "M0 walking skeleton: Xcode project + checks pass" && git push
```

- [ ] Commit the `.xcodeproj` so the next Mac session opens instantly.
- [ ] Screenshot the simulator debug screen + `swift test` output into
      `ios/m0-evidence/` and commit (milestone check evidence for the ledger).
- [ ] Note Xcode + macOS versions in the commit message (reproducibility).

## If time remains

- Run `swift test` once more from a clean clone (V1-style sanity).
- Start M1 GPS models ONLY if M0's check fully passed (B1: no milestone bleed).

## After the Mac session (back on Windows)

Record the 13 push-up Step 0 protocol clips (amended matrix in
`wargames/pushup-pipeline.md`): every clip starts with a 2s plank hold
(calibration), phone on floor, ~20s. Side/good: clean, shallow ×2,
shallow-mixed, paused-bottom, crawl + lie-down negatives; side/dim: shallow;
45°: clean + shallow; front ×3 (prove-it-fails). Plus the 4 VERIFY counts in
`pushup_stranger_labels.csv` (~10 min). Steps 1–3 then run on Windows.

## Priority if the session shrinks

1. Step 1 (parity) — closes the campaign's top technical risk, needs only CLT.
2. Step 2 (M0 shell) — unlocks milestone progression.
3. Step 3 (push everything) — a session that isn't pushed didn't happen.
