import Foundation
import SwiftData

@MainActor
final class LocalTopUpService: TopUpService {
    let modelContext: ModelContext
    private let packages: [DataPackage]

    init(modelContainer: ModelContainer, packages: [DataPackage]? = nil) {
        modelContext = ModelContext(modelContainer)
        modelContext.autosaveEnabled = false
        self.packages = packages ?? PackageCatalog.allPackages
    }

    func fetchPackages(for telecom: Telecom) async throws -> [DataPackage] {
        try await Task.sleep(for: AppConstants.simulatedNetworkDelay)
        return packages.filter { $0.telecom == telecom }
    }

    func topUp(phoneNumber: String, package: DataPackage) async throws -> TopUpTransaction {
        try Task.checkCancellation()

        guard let telecom = TelecomDetector.detect(from: phoneNumber) else {
            throw TopUpServiceError.invalidPhoneNumber
        }

        guard package.telecom == telecom else {
            throw TopUpServiceError.operatorMismatch
        }

        guard packages.contains(package), package.priceMMK > 0 else {
            throw TopUpServiceError.packageUnavailable
        }

        try await Task.sleep(for: AppConstants.simulatedRechargeDelay)

        let roll = Double.random(in: 0...1)
        let status: TransactionStatus
        if roll < AppConstants.rechargeSuccessProbability {
            status = .success
        } else if roll < AppConstants.rechargeSuccessProbability + AppConstants.rechargePendingProbability {
            status = .pending
        } else {
            status = .failed
        }

        let transaction = TopUpTransaction(
            transactionId: UUID().uuidString,
            phoneNumber: TelecomDetector.normalize(phoneNumber),
            telecom: telecom,
            packageName: package.title,
            packageDetail: package.detail,
            packageKind: package.kind,
            validity: package.validity.isEmpty ? "No expiry" : package.validity,
            amountMMK: package.priceMMK,
            status: status
        )

        modelContext.insert(transaction)

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }

        return transaction
    }

    func fetchTransactions() async throws -> [TopUpTransaction] {
        try Task.checkCancellation()
        let descriptor = FetchDescriptor<TopUpTransaction>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func syncPendingStatus(of transaction: TopUpTransaction) async -> Bool {
        guard transaction.status == .pending else { return false }
        try? await Task.sleep(for: .seconds(1.5))
        transaction.status = Double.random(in: 0...1) < AppConstants.rechargeSuccessProbability ? .success : .failed
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            return false
        }
        return true
    }
}
