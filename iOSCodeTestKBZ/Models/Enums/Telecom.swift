//
//  Telecom.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI

enum Telecom: String, CaseIterable, Codable, Identifiable {
    case mpt = "MPT"
    case atom = "ATOM"
    case u9 = "U9"
    case mytel = "Mytel"
    case mectel = "MECtel"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var imageName: String {
        switch self {
        case .mpt: "ic_operator_mpt"
        case .atom: "ic_operator_atom"
        case .u9: "ic_operator_u9"
        case .mytel: "ic_operator_mytel"
        case .mectel: "ic_operator_mec"
        }
    }

    var colorName: String {
        switch self {
        case .mpt: "color_operator_mpt"
        case .atom: "color_operator_atom"
        case .u9: "color_operator_u9"
        case .mytel: "color_operator_mytel"
        case .mectel: "color_operator_mec"
        }
    }

    var primaryColor: Color {
        Color(colorName)
    }

    var gradient: LinearGradient {
        LinearGradient(colors: [primaryColor, primaryColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


enum TelecomPrefixes {
    static let prefixesByOperator: [Telecom: Set<String>] = [
        .atom: [
            "0979", "0978", "0977", "0976", "0975", "0974"
        ],
        .u9: [
            "0997", "0996", "0995", "0994", "0998"
        ],
        .mytel: [
            "0969", "0968", "0967", "0966", "0965"
        ],
        .mectel: [
            "0930", "0931", "0932", "0933", "0934", "0935", "0936"
        ],
        .mpt: [
            "0920", "0921", "0922", "0923", "0924", "0925", "0926",
            "0940", "0941", "0942", "0943", "0944", "0945", "0947", "0948", "0949",
            "0950", "0951", "0952", "0953", "0954", "0955", "0956",
            "0988", "0989", "0983", "0984", "0985", "0986", "0987",
            "0971", "0973"
        ]
    ]
    
    static let sortedPrefixes: [(prefix: String, op: Telecom)] =
    prefixesByOperator
        .flatMap { op, prefixes in prefixes.map { (prefix: $0, op: op) } }
        .sorted { $0.prefix.count > $1.prefix.count }
}
