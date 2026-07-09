<!-- SEED: re-run /impeccable document once there's code to capture the actual tokens and components. -->
---
name: Verified-XP Fitness Leveler
description: Dark game-HUD fitness leveler where the camera is the referee and every XP point is earned.
---

# Design System: Verified-XP Fitness Leveler

## 1. Overview

**Creative North Star: "The Forge Ledger"**

A dark, controlled instrument where effort is smelted into proof. The surface
is near-black and disciplined; ember gold is the only voice of value, and it
appears exactly when something was *earned* — a verified rep, a filled XP bar,
a rank promotion. The system carries two postures from PRODUCT.md: in-workout
screens are calm, distance-legible instruments (Destiny 2's clarity under
chaos is the ceiling); between-workout progression screens carry kinetic,
ceremonial confidence (Persona 5's "the interface IS the fantasy" is the
ceiling — its attitude, not its palette).

This system explicitly rejects the cheap-clone leveler look (purple-glow
gradient soup, stock "system window" clichés, asset-flip energy), sterile
SaaS dashboards (identical card grids, gray-on-white, hero metrics), and
cheerleader fitness tone rendered visually (confetti for nothing, streak-guilt
badges). Motion is responsive at baseline — state feedback only — and
choreographed *solely* for progression ceremonies (rank promotion, level-up);
every animation ships a reduced-motion crossfade alternative.

**Key Characteristics:**
- Near-black committed dark surface; color is earned, not decorative
- Ember gold / forge orange as the single accent of value
- Display face for ceremony, monospace for numbers and verdicts
- Two postures: instrument (in-workout) vs. ceremony (progression)
- Glow is budgeted, state-driven, and always attached to verified effort
- WCAG AA is a gate: ≥4.5:1 body text, no color-only signaling, 2m legibility on live screens

## 2. Colors

Committed dark: a near-black controlled surface where one saturated ember
accent carries 30–60% of the identity but a small fraction of the pixels.

### Primary
- **Ember Gold** `[to be resolved during implementation — warm gold-orange family, OKLCH, tuned to ≥3:1 on the base surface]`: the color of earned value. Verified-rep confirmations, XP gains, filled progress, rank metal, quest completion. If it isn't proof of effort, it isn't ember.

### Neutral
- **Forge Black** `[to be resolved — near-black base, a warm-tinted dark, not pure #000]`: the body surface everywhere.
- **Iron / Ash grays** `[to be resolved — 2–3 dark surface steps + one legible text gray ≥4.5:1]`: panels, dividers, secondary text.
- **Verdict pair** `[to be resolved — a pass green and a reject red, each paired with shape + label, never color-alone]`: rep verdicts and plausibility states only.

### Named Rules (optional, powerful)
**The Earned Ember Rule.** Ember gold may only mark verified outcomes — reps,
XP, ranks, completed quests. It is prohibited on chrome, decoration, empty
states, or anything the user didn't earn. Its rarity is the reward.

**The No-Purple Rule.** The violet/purple glow family is forbidden outright.
It is the cheap-clone tell and the IP-association risk in one hue.

## 3. Typography

**Display Font:** `[to be chosen at implementation — a confident, sharp display face for ranks and ceremony; premium game-grade, not an off-the-shelf "gamer" font]`
**Body Font:** `[to be chosen — a clean, highly legible sans]`
**Label/Mono Font:** `[to be chosen — a monospace with tabular figures for all numbers, verdicts, timers, and stats]`

**Character:** The display face speaks at ceremonies; the mono speaks as the
arbiter — exact, impartial, tabular. Body text stays quiet and legible.
Pairing contrasts on axis (display vs. mono), never two near-identical sans.

### Hierarchy
- **Display** `[weight/size at implementation]`: rank promotions, level-ups, screen-title moments on progression surfaces only.
- **Headline / Title**: section headers on quest board and profile.
- **Body**: supporting copy, capped at 65–75ch.
- **Label (mono)**: every number in the app — rep counts, XP, pace, timers — plus verdict text ("too shallow — didn't count"). Tabular figures mandatory so live counters never jitter.

### Named Rules (optional)
**The Arbiter Speaks Mono Rule.** All quantities and verdicts render in the
monospace. If a number appears in the display or body face, it's wrong.

**The 2-Meter Rule.** On live set and run screens, primary numerals must be
legible from ~2m: oversized mono figures, maximum contrast, no thin weights.

## 4. Elevation

Flat by default with tonal layering: depth comes from surface steps (Forge
Black → Iron panels), not drop shadows. Glow — a tight ember bloom — is the
only "shadow," and it is a state response reserved for earned moments (verdict
flash, rank ceremony, filled XP bar), never ambient decoration. If a resting
screen glows, the budget is blown.

### Named Rules (optional)
**The Glow Is a Verb Rule.** Glow appears only as a response to a verified
event, and it decays. Nothing glows at rest.

## 6. Do's and Don'ts

### Do:
- **Do** keep in-workout screens (live set, run) in instrument posture: near-black surface, oversized tabular-mono numerals, minimal motion, distance-legible from ~2m.
- **Do** spend the ceremony budget on rank promotions — the single biggest visual moment in the app — with a reduced-motion crossfade alternative.
- **Do** hold every text/background pair to WCAG AA (≥4.5:1 body, ≥3:1 large) on the dark surface; dark UIs fail here constantly and this one is a gate.
- **Do** pair every verdict and rank signal with shape + label + position, never color alone.
- **Do** use the app-as-arbiter voice in UI copy: terse, exact ("too shallow — didn't count"), built only from the allowed vocabulary (hunter, rank, quest, gate, XP, ascend).

### Don't:
- **Don't** touch the cheap-clone leveler look: "purple-glow gradient soup, stock 'system window' clichés, templated asset-flip energy" (PRODUCT.md anti-reference, verbatim).
- **Don't** drift into sterile SaaS/dashboard aesthetics: "identical card grids, gray-on-white, hero-metric templates. The fantasy dies in a dashboard."
- **Don't** render cheerleader tone visually: no confetti for opening the app, no emoji encouragement, no streak-guilt pop-ups. "The arbiter never begs."
- **Don't** use ember gold on anything unearned (The Earned Ember Rule) or any purple/violet anywhere (The No-Purple Rule).
- **Don't** use banned franchise terms in any rendered copy or asset — the banned list in `wargames/output/market-analysis-report.md` §1 is a release gate.
- **Don't** gate content visibility on animation; every reveal enhances an already-visible default, and every animation has a `prefers-reduced-motion` path.
