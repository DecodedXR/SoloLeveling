// M1 gate in miniature: a walk earns distance, a car ride earns 0 (C7).

import XCTest
@testable import SoloCore

final class RunPlausibilityTests: XCTestCase {
    /// Straight-line trace at constant speed. 1° latitude ≈ 111.195 km.
    func trace(kmh: Double, minutes: Double, accuracy: Double = 5) -> [LocationSample] {
        let samples = Int(minutes * 6) // one sample per 10 s
        let degPerSample = (kmh / 3600 * 10) / 111.195
        return (0...samples).map {
            LocationSample(t: Double($0) * 10, latitude: Double($0) * degPerSample,
                           longitude: 0, horizontalAccuracy: accuracy)
        }
    }

    func testWalkIsFullyPlausible() {
        let s = RunPlausibility.summarize(trace(kmh: 5, minutes: 30))
        XCTAssertEqual(s.plausibleKm, 2.5, accuracy: 0.05)
        XCTAssertTrue(s.isFullyPlausible)
    }

    func testRunIsFullyPlausible() {
        let s = RunPlausibility.summarize(trace(kmh: 12, minutes: 30))
        XCTAssertEqual(s.plausibleKm, 6.0, accuracy: 0.1)
        XCTAssertTrue(s.isFullyPlausible)
    }

    func testCarRideEarnsZero() {
        let s = RunPlausibility.summarize(trace(kmh: 60, minutes: 10))
        XCTAssertEqual(s.plausibleKm, 0)
        XCTAssertGreaterThan(s.totalKm, 9) // shown, never priced
        XCTAssertFalse(s.isFullyPlausible)
    }

    func testBikePaceRejected() {
        let s = RunPlausibility.summarize(trace(kmh: 28, minutes: 10))
        XCTAssertEqual(s.plausibleKm, 0)
        XCTAssertFalse(s.isFullyPlausible)
    }

    func testDriveToParkThenWalk() {
        // implausible leg + plausible leg: only the walk is priced
        var drive = trace(kmh: 60, minutes: 5)
        let t0 = drive.last!.t, lat0 = drive.last!.latitude
        let walk = trace(kmh: 5, minutes: 30).dropFirst().map {
            LocationSample(t: t0 + $0.t, latitude: lat0 + $0.latitude, longitude: 0)
        }
        let s = RunPlausibility.summarize(drive + walk)
        XCTAssertEqual(s.plausibleKm, 2.5, accuracy: 0.05)
        XCTAssertFalse(s.isFullyPlausible)
    }

    func testGPSTeleportExcludedEntirely() {
        // 1 km jump in one 10 s sample = 360 km/h: artifact, not motion
        var samples = trace(kmh: 5, minutes: 10)
        let jumped = samples.map {
            $0.t < 300 ? $0 : LocationSample(t: $0.t, latitude: $0.latitude + 0.009,
                                             longitude: 0)
        }
        samples = jumped
        let s = RunPlausibility.summarize(samples)
        XCTAssertEqual(s.plausibleKm, 0.83, accuracy: 0.05) // walk minus the jump
        XCTAssertTrue(s.isFullyPlausible) // teleport is an artifact, not a rejection
    }

    func testPoorAccuracySamplesDropped() {
        let s = RunPlausibility.summarize(trace(kmh: 5, minutes: 30, accuracy: 80))
        XCTAssertEqual(s.plausibleKm, 0)
        XCTAssertEqual(s.durationS, 0)
    }
}
