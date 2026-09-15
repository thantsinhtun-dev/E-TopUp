//
//  DataPackage.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import Foundation

struct DataPackage: Identifiable, Codable, Equatable, Hashable, Sendable {
    enum Kind: String, Codable, CaseIterable, Identifiable, Sendable {
        case data
        case voice
        case combo
        case topUp

        var id: String { rawValue }

        var systemImage: String {
            switch self {
            case .data:  return "antenna.radiowaves.left.and.right"
            case .voice: return "phone.fill"
            case .combo: return "square.stack.3d.up.fill"
            case .topUp: return "creditcard.fill"
            }
        }
    }

    let id: UUID
    let telecom: Telecom
    let kind: Kind
    let title: String
    let detail: String
    let validity: String
    let priceMMK: Int

    init(
        id: UUID = UUID(),
        telecom: Telecom,
        kind: Kind,
        title: String,
        detail: String,
        validity: String,
        priceMMK: Int
    ) {
        self.id = id
        self.telecom = telecom
        self.kind = kind
        self.title = title
        self.detail = detail
        self.validity = validity
        self.priceMMK = priceMMK
    }

    var priceLabel: String {
        "\(priceMMK.formatted()) MMK"
    }

    var formattedValidity: String {
        validity.isEmpty ? "No expiry" : validity
    }
}
