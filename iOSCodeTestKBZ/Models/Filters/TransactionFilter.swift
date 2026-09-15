import Foundation

struct TransactionFilter: Equatable {
    var operatorFilter: Telecom?
    var statusFilter: TransactionStatus?
    var from: Date?
    var to: Date?

    static let defaultValue = TransactionFilter()

    var isDefault: Bool {
        self == .defaultValue
    }

    func includes(_ date: Date, calendar: Calendar = .current) -> Bool {
        if let from, date < calendar.startOfDay(for: from) {
            return false
        }
        if let to {
            if let endOfDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: to)) {
                if date >= endOfDay {
                    return false
                }
            } else if date > to {
                return false
            }
        }
        return true
    }
}
