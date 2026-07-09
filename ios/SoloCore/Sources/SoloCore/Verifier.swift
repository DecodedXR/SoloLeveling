// Verifier — 1:1 port of the Python kill-test reference (count_reps.py).
// ADR-9: pure value module, imports Foundation only. The Python corpus harness
// is the reference implementation; this port's acceptance criterion is exact
// event agreement on every corpus clip (fixtures/verifier_expected.json).
//
// Do NOT "improve" logic here without changing the Python reference and
// regenerating fixtures — the corpus, not code review, is the referee.

import Foundation

public enum Landmark {
    public static let lShoulder = 11, rShoulder = 12
    public static let lHip = 23, rHip = 24
    public static let lKnee = 25, rKnee = 26
    public static let lAnkle = 27, rAnkle = 28
}

/// Frozen constants — must match count_reps.py exactly.
public enum VerifierConstants {
    public static let a = 0.10 // standing re-arm threshold (hysteresis low)
    public static let b = 0.375 // deep-enough threshold (hysteresis high)
    public static let minVis = 0.5
    public static let teleportCap = 0.08
    public static let ankleDrift = 0.5
    public static let minTorso = 0.3
    public static let minObserved = 0.7
    public static let maxDwell = 6.0
    public static let maxDepth = 0.9
}

/// One extracted pose frame: 33 landmarks × (x, y, z, visibility).
public struct PoseFrame {
    public let t: Double
    /// 132 values, landmark-major: [x0, y0, z0, v0, x1, ...]
    public let values: [Double]

    public init(t: Double, values: [Double]) {
        self.t = t
        self.values = values
    }

    @inlinable public func x(_ i: Int) -> Double { values[i * 4] }
    @inlinable public func y(_ i: Int) -> Double { values[i * 4 + 1] }
    @inlinable public func v(_ i: Int) -> Double { values[i * 4 + 3] }
}

public struct RepEvent: Equatable {
    public let t: Double
    public let minRatio: Double
}

public struct Calibration: Equatable {
    public let standHip: Double
    public let leg: Double
    public let shin: Double
    public let torso: Double
    public let windowEndFrame: Int
}

public enum Verifier {
    @inlinable static func meanY(_ f: PoseFrame, _ i: Int, _ j: Int) -> Double {
        (f.y(i) + f.y(j)) / 2
    }

    static func boneLen(_ f: PoseFrame, _ i: Int, _ j: Int) -> Double {
        let dx = f.x(i) - f.x(j), dy = f.y(i) - f.y(j)
        return (dx * dx + dy * dy).squareRoot()
    }

    /// Highest stable ~1s window = standing (see count_reps.calibrate docstring).
    public static func calibrate(_ frames: [PoseFrame]) -> Calibration? {
        let n = frames.count
        guard n > 1, let tLast = frames.last?.t else { return nil }
        // Python: fps = max(1, round(len(t) / max(t[-1], 1e-9))) — banker's rounding
        let fps = max(1, Int((Double(n) / max(tLast, 1e-9)).rounded(.toNearestOrEven)))
        let win = fps
        guard n > win else { return nil }

        let hip = frames.map { meanY($0, Landmark.lHip, Landmark.rHip) }
        let vis = frames.map {
            ($0.v(Landmark.lHip) + $0.v(Landmark.rHip)
                + $0.v(Landmark.lAnkle) + $0.v(Landmark.rAnkle)) / 4
        }

        var best: (mean: Double, s: Int)?
        for s in 0..<(n - win) {
            let seg = hip[s..<(s + win)]
            if seg.contains(where: { $0.isNaN }) { continue }
            // NaN vis min compares false in Python (min < 0.5 is False) — but
            // vis is NaN only when hip is NaN, already skipped above.
            if let mn = vis[s..<(s + win)].min(), mn < VerifierConstants.minVis { continue }
            let mean = seg.reduce(0, +) / Double(win)
            let variance = seg.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(win)
            if variance.squareRoot() < 0.01, best == nil || mean < best!.mean {
                best = (mean, s)
            }
        }
        guard let (standHip, s) = best else { return nil }

        let window = frames[s..<(s + win)]
        let ankleMean = window.map { meanY($0, Landmark.lAnkle, Landmark.rAnkle) }
            .reduce(0, +) / Double(win)
        let leg = ankleMean - standHip
        var shins: [Double] = []
        for f in window { shins.append(boneLen(f, Landmark.lKnee, Landmark.lAnkle)) }
        for f in window { shins.append(boneLen(f, Landmark.rKnee, Landmark.rAnkle)) }
        let shin = shins.reduce(0, +) / Double(shins.count)
        let shoulderMean = window.map { meanY($0, Landmark.lShoulder, Landmark.rShoulder) }
            .reduce(0, +) / Double(win)
        let torso = standHip - shoulderMean
        return Calibration(standHip: standHip, leg: leg, shin: shin, torso: torso,
                           windowEndFrame: s + win)
    }

