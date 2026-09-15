import SwiftUI

struct TransactionRow: View {
    @ObserveInjection private var injectionObserver

    let transaction: TopUpTransaction

    var body: some View {
        HStack(spacing: .p12) {
            OperatorLogo(telecom: transaction.telecom, size: 44)

            VStack(alignment: .leading, spacing: .p3) {
                Text(transaction.packageName)
                    .font(.appSubheadline.weight(.semibold))
                    .lineLimit(1)
                operatorAndNumber
                Text(transaction.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.appCaption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }

            Spacer(minLength: .p8)

            VStack(alignment: .trailing, spacing: .p4) {
                Text("MMK \(transaction.amountMMK.formatted())")
                    .font(.appSubheadline.weight(.bold).monospacedDigit())
                    .foregroundStyle(transaction.status == .failed ? .secondary : .primary)
                    .lineLimit(1)
                StatusChip(status: transaction.status)
            }
        }
        .padding(.vertical, .p6)
        .enableInjection()
    }

    private var operatorAndNumber: some View {
        HStack(spacing: 4) {
            Text(transaction.telecom.displayName)
                .font(.appCaption2.weight(.semibold))
                .foregroundStyle(transaction.telecom.primaryColor)

            Text("•")
                .font(.appCaption2)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)

            Text(transaction.phoneNumber)
                .font(.appCaption2.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}
