import SwiftUI

struct PlanCard: View {
    @ObserveInjection private var injectionObserver

    let package: DataPackage
    let isSelected: Bool
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: .p8) {
                Image(systemName: package.kind.systemImage)
                    .font(.appTitle3)
                    .foregroundStyle(accent)
                Text(package.title)
                    .font(.appSubheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Text(package.detail)
                    .font(.appCaption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                if !package.validity.isEmpty {
                    Text(package.formattedValidity)
                        .font(.appCaption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
                Spacer(minLength: 2)
                HStack {
                    Text(package.priceLabel)
                        .font(.appFootnote.weight(.semibold).monospacedDigit())
                        .foregroundStyle(.primary)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(accent)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(.p12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: .r15, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .r15, style: .continuous)
                    .strokeBorder(isSelected ? accent : .clear, lineWidth: .thick)
            )
            .scaleEffect(isSelected ? 1.02 : 1)
            .animation(.snappy(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .enableInjection()
    }
}
