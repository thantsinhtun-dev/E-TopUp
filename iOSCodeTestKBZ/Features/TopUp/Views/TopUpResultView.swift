//
//  TopUpResultView.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import SwiftUI
import UIKit

struct TopUpResultView: View {
    @ObserveInjection private var injectionObserver

    let transaction: TopUpTransaction
    let onDone: () -> Void
    var onRetry: (() -> Void)?

    @State private var checkmarkScale: CGFloat = 0.2
    @State private var checkmarkOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    @State private var copied = false

    var body: some View {
        ZStack {
            transaction.telecom.gradient.ignoresSafeArea().opacity(0.9)
            VStack(spacing: .p24) {
                Spacer()
                checkmarkView
                Text(transaction.status.resultHeadline)
                    .font(.appTitle2.weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text(transaction.status.resultSubheadline(phoneNumber: transaction.phoneNumber))
                    .font(.appFootnote)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)

                detailCard
                    .opacity(contentOpacity)

                Spacer()

                if transaction.status == .failed, let onRetry {
                    Button {
                        Haptics.light()
                        onRetry()
                    } label: {
                        Label("Try Again", systemImage: "arrow.clockwise")
                            .font(.appHeadline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, .p15)
                            .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: .r15, style: .continuous))
                    }
                }

                Button(action: onDone) {
                    Text("Done")
                        .font(.appHeadline)
                        .foregroundStyle(transaction.telecom.primaryColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, .p15)
                        .background(.white, in: RoundedRectangle(cornerRadius: .r15, style: .continuous))
                }
                .padding(.bottom, .p8)
            }
            .padding(.p20)
        }
        .task {
            Haptics.notify(transaction.status)
            withAnimation(.spring(duration: 0.55, bounce: 0.5)) {
                checkmarkScale = 1
                checkmarkOpacity = 1
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.35)) {
                contentOpacity = 1
            }
        }
        .enableInjection()
    }

    private var checkmarkView: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: 120, height: 120)
            Circle()
                .stroke(.white.opacity(0.6), lineWidth: .heavy)
                .frame(width: 120, height: 120)
            Image(systemName: transaction.status == .failed ? "xmark" : "checkmark")
                .font(.system(size: 52, weight: .bold))
                .foregroundStyle(.white)
        }
        .scaleEffect(checkmarkScale)
        .opacity(checkmarkOpacity)
    }

    private var detailCard: some View {
        VStack(spacing: 0) {
            row("Operator", content: HStack(spacing: .p8) {
                OperatorLogo(telecom: transaction.telecom, size: 24)
                Text(transaction.telecom.displayName)
            })
            row("Phone Number", text: transaction.phoneNumber)
            row("Plan", text: transaction.packageName)
            row("Details", text: transaction.packageDetail)
            row("Validity", text: transaction.validity)
            row("Date", text: transaction.createdAt.formatted(date: .abbreviated, time: .shortened))
            transactionIdRow
            row("Status", content: StatusChip(status: transaction.status)
                .padding(.vertical, -.p4))
            Divider().padding(.vertical, .p8)
            HStack {
                Text("Amount").font(.appSubheadline.weight(.semibold))
                Spacer()
                Text("MMK \(transaction.amountMMK.formatted())")
                    .font(.appTitle3.weight(.bold).monospacedDigit())
            }
        }
        .padding(.p16)
        .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: .r18, style: .continuous))
    }

    private var transactionIdRow: some View {
        HStack {
            Text("Transaction ID").font(.appSubheadline).foregroundStyle(.secondary)
            Spacer()
            HStack(spacing: .p6) {
                Text(transaction.transactionId)
                    .font(.appFootnote.monospaced().weight(.medium))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Button {
                    UIPasteboard.general.string = transaction.transactionId
                    Haptics.light()
                    withAnimation(.snappy(duration: 0.2)) { copied = true }
                    Task {
                        try? await Task.sleep(for: .seconds(2))
                        withAnimation(.snappy(duration: 0.2)) { copied = false }
                    }
                } label: {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .font(.appCaption1.weight(.semibold))
                        .foregroundStyle(copied ? .green : Color.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(copied ? "Copied" : "Copy transaction ID")
            }
        }
        .padding(.vertical, .p7)
        .textSelection(.enabled)
    }

    private func row(_ title: String, text: String) -> some View {
        row(title, content: Text(text).font(.appSubheadline).foregroundStyle(.primary))
    }

    private func row<Content: View>(_ title: String, content: Content) -> some View {
        HStack(alignment: .center) {
            Text(title).font(.appSubheadline).foregroundStyle(.secondary)
            Spacer()
            content
        }
        .padding(.vertical, .p7)
    }
}
