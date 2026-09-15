import SwiftUI

struct EmptyStateView: View {
    @ObserveInjection private var injectionObserver

    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: .p12) {
            Image(systemName: systemImage)
                .font(.system(size: .p48))
                .foregroundStyle(.tertiary)
            Text(title)
                .font(.appHeadline)
                .multilineTextAlignment(.center)
            Text(message)
                .font(.appFootnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.p24)
        .enableInjection()
    }
}
