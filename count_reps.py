"""Step 2 — calibration + hysteresis rep counter.

Usage: python count_reps.py out/            # all clips
       python count_reps.py out/ front_good_clean

Per clip: standing calibration from the first stable second, hip-drop ratio
normalized by standing hip-to-ankle distance, frame lie detectors (visibility,
bone-length ±30%, teleport cap) that HOLD state on untrusted frames, and a
position-only A/B hysteresis state machine.

Output per clip: counted reps, per-rep min ratio + timestamp.
Thresholds A/B here are provisional — Step 3 grid-searches and freezes them.
"""

import math
import sys
from pathlib import Path

import numpy as np

# ponytail: provisional thresholds, Step 3 tunes and freezes these
A = 0.10  # above-this-is-standing (ratio must fall below A to complete a rep)
B = 0.35  # deeper-than-this-counts (ratio must exceed B to arm a rep)

L_SHOULDER, R_SHOULDER = 11, 12
L_HIP, R_HIP, L_KNEE, R_KNEE, L_ANKLE, R_ANKLE = 23, 24, 25, 26, 27, 28
MIN_VIS = 0.5
TELEPORT_CAP = 0.08  # max hip-y jump per frame (normalized units)
ANKLE_DRIFT = 0.5  # max ankle-x travel during a rep, in leg lengths (planted feet)
MIN_TORSO = 0.3  # min shoulder-above-hip at rep bottom, in calibrated torso units
# (real deep squats lean to ~0.47; a tie-your-shoes fold reads ~0.1)
MIN_OBSERVED = 0.7  # min trusted-frame fraction across a rep's DOWN phase —
# no XP for reps the camera didn't cleanly see (folded/occluded/garbage tracking)
MAX_DWELL = 6.0  # max seconds between first and last deep frame of one rep —
# a paused rep holds ~2-3s; camping at the bottom (tying shoes) is not a rep
MAX_DEPTH = 0.9  # a hip a full leg-length below standing is not a squat —
# deepest legit corpus rep is 0.80; beyond this is tracking garbage


def load(csv_path):
    data = np.genfromtxt(csv_path, delimiter=",", skip_header=1)
    t = data[:, 0]
    xyzv = data[:, 1:].reshape(len(data), 33, 4)
    return t, xyzv


def mean_y(xyzv, i, j):
    return (xyzv[:, i, 1] + xyzv[:, j, 1]) / 2


def bone_len(xyzv, i, j):
    return np.hypot(xyzv[:, i, 0] - xyzv[:, j, 0], xyzv[:, i, 1] - xyzv[:, j, 1])


def calibrate(t, xyzv):
    """Highest stable ~1s window = standing. Returns cal params + window end.

    Highest, not first: in a paused-rep clip the bottom hold is also a stable
    second, and calibrating there inverts the ratio. Standing is the top.
    Visibility gate uses the MEAN of hips+ankles, not the min — in side view
    the far-side landmarks are always half-occluded.
    """
    hip_y = mean_y(xyzv, L_HIP, R_HIP)
    vis = xyzv[:, [L_HIP, R_HIP, L_ANKLE, R_ANKLE], 3].mean(axis=1)
    fps = max(1, round(len(t) / max(t[-1], 1e-9)))
    win = fps  # ~1 second
    best = None  # (stand_hip, s)
    for s in range(0, len(t) - win):
        seg = hip_y[s : s + win]
        if np.isnan(seg).any() or vis[s : s + win].min() < MIN_VIS:
            continue
        if seg.std() < 0.01 and (best is None or seg.mean() < best[0]):
            best = (float(seg.mean()), s)
    if best is None:
        return None
    stand_hip, s = best
    leg = float((mean_y(xyzv, L_ANKLE, R_ANKLE)[s : s + win].mean()) - stand_hip)
    # shin, not thigh: the thigh legitimately foreshortens ~50% in a
    # deep squat (hips reach knee height); the shin stays near-constant
    shin = float(
        np.concatenate(
            [
                bone_len(xyzv, L_KNEE, L_ANKLE)[s : s + win],
                bone_len(xyzv, R_KNEE, R_ANKLE)[s : s + win],
            ]
        ).mean()
    )
    torso = float(stand_hip - mean_y(xyzv, L_SHOULDER, R_SHOULDER)[s : s + win].mean())
    return stand_hip, leg, shin, torso, s + win


