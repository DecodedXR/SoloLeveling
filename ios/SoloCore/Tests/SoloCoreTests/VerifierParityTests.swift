// B2 acceptance gate: the Swift Verifier must reproduce the Python reference
// event-for-event on every corpus clip. Inputs: landmark CSVs in out/ (local,
// regenerate via extract.py if absent); expected: fixtures/verifier_expected.json.

import Foundation
import XCTest
@testable import SoloCore

final class VerifierParityTests: XCTestCase {
    struct Expected: Decodable {
        struct Cal: Decodable {
            let stand_hip: Double, leg: Double, shin: Double, torso: Double
            let window_end_frame: Int
        }
        struct Event: Decodable { let t: Double, min_ratio: Double }
        struct Clip: Decodable { let calibration: Cal?, events: [Event] }
        struct Thresholds: Decodable { let A: Double, B: Double }
        let frozen_thresholds: Thresholds
        let clips: [String: Clip]
    }

    static var repoRoot: URL {
        // this file: <root>/ios/SoloCore/Tests/SoloCoreTests/VerifierParityTests.swift
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    static func loadCSV(_ url: URL) throws -> [PoseFrame] {
        let text = try String(contentsOf: url, encoding: .utf8)
        var frames: [PoseFrame] = []
        for line in text.split(separator: "\n").dropFirst() {
            let parts = line.split(separator: ",", omittingEmptySubsequences: false)
            guard parts.count == 133 else { continue }
            let nums = parts.map { Double($0) ?? .nan }
            frames.append(PoseFrame(t: nums[0], values: Array(nums[1...])))
        }
        return frames
    }

    func testCorpusParity() throws {
        let root = Self.repoRoot
        let fixURL = root.appendingPathComponent("fixtures/verifier_expected.json")
        let expected = try JSONDecoder().decode(Expected.self,
                                                from: Data(contentsOf: fixURL))
        let outDir = root.appendingPathComponent("out")
        guard FileManager.default.fileExists(atPath: outDir.path) else {
            throw XCTSkip("out/ landmark CSVs not present — run extract.py first")
        }

        var checked = 0
        for (stem, clip) in expected.clips.sorted(by: { $0.key < $1.key }) {
            let csv = outDir.appendingPathComponent("\(stem).csv")
            guard FileManager.default.fileExists(atPath: csv.path) else {
                XCTFail("\(stem): fixture exists but out/\(stem).csv missing")
                continue
            }
            let frames = try Self.loadCSV(csv)
            let cal = Verifier.calibrate(frames)
            let reps = Verifier.count(frames,
                                      a: expected.frozen_thresholds.A,
                                      b: expected.frozen_thresholds.B)

            if let expCal = clip.calibration {
                let got = try XCTUnwrap(cal, "\(stem): calibration failed, expected success")
                XCTAssertEqual(got.standHip, expCal.stand_hip, accuracy: 1e-5, stem)
                XCTAssertEqual(got.leg, expCal.leg, accuracy: 1e-5, stem)
                XCTAssertEqual(got.shin, expCal.shin, accuracy: 1e-5, stem)
                XCTAssertEqual(got.torso, expCal.torso, accuracy: 1e-5, stem)
                XCTAssertEqual(got.windowEndFrame, expCal.window_end_frame, stem)
            } else {
                XCTAssertNil(cal, "\(stem): expected calibration failure")
            }

            let events = reps ?? []
            XCTAssertEqual(events.count, clip.events.count,
                           "\(stem): event count mismatch")
            for (got, exp) in zip(events, clip.events) {
                XCTAssertEqual(got.t, exp.t, accuracy: 0.002, stem)
                XCTAssertEqual(got.minRatio, exp.min_ratio, accuracy: 1e-5, stem)
            }
            checked += 1
        }
        XCTAssertEqual(checked, expected.clips.count)
        print("parity: \(checked) clips checked against Python reference")
    }
}
