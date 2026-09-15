//
//  OperatorLogo.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI

struct OperatorLogo: View {
    @ObserveInjection private var injectionObserver

    let telecom: Telecom
    var size: CGFloat

    var body: some View {
        Image(telecom.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size * 0.62, height: size * 0.62)
            .frame(width: size, height: size)
            .background(telecom.primaryColor.opacity(0.12), in: Circle())
            .enableInjection()
    }
}
