# Wargame — Mac Session Prep (Windows-side)

**Mission:** de-risk the upcoming Mac session so it cannot be sunk by anything
fixable from Windows today. Executor runs on the Windows machine at
`C:\Users\user\GitHub\SoloLeveling` (Git Bash paths below use
`/c/Users/user/GitHub/SoloLeveling`).

**Objective (win condition):** a fresh, anonymous `git clone` of the public
repo — plus one documented `git` command — yields everything the Mac needs for
Step 1 (parity gate), proven by a clean-clone `swift test` pass on Windows; and
both Mac runbooks contain correct transfer instructions.

---

## Recon findings (already scouted by genius — executor re-verifies in Step 0)

| # | Assumption checked | Result |
|---|--------------------|--------|
| R1 | `out/` has the 32 landmark CSVs | ✓ `ls out/*.csv \| wc -l` → 32, 64 MB total |
| R2 | Repo folder is OneDrive-synced (runbook C4's premise) | ✗ **FALSE.** `C:\Users\user\GitHub` is a plain folder; OneDrive root is `C:\Users\user\OneDrive - purdue.edu`. Runbook C4's path `Documents → GitHub → SoloLeveling → out` does not exist in OneDrive. This is the defect this wargame exists to fix. |
| R3 | Repo visibility | PUBLIC (`gh repo view` → PUBLIC) → clone/fetch on the Mac needs NO token; token needed only to push |
| R4 | `gh` auth on Windows | Logged in as DecodedXR, token has `repo` scope |
| R5 | Swift on Windows | 6.3.3 present → pre-flight `swift test` possible |
| R6 | CSV line endings vs git | CSVs are LF; `core.autocrlf=true`; no `.gitattributes` exists. Risk: any future CRLF CSV would be silently normalized. Plan adds `.gitattributes` on the transfer branch. |
| R7 | Working tree | clean, master == origin/master |

## Battle plan

### Step 0 — Re-verify recon (2 min)

```sh
cd /c/Users/user/GitHub/SoloLeveling
git status -sb                 # expect: ## master...origin/master, no changes
ls out/*.csv | wc -l           # expect: 32
```

- **Expected observation:** exactly `## master...origin/master` with no file
  lines, and `32`.
- **Counter-move:** tree dirty → STOP, report the dirty files verbatim, do not
  stash or commit them. CSV count ≠ 32 → ABORT (A2).

### Step 1 — Pre-flight parity gate on Windows (15 min)

```sh
cd /c/Users/user/GitHub/SoloLeveling/ios/SoloCore
swift test 2>&1 | tail -20
```

Allow up to 10 minutes (first compile is slow). Use a 600000 ms timeout.

- **Expected observation:** all tests pass; output contains
  `parity: 32 clips checked` and 0 failures.
- **Counter-move:** any failure → ABORT (A1). Do NOT edit any Swift or Python.
  Report the failing test name(s) and the tail of the output. There is no
  point shipping CSVs to a Mac if parity is already broken at HEAD on Windows.

### Step 2 — Publish the CSVs on a transfer branch (10 min)

The CSVs stay gitignored on master; they ride a dedicated branch the Mac
fetches anonymously.

```sh
cd /c/Users/user/GitHub/SoloLeveling
git checkout -b csv-transfer
printf 'out/*.csv -text\n' > .gitattributes
git add .gitattributes
git add -f out/*.csv           # -f required: out/ is gitignored
git commit -m "csv-transfer: 32 landmark CSVs for Mac parity test (branch only, not for master)"
git push -u origin csv-transfer
git checkout master
git status -sb                 # master must be untouched
```

- **Expected observation:** commit reports 33 files changed (32 CSVs +
  `.gitattributes`); push succeeds; final `git status -sb` prints
  `## master...origin/master` with no changes. `git ls-tree -r origin/csv-transfer --name-only | grep -c '^out/.*csv$'` prints 32.
- **Counter-move:** push rejected (size/policy) → delete the branch
  (`git branch -D csv-transfer`, and `git push origin --delete csv-transfer`
  if it half-pushed) and take **Fork F1** (OneDrive fallback) below.
  If `git add -f` stages anything besides `.gitattributes` and `out/*.csv`
  (check `git diff --cached --stat`), reset and report.

### Step 3 — Fix both runbooks (10 min)

The OneDrive transfer instructions are wrong (recon R2). Replace them.

**3a. `ios/MAC_SESSION.md`** — replace the second checklist bullet under
"## Before you sit down" (the one beginning `- [ ] \`out/\` landmark CSVs
available to the Mac.` and ending `they are gitignored).`) with:

```markdown
- [ ] `out/` landmark CSVs published on the `csv-transfer` branch (32 CSVs;
      done — see wargames/mac-session-prep.md). On the Mac, after cloning:
      `git fetch origin csv-transfer && git checkout origin/csv-transfer -- out/`
      Then `ls out/*.csv | wc -l` must print 32. Without them the parity test
      skips. (The repo is public — no token needed to fetch.)
```

**3b. `ios/MAC_SESSION_NOVICE.md`** — two edits:

1. In Part B item 2, replace the sentence
   `**Know your OneDrive login** (the purdue.edu one). The 32 landmark CSVs in`
   + its continuation line with:
   ```markdown
   2. ~~OneDrive~~ Not needed anymore: the 32 landmark CSVs now travel on the
      `csv-transfer` git branch (see C4).
   ```
2. Replace the entire **C4** section body (heading stays
   `### C4. Get the \`out/\` CSVs onto the Mac`) with:
   ```markdown
   The CSVs live on a dedicated branch of the same repo — no OneDrive, no
   second login:

   ```sh
   cd ~/SoloLeveling
   git fetch origin csv-transfer
   git checkout origin/csv-transfer -- out/
   ls out/*.csv | wc -l    # expect 32
   ```

   (This copies the CSVs into your working folder without switching branches;
   `git status` will show them as new files — ignore that, don't commit them.)
   ```

Then:

```sh
git add ios/MAC_SESSION.md ios/MAC_SESSION_NOVICE.md
git commit -m "runbooks: CSVs travel on csv-transfer branch (repo is not OneDrive-synced; old C4 path did not exist)"
git push
```

- **Expected observation:** `grep -c csv-transfer ios/MAC_SESSION.md
  ios/MAC_SESSION_NOVICE.md` shows ≥1 per file; `grep -ci onedrive
  ios/MAC_SESSION_NOVICE.md` has dropped versus before the edit; push succeeds.
- **Counter-move:** if the anchor text for an edit isn't found verbatim (docs
  may have drifted), find the section by its heading, make the same semantic
  replacement, and note the deviation in the commit message. Do not skip the
  edit.

### Step 4 — `[HUMAN]` Token to phone (2 min, cannot be done by the executor)

Print the token for the human:

```sh
gh auth token
```

- **Expected observation:** a `gho_…` string prints. Tell the human verbatim:
  "Copy this into your phone's notes. On the Mac it is your git *password*
  when pushing (username DecodedXR). Never paste it into a repo file. Since
  the repo is public, you only need it for the final push."
- **Counter-move:** `gh` not logged in → tell the human to follow Part B's
  7-day-PAT route in `ios/MAC_SESSION_NOVICE.md`; do not create a PAT
  yourself.

### Step 5 — Verification run: dress rehearsal of the Mac's Step 1 (20 min)

Prove the exact command sequence the Mac will run, from a clean anonymous
clone, in the session scratchpad (NOT inside the repo):

```sh
cd "$SCRATCHPAD"   # the session scratchpad dir; any empty temp dir works
git clone https://github.com/DecodedXR/SoloLeveling.git rehearsal
cd rehearsal
git fetch origin csv-transfer
git checkout origin/csv-transfer -- out/
ls out/*.csv | wc -l                      # expect 32
cd ios/SoloCore
swift test 2>&1 | tail -20
```

- **Expected observation:** clone succeeds without credentials, CSV count 32,
  all tests pass with `parity: 32 clips checked`. This single run proves: repo
  completeness, branch transfer, line-ending safety, and parity — everything
  the Mac's Step 1 needs.
- **Counter-move:** parity passes in the repo (Step 1) but fails in the
  rehearsal → the difference is the git round-trip (line endings or a missed
  file). Run `git -C . diff --no-index out/45_good_clean.csv
  /c/Users/user/GitHub/SoloLeveling/out/45_good_clean.csv` on a failing clip
  to confirm byte drift, then ABORT (A3) and report — do not patch around it.
- Afterward delete the rehearsal folder.

## Fork triggers

- **F1 — push of csv-transfer rejected** (exact condition: `git push` exits
  non-zero citing file size or policy): fall back to OneDrive. Run
  `robocopy out "C:\Users\user\OneDrive - purdue.edu\SoloLeveling-out" *.csv`,
  confirm 32 files copied, and in Step 3 write the runbook C4 replacement to
  say: Safari → onedrive.com → purdue login → folder `SoloLeveling-out` →
  download zip → `unzip -j ~/Downloads/SoloLeveling-out*.zip -d ~/SoloLeveling/out/`.
  Step 5's rehearsal then verifies only clone + `swift test` with CSVs copied
  in locally from `out/`.
- **F2 — anchor text in a runbook not found** (Step 3 counter-move): semantic
  replacement by heading, deviation noted in commit message.

## Abort conditions

- **A1** — Step 1 `swift test` fails at HEAD on Windows. Halt everything;
  report failing tests. The Mac session premise (parity already proven) is
  broken and needs the genius, not prep.
- **A2** — `out/` does not contain exactly 32 CSVs. Halt; the corpus state
  differs from every recorded metric.
- **A3** — Step 5 rehearsal fails after Step 1 passed. Halt; leave the
  `csv-transfer` branch in place for debugging; report the diff evidence.
- **A4** — anything would require committing CSVs, tokens, or zips to
  `master`. Never do this; halt and report instead.

## Verification runs (mission-level proof, distinct from the work)

1. Step 5's clean-clone rehearsal (the core proof).
2. `git status -sb` on master at the very end → `## master...origin/master`,
   clean (proves master untouched by the CSV branch work).
3. `gh api repos/DecodedXR/SoloLeveling/branches/csv-transfer --jq .name` →
   prints `csv-transfer` (proves the branch is really on GitHub, not local).

All three pass ⇒ mission WIN. Record the outcome in `LEDGER.md` row for this
wargame.

## Red-team pass (attacks + folded-in fixes)

1. **Executor commits CSVs to master by muscle memory.** Fix: explicit branch
   commands, a staged-files check in Step 2, abort A4, and verification run 2.
2. **CRLF normalization corrupts CSV bytes through git.** Fix: `.gitattributes`
   `-text` on the branch (Step 2); Step 5 rehearsal is the byte-level proof
   (parity to 1e-5 fails on any drift).
3. **`swift test` first-compile time read as a hang.** Fix: 600 s timeout
   stated in Step 1.
4. **Public branch leaks something sensitive.** Checked: CSVs are numeric pose
   landmarks (t + 33 joints × x/y/z/v), no names, no video. Acceptable on a
   public repo. Tokens never touch files (A4).
5. **Runbook drift breaks Step 3's exact-anchor edits.** Fix: fork F2.
6. **Branch deleted before the Mac session uses it.** Fix: nothing in this plan
   deletes `csv-transfer`; cleanup is explicitly deferred to *after* the Mac
   session (add to that session's Step 3 checklist mentally — the branch is
   disposable once `out/` is on the Mac).
7. **Rehearsal clone left inside the repo confusing later sessions.** Fix:
   rehearsal runs in the scratchpad and is deleted afterward.

## Score

```
Score: 8/8
Blockers: none
Verdict: SHIP
```

- (1) Expected observations: every step names checkable output. ✓
- (2) Counter-moves: paired per observation. ✓
- (3) Fork triggers: F1/F2 with exact conditions. ✓
- (4) Recon flags: R1–R7 scouted, R2 falsified and folded in. ✓
- (5) Abort conditions: A1–A4. ✓
- (6) Verification runs: 3, distinct from the work. ✓
- (7) Red-team: 7 attacks, fixes folded in. ✓
- (8) Blind executability: all commands literal, paths absolute, human steps
  marked `[HUMAN]`, no judgment calls left. ✓
