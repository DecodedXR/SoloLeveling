// M0 check surface: tap the button, see "events: N, XP: 0".

import SwiftUI

struct DebugScreen: View {
    @State private var status = "no store"
    @State private var store: EventStore?

    var body: some View {
        VStack(spacing: 20) {
            Text(status).font(.system(.body, design: .monospaced))
            Button("Write debug_event") {
                do {
                    let s = try existingStore()
                    try s.append(Event(
                        id: nil, sessionId: UUID().uuidString, source: "debug",
                        task: "debug_event", evidenceJson: "{}", ts: Date()))
                    let (count, xp) = Ledger.fold(try s.all())
                    status = "events: \(count), XP: \(xp)"
                } catch {
                    status = "error: \(error)"
                }
            }
        }
        .navigationTitle("Debug")
    }

    private func existingStore() throws -> EventStore {
        if let store { return store }
        let dir = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask)[0]
        let s = try EventStore(path: dir.appendingPathComponent("events.sqlite").path)
        store = s
        return s
    }
}
