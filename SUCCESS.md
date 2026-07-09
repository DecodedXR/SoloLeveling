# SUCCESS.md — The 8-Point Standard

A wargame is not a plan. A plan says *what to do*. A wargame fights your project
on paper first: it predicts what will actually happen, decides what to do when
reality disagrees, and proves the win before a cheaper model spends a single
token executing.

A mission is **properly wargamed** only when the battle plan satisfies all 8
points below. If a point is missing, the plan is a to-do list wearing camo.

Score each battle plan 0–8. Anything under 8 goes back to the genius model.

---

## 1. Expected Observations
For every step, state what the executor should *see* if the step worked —
concrete, checkable output, not a vibe. "File compiles" is weak. "`build`
exits 0 and prints `wrote dist/app.js`" is an observation.
> ✅ Each step has a named, verifiable signal.

## 2. Counter-Moves
For each expected observation, name what to do when it *doesn't* appear.
Reality diverges; a wargame that only plans the happy path is a wish.
> ✅ Every observation has a paired "if not, then ___".

## 3. Fork Triggers
Mark the decision points where the plan legitimately branches, and the exact
condition that picks a branch. No fork should depend on the executor's taste.
> ✅ Branches are chosen by conditions, not judgment.

## 4. Recon Flags
List what must be *scouted before committing* — unknowns that would invalidate
the plan if they turn out wrong. The executor checks these first, cheaply.
> ✅ Assumptions that could sink the mission are flagged for pre-flight recon.

## 5. Abort Conditions
State the tripwires that mean *stop, don't push forward*. A wargame that can't
lose is lying. Name the states where continuing does damage.
> ✅ Explicit "if you see X, halt and report" conditions exist.

## 6. Verification Runs
Define the concrete runs that *prove the mission succeeded* — commands, checks,
or observations distinct from the work itself. Doing ≠ proving.
> ✅ There is a run whose passing means the objective is met.

## 7. Red-Team Pass
The genius model attacks its own plan: where does it break, what did it assume,
what's the most likely way the executor screws it up? The findings are folded
back into the plan before it ships.
> ✅ The plan contains a section listing its own weakest points and their fixes.

## 8. Blind Executability
A cheaper model with **no extra context** can run the plan start to finish.
No "you know what I mean," no missing paths, no unstated tools. If the executor
has to ask a question, the wargame failed point 8.
> ✅ Hand it to Haiku cold. It runs without a single clarifying question.

---

## The check
```
Score: [ ]/8
Blockers: <which points failed and why>
Verdict: SHIP / BACK TO GENIUS
```

A battle plan that scores 8/8 is *blindly executable, self-defending, and
falsifiable*. That is the whole game.
