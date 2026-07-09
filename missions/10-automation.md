# Mission 10 — Automation

**Objective:** Automate `<manual process>` so `<who>` stops doing `<the toil>`
and `<trigger>` produces `<outcome>` reliably.

**Situation**
- The process today (step by step): `<...>`
- How often / how long it takes: `<...>`
- Tools involved: `<apps, sheets, email, APIs>`
- Trigger: `<time, event, manual>`

**Constraints**
- Systems it must touch (and their limits): `<rate limits, auth, no API?>`
- What must stay human-approved: `<sends, payments, deletes>`
- Failure must not: `<double-charge, spam, lose data>`

**Definition of Victory**
- `<measurable: trigger fires → outcome produced with zero manual steps, a dry-run mode exists, failures alert instead of silently dropping>`

**Known Unknowns (recon candidates)**
- Does every system have an API / hook, or is it screen-only? `<check>`
- What's the failure/retry behavior needed? `<idempotent?>`
- Volume and rate limits? `<check>`

**Out of Scope:** `<rebuilding the underlying tools, unrelated processes>`

---
**Order:** `Read SUCCESS.md and this mission. Wargame it to the 8-Point Standard. Write the plan to wargames/10-automation.md.`
