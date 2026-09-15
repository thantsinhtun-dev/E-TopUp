import SwiftUI
import SwiftData

@MainActor
@Observable
final class AppState {
    enum Tab: Hashable {
        case topUp
        case history
    }

    var selectedTab: Tab = .topUp
    private(set) var prefillPhoneNumber: String?
    let topUpService: TopUpService

    init(modelContainer: ModelContainer) {
        topUpService = LocalTopUpService(modelContainer: modelContainer)
    }

    func requestRecharge(phoneNumber: String) {
        prefillPhoneNumber = phoneNumber
        selectedTab = .topUp
    }

    func consumePrefillPhoneNumber() -> String? {
        defer { prefillPhoneNumber = nil }
        return prefillPhoneNumber
    }
}
