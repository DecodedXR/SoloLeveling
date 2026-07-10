# Mac Session — the never-used-a-Mac version

Companion to `MAC_SESSION.md` (same steps, same priorities). This one assumes
zero Mac experience. Read Part A once; then work Parts B–E top to bottom.

---

## Part A — Mac survival basics (2 minutes)

- **Cmd (⌘) is your Ctrl.** Copy = ⌘C, paste = ⌘V, save = ⌘S, quit = ⌘Q,
  switch apps = ⌘Tab. The Ctrl key exists but does almost nothing you expect.
- **Launching any app:** press **⌘ + Space** (Spotlight), type the app name
  (e.g. `Terminal`, `Xcode`, `App Store`), press Return.
- **Terminal** is the Mac's command prompt. It runs the same commands as Git
  Bash on Windows (`cd`, `ls`, `git`, …). Paths use `/`, your home folder is
  `~` (e.g. `~/Downloads`).
- **Finder** is File Explorer. From Terminal, `open .` opens the current
  folder in Finder; from Finder you can drag a folder onto the Terminal icon
  to get its path.
- **Closing a window doesn't quit the app** (the menu bar at the top of the
  screen belongs to whatever app is frontmost). ⌘Q quits.
- **Right-click** = two-finger click on the trackpad (or Ctrl+click).

## Part B — Prep you can do on Windows BEFORE the session (10 min, do it now)

1. **Create a GitHub token** (you'll need it to push from the Mac, and to
   clone if the repo is private): github.com → your avatar → Settings →
   Developer settings → Personal access tokens → Tokens (classic) →
   Generate new token (classic) → check the **repo** scope → generate.
   **Copy it into your phone's notes** — you'll type it on the Mac as your
   password when git asks.
2. **Know your OneDrive login** (the purdue.edu one). The 32 landmark CSVs in
   `out/` are gitignored — OneDrive is how the Mac gets them.
3. Repo URL: `https://github.com/DecodedXR/SoloLeveling.git` (already pushed).

## Part C — One-time Mac setup

### C1. Check what's already installed (do this before downloading anything)

Open Terminal (⌘Space → `Terminal`) and run:

```sh
xcodebuild -version
```

- Prints `Xcode 15.x` or `16.x` → skip to C3. (Lab/borrowed Macs often have it.)
- Prints an error → C2.

### C2. Install Xcode — or the small fallback

