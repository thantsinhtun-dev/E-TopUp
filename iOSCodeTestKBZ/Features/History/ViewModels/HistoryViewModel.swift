
import SwiftUI

@MainActor
@Observable
final class HistoryViewModel {
    
    init(service: TopUpService) {
        self.service = service
    }

    private let service: TopUpService

    var searchText = ""
    var sort: SortingType = .newestFirst

    private(set) var filter = TransactionFilter.defaultValue
    private(set) var allTransactions: [TopUpTransaction] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var hasActiveFilters: Bool {
        !filter.isDefault
    }

    var filteredTransactions: [TopUpTransaction] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return allTransactions
            .filter { transaction in
                // 1. Telecom filter
                if let operatorFilter = filter.operatorFilter, transaction.telecom != operatorFilter {
                    return false
                }

                // 2. Status filter
                if let statusFilter = filter.statusFilter, transaction.status != statusFilter {
                    return false
                }

                // 3. Date range filter
                guard filter.includes(transaction.createdAt) else {
                    return false
                }

                // 4. Case-insensitive search query
                if !query.isEmpty {
                    let matchesSearch = transaction.phoneNumber.localizedCaseInsensitiveContains(query)
                        || transaction.packageName.localizedCaseInsensitiveContains(query)
                        || transaction.transactionId.localizedCaseInsensitiveContains(query)
                    guard matchesSearch else { return false }
                }

                return true
            }
            .sorted(by: sortComparator)
    }

    func apply(_ filter: TransactionFilter) {
        self.filter = filter
    }

    func refresh() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        // Fetch refreshed transactions with explicit error propagation
        do {
            allTransactions = try await service.fetchTransactions()
        } catch {
            errorMessage = error.localizedDescription
        }

        // Sync pending transactions concurrently after first paint
        let pending = allTransactions.filter { $0.status == .pending }
        await withTaskGroup(of: Void.self) { group in
            for transaction in pending {
                group.addTask {
                    _ = await self.service.syncPendingStatus(of: transaction)
                }
            }
        }
    }

    // MARK: - Sorting Helper
    private func sortComparator(lhs: TopUpTransaction, rhs: TopUpTransaction) -> Bool {
        switch sort {
        case .newestFirst: lhs.createdAt > rhs.createdAt
        case .oldestFirst: lhs.createdAt < rhs.createdAt
        case .amountHigh: lhs.amountMMK > rhs.amountMMK
        case .amountLow: lhs.amountMMK < rhs.amountMMK
        }
    }
}
