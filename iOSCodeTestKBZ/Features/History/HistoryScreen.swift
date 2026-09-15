import SwiftUI

struct HistoryScreen: View {
    @ObserveInjection private var injectionObserver

    @State private var viewModel: HistoryViewModel
    @State private var showFilterSheet = false

    init(service: TopUpService) {
        _viewModel = State(initialValue: HistoryViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.allTransactions.isEmpty {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        emptyState
                    }
                } else {
                    historyListSection
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: Binding(
                    get: { viewModel.searchText },
                    set: { viewModel.searchText = $0 }
                ),
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search number, plan, txn ID"
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("History")
                        .font(.appHeadline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: viewModel.hasActiveFilters
                              ? "line.3.horizontal.decrease.circle.fill"
                              : "line.3.horizontal.decrease.circle")
                    }
                    .foregroundStyle(viewModel.hasActiveFilters ? Color.accentColor : Color.secondary)
                    .accessibilityLabel("Filters")
                }
            }
            .onAppear {
                Task { await viewModel.refresh() }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            HistoryFilterSheet(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .enableInjection()
    }
}

extension HistoryScreen {
    @ViewBuilder
    private var historyListSection: some View {
        List {
            Section {
                if viewModel.filteredTransactions.isEmpty {
                    EmptyStateView(
                        systemImage: "magnifyingglass",
                        title: "No Results",
                        message: "No transactions match your search or filters."
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.filteredTransactions) { transaction in
                        NavigationLink(value: transaction) {
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            } header: {
                summaryHeader
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.refresh()
        }
        .animation(.snappy(duration: 0.25), value: viewModel.filteredTransactions.count)
        .navigationDestination(for: TopUpTransaction.self) { transaction in
            TransactionDetailView(transaction: transaction)
        }
    }

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "clock.arrow.circlepath",
            title: "No Transactions",
            message: "Your recharge history will appear here."
        )
        .frame(maxHeight: .infinity)
    }

    private var summaryHeader: some View {
        HStack {
            Text("\(viewModel.filteredTransactions.count) transaction(s)")
                .font(.appSubheadline.weight(.semibold))
            Spacer()
            Picker("Sort", selection: Binding(
                get: { viewModel.sort },
                set: { viewModel.sort = $0 }
            )) {
                ForEach(SortingType.allCases) { option in
                    Text(option.rawValue)
                        .font(.appFootnote)
                        .tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(.secondary)
        }
        .textCase(nil)
    }
}
