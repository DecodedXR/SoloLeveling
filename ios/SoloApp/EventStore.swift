// ADR-4: single-file SQLite via GRDB, one append-only events table.
// Repository exposes INSERT + read ONLY — no update/delete API exists,
// by design (an accidental UPDATE breaks the audit trail).

import Foundation
import GRDB

struct Event: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "events"
    var id: Int64?
    var sessionId: String
    var source: String // "vision" | "gps" | "debug"
    var task: String
    var evidenceJson: String
    var ts: Date

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}

final class EventStore {
    private let dbQueue: DatabaseQueue

    init(path: String) throws {
        dbQueue = try DatabaseQueue(path: path)
        try dbQueue.write { db in
            try db.create(table: "events", ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("sessionId", .text).notNull()
                t.column("source", .text).notNull()
                t.column("task", .text).notNull()
                t.column("evidenceJson", .text).notNull()
                t.column("ts", .datetime).notNull()
            }
        }
    }

    func append(_ event: Event) throws {
        var e = event
        try dbQueue.write { db in try e.insert(db) }
    }

    func all() throws -> [Event] {
        try dbQueue.read { db in
            try Event.order(Column("id")).fetchAll(db)
        }
    }
}

// M2 replaces this with the full SPEC §3 pricing fold. M0: XP is always 0.
enum Ledger {
    static func fold(_ events: [Event]) -> (eventCount: Int, xp: Int) {
        (events.count, 0)
    }
}
