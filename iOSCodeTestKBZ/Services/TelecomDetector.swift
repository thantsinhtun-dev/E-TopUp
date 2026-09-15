import Foundation

struct TelecomDetector {
    static func normalize(_ input: String) -> String {
        var digits = input.filter(\.isNumber)

        if digits.hasPrefix("0095") {
            digits.removeFirst(2)
        }

        if digits.hasPrefix("959") {
            digits = "0" + digits.dropFirst(2)
        } else if digits.hasPrefix("9") {
            digits = "0" + digits
        }

        return digits
    }

    static func isValidLength(_ input: String) -> Bool {
        let number = normalize(input)
        return (9...11).contains(number.count)
    }

    static func detect(from input: String) -> Telecom? {
        let number = normalize(input)

        guard isValidLength(number) else { return nil }

        return TelecomPrefixes.sortedPrefixes.first {
            number.hasPrefix($0.prefix)
        }?.op
    }
}
