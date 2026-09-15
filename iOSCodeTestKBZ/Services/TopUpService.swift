import Foundation

@MainActor
protocol TopUpService {
    func fetchPackages(for telecom: Telecom) async throws -> [DataPackage]
    func topUp(phoneNumber: String, package: DataPackage) async throws -> TopUpTransaction
    func fetchTransactions() async throws -> [TopUpTransaction]
    func syncPendingStatus(of transaction: TopUpTransaction) async -> Bool
}

enum TopUpServiceError: LocalizedError {
    case invalidPhoneNumber
    case operatorMismatch
    case packageUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            "Enter a valid phone number with a recognized operator."
        case .operatorMismatch:
            "Select a plan from the phone number's operator."
        case .packageUnavailable:
            "This plan is unavailable. Refresh the list and select another plan."
        }
    }
}
