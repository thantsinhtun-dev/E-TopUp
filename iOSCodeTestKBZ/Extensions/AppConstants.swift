import Foundation

enum AppConstants {
    static let maxPhoneNumberLength = 11
    static let simulatedNetworkDelay: Duration = .milliseconds(500)
    static let simulatedRechargeDelay: Duration = .seconds(1)
    static let rechargeSuccessProbability = 0.5
    static let rechargePendingProbability = 0.3
}
