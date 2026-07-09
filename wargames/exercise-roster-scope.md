# Exercise Roster — Scope Decisions

The verified-exercise roster and why each candidate is in, sequenced, or
out. F17's admission rule governs: an exercise ships only when its own
state machine passes the corpus protocol (ENG §5). Nothing here overrides
that; this memo records which candidates get a wargame at all.

## Wargamed (each has an 8/8 plan + ledger row)

| Exercise | Tier | Plan | Sequenced after | Why this order |
|---|---|---|---|---|
| Squat | Free | `workout-tracker-verification.md` | — | The kill test itself |
| Push-up | Free | `pushup-pipeline.md` | squat WIN | Mandated second exercise (C12); prone-posture scout |
| Sit-up | Pro #1 | `situp-pipeline.md` | push-up resolved | Completes the meme routine; supine scout |
| Lunge | Pro | `lunge-pipeline.md` | squat WIN | Cheapest add: standing, reuses squat calibration + signal; no scout |
| Pull-up | Pro | `pullup-pipeline.md` | squat WIN | Named in the paywall copy; hanging-pose scout + bar logistics |
| Jumping jack | Pro | `jumpingjack-pipeline.md` | squat WIN | Standing, no scout; fast-motion risk (fps, per-exercise detector caps) |
| Glute bridge | Pro | `glutebridge-pipeline.md` | sit-up resolved | Supine; inherits sit-up's posture evidence |

Human recording cost: one scout clip per novel posture, then ~1 corpus
evening per exercise. Lunge and jumping jack need no scout.

## Scoped out (not wargamed; revisit conditions named)

- **Burpee.** Multi-phase compound (stand → squat → plank → push-up → jump):
  it needs either chained per-phase state machines (new infrastructure, new
  failure modes at every phase boundary) or free-running sequence detection
  (on the ENG kill list). The framing alone is disqualifying at v1: full
  standing body AND floor plank in one static frame forces a wide shot that
  shrinks every landmark. Burpees also already serve as a *negative* in the
  push-up corpus — promoting them to an exercise would demand re-verifying
  that boundary. **Revisit when:** ≥3 single-phase exercises are shipped
  WINs and the harness has per-exercise detector caps proven (jumping-jack
  plan), making phase-chaining an extension rather than a rewrite.
- **Plank.** No rep cycle — it's time-under-pose, which breaks the Verifier
  contract (SignalFrame → [RepEvent]) and has no XP price (the economy
  prices reps and kilometers; a verified-minute price exists only for
  runs). Technically feasible (hold-detection is easier than rep counting),
  but it needs a product decision (duration-event type + XP/minute price
  for static holds) BEFORE an engineering wargame is writable. **Revisit
  when:** the product owner prices static-hold XP; the wargame is then
  straightforward and cheap.
- **Weighted/equipment exercises (deadlift, bench, rows, hip thrust on
  bench).** The camera cannot verify load, so "valid rep" collapses to
  unloaded motion — phantom-XP surface with barbells' occlusion on top.
  Standing ENG constraint (verify motion, never difficulty) makes these
  permanently out for camera verification, not deferred.
- **Free-form cardio (burpee variants, mountain climbers, high knees).**
  Mountain climbers and high knees are plausible single-cycle candidates
  (plank posture + alternating knees; standing + knee-rise line) but add no
  new capability the wargamed six don't already prove, and each costs a
  human corpus evening. **Revisit when:** the Pro roster needs breadth
  beyond six and the harness's per-exercise config is stable — they slot
  into the existing plan template (jumping-jack's cadence forks apply to
  high knees nearly verbatim).
