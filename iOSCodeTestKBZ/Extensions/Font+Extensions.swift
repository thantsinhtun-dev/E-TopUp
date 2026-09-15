//
//  Font+Extensions.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI

enum AppFontName {
    case regular
    case semiBold

    var name: String {
        switch self {
        case .regular:  return "Poppins-Regular"
        case .semiBold: return "Poppins-SemiBold"
        }
    }
}
extension Font {
    // Large Title: 34 pt (Regular)
    static let appLargeTitle = Font.custom(AppFontName.regular.name, size: 34, relativeTo: .largeTitle)

    // Title 1: 28 pt (Regular)
    static let appTitle1 = Font.custom(AppFontName.regular.name, size: 28, relativeTo: .title)

    // Title 2: 22 pt (Regular)
    static let appTitle2 = Font.custom(AppFontName.regular.name, size: 22, relativeTo: .title2)

    // Title 3: 20 pt (Regular)
    static let appTitle3 = Font.custom(AppFontName.regular.name, size: 20, relativeTo: .title3)

    // Headline: 17 pt (Semibold)
    static let appHeadline = Font.custom(AppFontName.semiBold.name, size: 17, relativeTo: .headline)

    // Body: 17 pt (Regular)
    static let appBody = Font.custom(AppFontName.regular.name, size: 17, relativeTo: .body)

    // Callout: 16 pt (Regular)
    static let appCallout = Font.custom(AppFontName.regular.name, size: 16, relativeTo: .callout)

    // Subheadline: 15 pt (Regular)
    static let appSubheadline = Font.custom(AppFontName.regular.name, size: 15, relativeTo: .subheadline)

    // Footnote: 13 pt (Regular)
    static let appFootnote = Font.custom(AppFontName.regular.name, size: 13, relativeTo: .footnote)

    // Caption 1: 12 pt (Regular)
    static let appCaption1 = Font.custom(AppFontName.regular.name, size: 12, relativeTo: .caption)

    // Caption 2: 11 pt (Regular)
    static let appCaption2 = Font.custom(AppFontName.regular.name, size: 11, relativeTo: .caption2)
}
