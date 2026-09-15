//
//  StatusChip.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI

struct StatusChip: View {
    @ObserveInjection private var injectionObserver

    let status: TransactionStatus

    var body: some View {
        Label(status.displayName, systemImage: status.systemImage)
            .font(.appCaption1.weight(.semibold))
            .padding(.horizontal, .p10)
            .padding(.vertical, .p5)
            .background(status.color.opacity(0.15), in: Capsule())
            .foregroundStyle(status.color)
            .enableInjection()
    }
}
