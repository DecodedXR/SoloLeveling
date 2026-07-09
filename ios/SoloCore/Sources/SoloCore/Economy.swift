// Economy — SPEC §3 pricing, level curve, rank gates, as a pure fold (C5).
// The base pricing is DATA (repricing = re-fold with a new table, never a
// migration). The M2 acceptance gate is EconomyTests reproducing the SPEC
// §3.4 simulation table exactly.

import Foundation

public enum XPSource: String, Codable {
    case visionRep // valid verified rep (squat / push-up)
    case runKm // GPS-verified run/walk distance
    case step // pedometer step without GPS fix
}

/// One economy-relevant event, as folded from the append-only log.
public struct PricedEvent {
    public let source: XPSource
    public let quantity: Double // reps, km, or steps
    /// XP earned toward a daily quest that was completed (×1.25, C20).
    public let towardCompletedQuest: Bool
    /// Streak length in consecutive days at the time of the event.
    public let streakDays: Int

    public init(source: XPSource, quantity: Double,
                towardCompletedQuest: Bool = false, streakDays: Int = 0) {
        self.source = source
        self.quantity = quantity
        self.towardCompletedQuest = towardCompletedQuest
        self.streakDays = streakDays
    }
}

/// SPEC §3.1 base pricing — data, not code.
public struct PricingTable {
    public var xpPerRep: Double = 10
    public var xpPerKm: Double = 300
    public var xpPerStep: Double = 0.3 // priced to the 300 XP/km line
    public var questMultiplier: Double = 1.25
    public var compoundCap: Double = 2.0

    public init() {}

    /// Streak ladder: ×1.0 (0–2) · ×1.1 (3–6) · ×1.25 (7–29) · ×1.5 (30+).
    public func streakMultiplier(days: Int) -> Double {
        switch days {
        case ..<3: return 1.0
        case 3...6: return 1.1
        case 7...29: return 1.25
        default: return 1.5
        }
    }
}

public struct LedgerState: Equatable {
    public let xp: Int
    public let level: Int
    public let rank: Rank
    public let strengthXP: Int // from vision rep events only
    public let enduranceXP: Int // from distance/step events only
}

public enum Rank: String, CaseIterable, Comparable {
    case e = "E", d = "D", c = "C", b = "B", a = "A", s = "S"

    public static func < (lhs: Rank, rhs: Rank) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

public enum Economy {
    /// SPEC §3.2: cumulative XP to REACH level L. `CumXP(L) = 500·L·(L−1)`.
    public static func cumulativeXP(toReach level: Int) -> Int {
        500 * level * (level - 1)
    }

    /// Level for a given XP total, clamped to 1...50.
    public static func level(forXP xp: Int) -> Int {
        var l = 1
        while l < 50, xp >= cumulativeXP(toReach: l + 1) { l += 1 }
        return l
    }

    /// SPEC §3.3 rank bands: E 1–4, D 5–8, C 9–11, B 12–20, A 21–35, S 36–50.
    public static func rank(forLevel level: Int) -> Rank {
        switch level {
        case ..<5: return .e
        case 5...8: return .d
        case 9...11: return .c
        case 12...20: return .b
        case 21...35: return .a
        default: return .s
        }
    }

    /// XP for one event: base price × multipliers, compound-capped (§3.1).
    public static func price(_ event: PricedEvent,
                             table: PricingTable = PricingTable()) -> Double {
        let base: Double
        switch event.source {
        case .visionRep: base = event.quantity * table.xpPerRep
        case .runKm: base = event.quantity * table.xpPerKm
        case .step: base = event.quantity * table.xpPerStep
        }
        var multiplier = table.streakMultiplier(days: event.streakDays)
        if event.towardCompletedQuest { multiplier *= table.questMultiplier }
        return base * min(multiplier, table.compoundCap)
    }

    /// The pure fold (C5): events in → LedgerState out. Repricing = re-fold.
    public static func fold(_ events: [PricedEvent],
                            table: PricingTable = PricingTable()) -> LedgerState {
        var total = 0.0, strength = 0.0, endurance = 0.0
        for e in events {
            let xp = price(e, table: table)
            total += xp
            switch e.source {
            case .visionRep: strength += xp
            case .runKm, .step: endurance += xp
            }
        }
        let xp = Int(total.rounded(.down))
        let level = level(forXP: xp)
        return LedgerState(xp: xp, level: level, rank: rank(forLevel: level),
                           strengthXP: Int(strength.rounded(.down)),
                           enduranceXP: Int(endurance.rounded(.down)))
    }
}
