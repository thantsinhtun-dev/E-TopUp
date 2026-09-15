//
//  TransactionStatus.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI


enum TransactionStatus: String, Codable, CaseIterable, Identifiable {
    case success
    case pending
    case failed

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .success: return "Success"
        case .pending: return "Pending"
        case .failed: return "Failed"
        }
    }

    var systemImage: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .pending: return "clock.fill"
        case .failed: return "xmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .pending: return .orange
        case .failed: return .red
        }
    }

    var resultHeadline: String {
        switch self {
        case .success: return "Recharge Successful!"
        case .pending: return "Recharge Pending"
        case .failed: return "Recharge Failed"
        }
    }

    func resultSubheadline(phoneNumber: String) -> String {
        switch self {
        case .success: return "Your plan has been added to \(phoneNumber)"
        case .pending: return "We're processing your request. It may take a few moments."
        case .failed: return "The amount was not deducted. Please try again."
        }
    }
}
