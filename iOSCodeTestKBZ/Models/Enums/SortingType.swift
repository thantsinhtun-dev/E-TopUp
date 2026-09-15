//
//  SortingType.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

enum SortingType: String, CaseIterable, Identifiable {
    case newestFirst = "Newest first"
    case oldestFirst = "Oldest first"
    case amountHigh = "Amount: high → low"
    case amountLow = "Amount: low → high"

    var id: String { rawValue }
}
