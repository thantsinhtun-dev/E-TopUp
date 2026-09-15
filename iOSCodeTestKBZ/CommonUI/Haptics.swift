//
//  Haptics.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import UIKit

enum Haptics {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func notify(_ status: TransactionStatus) {
        let generator = UINotificationFeedbackGenerator()
        switch status {
        case .success: generator.notificationOccurred(.success)
        case .pending: generator.notificationOccurred(.warning)
        case .failed: generator.notificationOccurred(.error)
        }
    }
}
