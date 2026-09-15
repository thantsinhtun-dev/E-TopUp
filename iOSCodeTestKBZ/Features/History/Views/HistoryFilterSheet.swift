import SwiftUI

struct HistoryFilterSheet: View {
    @ObserveInjection private var injectionObserver

    @Bindable var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var draft = TransactionFilter.defaultValue
    @State private var activeDateField: DateField?
    @State private var dialogDate: Date = .now

    var body: some View {
        NavigationStack {
            Form {
                Section("Telecom Operator") {
                    Picker("Telecom operator", selection: $draft.operatorFilter) {
                        Text("All operators").tag(nil as Telecom?)
                        ForEach(Telecom.allCases) { telco in
                            Text(telco.rawValue)
                                .tag(Optional(telco))
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.appBody)
                }

                Section("Status") {
                    Picker("Transaction status", selection: $draft.statusFilter) {
                        Text("All statuses").tag(nil as TransactionStatus?)
                        ForEach(TransactionStatus.allCases) { status in
                            Text(status.displayName).tag(Optional(status))
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.appBody)
                }

                Section {
                    dateField(.start)
                    dateField(.end)
                } header: {
                    Text("Custom date range")
                } footer: {
                    Text("Includes the full start and end dates.")
                }

                Section {
                    Button("Reset", role: .destructive) {
                        withAnimation(.snappy(duration: 0.25)) {
                            draft = .defaultValue
                        }
                    }
                    .font(.appBody.weight(.semibold))
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Filters")
                        .font(.appHeadline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.appBody)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.apply(draft)
                        Haptics.light()
                        dismiss()
                    }
                    .font(.appBody.weight(.semibold))
                }
            }
            .onAppear {
                draft = viewModel.filter
            }
        }
        .overlay {
            datePickerDialog
        }
        .interactiveDismissDisabled(activeDateField != nil)
        .enableInjection()
    }
}

extension HistoryFilterSheet {

    private enum DateField: String, Identifiable {
        case start
        case end

        var id: Self { self }

        var title: String {
            switch self {
            case .start: "Start Date"
            case .end: "End Date"
            }
        }
    }

    private func dateField(_ kind: DateField) -> some View {
        Button {
            dialogDate = currentValue(for: kind) ?? .now
            withAnimation(.snappy(duration: 0.25)) {
                activeDateField = kind
            }
        } label: {
            LabeledContent {
                HStack(spacing: .p8) {
                    Text(displayValue(for: kind))
                        .foregroundStyle(.secondary)
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.accentColor)
                }
            } label: {
                Text(kind.title)
            }
        }
        .buttonStyle(.plain)
        .font(.appBody)
    }

    private func currentValue(for kind: DateField) -> Date? {
        kind == .start ? draft.from : draft.to
    }

    private func displayValue(for kind: DateField) -> String {
        currentValue(for: kind)?.formatted(.dateTime.day().month().year()) ?? "Any"
    }

    @ViewBuilder
    private var datePickerDialog: some View {
        if let field = activeDateField {
            DatePickerDialog(
                title: field.title,
                selection: $dialogDate,
                range: selectableRange(for: field),
                onCancel: dismissDialog,
                onConfirm: { confirmPickedDate(for: field) }
            )
        }
    }

    private func selectableRange(for field: DateField) -> ClosedRange<Date> {
        switch field {
        case .start: .distantPast...((draft.to ?? .now))
        case .end: (draft.from ?? .distantPast)...Date.now
        }
    }

    private func confirmPickedDate(for field: DateField) {
        switch field {
        case .start: draft.from = min(dialogDate, draft.to ?? dialogDate)
        case .end: draft.to = max(dialogDate, draft.from ?? dialogDate)
        }
        dismissDialog()
    }

    private func dismissDialog() {
        withAnimation(.snappy(duration: 0.25)) {
            activeDateField = nil
        }
    }
}
