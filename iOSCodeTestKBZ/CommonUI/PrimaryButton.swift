//
//  PrimaryButton.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI

struct PrimaryButton: View {
    @ObserveInjection private var injectionObserver

    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    var isLoading: Bool = false
    var background: AnyShapeStyle = AnyShapeStyle(Color.accentColor)
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .p8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                    Text("Processing…")
                } else {
                    if let icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                }
            }
            .font(.appHeadline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, .p15)
            .background(
                isEnabled ? background : AnyShapeStyle(Color(.systemGray4)),
                in: RoundedRectangle(cornerRadius: .r15, style: .continuous)
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.snappy(duration: 0.25), value: isEnabled)
        .enableInjection()
    }
}
