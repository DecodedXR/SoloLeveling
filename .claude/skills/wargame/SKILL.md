---
name: wargame
description: Wargame a mission to a blindly-executable battle plan before a cheaper model runs it. Use when the user says "wargame", "wargame this", "battle plan", "plan this out", "fight it on paper", or points at a file in missions/. The genius model plans, predicts, and red-teams; a cheaper model executes the result. Produces a plan scored against the 8-Point Standard in SUCCESS.md and written to wargames/.
---

# Wargame

You are a genius strategist. You do **not** solve the mission — you *plan the
fight* so a cheaper model can execute it blind, with no context but your plan.

## Steps

1. **Read the standard.** Open `SUCCESS.md`. Every plan you write must score 8/8
   against it.

2. **Get the mission.**
   - If the user named a mission file (e.g. `missions/07-bug-hunt.md`), read it.
   - If they pasted a task, use it directly.
   - If any `<blank>` in a mission brief is unfilled, ask for it before planning —
     a plan built on a blank fails point 8 (blind executability).

3. **Recon first.** List the recon flags — assumptions that would sink the plan
   if wrong. If you can cheaply check them now (read a file, run a read-only
   command), do it. Don't plan on top of an unchecked assumption.

4. **Write the battle plan.** Numbered steps. For **each step**:
   - the action (concrete, tool-level, no implied knowledge)
   - **Expected observation** — the checkable signal it worked
   - **Counter-move** — what to do if that signal doesn't appear
   Then, once, cover the plan-level points: **fork triggers**, **abort
   conditions**, and **verification runs** that prove the objective is met.

5. **Red-team your own plan.** Attack it: weakest assumption, most likely way
   the executor screws it up, what breaks under load/edge cases. Fold the fixes
   back in.

6. **Self-score.** End with:
   ```
   Score: N/8
   Blockers: <failing points, or none>
   Verdict: SHIP / BACK TO GENIUS
   ```
   If under 8/8, fix it and re-score. Do not hand off a plan below 8.

7. **Write it out.** Save to `wargames/<mission-name>.md` (e.g.
   `wargames/07-bug-hunt.md`). Then add a row to `LEDGER.md`.

## The one rule

You plan. A **different, cheaper model** executes. Leave nothing implied — if the
executor would have to ask a question, the wargame failed.
