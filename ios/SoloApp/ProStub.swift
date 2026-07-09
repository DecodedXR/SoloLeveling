// M0: StoreKit 2 stub behind a flag. M5 replaces with real entitlement checks
// (Transaction.currentEntitlements per ADR-7).

import Foundation

enum ProEntitlement {
    static let storeKitEnabled = false // flip in M5

    static var isPro: Bool {
        guard storeKitEnabled else { return false }
        return false // M5: Transaction.currentEntitlements
    }
}