**Full Xcode (needed for Step 2's app shell): 8–12 GB.**
⌘Space → `App Store` → sign in with an Apple ID (make a free one at
appleid.apple.com if needed) → search **Xcode** → Get. While it downloads,
do C3 and Step 1 prep.

First launch of Xcode: it asks to *install additional components* and which
platforms — make sure **iOS** is checked (this pulls the iOS simulator
runtime, several more GB). Say yes to everything, enter the Mac's password
when asked. If Terminal ever complains about the license:
`sudo xcodebuild -license accept`.

**If the download would eat the session: fallback.** Run
`xcode-select --install` (~1 GB Command Line Tools). That gives you
`swift test` — enough for **Step 1, the most valuable thing in the session**.
Skip Step 2, still do Step 3.

### C3. Tell git who you are + get the repo

```sh
git config --global user.name  "DecodedXR"
git config --global user.email "decodedpc@gmail.com"
cd ~
git clone https://github.com/DecodedXR/SoloLeveling.git
cd SoloLeveling
```

If it asks for username/password: username = your GitHub username, password =
**the token from Part B** (your real password will not work).

### C4. Get the `out/` CSVs onto the Mac

Easiest on a borrowed Mac — the browser, no OneDrive app install:

1. Safari → onedrive.com → sign in with the purdue.edu account.
2. Navigate to `Documents → GitHub → SoloLeveling → out` → select all →
   Download (arrives as a zip in `~/Downloads`).
3. In Terminal:

```sh
cd ~/SoloLeveling
mkdir -p out
unzip -j ~/Downloads/out*.zip -d out/
ls out/*.csv | wc -l    # expect 32
```

---

## Part D — The session itself

### Step 1 — Verifier parity, the B2 gate (15 min)

```sh
cd ~/SoloLeveling/ios/SoloCore
swift test
```

First run compiles for a few minutes. **Expected:** all tests pass and
`testCorpusParity` prints `parity: 32 clips checked`. Save the proof:

```sh
mkdir -p ../m0-evidence
swift test 2>&1 | tee ../m0-evidence/swift-test.txt
```

**If any clip mismatches: do NOT edit Swift to make it pass.** Write down the
failing clip name(s), commit the log, move on — the plan bisects it against
Python intermediates later.

### Step 2 — Xcode app project, the M0 shell (45 min)

1. Open Xcode → **File → New → Project** (⇧⌘N) → **iOS** tab → **App** → Next.
2. Fill in: Product Name `SoloApp` · Team: None · Organization Identifier:
   `com.decodedxr` · Interface **SwiftUI** · Language Swift · Storage None ·
   **keep "Include Tests" checked**. Next.
3. Save location: navigate to `~/SoloLeveling/ios` and **uncheck "Create Git
   repository"** → Create.
   - **If Xcode refuses because a `SoloApp` folder already exists:** save the
     project to the Desktop instead, then in Finder drag just the
     `SoloApp.xcodeproj` file into `~/SoloLeveling/ios/`. Open it from there;
     the template files will show red (missing) — that's fine, you delete
     them in the next step anyway.
4. In the left sidebar (Project navigator, folder icon at top-left), delete
   every template source file (`ContentView.swift`, the template
   `SoloAppApp.swift`, and any red/missing files): right-click → Delete →
   **Move to Trash**.
5. **File → Add Files to "SoloApp"…** → navigate to `~/SoloLeveling/ios/SoloApp`
   → select `SoloApp.swift`, `EventStore.swift`, `DebugScreen.swift`,
   `ProStub.swift` → make sure **"Copy items if needed" is UNCHECKED** and
   the **SoloApp target checkbox is CHECKED** → Add.
   Then repeat for `LedgerFoldTests.swift`, but in the target checkboxes pick
   the **SoloAppTests** target (not the app).
6. Set the deployment floor: click the blue **SoloApp** project icon at the
   very top of the sidebar → select the **SoloApp** target → **General** tab
   → Minimum Deployments → **iOS 16.0**.
7. Add GRDB: **File → Add Package Dependencies…** → paste
   `https://github.com/groue/GRDB.swift` in the search box → Dependency Rule:
   **Exact Version** (take the latest shown) → Add Package → add the **GRDB**
   library to the SoloApp target.
8. Add SoloCore: same dialog → bottom-left **Add Local…** → select the folder
   `~/SoloLeveling/ios/SoloCore` → Add Package. Then blue project icon →
   SoloApp target → General → **Frameworks, Libraries, and Embedded Content**
   → **+** → add **SoloCore**.
9. Run it: in the toolbar at the top, the device menu (next to the scheme
   name) → pick any **iPhone simulator** (e.g. iPhone 15) → press the **▶**
   button (or ⌘R). First simulator boot is slow — minutes, not seconds.
   - If the device list is empty: Xcode → Settings (⌘,) → **Platforms** →
     iOS → Get.
10. Expect compile errors — these files were written on Windows without
    Apple's SDKs. Read the first error, fix it, rebuild (⌘B), repeat. Commit
    each fix. Don't rewrite; smallest change that compiles.

**M0 pass criteria:**
- App launches; all 12 screens navigate.
- Debug screen → tap "Write debug_event" → `events: 1, XP: 0`; tap again →
  `events: 2` (persistence proven).
- **⌘U** runs the tests; `LedgerFoldTests` passes.

**Evidence:** with the simulator frontmost, **⌘S saves a screenshot of the
phone screen to the Desktop.** Copy it in:

```sh
cp ~/Desktop/Simulator*.png ~/SoloLeveling/ios/m0-evidence/
```

### Step 3 — Before leaving the Mac (15 min, DO NOT SKIP)

```sh
cd ~/SoloLeveling
git add -A
git commit -m "M0 walking skeleton: Xcode project + checks pass (Xcode <ver>, macOS <ver>)"
git push
```

(Get the versions: `xcodebuild -version` and `sw_vers -productVersion`.)
Password prompt = the Part B token again. Confirm on github.com that the
commit is visible. **A session that isn't pushed didn't happen.**

---

## Part E — Priorities and afterward

**If the session shrinks:** 1) Step 1 parity (needs only the 1 GB CLT),
2) Step 2 M0 shell, 3) Step 3 push.

**If time remains after M0:** re-run `swift test` from a fresh clone in a
second folder (clean-clone sanity); start M1 GPS models only if every M0
check passed.

**Back on Windows:** record the 13 push-up Step 0 protocol clips
(`wargames/pushup-pipeline.md` amended matrix — every clip opens with a 2 s
plank hold, phone on floor, ~20 s) and resolve the 4 VERIFY counts in
`pushup_stranger_labels.csv` (~10 min of watching).
