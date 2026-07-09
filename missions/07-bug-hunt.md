# Mission 07 — Bug Hunt

**Objective:** Find and fix `<the bug: symptom>` in `<system/repo>` without
`<what must not break>`.

**Situation**
- Symptom (what's observed): `<...>`
- When it started / what changed: `<...>`
- Repro steps (if known): `<...>`
- Repo / files suspected: `<...>`

**Constraints**
- Can't touch: `<prod data, public API, ...>`
- Must keep passing: `<existing tests, other features>`

**Definition of Victory**
- `<measurable: a failing test reproduces the bug, the fix makes it pass, full suite stays green>`

**Known Unknowns (recon candidates)**
- Is it reliably reproducible or intermittent? `<check>`
- One bug or a class of them (all callers)? `<check>`
- Data issue or logic issue? `<check>`

**Out of Scope:** `<refactors, unrelated cleanup, new features>`

---
**Order:** `Read SUCCESS.md and this mission. Wargame it to the 8-Point Standard. Write the plan to wargames/07-bug-hunt.md.`