def trusted(frame, shin_cal, prev_hip_y, hip_y):
    """Frame lie detectors: visibility, bone-length ±30%, teleport cap."""
    if frame[[L_HIP, R_HIP], 3].mean() < MIN_VIS:  # mean: far hip occluded side-on
        return False
    shins = [
        math.hypot(frame[k, 0] - frame[a, 0], frame[k, 1] - frame[a, 1])
        for k, a in ((L_KNEE, L_ANKLE), (R_KNEE, R_ANKLE))
    ]
    # at least one shin in bounds — the far-side leg is unreliable in side view
    if not any(0.7 * shin_cal <= d <= 1.3 * shin_cal for d in shins):
        return False
    if prev_hip_y is not None and abs(hip_y - prev_hip_y) > TELEPORT_CAP:
        return False
    return True


def count(t, xyzv, a=None, b=None):
    a = A if a is None else a
    b = B if b is None else b
    cal = calibrate(t, xyzv)
    if cal is None:
        return None
    stand_hip, leg, shin, torso, _ = cal
    if leg <= 0 or torso <= 0:
        return None

    hip_y = mean_y(xyzv, L_HIP, R_HIP)
    ankle_x = (xyzv[:, L_ANKLE, 0] + xyzv[:, R_ANKLE, 0]) / 2
    shoulder_y = mean_y(xyzv, L_SHOULDER, R_SHOULDER)
    reps = []
    state = "START"  # arm only after first standing frame — kills walk-in phantoms
    rep_min_ratio, rep_min_t = 0.0, 0.0
    anchor_x = rep_ok = None
    down_total = down_seen = 0
    prev_y = None
    for k in range(len(t)):
        y = hip_y[k]
        if state == "DOWN":
            down_total += 1
        if np.isnan(y):
            continue
        ok = trusted(xyzv[k], shin, prev_y, y)
        prev_y = y  # teleport compares to previous RAW frame: a glitch is a
        # one-frame spike; comparing to last-trusted deadlocks after any gap
        if not ok:
            continue  # hold state on untrusted frames
        if state == "DOWN":
            down_seen += 1
        ratio = (y - stand_hip) / leg
        if state == "START":
            if ratio < a:
                state = "UP"
        elif state == "UP":
            if ratio > b:
                state = "DOWN"
                rep_min_ratio, rep_min_t = ratio, t[k]
                anchor_x, rep_ok = ankle_x[k], True
                down_total = down_seen = 1
                deep_first = deep_last = t[k]
        else:
            # squat validity: feet stay planted, torso stays upright.
            # Walking/lunging translates the ankles; tying shoes / picking
            # things up folds the shoulders down to hip level. Neither is a squat.
            if abs(ankle_x[k] - anchor_x) > ANKLE_DRIFT * leg:
                rep_ok = False
            if ratio > b:
                deep_last = t[k]
            if deep_last - deep_first > MAX_DWELL:
                rep_ok = False  # camping at the bottom, not repping
            if ratio > rep_min_ratio:
                rep_min_ratio, rep_min_t = ratio, t[k]
                if (y - shoulder_y[k]) < MIN_TORSO * torso:
                    rep_ok = False  # folded over at the bottom
            if ratio < a:
                state = "UP"
                if (
                    rep_ok
                    and rep_min_ratio <= MAX_DEPTH
                    and down_seen >= MIN_OBSERVED * down_total
                ):
                    reps.append((rep_min_t, rep_min_ratio))
    return reps


def main():
    out_dir = Path(sys.argv[1])
    only = sys.argv[2] if len(sys.argv) > 2 else None
    for csv_path in sorted(out_dir.glob("*.csv")):
        if only and csv_path.stem != only:
            continue
        t, xyzv = load(csv_path)
        reps = count(t, xyzv)
        if reps is None:
            print(f"{csv_path.stem}: CALIBRATION FAILED")
            continue
        detail = ", ".join(f"{ts:.1f}s@{r:.2f}" for ts, r in reps)
        print(f"{csv_path.stem}: {len(reps)} reps  [{detail}]")


