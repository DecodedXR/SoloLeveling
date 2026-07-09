"""Push-up stranger-corpus screening: naive bottom counter for label cross-checks.

Usage: python pushup_screen.py pushup_stranger_out/ [clip_stem]

NOT the Step 2 state machine — a deliberately dumb peak counter (smoothed
shoulder-y local maxima) used to cross-check label claims (on-screen counters,
title rep counts) and to eyeball signal quality per clip. Saves an annotated
trace PNG per clip.
"""

import sys
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

L_SH, R_SH = 11, 12


def bottoms(t, ys, prominence=0.02, min_gap=0.5):
    peaks = []
    for k in range(3, len(ys) - 3):
        if (
            ys[k] == max(ys[k - 3 : k + 4])
            and ys[k] - min(ys[max(0, k - 30) : k + 30]) > prominence
        ):
            if not peaks or t[k] - t[peaks[-1]] > min_gap:
                peaks.append(k)
    return np.array(peaks, dtype=int)


def screen(csv_path):
    data = np.genfromtxt(csv_path, delimiter=",", skip_header=1)
    t = data[:, 0]
    xyzv = data[:, 1:].reshape(len(data), 33, 4)
    sh = (xyzv[:, L_SH, 1] + xyzv[:, R_SH, 1]) / 2
    ok = ~np.isnan(sh)
    if ok.sum() < 30:
        print(f"{csv_path.stem}: no pose")
        return
    yi = np.interp(t, t[ok], sh[ok])
    ys = np.convolve(yi, np.ones(5) / 5, mode="same")
    pk = bottoms(t, ys)
    det = ok.mean()
    print(f"{csv_path.stem}: {len(pk)} bottoms, det={det:.2f}, dur={t[-1]:.0f}s")
    plt.figure(figsize=(14, 3))
    plt.plot(t, ys, lw=0.8)
    if len(pk):
        plt.plot(t[pk], ys[pk], "rx", ms=4)
    plt.gca().invert_yaxis()
    plt.title(f"{csv_path.stem}: {len(pk)} bottoms (naive)")
    plt.tight_layout()
    plt.savefig(csv_path.with_name(csv_path.stem + "_screen.png"), dpi=100)
    plt.close()


def main():
    out_dir = Path(sys.argv[1])
    only = sys.argv[2] if len(sys.argv) > 2 else None
    for p in sorted(out_dir.glob("*.csv")):
        if only and p.stem != only:
            continue
        screen(p)


if __name__ == "__main__":
    main()
