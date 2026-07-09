// M2 acceptance gate: reproduce SPEC §3.4's simulation table exactly.
// If these numbers drift, the fold is wrong — the spec is the referee (B-rule:
// economy changes go through the spec, never the code).

import XCTest
@testable import SoloCore

final class EconomyTests: XCTestCase {
    // MARK: §3.2 level curve

    func testLevelCurveClosedForm() {
        XCTAssertEqual(Economy.cumulativeXP(toReach: 1), 0)
        XCTAssertEqual(Economy.cumulativeXP(toReach: 2), 1_000)
        XCTAssertEqual(Economy.cumulativeXP(toReach: 12), 66_000)
        XCTAssertEqual(Economy.cumulativeXP(toReach: 21), 210_000)
        XCTAssertEqual(Economy.cumulativeXP(toReach: 36), 630_000)
        XCTAssertEqual(Economy.cumulativeXP(toReach: 50), 1_225_000)
    }

    func testLevelForXP() {
        XCTAssertEqual(Economy.level(forXP: 0), 1)
        XCTAssertEqual(Economy.level(forXP: 999), 1)
        XCTAssertEqual(Economy.level(forXP: 1_000), 2)
        XCTAssertEqual(Economy.level(forXP: 66_000), 12)
        XCTAssertEqual(Economy.level(forXP: 9_999_999), 50) // clamped
    }

    func testRankBands() {
        XCTAssertEqual(Economy.rank(forLevel: 1), .e)
        XCTAssertEqual(Economy.rank(forLevel: 5), .d)
        XCTAssertEqual(Economy.rank(forLevel: 9), .c)
        XCTAssertEqual(Economy.rank(forLevel: 12), .b)
        XCTAssertEqual(Economy.rank(forLevel: 21), .a)
        XCTAssertEqual(Economy.rank(forLevel: 36), .s)
        XCTAssertEqual(Economy.rank(forLevel: 50), .s)
    }

    // MARK: §3.1 pricing + multipliers

    func testEffortTimeParity() {
        // Vision: 5 reps/min × 10 = 50 XP/min; GPS: 0.15 km/min × 300 = 45.
        let vision = Economy.price(PricedEvent(source: .visionRep, quantity: 5))
        let gps = Economy.price(PricedEvent(source: .runKm, quantity: 0.15))
        XCTAssertEqual(vision, 50)
        XCTAssertEqual(gps, 45, accuracy: 1e-9)
        XCTAssertLessThan(vision / gps, 2.0) // parity band (ratio 1.11×)
    }

    func testStreakLadder() {
        let t = PricingTable()
        XCTAssertEqual(t.streakMultiplier(days: 0), 1.0)
        XCTAssertEqual(t.streakMultiplier(days: 2), 1.0)
        XCTAssertEqual(t.streakMultiplier(days: 3), 1.1)
        XCTAssertEqual(t.streakMultiplier(days: 6), 1.1)
        XCTAssertEqual(t.streakMultiplier(days: 7), 1.25)
        XCTAssertEqual(t.streakMultiplier(days: 29), 1.25)
        XCTAssertEqual(t.streakMultiplier(days: 30), 1.5)
    }

    func testCompoundCapGuardsInflation() {
        // Max realizable = 1.25 × 1.5 = 1.875 ≤ 2.0 (spec ✓) — cap must not
        // bind at spec values but must clamp anything beyond it.
        let maxed = Economy.price(PricedEvent(source: .visionRep, quantity: 1,
                                              towardCompletedQuest: true,
                                              streakDays: 30))
        XCTAssertEqual(maxed, 18.75, accuracy: 1e-9) // 10 × 1.875, uncapped
        var greedy = PricingTable()
        greedy.questMultiplier = 3.0 // hypothetical mis-tune
        let capped = Economy.price(PricedEvent(source: .visionRep, quantity: 1,
                                               towardCompletedQuest: true,
                                               streakDays: 30),
                                   table: greedy)
        XCTAssertEqual(capped, 20, accuracy: 1e-9) // clamped at ×2.0
    }

    // MARK: §3.4 simulation table — the M2 milestone check

    func testCasualPersonaWeeklyXP() {
        // 3 sessions × 20 min × 5 reps/min = 300 reps, all toward completed
        // quests, non-consecutive days (streak ×1.0) → 3,750 XP/wk.
        let week = [PricedEvent(source: .visionRep, quantity: 300,
                                towardCompletedQuest: true, streakDays: 0)]
        XCTAssertEqual(Economy.fold(week).xp, 3_750)
    }

    func testCommittedFastestWeeklyXP() {
        // 6 × 40 min × 5 reps/min = 1,200 reps at quest ×1.25 × streak ×1.5
        // = 22,500 XP/wk (the adversarial S-guard case).
        let week = [PricedEvent(source: .visionRep, quantity: 1_200,
                                towardCompletedQuest: true, streakDays: 30)]
        XCTAssertEqual(Economy.fold(week).xp, 22_500)
    }

    func testSimulationTableWeeksToRankFloors() {
        // SPEC §3.4 table, exact to 2 decimals / stated precision.
        let casual = 3_750.0, committed = 22_500.0
        XCTAssertEqual(10_000 / casual, 2.67, accuracy: 0.005) // D
        XCTAssertEqual(36_000 / casual, 9.6, accuracy: 0.05) // C
        XCTAssertEqual(66_000 / casual / 4.345, 4.05, accuracy: 0.01) // B, months
        XCTAssertEqual(210_000 / casual, 56.0, accuracy: 0.05) // A
        XCTAssertEqual(630_000 / casual, 168.0, accuracy: 0.05) // S
        XCTAssertEqual(10_000 / committed, 0.44, accuracy: 0.005) // D
        XCTAssertEqual(630_000 / committed, 28.0, accuracy: 0.05) // S
        // Acceptance bands: Casual D in 2–4 wks; Casual B in 3–6 mo;
        // Committed cannot reach S under 6 months even at max multiplier.
        XCTAssertTrue((2.0...4.0).contains(10_000 / casual))
        XCTAssertTrue((3.0...6.0).contains(66_000 / casual / 4.345))
        XCTAssertGreaterThan(630_000 / committed / 4.345, 6.0)
    }

    // MARK: C5 — repricing is a re-fold, never a migration

    func testRepricingIsAReFold() {
        let events = [
            PricedEvent(source: .visionRep, quantity: 100),
            PricedEvent(source: .runKm, quantity: 5),
        ]
        XCTAssertEqual(Economy.fold(events).xp, 2_500) // 1000 + 1500
        var retuned = PricingTable()
        retuned.xpPerRep = 12 // config change only — same events
        XCTAssertEqual(Economy.fold(events, table: retuned).xp, 2_700)
    }

    func testStrengthEnduranceSplit() {
        let events = [
            PricedEvent(source: .visionRep, quantity: 30), // 300 strength
            PricedEvent(source: .runKm, quantity: 2), // 600 endurance
            PricedEvent(source: .step, quantity: 1_000), // 300 endurance
        ]
        let state = Economy.fold(events)
        XCTAssertEqual(state.strengthXP, 300)
        XCTAssertEqual(state.enduranceXP, 900)
        XCTAssertEqual(state.xp, 1_200)
    }
}
