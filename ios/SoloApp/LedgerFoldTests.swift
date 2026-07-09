// M0 check: unit test folds 3 fixture events. Add to the app's test target.

import XCTest
@testable import SoloApp

final class LedgerFoldTests: XCTestCase {
    func testFoldsThreeFixtureEvents() {
        let events = (1...3).map { i in
            Event(id: Int64(i), sessionId: "fixture", source: "debug",
                  task: "debug_event", evidenceJson: "{}", ts: Date())
        }
        let (count, xp) = Ledger.fold(events)
        XCTAssertEqual(count, 3)
        XCTAssertEqual(xp, 0) // M0: XP is always 0; M2 brings the pricing table
    }
}
