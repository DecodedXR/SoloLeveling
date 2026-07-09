# App Store Review Compliance Checklist — Verified-XP Fitness Leveler (iOS v1)

Derived from SPEC (`wargames/output/product-spec.md`), SUB
(`wargames/output/features-subscription-spec.md`), MKT
(`wargames/output/market-analysis-report.md`), with ADR conditionals resolved
from `wargames/output/architecture-adr.md` (ADR-5, ADR-6, ADR-7).

**Date:** 2026-07-09 · **Executor:** Claude Opus 4.8 · Plan:
`wargames/appstore-compliance.md`.

**Recon.** R1 pass (SPEC/SUB/MKT + ADR all readable). R2 pass (WebSearch live —
test query `App Store Review Guidelines 2026` returned live results; the current
Guidelines page at `developer.apple.com/app-store/review/guidelines/` is
fetchable, so **no row is `(snippet-only)`** — every clause below is live-cited).
R3 pass (all cites carry access date **2026-07-09**; guideline numbers are the
live numbers as of that date and may be renumbered later).

**Aborts.** A0 clear (web access works — this is not a from-memory doc). **A1 not
tripped** — no guideline prohibits a core mechanic outright: the app makes no
medical-measurement claim, never writes to HealthKit, uses no health data for
advertising, and keeps XP private and on-device (SPEC C6, C18; ADR-5/6).

**Fork F1: did NOT fire.** Step 1 searched the live guidelines for a clause
*specifically* governing camera-based motion/health inference (pose detection /
rep counting / inferring fitness metrics from the camera). No such dedicated or
newly-added clause exists. The two nearest clauses — **1.4.1** (medical-accuracy
claims from device sensors) and **5.1.2(vi)** (camera/depth data may not be used
for advertising or data-mining) — are pre-existing and general, not a
camera-motion-specific rule. F1's condition ("such a clause is found in Step 1")
is therefore false; the risk register is ordered normally, with the mandatory
camera-fitness/medical-scrutiny row (anchored to 1.4.1) as its top row on its own
merit.

---

## 1. Guideline map

Every clause the app plausibly touches, mapped to a concrete SPEC/SUB/ADR
surface. 16 rows. All clauses quoted/summarized from the live Guidelines page
(accessed 2026-07-09); age-rating rows cite Apple Developer News (same date). No
row is from memory.

