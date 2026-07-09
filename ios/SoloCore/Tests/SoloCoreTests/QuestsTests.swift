import XCTest
@testable import SoloCore

final class QuestsTests: XCTestCase {
    func testQuestProgressAndCompletion() {
        let quest = DailyQuest(source: .visionRep, target: 30, title: "30 verified squats")
        XCTAssertEqual(quest.progress(dayQuantity: 15), 0.5)
        XCTAssertFalse(quest.isComplete(dayQuantity: 29))
        XCTAssertTrue(quest.isComplete(dayQuantity: 30))
        XCTAssertEqual(quest.progress(dayQuantity: 90), 1.0) // clamped
    }

    func testStreakCountsConsecutiveDays() {
        XCTAssertEqual(Streak.length(completedDays: [100, 101, 102], today: 102), 3)
        XCTAssertEqual(Streak.length(completedDays: [100, 102], today: 102), 1) // gap broke it
        XCTAssertEqual(Streak.length(completedDays: [], today: 102), 0)
    }

    func testTodayIncompleteDoesNotBreakStreakYet() {
        // quests done Mon–Wed, it's Thursday morning: streak shows 3
        XCTAssertEqual(Streak.length(completedDays: [100, 101, 102], today: 103), 3)
        // but a full missed day kills it
        XCTAssertEqual(Streak.length(completedDays: [100, 101, 102], today: 104), 0)
    }

    func testStreakFeedsEconomyLadder() {
        // day 7 of a streak crosses into ×1.25 (SPEC §3.1 ladder)
        let days = Set(100...106) // 7 consecutive days
        let streak = Streak.length(completedDays: days, today: 106)
        XCTAssertEqual(streak, 7)
        XCTAssertEqual(PricingTable().streakMultiplier(days: streak), 1.25)
    }
}