def _selfcheck():
    """Synthetic 3-rep signal through the state machine — fails if logic breaks."""
    fps, secs = 30, 20
    n = fps * secs
    t = np.linspace(0, secs, n)
    xyzv = np.full((n, 33, 4), np.nan)
    xyzv[:, :, 3] = 1.0
    # standing geometry: shoulders .2, hips .5, knees .7, ankles .9
    for i, y0 in (
        (L_SHOULDER, 0.2),
        (R_SHOULDER, 0.2),
        (L_HIP, 0.5),
        (R_HIP, 0.5),
        (L_KNEE, 0.7),
        (R_KNEE, 0.7),
        (L_ANKLE, 0.9),
        (R_ANKLE, 0.9),
    ):
        xyzv[:, i, 0] = 0.5
        xyzv[:, i, 1] = y0
    # 2s stable, then 3 squats (hip drops 0.16 = ratio 0.4); knees stay put,
    # as in a real squat — hips descend toward knee height
    for c in (5.0, 9.0, 13.0):
        mask = np.abs(t - c) < 1.0
        dip = 0.16 * np.cos((t[mask] - c) * np.pi / 2) ** 2
        for hip in (L_HIP, R_HIP):
            xyzv[mask, hip, 1] += dip
    reps = count(t, xyzv)
    assert reps is not None, "calibration failed on synthetic clip"
    assert len(reps) == 3, f"expected 3 reps, got {len(reps)}"
    assert all(r > B for _, r in reps)
    # shallow dips (ratio 0.2 < B) must not count
    xyzv2 = xyzv.copy()
    xyzv2[:, [L_HIP, R_HIP], 1] = 0.5
    for c in (5.0, 9.0):
        mask = np.abs(t - c) < 1.0
        for hip in (L_HIP, R_HIP):
            xyzv2[mask, hip, 1] += 0.08 * np.cos((t[mask] - c) * np.pi / 2) ** 2
    assert count(t, xyzv2) == [], "shallow reps were counted"
    # deep dip with torso folded to hip level (tie shoes / pickup) must not count
    xyzv3 = xyzv.copy()
    for c in (5.0, 9.0, 13.0):
        mask = np.abs(t - c) < 1.0
        for sh in (L_SHOULDER, R_SHOULDER):
            xyzv3[mask, sh, 1] = xyzv3[mask, L_HIP, 1] - 0.05  # shoulders near hips
    assert count(t, xyzv3) == [], "folded-over dips were counted"
    # deep dip while ankles translate (walking / lunge) must not count
    xyzv4 = xyzv.copy()
    for c in (5.0, 9.0, 13.0):
        mask = np.abs(t - c) < 1.0
        drift = np.linspace(0, 0.6, mask.sum())
        for ank in (L_ANKLE, R_ANKLE):
            xyzv4[mask, ank, 0] += drift
    assert count(t, xyzv4) == [], "moving-feet dips were counted"
    # camping deep for >MAX_DWELL (tying shoes) must not count
    fps2, secs2 = 30, 16
    t5 = np.linspace(0, secs2, fps2 * secs2)
    xyzv5 = np.full((fps2 * secs2, 33, 4), np.nan)
    xyzv5[:, :, 3] = 1.0
    for i, y0 in (
        (L_SHOULDER, 0.2),
        (R_SHOULDER, 0.2),
        (L_HIP, 0.5),
        (R_HIP, 0.5),
        (L_KNEE, 0.7),
        (R_KNEE, 0.7),
        (L_ANKLE, 0.9),
        (R_ANKLE, 0.9),
    ):
        xyzv5[:, i, 0] = 0.5
        xyzv5[:, i, 1] = y0
    hold = (t5 > 3.0) & (t5 < 12.0)  # 9s at the bottom
    for hip in (L_HIP, R_HIP):
        xyzv5[hold, hip, 1] += 0.16
    assert count(t5, xyzv5) == [], "bottom-camping was counted"
    print("selfcheck OK")


if __name__ == "__main__":
    _selfcheck() if "--selfcheck" in sys.argv else main()
