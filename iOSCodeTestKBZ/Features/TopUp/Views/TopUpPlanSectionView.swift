import SwiftUI

struct TopUpPlanSectionView: View {
    @ObserveInjection private var injectionObserver

    let viewModel: TopUpViewModel

    var body: some View {
        Group {
            if let operatorDetected = viewModel.detectedOperator {
                VStack(alignment: .leading, spacing: .p12) {
                    HStack {
                        Text(sectionTitle)
                            .font(.appHeadline)
                        Spacer()
                        Text("\(viewModel.packages.count) available")
                            .font(.appCaption1)
                            .foregroundStyle(.secondary)
                    }

                    planGrid(accent: operatorDetected.primaryColor)

                    PrimaryButton(
                        title: "Proceed to Recharge",
                        icon: "bolt.fill",
                        isEnabled: viewModel.canRecharge,
                        isLoading: viewModel.isRecharging,
                        background: proceedButtonBackground
                    ) {
                        Task { await viewModel.recharge() }
                    }
                }
            } else {
                hintCard
            }
        }
        .enableInjection()
    }

    private var sectionTitle: String {
        viewModel.detectedOperator.map { "Plans for \($0.displayName)" } ?? "Plans"
    }

    private var proceedButtonBackground: AnyShapeStyle {
        if let operatorDetected = viewModel.detectedOperator {
            return AnyShapeStyle(operatorDetected.gradient)
        }
        return AnyShapeStyle(Color.accentColor)
    }

    @ViewBuilder
    private func planGrid(accent: Color) -> some View {
        if viewModel.isLoadingPackages {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, .p48)
        } else if viewModel.packages.isEmpty {
            VStack(spacing: .p12) {
                Image(systemName: "tray")
                    .font(.system(size: .p32))
                    .foregroundStyle(.tertiary)
                Text("No plans available for this operator")
                    .font(.appFootnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .p48)
        } else {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: .p12) {
                ForEach(viewModel.packages) { package in
                    PlanCard(
                        package: package,
                        isSelected: viewModel.selectedPackage?.id == package.id,
                        accent: accent
                    ) {
                        endTextEditing()
                        Haptics.light()
                        viewModel.selectPackage(package)
                    }
                }
            }
            .animation(.snappy(duration: 0.25), value: viewModel.packages)
        }
    }

    private var hintCard: some View {
        VStack(spacing: .p12) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: .p32))
                .foregroundStyle(.tertiary)
            Text("Enter a phone number to see available plans")
                .font(.appFootnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, .p48)
    }
}
