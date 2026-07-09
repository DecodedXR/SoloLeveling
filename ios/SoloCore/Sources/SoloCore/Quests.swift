// M1 quest + streak logic (SPEC §2.3, C20). Pure over day-keyed data:
// callers convert Date → dayNumber (days since epoch in the USER's calendar)
// so calendar/timezone handling stays at the edge, not in the logic.

import Foundation

public struct DailyQuest: Equatable {
    public let source: XPSource
    public let target: Double // e.g. 30 (reps) or 2.0 (km)
    public let title: String // display only; voice rules applied at UI layer

    public init(source: XPSource, target: Double, title: String) {
        self.source = source
        self.target = target
        self.title = title
    }

    /// Progress from the day's verified quantities for this source.
    public func progress(dayQuantity: Double) -> Double {
        min(dayQuantity / target, 1.0)
    }

    public func isComplete(dayQuantity: Double) -> Bool {
        dayQuantity >= target
    }
}

public enum Streak {
    /// SPEC §2.3: consecutive calendar days with ≥1 completed quest.
    /// Counts the run ending today, or — if today has no completion YET —
    /// the run ending yesterday (today doesn't break the streak until it ends).
    public static func length(completedDays: Set<Int>, today: Int) -> Int {
        var day = completedDays.contains(today) ? today : today - 1
        var streak = 0
        while completedDays.contains(day) {
            streak += 1
            day -= 1
        }
        return streak
    }
}
