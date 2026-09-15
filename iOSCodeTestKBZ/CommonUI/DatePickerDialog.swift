//
//  DatePickerDialog.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI

struct DatePickerDialog: View {
    @ObserveInjection private var injectionObserver

    let title: String
    @Binding var selection: Date
    var range: ClosedRange<Date> = .distantPast...(.distantFuture)
    let onCancel: () -> Void
    let onConfirm: () -> Void

    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isCompactHeight: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)

            VStack(spacing: 0) {
                Text(title)
                    .font(.appHeadline)
                    .padding(.top, .p20)
                    .padding(.bottom, .p8)

                if isCompactHeight {
                    wheelPicker
                } else {
                    graphicalPicker
                }

                Divider()

                HStack(spacing: 0) {
                    button("Cancel") {
                        onCancel()
                    }
                    Divider()
                        .frame(height: 46)
                    button("Confirm", prominent: true) {
                        onConfirm()
                    }
                }
            }
            .frame(maxWidth: isCompactHeight ? 420 : 320)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: .r20, style: .continuous))
            .padding(.horizontal, .p24)
            .shadow(color: .black.opacity(0.25), radius: 24)
            .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
        .enableInjection()
    }

    private var graphicalPicker: some View {
        DatePicker(
            "Select date",
            selection: $selection,
            in: range,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .padding(.horizontal, .p16)
        .padding(.bottom, .p12)
    }

    private var wheelPicker: some View {
        DatePicker(
            "Select date",
            selection: $selection,
            in: range,
            displayedComponents: .date
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .padding(.horizontal, .p8)
        .padding(.bottom, .p4)
    }

    private func button(_ title: String, prominent: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(prominent ? .appHeadline : .appBody)
                .foregroundStyle(prominent ? Color.accentColor : Color.primary)
                .frame(maxWidth: .infinity, minHeight: 46)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

