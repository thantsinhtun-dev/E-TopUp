import SwiftUI

struct TopUpScreen: View {
    @ObserveInjection private var injectionObserver
    @Environment(AppState.self) private var appState
    @State private var viewModel: TopUpViewModel
    @State private var phoneText = ""

    @FocusState private var isPhoneFieldFocused: Bool

    init(service: TopUpService) {
        _viewModel = State(initialValue: TopUpViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .p16) {
                    phoneInputSection
                    TopUpPlanSectionView(viewModel: viewModel)
                }
                .padding(.p16)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color(.systemGroupedBackground))
            .contentShape(Rectangle())
            .onTapGesture {
                endTextEditing()
            }
            .navigationTitle("Mobile Top Up")
            .navigationBarTitleDisplayMode(.inline)
            .task(id: viewModel.detectedOperator) {
                await viewModel.loadPackages()
            }
            .onChange(of: appState.prefillPhoneNumber, initial: true) { _, _ in
                viewModel.applyPrefill(appState.consumePrefillPhoneNumber())
            }
            .onChange(of: viewModel.phoneNumber) { _, newValue in
                if phoneText != newValue {
                    phoneText = newValue
                }
            }
            .alert(
                "Recharge Failed",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.clearError() } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .fullScreenCover(
            isPresented: Binding(
                get: { viewModel.resultTransaction != nil },
                set: { if !$0 { viewModel.dismissResult() } }
            )
        ) {
            if let transaction = viewModel.resultTransaction {
                TopUpResultView(
                    transaction: transaction,
                    onDone: { viewModel.dismissResult() },
                    onRetry: { Task { await viewModel.retryRecharge() } }
                )
            }
        }
        .enableInjection()
    }

    // MARK: - Input Section

    private var phoneInputSection: some View {
        VStack(alignment: .leading, spacing: .p12) {
            Label("Phone Number", systemImage: "phone")
                .font(.appSubheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: .p12) {
                TextField("09 9X XXX XXXX", text: $phoneText)
                    .focused($isPhoneFieldFocused)
                    .keyboardType(.phonePad)
                    .font(.appTitle3.monospacedDigit())
                    .textFieldStyle(.plain)
                    .onChange(of: phoneText) { _, newValue in
                        let digits = newValue.filter { ("0"..."9").contains($0) }
                        let limited = String(digits.prefix(AppConstants.maxPhoneNumberLength))
                        if limited != newValue {
                            phoneText = limited
                        }
                        viewModel.updatePhoneNumber(limited)
                    }

                if let operatorDetected = viewModel.detectedOperator {
                    OperatorLogo(telecom: operatorDetected, size: 36)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "questionmark.circle.dashed")
                        .font(.appTitle2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.p12)
            .background(Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: .r14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .r14, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: .thick)
                    .animation(.snappy(duration: 0.25), value: viewModel.detectedOperator)
            )

            if let hint = validationHint {
                Label(hint.text, systemImage: hint.systemImage)
                    .font(.appCaption1)
                    .foregroundStyle(.orange)
                    .transition(.opacity)
            }
        }
        .padding(.p16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: .r18, style: .continuous))
        .animation(.snappy(duration: 0.25), value: viewModel.phoneNumber)
    }

    // MARK: - Layout Helpers

    private var borderColor: Color {
        if let operatorDetected = viewModel.detectedOperator {
            return operatorDetected.primaryColor
        }
        return viewModel.phoneNumber.isEmpty ? .clear : .orange
    }

    private var validationHint: (text: String, systemImage: String)? {
        if !viewModel.phoneNumber.isEmpty && !viewModel.isValidNumber {
            return ("Enter the full number (9–11 digits)", "exclamationmark.circle")
        }
        if viewModel.isValidNumber && viewModel.detectedOperator == nil {
            return ("Operator not recognized for this prefix", "questionmark.circle")
        }
        return nil
    }
}
