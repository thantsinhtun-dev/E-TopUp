import SwiftUI

struct TransactionDetailView: View {
    @ObserveInjection private var injectionObserver

    let transaction: TopUpTransaction

    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false
    @State private var isChecking = false
    @State private var statusChanged = false

    var body: some View {
        ScrollView {
            VStack(spacing: .p18) {
                operatorCard
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)

                detailList
                    .opacity(appeared ? 1 : 0)

                switch transaction.status {
                case .pending:
                    Button {
                        checkStatus()
                    } label: {
                        Label(
                            isChecking ? "Checking…" : "Check Status",
                            systemImage: "arrow.triangle.2.circlepath"
                        )
                        .font(.appHeadline)
                        .foregroundStyle(transaction.telecom.primaryColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, .p15)
                        .background(transaction.telecom.primaryColor.opacity(0.12), in: RoundedRectangle(cornerRadius: .r15, style: .continuous))
                    }
                    .disabled(isChecking)

                case .failed:
                    Button {
                        Haptics.light()
                        requestRecharge()
                    } label: {
                        Label("Try Again", systemImage: "arrow.clockwise")
                            .font(.appHeadline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, .p15)
                            .background(Color.red.gradient, in: RoundedRectangle(cornerRadius: .r15, style: .continuous))
                    }

                case .success:
                    EmptyView()
                }

                Button {
                    requestRecharge()
                } label: {
                    Label("Proceed to Recharge", systemImage: "bolt.fill")
                        .font(.appHeadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, .p15)
                        .background(transaction.telecom.gradient, in: RoundedRectangle(cornerRadius: .r15, style: .continuous))
                }
                .padding(.top, .p6)

                if statusChanged {
                    Text("Status updated")
                        .font(.appCaption1.weight(.semibold))
                        .foregroundStyle(.green)
                        .transition(.opacity)
                }
            }
            .padding(.p16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Transaction Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Transaction Detail")
                    .font(.appHeadline)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.25).delay(0.1)) {
                appeared = true
            }
        }
        .enableInjection()
    }

    private func requestRecharge() {
        appState.requestRecharge(phoneNumber: transaction.phoneNumber)
        dismiss()
    }

    private func checkStatus() {
        isChecking = true
        Task {
            let changed = await appState.topUpService.syncPendingStatus(of: transaction)
            isChecking = false
            if changed {
                Haptics.notify(transaction.status)
                withAnimation(.snappy(duration: 0.3)) { statusChanged = true }
            }
        }
    }

    private var operatorCard: some View {
        VStack(spacing: .p12) {
            OperatorLogo(telecom: transaction.telecom, size: 76)
            Text(transaction.telecom.displayName)
                .font(.appTitle3.weight(.bold))
            Text(transaction.phoneNumber)
                .font(.appHeadline.monospacedDigit())
                .foregroundStyle(.secondary)
            StatusChip(status: transaction.status)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, .p24)
        .background(
            LinearGradient(
                colors: [transaction.telecom.primaryColor.opacity(0.12), .clear],
                startPoint: .top, endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: .r20, style: .continuous)
        )
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: .r20, style: .continuous))
    }

    private var detailList: some View {
        VStack(spacing: 0) {
            row("Transaction ID", mono: transaction.transactionId)
            Divider().padding(.leading, .p16)
            row("Plan", text: transaction.packageName)
            Divider().padding(.leading, .p16)
            row("Plan Details", text: transaction.packageDetail)
            Divider().padding(.leading, .p16)
            row("Validity", text: transaction.validity)
            Divider().padding(.leading, .p16)
            row("Date", text: transaction.createdAt.formatted(date: .long, time: .standard))
            Divider().padding(.leading, .p16)
            HStack {
                Text("Amount").font(.appSubheadline)
                Spacer()
                Text("MMK \(transaction.amountMMK.formatted())")
                    .font(.appHeadline.monospacedDigit())
            }
            .padding(.vertical, .p12)
        }
        .padding(.horizontal, .p16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: .r18, style: .continuous))
    }

    private func row(_ title: String, text: String) -> some View {
        HStack {
            Text(title).font(.appSubheadline)
            Spacer()
            Text(text).font(.appSubheadline.weight(.medium))
        }
        .padding(.vertical, .p12)
    }

    private func row(_ title: String, mono value: String) -> some View {
        HStack {
            Text(title).font(.appSubheadline)
            Spacer()
            Text(value).font(.appFootnote.monospaced().weight(.medium))
                .textSelection(.enabled)
        }
        .padding(.vertical, .p12)
    }
}
