//
//  TopUpTransaction.swift
//  iOSCodeTestKBZ
//
//  Created by Thant Sin Htun on 16/09/2026.
//

import Foundation
import SwiftData

@Model
final class TopUpTransaction {

    @Attribute(.unique) var transactionId: String
    var phoneNumber: String
    var telecom: Telecom
    var packageName: String
    var packageDetail: String
    var packageKind: DataPackage.Kind
    var validity: String
    var amountMMK: Int
    var status: TransactionStatus
    var createdAt: Date

    init(
        transactionId: String,
        phoneNumber: String,
        telecom: Telecom,
        packageName: String,
        packageDetail: String,
        packageKind: DataPackage.Kind,
        validity: String,
        amountMMK: Int,
        status: TransactionStatus = .pending,
        createdAt: Date = .now
    ) {

        self.transactionId = transactionId
        self.phoneNumber = phoneNumber
        self.telecom = telecom
        self.packageName = packageName
        self.packageDetail = packageDetail
        self.packageKind = packageKind
        self.validity = validity
        self.amountMMK = amountMMK
        self.status = status
        self.createdAt = createdAt
    }
}
