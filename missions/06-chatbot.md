# Mission 06 — Chatbot

**Objective:** Build a `<support / sales / internal>` chatbot that answers
`<question types>` from `<knowledge source>` and `<escalates / converts>` when
`<condition>`.

**Situation**
- Channel: `<website widget, WhatsApp, Slack, ...>`
- Knowledge source: `<docs, FAQ, DB, site>`
- Volume: `<expected conversations/day>`
- Existing stack: `<platform, LLM, none>`

**Constraints**
- Must not answer: `<topics to refuse / escalate>`
- Latency / cost ceiling: `<...>`
- Data / privacy rules: `<...>`

**Definition of Victory**
- `<measurable: answers N test questions correctly, refuses/escalates the out-of-scope set, logs conversations, falls back cleanly on unknowns>`

**Known Unknowns (recon candidates)**
- Is the knowledge source clean and current? `<check>`
- What's the escalation path to a human? `<define>`
- What are the top 10 real questions? `<pull from logs>`

**Out of Scope:** `<CRM integration, multilingual, voice>`

---
**Order:** `Read SUCCESS.md and this mission. Wargame it to the 8-Point Standard. Write the plan to wargames/06-chatbot.md.`
