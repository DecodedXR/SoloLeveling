# Product

## Register

product

## Users

Anime fans and lapsed gym-goers (teens through early 30s, heavy TikTok/YouTube
anime-fitness audience) who love the "level up in real life" fantasy but are
tired of leveling apps they can cheat. Context of use is physical and hostile
to fiddly UI: phone propped ~2m away on a gym or bedroom floor, user mid-set,
sweaty, glancing from distance. The job to be done: do a real workout, have it
*proven* real, and feel the progression fantasy pay off (XP, ranks E→S, stats)
without ever being able to fake it.

Two usage postures: **in-workout** (live set screen, run screen — glanceable,
distance-legible, hands-free) and **between-workouts** (quest board, profile,
rank-ups — the dopamine surfaces, browsed up close).

## Product Purpose

A verified-XP fitness leveler: the phone camera is the referee (pose detection
judges each rep valid/invalid), GPS/steps verify runs and walks, and every XP
point folds from an append-only event log of verified effort. No honor-system
XP source exists anywhere in the product. Success = users level up daily on
the free loop, trust the numbers ("XP you actually earned"), and convert to
Pro for breadth (more verified exercises, ranks B→S, advanced history) — never
because the core loop is walled.

Canonical design source: `wargames/output/product-spec.md` (screen map, XP
economy, free/Pro split, constraint ledger). Engineering truth:
`wargames/workout-tracker-verification.md`. Market/IP truth:
`wargames/output/market-analysis-report.md`.

## Brand Personality

**Earned. Arcane. Precise.** The app is a dark game-HUD: the leveling fantasy
IS the aesthetic — glowing rank badges, quest-log framing, stat panels — built
with the polish of a premium action-RPG menu (clean dark panels, crisp type,
deliberate glow), not a mobile-game asset flip. Emotional goals: the gravity
of a rank promotion should feel ceremonial; a verified rep should feel like a
judge's gavel — instant, impartial, satisfying. The voice is the app-as-
arbiter: terse, exact, never pleading ("too shallow — didn't count", not
"almost! try again! 💪").

UI copy must use its own fantasy voice built from the allowed vocabulary
(hunter, rank, quest, gate, XP, ascend) and must never use franchise-
trademarked terms — the banned list lives in
`wargames/output/market-analysis-report.md` §1 and is a release gate.

## Anti-references

- **The cheap-clone levelers** (existing anime-leveling fitness apps): purple-
  glow gradient soup, stock "system window" clichés, templated asset-flip
  energy. This product must read as crafted; looking like them also invites
  the IP association we legally must avoid.
- **Sterile SaaS/dashboard aesthetics**: identical card grids, gray-on-white,
  hero-metric templates. The fantasy dies in a dashboard.
- **Cheerleader fitness-app tone** (streak-guilt pop-ups, emoji encouragement,
  "you got this!"): the arbiter never begs. Motivation comes from earned
  progression, not nagging.

## Design Principles

1. **The referee is the brand.** Verification moments (rep verdict, plausibility
   check, the untrusted-frame freeze) are the product's signature — design them
   as first-class ceremony, never as error states to hide.
2. **Two postures, two intensities.** In-workout surfaces are glanceable
   instruments: distance-legible, high-contrast, minimal motion. Between-
   workout surfaces carry the full game-HUD drama. Never let the drama leak
   into the instrument.
3. **Earned, never given.** No UI moment may imply unearned progress — no
   confetti for opening the app, no XP for showing up. Celebration scales with
   verified effort; the biggest visual ceremony in the app is a rank promotion.
4. **Honest state, always.** The system never fakes certainty: untrusted frames
   freeze the counter ("hold on…"), rejections say why ("too shallow"), and
   feedback is inline, never modal, never interrupting a set.
5. **Premium dark, disciplined glow.** Glow and drama are budgeted accents on a
   controlled dark surface — the difference between an action-RPG menu and a
   clone-app gradient wash is restraint.

## Accessibility & Inclusion

WCAG AA as a gate: ≥4.5:1 body-text contrast (≥3:1 large text) — load-bearing
on dark surfaces where clone apps fail; every animation has a
`prefers-reduced-motion` alternative (rank ceremony included: crossfade, not
skipped); rank tiers and rep verdicts never signaled by color alone (shape +
label + position); live set/run screens designed for ~2m viewing distance
(large numerals, high contrast); verdict feedback also delivered via
haptic/audio so mid-set users never need to watch the screen.
