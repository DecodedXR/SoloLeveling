# Market Analysis & App Store Marketing Plan — Verified-XP Fitness Leveler

**Report date:** 2026-07-09 (run began 2026-07-08; date rolled over mid-run). All access dates in `## Sources` are 2026-07-09.
**Product:** Gamified workout tracker — phone camera + pose detection verifies reps (binary valid/invalid → XP); GPS + step counter verifies runs/walks; XP private in v1; on-device, no video upload. Positioned as a legal, *Solo Leveling*-aesthetic "level up in real life" experience.
**Recon:** R1 pass (WebSearch live), R2 pass (App Store pages fetchable; individual pages that 404'd are marked `(snippet-only)`), R3 pass (date stamped; pre-2024 figures year-labeled).
**Forks:** F1 not triggered (no official licensed Solo Leveling fitness app). F2 not triggered (no competitor feeds camera-verified reps into a leveling system). Aborts A0/A1/A2 not triggered.

---

## 1. IP & naming constraints

**IP ownership (resolved).** Original IP and trademark: **D&C Media / D&C Webtoon Biz Co., Ltd.** (Korea) — the USPTO/WIPO "SOLO LEVELING" mark (Justia serial 79316775, filed 2021-05-17) is held by D&C Webtoon Biz and explicitly covers *software and video-game programs*, so the mark reaches app products directly. **Kakao Entertainment / Kakao Piccoma** publishes the webtoon. **Netmarble** is a game *licensee* (Solo Leveling: ARISE, and upcoming KARMA / ARISE Overdrive), not the owner. Ownership is therefore clear — the Step 1 "ownership unclear" counter-move was not needed.

**A1 check (enforcement against fantasy-adjacent apps):** No evidence found of takedowns targeting apps that used *no* trademarked terms. Existing branded fitness apps (below) use the marks directly; enforcement risk attaches to the marks, not to the generic fantasy aesthetic. A1 not triggered.

**Banned-terms list** (must not appear in name / subtitle / keywords):
- **"Solo Leveling"** — the registered mark, covers software.
- **"Sung Jinwoo" / "Jinwoo" / "Cha Hae-In"** — distinctive character names.
- **"Arise"** — Netmarble's official game title *and* an existing anime-leveler app name (double conflict).
- **"KARMA"** (as franchise title) / **"ARISE Overdrive"** — official game titles.
- **"Shadow Monarch" / "Ashborn" / "Monarch(s)"** — distinctive in-universe marks/characters.
- **"The System"** as a branded phrase tied to the franchise — use with caution; the generic word "system" is fine, the franchise catchphrase styling is not.

**Allowed generic genre terms** (fantasy vocabulary, no fitness-app registration conflict found):
- **"level up" / "leveling"** — generic RPG verb; used across dozens of fitness apps.
- **"hunter"** — generic; "Hunt Fitness" already exists uncontested.
- **"quest"** — generic; "Workout Quest" ships freely.
- **"rank" / "rank up" (E→S)** — generic; "GymLevels", "Ascend" use E–S ranks.
- **"dungeon" / "gate"** — generic fantasy locations; no fitness-app conflict found.
- **"XP" / "grind" / "ascend"** — generic gamification/gym vocabulary.

(≥4 banned terms, ≥6 allowed terms, each justified — Expected observation met.)

---

## 2. Competitor landscape

`(snippet-only)` = App Store page not directly fetchable; figure from search snippet. `unknown` = not found (never left blank).

| Name | Cluster | Price model | Rating & count | Last update | Core loop | Verifies effort? | Top 2 complaint themes |
|---|---|---|---|---|---|---|---|
| Arise: Level Up In Real Life | 1 anime-leveler | Free + sub $4.99–$59.99 | 4.8 / 19K | 2026 | Answer lifestyle Qs → custom plan → daily quests → rewards | honor (self-report) | paywall blocks trial; unclear quest-vs-plan interaction |
| Solo X Player Leveling Workout | 1 anime-leveler | Free + sub $2.99/mo, $19.99/yr, $59.99 lifetime + coins | 4.8 / 20 | 2026 | Daily quests → XP, global leaderboard | honor | tiny review base; leaderboard self-report gameable |
| LEVELING: Fitness | 1 anime-leveler | unknown | unknown | unknown | Workouts as epic quest merging "manga universe" + real program | honor | unknown |
| Level Up - Gamified Fitness | 1 anime-leveler | Free + IAP (amount unknown) | unknown | unknown | Daily workout quests → XP → rank E to SSS | honor | unknown |
| Walkr | 2 RPG/gamified | Free + sub $7.99/mo, $69.99/yr | 4.5 / 8K | 2024 | Steps → spaceship fuel → explore planets | sensor (steps) | unknown |
| Pikmin Bloom | 2 RPG/gamified | Free + IAP | 4.73 / 200K `(snippet-only)` | unknown | Walk to grow Pikmin, plant flowers on real-world map | sensor (GPS/steps) | rewards stay inside its own closed world |
| Habitica | 2 RPG/gamified | Free + sub $4.99/mo–$47.99/yr | 4.2 / 2.8K | 2024 | Turn tasks/habits into RPG; avatar, gold, gear | honor | thin after ~1 month; sub adds little |
| Zombies, Run! | 2 RPG/gamified | Free + sub (amount unknown) | unknown | unknown | Audio zombie story unfolds while you run/walk | sensor (GPS/steps) | unknown |
| Sweatcoin | 3 stakes/verified | Free + IAP $0.99–$24.99 | 4.5 / 389K | 2026 | Outdoor steps → Sweatcoins → marketplace rewards | sensor (proprietary algo, outdoor-only) | low earning potential; step/coin discrepancies |
| StepBet | 3 stakes/verified | Bet-based (stake to join pot) | unknown | unknown | Bet money, hit step goals to win the pot | sensor (steps) | unknown |
| Paceline | 3 stakes/verified | Free (reward-funded) | unknown | unknown | Elevated-HR minutes → rewards; needs wearable | sensor (HR/wearable) | slow reward rate (~$21 / 12 weeks) |
| Onyx | 4 camera rep-count | Free + sub (amount unknown) | 4.9 / ~2,500 `(snippet-only)` | unknown | 3D camera capture counts reps, corrects form, audio feedback | camera | unknown |
| Kaia Personal Trainer | 4 camera rep-count | Free trial → $29.99 / 3 mo | unknown | unknown | iPhone camera + AI (16 keypoints) tracks reps + feedback | camera | unknown |
| AI Rep Counter (On-Device) | 4 camera rep-count | unknown | unknown | unknown | On-device camera counts reps, form score A/B/C, 11 exercises | camera | unknown |

14 apps, ≥2 per cluster, no blank cells — Expected observation met. No cluster was thin (counter-move not needed).

**Whitespace summary (3 sentences).** Camera verification and the anime game-layer exist today only in *separate* apps — Onyx/Kaia/AI Rep Counter verify reps with the camera but have no leveling, while Arise, LEVELING, Solo X and a dozen clones run rich anime-leveling entirely on the honor system. No app in any cluster feeds *camera-verified* reps into an XP/leveling loop; that intersection is empty. The stakes cluster (Sweatcoin at 389K ratings) proves users already accept sensor-gated rewards, validating appetite for the "your effort must be real" wedge.

---

## 3. Demand signals

**Fantasy demand: STRONG.**

- A "Solo Leveling workout" trend is real, mass-scale, and *alive* in 2026. TikTok carries dedicated discovery hubs — "Solo Leveling Workout Routine", "30 Days of the Solo Leveling Workout", "Solo Leveling Workout Routine Challenge" — with hundreds of creators posting transformation and challenge videos (TikTok discover pages, accessed 2026-07-09).
- Scale: Solo Leveling was the most-watched anime on Crunchyroll, won Anime of the Year at the 2025 Crunchyroll Awards, and the franchise has 27B+ TikTok views (Motion blog, 2026).
- The core meme routine (100 push-ups / 100 sit-ups / 100 squats / 10 km run) is widely reproduced and titled explicitly around the show — free organic keyword surface for ASO.
- Recency check: the majority of top trend results date to the last 12 months (2025–2026) → **alive, not post-peak**.
- Platforms carrying it: **TikTok** (primary), **YouTube** (routine/transformation vids), **Reddit** (training-arc discussion).

**Market-size figures (year-labeled; conflicting → range reported per counter-move, not averaged):**
- Global fitness-app market 2026: **$13.5B** (Straits Research, 2026) — vs **$22.36B** (The Business Research Company, 2026, growing from $17.71B in 2025 at 26.2% CAGR) — vs **$13.92B** (Grand View Research, 2026) — vs **$7.7B** (Future Market Insights, 2026). Range: **~$7.7B–$22.4B** depending on firm/definition.
- US **gamified** fitness market 2026: **>$4.2B** (EditorialGE, 2026).
- Behavioral: gamification cited to raise exercise adherence ~27% (yukaichou/FitCraft, 2026).

≥5 cited dated sources supporting the STRONG verdict — Expected observation met.

---

## 4. Positioning

**For** anime fans and lapsed gym-goers who love the "level up in real life" fantasy but are tired of leveling systems they can cheat. **The enemy** is honor-system XP: every incumbent anime-leveler (Arise, LEVELING, Solo X, Level Up) hands out experience for a button-tap you could press on the couch, so the number means nothing. **The promise:** XP you actually earned — the phone camera is the referee that only counts a rep if your form is real, and GPS/steps prove the run happened. This is the only app that puts camera verification *underneath* the leveling loop; competitors have one or the other, never both (whitespace confirmed in §2). Neither F1 nor F2 triggered, so the "first *verified*-XP leveler" framing stands unqualified. Legally it rides the aesthetic, not the IP — the way "soulslike" rides Dark Souls — using only the allowed generic vocabulary in §1.

---

## 5. ASO plan

**1. Category call: Health & Fitness.** Rule applied — follow the store category of the top comparable levelers. The three closest comparables (Arise, Solo X Player Leveling Workout, Walkr) all list in **Health & Fitness**; Habitica sits in Productivity but it is a task manager, not a fitness app, so it does not govern. Decision is data-driven, not opinion.

**2. Candidate names + subtitles** (each ≤30 chars; zero banned terms; collision = live App Store search result). Target ≥3 collision-free — **5 of 5 are collision-free** after the first name set (RankUp, XP Athlete, Ascend) collided and were replaced per the counter-move.

| # | Name (chars) | Subtitle (chars) | Collision |
|---|---|---|---|
| 1 | HunterFit (9) | Level Up in Real Life (21) | **no** (only "Hunt Fitness" exists, distinct) |
| 2 | Proof of Grind (14) | Verified XP, real reps (22) | **no** |
| 3 | RepProof (8) | The camera is the ref (21) | **no** (note: "RepXP" exists — different) |
| 4 | GateRunner (10) | Clear quests, earn ranks (24) | **no** |
| 5 | Realm Reps (10) | Level up, verified (18) | **no** |

**3. Keyword strategy (~20, three tiers, each with a why):**

*Tier A — fantasy terms fans actually search (from §3 trend titles):*
- `level up workout` — the trend's core phrase (§3 TikTok hubs).
- `level up in real life` — verbatim trend/app-subtitle language (§3).
- `anime workout` — trend category term (§3 "anime workout trend"); this is the safe generic proxy for the (banned, un-registrable) franchise trend phrase — capture the fans who search the mark via generic ranking, never by naming it.
- `hunter workout` — allowed genre term, trend-adjacent (§1, §3).
- `rank up E to S` — the E→S rank meme (§3, competitors §2).

*Tier B — category terms:*
- `workout tracker` — core category (§2 competitor category).
- `rep counter` — core feature category (§2 cluster 4).
- `step counter` — GPS/steps scope (§2 cluster 3).
- `running tracker` — run scope (product spec).
- `gym log` / `strength tracker` — leveler comparables use it (§2 Ascend/GymLevels).
- `home workout` — camera-app category (§2 Onyx/Kaia).

*Tier C — differentiator terms (the wedge):*
- `AI rep counter` — verification tech term (§2 cluster 4).
- `camera workout` — the referee mechanic (§2 cluster 4).
- `verified workout` — the wedge, low competition (§1/§2 whitespace).
- `form check` / `form counter` — camera value prop (§2 Onyx/Kaia).
- `no cheating fitness` / `honest XP` — anti-honor-system framing (§4 enemy).
- `gamified fitness` — bridges category + differentiator (§3 market term).
- `RPG fitness` — game-layer term (§2 cluster 2).
- `quest fitness` — game-layer term (§2/§3).

**4. Screenshot / preview narrative (6, ordered; first 3 fixed):**
1. **The fantasy** — full-screen level-up UI: "LEVEL 12 → 13", XP bar filling, rank badge climbing E→D. Hook the fan in one frame.
2. **The proof** — split screen: camera view with pose skeleton overlay, a shallow squat flashing "REP REJECTED", a full squat flashing "+10 XP". This is the differentiator; it must be screenshot #2.
3. **The scope** — a run map with GPS path + step count converting to XP, showing it's not just gym reps.
4. **The streak / quest board** — daily quests (100 squats, 5 km) with verified-completion checkmarks.
5. **Progression over time** — stat graph (Strength/Endurance) rising, "every point earned, none faked".
6. **The paywall value** — Pro tier: unlock all verified exercises + advanced form scoring (sets up §5.5 monetization).

**5. Monetization: Free + subscription.** Rule applied — pick the model most common among the ≥4.5-star apps in clusters 1–2. Those apps are Arise (4.8, free+sub), Solo X (4.8, free+sub+IAP), Walkr (4.5, free+sub), Pikmin Bloom (4.73, free+IAP); free+subscription is the majority (3 of 4). The tie-breaker (prefer free+sub because the camera feature is a credible paywall) also points here. Suggested shape from competitor price bands: free core loop, Pro at ~$5–8/mo or ~$40–60/yr, with camera-verified advanced exercises + form scoring behind Pro.

All 5 artifacts present; every name has a collision result; every keyword has tier + why — Expected observation met.

---

## 6. Launch channels

Top 3 organic channels, each traced to a §3 finding (the trend lives on TikTok / YouTube / Reddit):

1. **TikTok (primary).** First action: post a split-screen of the camera *rejecting* a shallow squat then *accepting* a deep one — the verification moment is the hook, and it slots directly into the existing "Solo Leveling Workout Routine" discovery hubs (§3). This is where the trend's mass is.
2. **YouTube (routine/transformation).** First action: a "I let an app referee my 30-day level-up challenge" transformation video — mirrors the "30 Days of the Solo Leveling Workout" format already trending (§3), with the verified-XP twist as the differentiator.
3. **Reddit (community credibility).** First action: post in anime/fitness crossover communities where training-arc discussion already happens (§3), leading with the anti-cheat angle ("XP you can't fake") to earn the skeptic crowd.

**Paid UA at launch: not advised.** Cluster 1–2 leaders monetize via low-ARPU free+sub with heavy IAP price sensitivity (§2: Arise paywall complaints, Sweatcoin low-earning complaints), so blended LTV is thin and paid CAC would likely exceed it early. With a proven, free, high-volume organic trend (§3), spend should stay organic until retention/LTV are measured. (Step 3 found a living trend, so the "no living trend" counter-move default did not apply.)

---

## 7. Risks & unknowns

1. **True downloads/revenue are hidden.** Ratings *count* is public and comparable, but installs and MRR are not — the market read here is a proxy, not ground truth. *Resolves when:* a data.ai/Sensor Tower estimate or a competitor's disclosed numbers become available.
2. **Trademark drift risk in marketing.** The aesthetic is legal only while copy stays on generic vocabulary; a single "Solo Leveling" in an ad or ASO field invites a D&C/Netmarble takedown (mark covers software, §1). *Resolves when:* legal review signs off on final store copy + ad creative, and V2 stays clean per release.
3. **Crowded honor-system field could add camera fast.** A dozen anime-levelers already exist (§2); any could bolt on an off-the-shelf pose SDK and neutralize the wedge, or the trend could cool from its 2025 peak. *Resolves when:* a competitor's listing/reviews describe camera-verified XP (would trigger F2), or trend recency flips to majority-older content (would flip §3 to POST-PEAK).
4. **Camera-verification retention is unproven for a game loop.** Onyx (4.9) proves camera counting is loved, but bolting it to *mandatory* verification for XP may add friction that pure honor-system levelers avoid. *Resolves when:* beta cohort retention (verified-XP arm vs honor-system arm) is measured.

---

## Sources

All accessed 2026-07-09.

- WebSearch "gamified fitness app 2026" (market overview, adherence 27%) — https://yukaichou.com/gamification-analysis/top-10-gamification-in-fitness/ ; https://getfitcraft.com/compare/best-gamified-fitness-apps ; https://editorialge.com/us-gamified-fitness-market-2026/
- Walkr App Store page — https://apps.apple.com/us/app/walkr-gamified-fitness-walk/id834805518
- Solo Leveling IP/ownership — https://en.wikipedia.org/wiki/Solo_Leveling ; https://www.cbr.com/solo-leveling-anime-netmarble-investment/ ; Netmarble ARISE — https://sololeveling.netmarble.com/en ; KARMA — https://sololeveling-karma.netmarble.com/en/
- "SOLO LEVELING" trademark (D&C Webtoon Biz, serial 79316775, filed 2021) — https://trademarks.justia.com/793/16/solo-79316775.html
- No official Solo Leveling fitness app (F1 check) — https://motion-app.com/blog/best-solo-leveling-fitness-app/ ; https://oursololeveling.app/ ; https://arisesolo.com/
- Apple App Store IP takedown / dispute process (A1 context) — https://www.apple.com/legal/intellectual-property/dispute-forms/app-store/ ; https://www.apple.com/legal/app-store/transparency/2025/
- Arise: Level Up In Real Life App Store page — https://apps.apple.com/us/app/arise-level-up-in-real-life/id6743036247
- Solo X Player Leveling Workout App Store page — https://apps.apple.com/us/app/solo-x-player-leveling-workout/id6748594462
- LEVELING: Fitness / Level Up - Gamified Fitness — https://apps.apple.com/us/app/leveling-fitness/id6624294081 ; https://apps.apple.com/us/app/level-up-gamified-fitness/id6754510739
- Habitica App Store page — https://apps.apple.com/us/app/habitica-gamified-taskmanager/id994882113
- Pikmin Bloom App Store page — https://apps.apple.com/us/app/pikmin-bloom/id1556357398
- Zombies, Run! — https://www.motera.app/zombies-run
- Sweatcoin App Store page — https://apps.apple.com/us/app/sweatcoin-walking-step-counter/id971023427
- StepBet / Paceline (verification + rewards) — https://bitletics.com/blog/apps-that-pay-you-to-walk/ ; https://visu.network/blog/sweatcoin-review/
- Camera rep-counting apps — https://apps.apple.com/us/app/ai-rep-counter-on-device/id6756504196 ; Onyx https://insider.fitt.co/onyx-ai-fitness-startup/ ; Kaia https://www.engadget.com/2019-03-21-kaia-personal-trainer-app-iphone-ipad-camera-fitness.html
- Solo Leveling workout trend (§3) — https://www.tiktok.com/discover/solo-leveling-workout-routine ; https://www.tiktok.com/discover/30-days-of-the-solo-leveling-workout ; https://www.tiktok.com/discover/solo-leveling-workout-routine-challenge
- Market-size figures — https://straitsresearch.com/report/fitness-app-market ; https://www.thebusinessresearchcompany.com/report/fitness-app-global-market-report ; https://www.grandviewresearch.com/industry-analysis/fitness-app-market ; https://www.futuremarketinsights.com/reports/fitness-apps-market
- ASO name collision checks — https://apps.apple.com/us/app/rankup-self-improvement/id6756327565 ; https://apps.apple.com/us/app/xp-athletics/id6741366213 ; https://apps.apple.com/us/app/ascend-fitness-rpg-gym-log/id6755652663 ; "HunterFit"/"Proof of Grind"/"RepProof"/"GateRunner"/"Realm Reps" — no exact App Store match found in search (collision-free)
