"""Step 3 — tune A/B on front-view good-light clips only, freeze, evaluate all.

Usage: python evaluate.py out/ labels.csv

Tuning set = clips named front_good_* (including front_good negatives, so the
zero-false-positive constraint shapes the thresholds). Everything else is
held out. Rows still labeled TODO are skipped with a warning.

Selection is lexicographic, per the plan's "false XP is worse than missed XP":
fewest false positives first, then highest recall.
"""

import csv
import sys
from pathlib import Path

import numpy as np

import count_reps as cr

# accepted-by-policy clips: excluded from tuning and metrics, reported separately.
# sitstand: the arming gate covers deliberate self-cheating in an armed session.
# pickup: 1 phantom rep per pathological event, accepted ceiling.
POLICY = {"front_good_sitstand", "front_good_pickup"}


def load_labels(path):
    labels = {}
    with open(path, newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            stem = Path(row["filename"]).stem
            v = row["valid_reps"].strip()
            if v == "TODO":
                print(f"WARNING: {stem} still TODO — skipped")
                continue
            labels[stem] = int(v)
    return labels


def score(clips, a, b):
    """Split false positives by class: true-negative clips vs shallow clips
    vs overcounts on positive clips. Mirrors the plan's priority order."""
    neg_fp = shallow_leak = over = matched = total = 0
    for stem, (t, xyzv, label) in clips.items():
        reps = cr.count(t, xyzv, a, b)
        pred = len(reps) if reps is not None else 0
        if label == 0:
            if "shallow" in stem:
                shallow_leak += pred
            else:
                neg_fp += pred
        else:
            over += max(pred - label, 0)
            matched += min(pred, label)
            total += label
    return neg_fp, shallow_leak, over, matched, total


def main():
    out_dir, labels_path = Path(sys.argv[1]), sys.argv[2]
    labels = load_labels(labels_path)

    clips = {}
    for stem, label in labels.items():
        csv_path = out_dir / f"{stem}.csv"
        if not csv_path.exists():
            print(f"WARNING: {stem} has no extracted CSV — skipped")
            continue
        t, xyzv = cr.load(csv_path)
        clips[stem] = (t, xyzv, label)

    policy = {s: clips.pop(s) for s in POLICY if s in clips}
    tune = {s: c for s, c in clips.items() if s.startswith("front_good_")}
    hold = {s: c for s, c in clips.items() if s not in tune}
    print(f"tuning on {len(tune)} front_good clips, holding out {len(hold)}\n")

    # plan-priority selection: zero negative-clip reps is a hard requirement,
    # shallow rejection only needs >=90% (leak allowance), THEN maximize recall.
    shallow_attempts = 40  # from labels.csv notes; 10% allowance below
    best = None
    for a in np.arange(0.05, 0.21, 0.025):
        for b in np.arange(0.25, 0.51, 0.025):
            neg_fp, leak, over, m, tot = score(tune, a, b)
            recall = m / tot if tot else 1.0
            key = (neg_fp, max(0, leak - shallow_attempts // 10), -recall, leak + over)
            if best is None or key < best[0]:
                best = (key, round(float(a), 3), round(float(b), 3))
    (neg_fp, _, neg_recall, _), a, b = best
    print(
        f"FROZEN: A={a} B={b}  (tune: {neg_fp} negative-clip reps, "
        f"{-neg_recall:.0%} recall)\n"
    )

    print(f"{'clip':34} {'set':8} {'label':>5} {'pred':>5}")
    for stem in sorted(clips):
        t, xyzv, label = clips[stem]
        reps = cr.count(t, xyzv, a, b)
        pred = len(reps) if reps is not None else "CAL!"
        flag = "" if pred == label else "  <-- MISMATCH"
        which = "tune" if stem in tune else "holdout"
        print(f"{stem:34} {which:8} {label:>5} {pred!s:>5}{flag}")

    for name, subset in (("TUNE", tune), ("HOLDOUT", hold)):
        neg_fp, leak, over, m, tot = score(subset, a, b)
        recall = m / tot if tot else float("nan")
        print(
            f"\n{name}: recall {recall:.0%} ({m}/{tot}), negative-clip reps {neg_fp}, "
            f"shallow leaks {leak}, overcounts {over}"
        )
    for stem, (t, xyzv, _) in sorted(policy.items()):
        reps = cr.count(t, xyzv, a, b)
        print(f"POLICY (not scored): {stem} -> {len(reps or [])} reps")
    print("\ntargets: recall >=95%, negative-clip false positives = 0")


if __name__ == "__main__":
    main()