    /// Frame lie detectors: visibility, shin bone-length ±30%, teleport cap.
    static func trusted(_ f: PoseFrame, shinCal: Double, prevHipY: Double?,
                        hipY: Double) -> Bool {
        if (f.v(Landmark.lHip) + f.v(Landmark.rHip)) / 2 < VerifierConstants.minVis {
            return false
        }
        let shins = [
            boneLen(f, Landmark.lKnee, Landmark.lAnkle),
            boneLen(f, Landmark.rKnee, Landmark.rAnkle),
        ]
        if !shins.contains(where: { 0.7 * shinCal <= $0 && $0 <= 1.3 * shinCal }) {
            return false
        }
        if let p = prevHipY, abs(hipY - p) > VerifierConstants.teleportCap {
            return false
        }
        return true
    }

    /// Position-only A/B hysteresis with rep-validity checks. nil = calibration failed.
    public static func count(_ frames: [PoseFrame],
                             a: Double = VerifierConstants.a,
                             b: Double = VerifierConstants.b) -> [RepEvent]? {
        guard let cal = calibrate(frames), cal.leg > 0, cal.torso > 0 else { return nil }

        enum State { case start, up, down }
        var state = State.start
        var reps: [RepEvent] = []
        var repMinRatio = 0.0, repMinT = 0.0
        var anchorX = 0.0, repOk = false
        var downTotal = 0, downSeen = 0
        var deepFirst = 0.0, deepLast = 0.0
        var prevY: Double?

        for f in frames {
            let y = meanY(f, Landmark.lHip, Landmark.rHip)
            if state == .down { downTotal += 1 }
            if y.isNaN { continue }
            let ok = trusted(f, shinCal: cal.shin, prevHipY: prevY, hipY: y)
            prevY = y // teleport compares to previous RAW frame (see Python note)
            if !ok { continue } // hold state on untrusted frames
            if state == .down { downSeen += 1 }
            let ratio = (y - cal.standHip) / cal.leg
            let ankleX = (f.x(Landmark.lAnkle) + f.x(Landmark.rAnkle)) / 2
            let shoulderY = meanY(f, Landmark.lShoulder, Landmark.rShoulder)

            switch state {
            case .start:
                if ratio < a { state = .up }
            case .up:
                if ratio > b {
                    state = .down
                    repMinRatio = ratio; repMinT = f.t
                    anchorX = ankleX; repOk = true
                    downTotal = 1; downSeen = 1
                    deepFirst = f.t; deepLast = f.t
                }
            case .down:
                if abs(ankleX - anchorX) > VerifierConstants.ankleDrift * cal.leg {
                    repOk = false
                }
                if ratio > b { deepLast = f.t }
                if deepLast - deepFirst > VerifierConstants.maxDwell {
                    repOk = false // camping at the bottom, not repping
                }
                if ratio > repMinRatio {
                    repMinRatio = ratio; repMinT = f.t
                    if (y - shoulderY) < VerifierConstants.minTorso * cal.torso {
                        repOk = false // folded over at the bottom
                    }
                }
                if ratio < a {
                    state = .up
                    if repOk, repMinRatio <= VerifierConstants.maxDepth,
                       Double(downSeen) >= VerifierConstants.minObserved * Double(downTotal) {
                        reps.append(RepEvent(t: repMinT, minRatio: repMinRatio))
                    }
                }
            }
        }
        return reps
    }
}
