# Mission 03 — Local AI Setup

**Objective:** Stand up `<local model / stack>` on `<hardware>` so that
`<workload>` runs `<offline / private / cheap>` at `<acceptable speed>`.

**Situation**
- Hardware: `<CPU/GPU, VRAM, RAM, OS>`
- Use case: `<chat, RAG, coding, batch>`
- Data sensitivity: `<why local>`
- Existing tooling: `<Ollama, LM Studio, none>`

**Constraints**
- Must run offline: `<y/n>` · Max cost: `<...>` · Model licenses: `<...>`
- Latency / throughput target: `<tokens/s, requests/min>`

**Definition of Victory**
- `<measurable: model answers a test prompt in <Ns, survives reboot, reachable at localhost:PORT>`

**Known Unknowns (recon candidates)**
- Does the hardware fit the model at the target quant? `<VRAM math>`
- Driver / CUDA / Metal state? `<check>`
- Will it need to serve other apps (API)? `<check>`

**Out of Scope:** `<fine-tuning, multi-node, production hosting>`

---
**Order:** `Read SUCCESS.md and this mission. Wargame it to the 8-Point Standard. Write the plan to wargames/03-local-ai-setup.md.`
