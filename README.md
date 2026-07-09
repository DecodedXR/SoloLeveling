# SoloLeveling — The Fable Wargame Kit

Fight your project on paper before a cheaper model executes it.

A **genius model** (Fable 5 / Opus) writes a *battle plan* — a wargame that
predicts what will happen, plans counter-moves, and proves the win. A **cheaper
model** (Sonnet / Haiku) then executes it blindly, no thinking required. You get
genius-grade planning at commodity execution cost.

---

## Quick Start (under 5 minutes)

1. **Pick a mission.** Open `missions/` and choose the brief that matches your
   task (website rebuild, sales copy, bug hunt, ...). 10 domains ship in the box.

2. **Fill the blanks.** Each mission is a fill-in-the-blank brief. Replace every
   `<...>` with your specifics. Takes 2 minutes.

3. **Point the genius model at it.** In Claude Code, on a genius model:
   ```
   Read SUCCESS.md and missions/07-bug-hunt.md.
   Wargame this mission to the 8-Point Standard.
   Write the battle plan to wargames/07-bug-hunt.md.
   ```

4. **Verify it scores 8/8.** The plan must satisfy every point in `SUCCESS.md`.
   Under 8 → send it back. A wargame that can't lose is lying.

5. **Execute blind.** Switch to a cheaper model, hand it *only* the battle plan:
   ```
   Execute wargames/07-bug-hunt.md exactly. Follow the counter-moves and
   abort conditions. Do not improvise.
   ```

6. **Log it.** Add a row to `LEDGER.md`. Every run tracked, win or abort.

---

## What's in the box

| File / Folder      | What it is |
|--------------------|-----------|
| `SUCCESS.md`       | The 8-Point Standard — the definition of a properly wargamed mission. |
| `LAUNDRY_LIST.md`  | 10 ready-to-run wargame orders, one per domain, with the full optimized prompt. |
| `missions/`        | 10 fill-in-the-blank mission briefs. |
| `wargames/`        | Empty. Where the battle plans land. |
| `LEDGER.md`        | Tracks every run: mission, models, score, outcome. |

---

## The one rule

> The genius model plans. The cheap model executes. **They are never the same
> model.** If you let the executor think, you paid genius prices for nothing.
