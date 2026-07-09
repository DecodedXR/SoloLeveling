# Mission 08 — Model Migration

**Objective:** Migrate `<system>` from `<old model>` to `<new model>` so that
`<quality holds / cost drops / speed improves>` with `<no regression in X>`.

**Situation**
- Where the model is called: `<files / services>`
- Current model & why moving: `<cost, deprecation, quality>`
- Target model: `<id>`
- Prompts / tools / schemas in play: `<...>`

**Constraints**
- Output format that must stay identical: `<JSON schema, tone, length>`
- Budget / latency ceiling: `<...>`
- Rollback plan required: `<y/n>`

**Definition of Victory**
- `<measurable: eval set scores ≥ baseline, all tool calls still parse, cost/latency within ceiling, flag-guarded rollback exists>`

**Known Unknowns (recon candidates)**
- Is there an eval set to compare against? `<build one if not>`
- Do prompts rely on old-model quirks? `<check>`
- API param / tool-format differences? `<check the model's docs>`

**Out of Scope:** `<prompt redesign beyond compatibility, new features>`

---
**Order:** `Read SUCCESS.md and this mission. Wargame it to the 8-Point Standard. Write the plan to wargames/08-model-migration.md.`
