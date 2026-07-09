"""Step 1 — extraction harness.

Usage: python extract.py corpus/ out/
Per clip: out/<name>.csv (t + 33 landmarks x,y,z,visibility) and out/<name>.png
(hip-y vs time, mean of landmarks 23,24, axis inverted so squats dip down).

Needs pose_landmarker_full.task next to this script:
https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_full/float16/latest/pose_landmarker_full.task
"""

import csv
import sys
from pathlib import Path

import cv2
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import mediapipe as mp
from mediapipe.tasks import python as mp_tasks
from mediapipe.tasks.python import vision

MODEL = Path(__file__).parent / "pose_landmarker_full.task"
HEADER = ["t"] + [f"{i}_{f}" for i in range(33) for f in ("x", "y", "z", "v")]


def extract(video: Path, out_dir: Path) -> None:
    landmarker = vision.PoseLandmarker.create_from_options(
        vision.PoseLandmarkerOptions(
            base_options=mp_tasks.BaseOptions(model_asset_path=str(MODEL)),
            running_mode=vision.RunningMode.VIDEO,
        )
    )
    cap = cv2.VideoCapture(str(video))
    rows = []
    last_ms = -1
    while True:
        ok, frame = cap.read()
        if not ok:
            break
        ms = int(cap.get(cv2.CAP_PROP_POS_MSEC))
        if ms <= last_ms:  # detect_for_video requires monotonic timestamps
            ms = last_ms + 1
        last_ms = ms
        img = mp.Image(
            image_format=mp.ImageFormat.SRGB,
            data=cv2.cvtColor(frame, cv2.COLOR_BGR2RGB),
        )
        res = landmarker.detect_for_video(img, ms)
        if res.pose_landmarks:
            row = [ms / 1000.0] + [
                v
                for lm in res.pose_landmarks[0]
                for v in (lm.x, lm.y, lm.z, lm.visibility)
            ]
        else:
            row = [ms / 1000.0] + [float("nan")] * 132
        rows.append(row)
    cap.release()
    landmarker.close()

    with open(out_dir / f"{video.stem}.csv", "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(HEADER)
        w.writerows(rows)

    ts = [r[0] for r in rows]
    hip_y = [(r[1 + 23 * 4 + 1] + r[1 + 24 * 4 + 1]) / 2 for r in rows]
    plt.figure(figsize=(12, 3))
    plt.plot(ts, hip_y, lw=0.8)
    plt.gca().invert_yaxis()  # image y grows downward; flip so squats dip down
    plt.title(video.stem)
    plt.xlabel("s")
    plt.ylabel("hip y (norm)")
    plt.tight_layout()
    plt.savefig(out_dir / f"{video.stem}.png", dpi=100)
    plt.close()


def main() -> None:
    src, out_dir = Path(sys.argv[1]), Path(sys.argv[2])
    out_dir.mkdir(exist_ok=True)
    clips = sorted(p for p in src.iterdir() if p.suffix.lower() in (".mov", ".mp4"))
    for clip in clips:
        if (out_dir / f"{clip.stem}.csv").exists():
            continue
        print(clip.name, flush=True)
        extract(clip, out_dir)
    print(f"done: {len(clips)} clips")


if __name__ == "__main__":
    main()
