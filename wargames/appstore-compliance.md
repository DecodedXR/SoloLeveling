# Wargame: App Store Review Compliance

**Mission:** Produce the App Store compliance checklist for v1: every
guideline the app touches (camera, health/fitness data, on-device claims,
subscriptions, gamification/IP), the exact permission strings and privacy-
label entries required, and a rejection-risk register with mitigations.

**Date:** 2026-07-09 · **Genius:** fable-5 · **Executor:** any model with
`WebSearch`/`WebFetch`.

**Deliverable:** `wargames/output/appstore-compliance.md`, structure in Step 5.

## Inputs (read first)

- **SPEC** = `wargames/output/product-spec.md` — C6 (on-device, never video),
  C15 (banned terms), screens (§4: camera, GPS, paywall).
- **SUB** = `wargames/output/features-subscription-spec.md` — prices, trial,
  paywall placements, lapse policy (all reviewable surfaces).
- **MKT** = `wargames/output/market-analysis-report.md` — §1 IP constraints.

## Recon flags

- **R1:** Inputs readable. Missing → halt.
- **R2:** WebSearch live (test: `App Store Review Guidelines 2026`), and the
  current guidelines page fetchable at developer.apple.com. Not fetchable →
  work from search snippets, mark every affected item `(snippet-only)`.
- **R3:** Date-stamp everything; guideline numbers cited with access date
  (they get renumbered).

## Battle plan

### Step 1 — Guideline sweep
Fetch/search the current App Store Review Guidelines and enumerate every
clause this app plausibly touches. Mandatory coverage: health & fitness data
rules (incl. HealthKit usage/sharing limits and the ban on using health data
for advertising), camera usage & purpose strings, on-device processing /
privacy claims, auto-renewable subscription rules (required disclosures,
restore, price display), free-tier/trial representation, "minimum
functionality"/spam clauses for template-like apps, IP/trademark clause
(third-party content), and account deletion requirements if any account
exists. For each: clause number, one-line requirement, what in SPEC/SUB it
touches, access-dated cite.
- **Expected observation:** ≥12 clause rows, each mapped to a concrete app
  surface; none from memory (every row cited).
- **Counter-move:** a clause number can't be confirmed → keep the requirement,
  mark number `unverified`, cite the snippet.

### Step 2 — Permission strings & privacy labels
Produce ready-to-paste values: `NSCameraUsageDescription`,
`NSMotionUsageDescription`, `NSLocationWhenInUseUsageDescription`, HealthKit
strings if ADR-5 chose HealthKit (state the conditional), each in the arbiter
voice, plain-language, and truthful to C6 ("reps are verified on your device;
video never leaves it"). Then the App Privacy "nutrition label" table: data
type × collected? × linked? × tracking? — consistent with C6 and the
no-account-or-account question (flag it if unresolved by ADR-6).
- **Expected observation:** every permission the screens imply has a string;
  the privacy table has no row contradicting C6; banned terms absent.
- **Counter-move:** a permission's necessity is uncertain (depends on an
  unmade ADR) → include both variants labeled by the ADR outcome.

### Step 3 — Rejection-risk register
≥6 risks with likelihood, guideline anchor, and mitigation. Mandatory:
(1) camera fitness claims triggering a medical/health scrutiny path;
(2) subscription screen missing required disclosure text; (3) IP association
— reviewer pattern-matches the aesthetic to the franchise (mitigation:
banned-terms sweep + original assets + no franchise references in metadata
or screenshots); (4) privacy-label vs actual-SDK-traffic mismatch (MediaPipe
analytics if chosen); (5) "minimum functionality" if v1 ships GPS-only after
a kill-test failure; (6) age rating / kids-category miscalabration.
- **Expected observation:** each risk names the reviewable surface and a
  checkable mitigation.
- **Counter-move:** a mandatory risk seems inapplicable → argue why in one
  line, don't silently drop.

### Step 4 — Pre-submission checklist
A single flat checklist (≤25 items) a human runs before every submission:
strings present, disclosures on paywall, restore purchases works, privacy
labels match traffic, banned-term sweep of metadata/screenshots, demo-video
or reviewer notes for the camera flow (reviewers can't easily squat — provide
a review note + demo account/video plan), export-compliance answer.
- **Expected observation:** every Step 1 clause row is covered by ≥1
  checklist item (cross-reference column).
- **Counter-move:** an uncovered clause → add the item; the cross-reference
  column exists to make gaps visible.

### Step 5 — Assemble
`wargames/output/appstore-compliance.md`: `## 1. Guideline map` · `## 2.
Permission strings & privacy labels` · `## 3. Rejection-risk register` ·
`## 4. Pre-submission checklist` · `## 5. Open questions` (≥2, incl. any
ADR-dependent conditionals) · `## Sources` (dated URLs).

## Fork triggers

- **F1:** If the current guidelines show a clause specifically governing
  camera-based motion/health inference (new since training data), it becomes
  the top row of the risk register and its requirements get their own
  checklist items. Condition: such a clause is found in Step 1.

## Abort conditions

- **A0:** No web access — a compliance doc from memory is dangerous; halt.
- **A1:** Step 1 finds a guideline that prohibits a core mechanic outright
  (e.g., XP rewards tied to health data in a way Apple bans). Product-level
  decision — halt with the clause quoted.

## Verification runs

- **V1:** Re-fetch 4 cited clauses (every 3rd row); text must support the row.
- **V2:** Banned-term sweep over all deliverable strings/labels/checklist
  metadata items (citations exempt). Zero hits.
- **V3:** Checklist coverage audit — pick 5 random clause rows; each must
  point to an existing checklist item.

## Red-team pass

1. **Weakest assumption:** guideline numbers/structure from memory are stale.
   *Fix:* R2/R3 force live cites with dates; V1 re-fetches.
2. **Likely screw-up:** writing a generic "how to pass review" listicle.
   *Fix:* every row must map to a named SPEC/SUB surface; unmapped rows are
   padding and get cut at Step 1's expected-observation check.
3. **The IP risk is the sleeper:** metadata is clean but screenshots/preview
   video could still read as franchise content to a reviewer. *Fix:* risk #3
   explicitly covers assets, and the checklist sweeps screenshots, not just text.
4. **Reviewer-can't-test-the-camera:** a reviewer who can't trigger a valid
   rep may reject as broken. *Fix:* Step 4 mandates reviewer notes + demo
   video plan as checklist items.
5. **ADR coupling:** privacy labels depend on undecided ADRs (HealthKit,
   sync). *Fix:* Step 2's conditional-variant rule keeps the doc correct
   under either outcome instead of guessing.

```
Score: 8/8
Blockers: none
Verdict: SHIP
```