| # | Clause | One-line requirement | App surface it touches | Cite (accessed 2026-07-09) |
|---|---|---|---|---|
| G1 | **1.4.1** (Medical) | Must disclose data/methodology behind any health-measurement accuracy claim; device sensors may **not** claim to measure BP/glucose/etc. | Camera "verifies your reps" claim (SPEC C18 "XP you actually earned", F1/F6); positioning must read as rep/form counting + gamification, **not** a medical measurement | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G2 | **5.1.3(i)** (Health & Fitness data) | Fitness data may **not** be used for advertising/marketing/use-based data-mining; must disclose the specific health data collected from the device | Rep/run fitness signals (SPEC F1–F4); guarantees C6/C18 (on-device, no ads) hold; privacy disclosure of what is read | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G3 | **5.1.2(vi)** (Camera/Health data use) | Data from HealthKit or **Camera APIs** / depth/facial-mapping may **not** be used for marketing, advertising or use-based data-mining, incl. by third parties | Camera pose frames feed the on-device Verifier only (ADR-1 Apple Vision, ADR-3 AVFoundation); no analytics SDK on the camera path | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G4 | **5.1.3(ii)** (HealthKit integrity) | Must not write false/inaccurate data into HealthKit; may not store personal health info in iCloud | ADR-5 keeps HealthKit **optional-read only** (never writes) → compliant by design; ADR-6 stores no PHI in iCloud (no v1 sync) | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G5 | **5.1.1(i)** (Privacy policy) | Must link a privacy policy in metadata **and** in-app; it must state data collected, uses, retention/deletion, and how to revoke consent | Settings/Privacy screen (SPEC scr.11, F21) + App Store Connect metadata | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G6 | **5.1.1(ii)** (Consent & purpose strings) | Must secure consent for data collection; **purpose strings must clearly and completely describe the use** | `NSCameraUsageDescription`, `NSMotionUsageDescription`, `NSLocationWhenInUseUsageDescription` (§2) | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G7 | **5.1.1(iii)** (Data minimization) | Request only data relevant to core functionality; collect only what the task requires | Camera/motion/location are each core to a verified XP source (SPEC C18) — no non-core permission requested | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G8 | **5.1.1(v)** (Account deletion / no forced login) | If the app supports account creation it must offer in-app account deletion; if core function isn't a social network, provide access **without a login** | ADR-6 = **no account system**; app runs login-less → account-deletion duty N/A, "access without login" satisfied by design | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G9 | **5.1.2(i)** (Data use & sharing) | May not use/share personal data without permission; must disclose third-party/third-party-AI sharing; ATT required to track | v1 shares nothing off-device (ADR-6); privacy label Tracking = No; no ATT prompt needed | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G10 | **2.5.14** (Recording indication) | Must get explicit consent **and** give a clear visual/audible indication when recording via camera/microphone | Live-set screen must show an on-screen "camera active" indicator during a set (SPEC scr.5) | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G11 | **3.1.1** (In-App Purchase) | Unlocking features/subscriptions must use IAP; no own license-key/QR/crypto unlock mechanisms | Pro subscription via StoreKit 2 (ADR-7); no side-channel unlock | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G12 | **3.1.2(a)** (Auto-renewable subs) | Sub must provide ongoing value, last ≥7 days, and be available across all the user's devices | Pro = $6.99/mo, $44.99/yr (SUB §3.2); breadth content (SUB §3.1); entitlement syncs via Apple ID (ADR-7) | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G13 | **3.1.2(c)** (Sub disclosure) | Before subscribing, clearly describe what the user gets for the price (per Schedule 2) | Paywall screen (SPEC scr.12) + arbiter-voice strings (SUB §3.5) must state contents, price, renewal terms | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G14 | **2.1(a)/(b)** (App completeness) | Final build, no placeholder; if the reviewer can't reach a feature/IAP, provide a demo mode + explain in review notes | Reviewer can't easily perform a valid squat → demo mode/video + review notes; Pro IAP must be visible/functional (SUB §3.4) | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G15 | **4.2 / 4.3(b)** (Min functionality / spam-copycat) | Must be useful, unique, "app-like"; don't submit apps indistinguishable from what's widely available | The camera-verification wedge differentiates from honor-system levelers (MKT §2 whitespace); matters most if v1 ships GPS-only after a kill-test failure (SPEC C13) | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |
| G16 | **5.2.1 + 4.1** (IP / copycat) | No protected third-party trademarks/copyrighted work; no copycat name/icon/metadata | Solo Leveling IP owned by D&C Webtoon Biz (MKT §1); banned-terms list (SPEC C15) must be absent from name, subtitle, keywords, screenshots, preview video | [guidelines](https://developer.apple.com/app-store/review/guidelines/) |

**Age rating (submission-form, not a numbered review clause).** Under the age-
rating system in force since the 2026 overhaul, bands are **4+ / 9+ / 13+ / 16+ /
18+** (12+ and 17+ removed); the questionnaire added a **"Medical or wellness
topics"** question, mandatory since 2026-01-31. Cite: [Apple Developer News —
updated age ratings](https://developer.apple.com/news/?id=ks775ehf) and
[Age Rating Updates — upcoming requirements](https://developer.apple.com/news/upcoming-requirements/?id=07242025a)
(accessed 2026-07-09). See risk R6.

*Every G-row maps to a named SPEC/SUB/ADR surface — no generic "how to pass
review" padding (Step 1 expected observation + red-team #2 met). No clause number
is `unverified`: all resolved on the live page (Step 1 counter-move not needed).*

---

## 2. Permission strings & privacy labels

### 2.1 Info.plist purpose strings (ready to paste, arbiter voice, truthful to C6)

All three are required by the v1 architecture (ADR-1/3/5). Each is plain-language
and completely describes the use, per **5.1.1(ii)** (G6).

| Key | Required? | Value |
|---|---|---|
| `NSCameraUsageDescription` | **Yes** — camera rep verification (ADR-1/3, SPEC F1/F5) | `Used to watch your reps and verify each one on this device. Video is processed live and is never recorded, stored, or uploaded.` |
| `NSMotionUsageDescription` | **Yes** — CMPedometer steps + CoreMotion still-phone check (ADR-3/5, SPEC F4/F8) | `Used to count your steps and to detect phone movement, so a bounced phone can't fake a rep.` |
| `NSLocationWhenInUseUsageDescription` | **Yes** — CoreLocation run pace/distance + plausibility (ADR-5, SPEC F3) | `Used to measure your run's distance and pace and to confirm the pace is humanly plausible. Your route stays on this device.` |
| `NSHealthShareUsageDescription` | **Conditional — only if the ADR-5 optional HealthKit read ships.** ADR-5 chose CMPedometer+CoreLocation as primary and HealthKit as **optional-read only**. Include this string only if that optional import is built. | `Optional. Grant read access only if you want to import your existing workouts. The app never writes to Health.` |
| `NSHealthUpdateUsageDescription` | **No** — the app never writes to HealthKit (ADR-5; required to stay clean of 5.1.3(ii)/G4). Omit the key. | *(not included)* |

*Counter-move applied:* the HealthKit variant is the ADR-dependent one; it is
shown labeled by its ADR-5 outcome (optional-read) rather than guessed. No banned
term (SPEC C15) appears in any string.

### 2.2 App Privacy "nutrition label"

v1 has **no account** (ADR-6), **no cross-device sync** (ADR-6 defers CloudKit to
v2), **no third-party analytics/ads SDK** (ADR-1 = Apple Vision, no MediaPipe
CocoaPod), and processes everything on-device with only *events* ever syncing —
and in v1 nothing syncs at all. Under Apple's definition, data that never leaves
the device is **not "collected."** The truthful v1 label is therefore *Data Not
Collected*, which is consistent with C6 by construction.

| Data type | Collected? | Linked to user? | Used for tracking? | Rationale |
|---|---|---|---|---|
| Health & Fitness (reps, runs, XP) | **No** (v1) | n/a | **No** | On-device only; never transmitted (C6, ADR-6). *v2 flag below.* |
| Location | **No** (v1) | n/a | **No** | CoreLocation used on-device for pace/distance; route not uploaded (C6) |
| Identifiers | **No** | n/a | **No** | No account, no user ID (ADR-6, C1) |
| Usage Data / Diagnostics | **No** | n/a | **No** | No analytics SDK in v1 (ADR-1). If one is later added, this row and G9 change |
| Purchases | **No** (by the developer) | n/a | **No** | StoreKit handles the transaction; the app stores only a local entitlement flag (ADR-7) |

*No row contradicts C6; banned terms absent (Step 2 expected observation met).*

**ADR-dependent conditional (flagged, per Step 2 counter-move):** the no-account
question is **resolved** by ADR-6 (login-less) — so 5.1.1(v)/G8 imposes no
account-deletion duty. If the **ADR-6 v2 CloudKit event-mirror** ships, the
Health & Fitness row flips to *Collected → Linked (to the iCloud identity) →
Tracking: No*, and the privacy policy (G5) and G2 disclosure must be updated
before that build submits. This doc is correct under either outcome.

---

## 3. Rejection-risk register

7 risks, each naming the reviewable surface and a checkable mitigation. R1 is the
mandatory camera-fitness/medical row (F1 did not fire, so it sits at the top on
merit, not as a fork-promoted clause).

| # | Risk | Likelihood | Guideline anchor | Reviewable surface | Mitigation (checkable) |
|---|---|---|---|---|---|
| **R1** | Camera "verifies your reps" reads as a **medical/health measurement claim**, triggering the medical-accuracy scrutiny path | Med | **1.4.1** (also 5.1.3) | Store description, screenshots ("REP REJECTED / +10 XP"), in-app copy | Frame strictly as rep-counting + gamification; **no** BP/HR/calorie/medical claim anywhere; "verified" = depth/form + sensor plausibility, stated as such; disclose the on-device methodology in review notes |
| **R2** | Subscription screen **missing required disclosure** (price, renewal terms, contents, restore, Terms/Privacy links) | Med | **3.1.2(a)/(c)**, 3.1.1 | Paywall screen (SPEC scr.12) | Paywall shows price + renewal terms + one-line contents (SUB §3.5), a working **Restore Purchases** button, and links to Terms of Use (EULA) + privacy policy |
| **R3** | **IP association** — reviewer pattern-matches the aesthetic/screenshots/preview video to the *Solo Leveling* franchise | Med-High | **5.2.1**, 4.1 | App name, subtitle, keywords, **screenshots + preview video**, developer name | Banned-terms sweep of all metadata **and** visual assets (SPEC C15 / MKT §1); original art only; no franchise character/title/catchphrase in any field or frame; keep to allowed generic vocabulary (MKT §1) |
| **R4** | **Privacy-label vs actual traffic mismatch** (a third-party SDK phones home while the label says "Not Collected") | Low | **5.1.1(i)/(ii)**, 5.1.2(vi) | App Privacy label vs on-device network behavior | ADR-1 chose Apple Vision (no MediaPipe/analytics SDK) → no camera-path traffic; **verify** with a network trace that no SDK transmits; if any analytics is added later, update the label first |
| **R5** | **"Minimum functionality" / copycat** if v1 ships **GPS-only** after a squat kill-test failure (SPEC C13) | Low-Med | **4.2 / 4.3(b)** | Whole-app value proposition in a vision-less build | The GPS/step loop is a complete leveling app (quests→XP→levels→ranks→streaks→Endurance, SUB J6), not a bare step counter; lead the listing with the verified-XP wedge; if vision is cut, re-review the listing against 4.3(b) before submitting |
| **R6** | **Age-rating / Kids miscalibration** — wrong band or accidental Kids-Category obligations | Low | Age-rating questionnaire (2026 system); **1.3** Kids Category | App Store Connect age-rating answers | Answer the new **"Medical or wellness topics"** question accurately (wellness, non-medical); do **not** enroll in the Kids Category (app has a subscription + camera); pick the band the questionnaire yields (expected 4+/13+), no manual under-rating |
| **R7** | **Reviewer can't trigger a valid rep** and rejects the camera flow as broken | Med | **2.1(a)/(b)** | Live-set / setup-gate flow under review | Ship a **demo mode** that exercises the full set flow without a live squat, plus a **demo video** and **review notes** explaining the camera setup + how to reach a valid rep (red-team #4) |

*No mandatory risk was silently dropped: the plan's risk #4 (MediaPipe-analytics
mismatch) is retained as R4 but noted **largely pre-mitigated by ADR-1's choice of
Apple Vision** — stated, not omitted (Step 3 counter-move).*

---

## 4. Pre-submission checklist

Flat list a human runs before **every** submission. 23 items. The "Covers"
column cross-references the Step 1 clause(s) each item satisfies — every G-row
G1–G16 appears at least once (Step 4 expected observation).

| # | Item | Covers |
|---|---|---|
| 1 | `NSCameraUsageDescription` present, arbiter-voice, matches §2.1 text | G6 |
| 2 | `NSMotionUsageDescription` present, matches §2.1 text | G6, G7 |
| 3 | `NSLocationWhenInUseUsageDescription` present, matches §2.1 text | G6, G7 |
| 4 | `NSHealthShareUsageDescription` present **iff** the optional HealthKit read shipped; `NSHealthUpdateUsageDescription` **absent** (app never writes Health) | G4, G6 |
| 5 | Live-set screen shows a visible "camera active" recording indicator | G10 |
| 6 | Store description + screenshots make **no medical/health-measurement claim**; "verified" framed as rep/form + sensor check | G1, G2 |
| 7 | No health/fitness data used for ads/marketing; no analytics on the camera path | G2, G3 |
| 8 | Privacy policy linked in App Store Connect metadata **and** reachable in-app (Settings/Privacy) | G5 |
| 9 | App Privacy label = "Data Not Collected" and matches actual on-device-only behavior (v1) | G9, G2 |
| 10 | Network trace confirms no SDK transmits data off-device (label-vs-traffic check) | G9, G3 |
| 11 | App runs fully with **no login**; no account system present (so no account-deletion control needed) | G8 |
| 12 | Only camera/motion/location requested — each core; no extra permission prompts | G7 |
| 13 | Pro unlocked **only** via StoreKit IAP; no license-key/QR/crypto side-channel | G11 |
| 14 | Subscription lasts ≥7 days and entitlement is available across the user's devices | G12 |
| 15 | Paywall shows price + renewal terms + one-line contents before purchase | G13 |
| 16 | Working **Restore Purchases** button on the paywall | G11, G12 |
| 17 | Paywall links to Terms of Use (EULA) and privacy policy | G13, G5 |
| 18 | Build is final (no placeholder); Pro IAP visible & functional to the reviewer | G14 |
| 19 | **Demo mode + demo video + review notes** for the camera flow (how to reach a valid rep) | G14 |
| 20 | Banned-term sweep of name, subtitle, keywords, description, **screenshots, and preview video** (SPEC C15 / MKT §1) | G16 |
| 21 | Original assets only; no franchise character/title/catchphrase in any field or frame | G16 |
| 22 | Age-rating questionnaire answered accurately (incl. "Medical or wellness topics"); **not** enrolled in Kids Category; export-compliance question answered (uses only standard HTTPS/OS crypto → typically exempt) | R6 (age system), G14 |
| 23 | Listing leads with the verified-XP wedge (not a bare step counter / anime-leveler clone); if vision is cut to a GPS-only build, re-review the app against 4.2/4.3(b) before submitting | G15 |

*Every Step 1 clause G1–G16 is covered by ≥1 item (verified in V3). Item 23 was
added when V3's coverage audit found G15 uncovered — Step 4 counter-move applied.*

---

## 5. Open questions

1. **HealthKit optional-read is an unmade sub-decision (ADR-5-dependent).** ADR-5
   fixed CMPedometer+CoreLocation as primary and HealthKit as *optional-read
   only*, but whether v1 actually ships the optional import is not decided. It
   changes whether `NSHealthShareUsageDescription` (checklist item 4) is present
   and whether G4's disclosure applies. *Resolves when:* the team confirms if the
   optional HealthKit import is in the v1 build.
2. **Privacy-label correctness is coupled to the ADR-6 sync decision.** v1's
   "Data Not Collected" label is only true while nothing leaves the device. If
   the ADR-6 v2 CloudKit event-mirror is pulled into v1, the Health & Fitness row
   becomes *Collected → Linked → Tracking: No* and the privacy policy (G5) + G2
   disclosure must be rewritten before submission. *Resolves when:* the v1 sync
   scope is frozen.
3. **"Verified"/anti-cheat wording sits near the 1.4.1 line.** The marketing
   promise "XP you actually earned" (SPEC C18) is legitimate as a gamification/
   form claim but must never drift into implying a validated *health measurement*.
   *Resolves when:* legal/marketing sign off that final store + in-app copy makes
   no medical-measurement claim (ties to SPEC open-question #4 and MKT risk #2).
4. **Reviewer camera testability is unproven.** Whether a reviewer can trigger a
   valid rep (or accepts the demo-mode substitute) is untested; a failure here
   reads as a broken app under 2.1 (R7). *Resolves when:* the demo mode + review
   note + demo video are built and dry-run against the setup gate.

---

## Sources

All accessed **2026-07-09**.

- App Store Review Guidelines (current; all G-rows G1–G16 — clauses 1.4.1, 2.1,
  2.5.14, 3.1.1, 3.1.2, 4.1, 4.2, 4.3, 5.1.1, 5.1.2, 5.1.3, 5.2.1) —
  https://developer.apple.com/app-store/review/guidelines/
- Apple Developer News — updated age ratings in App Store Connect (new
  4+/9+/13+/16+/18+ bands; 12+/17+ removed; "Medical or wellness topics"
  question) — https://developer.apple.com/news/?id=ks775ehf
- Apple Developer — Age Rating Updates, upcoming requirements (deadline
  2026-01-31) — https://developer.apple.com/news/upcoming-requirements/?id=07242025a
- Apple Developer News index (2026 low-quality/"do not add value" tightening,
  context for G15/4.3) — https://developer.apple.com/news/
- WebSearch test (R2): `App Store Review Guidelines 2026` — returned live results
  incl. https://developer.apple.com/app-store/review/guidelines/ and
  https://9to5mac.com/2026/06/09/apple-tightens-app-review-guidelines-against-apps-that-do-not-add-value-to-the-app-store/

*Input docs (repo): `wargames/output/product-spec.md`,
`wargames/output/features-subscription-spec.md`,
`wargames/output/market-analysis-report.md`,
`wargames/output/architecture-adr.md`.*
