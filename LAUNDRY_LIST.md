# The Laundry List — 10 Ready-to-Run Wargame Orders

Ten battle-tested orders, one per domain. Each is the **full optimized prompt** —
paste it into a genius model (Fable 5 / Opus), fill the `<blanks>`, and it
produces a battle plan that meets the 8-Point Standard in `SUCCESS.md`.

**The universal frame** (every order below is this, specialized):

> You are a genius strategist wargaming a mission for a *cheaper model to
> execute blind*. Do not solve the task — plan the fight. Produce a battle plan
> that meets all 8 points in SUCCESS.md: expected observations, counter-moves,
> fork triggers, recon flags, abort conditions, verification runs, a red-team
> pass, and blind executability. Number the steps. For each step give the
> expected observation and its counter-move. End with the red-team pass and the
> 8/8 self-score. The executor has no context but this plan — leave nothing
> implied.

---

## 1 · Website Rebuild
```
Wargame rebuilding <site/page> onto <stack>, preserving <SEO/URLs/forms/pixels>.
Executor is a cheaper model with repo access only. Before any change, order recon
on current indexing, redirects, and server-side logic. Plan the migration step by
step with expected observations (Lighthouse, 301 checks, form submits) and
counter-moves. Abort if <live traffic pages 404 or rankings can't be preserved>.
Verification: <Lighthouse ≥90, every old URL 301s, all forms submit>. Meet SUCCESS.md 8/8.
```

## 2 · Sales Copy
```
Wargame writing <asset> to move <audience> from <belief> to <action> for <offer>.
Executor writes the copy blind from your plan. Order recon on the single strongest
proof element and the deal-killing objection. Plan the copy as ordered beats
(hook → promise → proof → objections → CTA), each with an expected reader reaction
and a counter-move if it falls flat. Abort if <no honest proof exists for the core
claim>. Verification: <one promise, every objection answered, CTA unambiguous,
grade <8 reading level>. Meet SUCCESS.md 8/8.
```

## 3 · Local AI Setup
```
Wargame standing up <model> on <hardware> for <workload>, <offline?>. Executor runs
shell commands blind. Order recon FIRST on VRAM-vs-model-quant fit, driver/CUDA/Metal
state, and port availability — these sink the mission if wrong. Plan install → load →
serve → persist, each with expected observation (e.g. "responds in <Ns at localhost:PORT")
and counter-move. Abort if <the model can't fit at the target quant>. Verification:
<test prompt answers under target latency and survives a reboot>. Meet SUCCESS.md 8/8.
```

## 4 · Tax Prep
```
Wargame organizing <tax year> records for <entity> into a CPA-ready package. You
organize and reconcile ONLY — no tax advice, no filing, no deduction calls; those
are abort-and-escalate. Executor sorts documents blind. Order recon on complete
account exports for the period and prior-year carryovers. Plan: gather → reconcile
each income source to bank → categorize expenses → produce a missing-doc list, each
with an expected observation (totals tie out) and counter-move. Abort if <records are
incomplete or a professional judgment is required>. Verification: <every income source
reconciled, totals tie, missing-doc list produced>. Meet SUCCESS.md 8/8.
```

## 5 · Offer Design
```
Wargame designing an offer for <product> that makes <audience> feel not-buying is
the risk, at <price>. Executor drafts the offer blind. Order recon on the outcome
the buyer actually pays for and the true price objection. Plan the build: core →
value stack → guarantee → urgency, each with an expected "so what" test result and a
counter-move if it flops. Abort if <margin floor is broken or delivery can't scale>.
Verification: <value stack > price by Nx, one-sentence pitch survives "so what?",
guarantee is honest and specific>. Meet SUCCESS.md 8/8.
```

## 6 · Chatbot
```
Wargame building a <type> chatbot answering <question types> from <source>, escalating
on <condition>. Executor wires it blind. Order recon on knowledge-source cleanliness,
the human escalation path, and the top 10 real questions. Plan: ingest → prompt/guardrails
→ escalation → logging → fallback, each with an expected observation and counter-move.
Abort if <the knowledge source is stale or the refuse-set can't be enforced>.
Verification: <answers the test set, refuses/escalates the out-of-scope set, logs
every turn, degrades gracefully on unknowns>. Meet SUCCESS.md 8/8.
```

## 7 · Bug Hunt
```
Wargame finding and fixing <symptom> in <repo>, without breaking <constraint>. Executor
debugs blind from your plan. Order recon on reproducibility (reliable vs intermittent)
and blast radius (one bug vs all callers of the shared function). Plan: reproduce with a
failing test → isolate root cause → fix at the shared choke point → verify, each with an
expected observation and counter-move. Abort if <the fix requires touching the forbidden
constraint or the bug can't be reproduced>. Verification: <failing test now passes, full
suite stays green>. Fix the root cause, not the symptom path. Meet SUCCESS.md 8/8.
```

## 8 · Model Migration
```
Wargame migrating <system> from <old model> to <new model> with no regression in <X>.
Executor swaps and validates blind. Order recon on an eval set (build one if absent),
prompt reliance on old-model quirks, and API/tool-format differences — read the new
model's docs, don't guess. Plan: build eval baseline → swap behind a flag → run eval →
compare → keep-or-rollback, each with expected observation and counter-move. Abort if
<eval drops below baseline or tool calls stop parsing and can't be fixed by compat shim>.
Verification: <eval ≥ baseline, all tool calls parse, cost/latency within ceiling, flagged
rollback works>. Meet SUCCESS.md 8/8.
```

## 9 · Competitor Teardown
```
Wargame tearing down <competitor> to find an exploitable gap in <niche>. Public info only —
no scraping gated data, no impersonation (that's an abort). Executor gathers and analyzes
blind. Order recon on their reviews (top complaints), funnel friction (walk it), and unserved
segments. Plan: map offer/price/funnel/hook → mine reviews → walk the funnel → name the gap,
each with an expected observation and counter-move. Abort if <the only edge requires copying
protected assets>. Verification: <teardown names offer+price+funnel+hook, lists 3 real
weaknesses, and 1 wedge actionable this month>. Meet SUCCESS.md 8/8.
```

## 10 · Automation
```
Wargame automating <process> so <trigger> produces <outcome> with zero manual steps.
Executor builds it blind. Order recon on whether every system has an API/hook or is
screen-only, idempotency/retry needs, and rate limits. Plan: trigger → fetch → transform →
act → verify/alert, each with an expected observation and counter-move; keep <sends/payments/
deletes> human-approved. Abort if <a required system has no automatable surface or failure
could double-charge/lose data>. Verification: <dry-run produces the outcome with no manual
step, failures alert instead of dropping silently>. Meet SUCCESS.md 8/8.
```

---

**How to use one:** copy the block, fill every `<blank>`, paste into a genius
model with `SUCCESS.md` in context, and tell it to write the plan to
`wargames/<n>-<name>.md`. Then execute blind on a cheaper model. Log it in
`LEDGER.md`.
