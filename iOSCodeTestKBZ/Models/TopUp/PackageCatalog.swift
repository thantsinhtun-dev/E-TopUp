import Foundation

enum PackageCatalog {
    static let allPackages: [DataPackage] = mpt + atom + u9 + mytel + mectel

    static func packages(for telecom: Telecom) -> [DataPackage] {
        switch telecom {
        case .mpt: mpt
        case .atom: atom
        case .u9: u9
        case .mytel: mytel
        case .mectel: mectel
        }
    }

    static func package(id: UUID) -> DataPackage? {
        allPackages.first { $0.id == id }
    }

    private static let mpt: [DataPackage] = [
        .init(telecom: .mpt, kind: .topUp, title: "1,000 MMK", detail: "Talktime balance", validity: "N/A", priceMMK: 1_000),
        .init(telecom: .mpt, kind: .topUp, title: "5,000 MMK", detail: "Talktime balance", validity: "N/A", priceMMK: 5_000),
        .init(telecom: .mpt, kind: .data, title: "1.5 GB / 7 Days", detail: "Data only pack", validity: "7 days", priceMMK: 2_000),
        .init(telecom: .mpt, kind: .data, title: "4.5 GB / 30 Days", detail: "Data only pack", validity: "30 days", priceMMK: 5_000),
        .init(telecom: .mpt, kind: .combo, title: "MPT Combo 9 GB", detail: "9 GB + 100 min + 100 SMS", validity: "30 days", priceMMK: 10_000),
    ]

    private static let atom: [DataPackage] = [
        .init(telecom: .atom, kind: .topUp, title: "2,000 MMK", detail: "Talktime balance", validity: "N/A", priceMMK: 2_000),
        .init(telecom: .atom, kind: .data, title: "1.8 GB / 7 Days", detail: "Data pack", validity: "7 days", priceMMK: 1_990),
        .init(telecom: .atom, kind: .data, title: "7 GB / 30 Days", detail: "Data pack", validity: "30 days", priceMMK: 6_990),
        .init(telecom: .atom, kind: .combo, title: "ATOM Combo 10 GB", detail: "10 GB + 150 min", validity: "30 days", priceMMK: 9_990),
    ]

    private static let u9: [DataPackage] = [
        .init(telecom: .u9, kind: .topUp, title: "1,000 MMK", detail: "Talktime balance", validity: "N/A", priceMMK: 1_000),
        .init(telecom: .u9, kind: .data, title: "2 GB / 7 Days", detail: "Data pack", validity: "7 days", priceMMK: 1_500),
        .init(telecom: .u9, kind: .data, title: "5 GB / 30 Days", detail: "Data pack", validity: "30 days", priceMMK: 4_500),
        .init(telecom: .u9, kind: .combo, title: "U9 Combo 8 GB", detail: "8 GB + 100 min", validity: "30 days", priceMMK: 7_500),
    ]

    private static let mytel: [DataPackage] = [
        .init(telecom: .mytel, kind: .topUp, title: "1,000 MMK", detail: "Talktime balance", validity: "N/A", priceMMK: 1_000),
        .init(telecom: .mytel, kind: .data, title: "2.5 GB / 7 Days", detail: "Data pack", validity: "7 days", priceMMK: 1_990),
        .init(telecom: .mytel, kind: .data, title: "8 GB / 30 Days", detail: "Data pack", validity: "30 days", priceMMK: 6_990),
        .init(telecom: .mytel, kind: .combo, title: "Mytel Combo 15 GB", detail: "15 GB + 200 min", validity: "30 days", priceMMK: 10_990),
    ]

    private static let mectel: [DataPackage] = [
        .init(telecom: .mectel, kind: .topUp, title: "1,000 MMK", detail: "Talktime balance", validity: "N/A", priceMMK: 1_000),
        .init(telecom: .mectel, kind: .data, title: "1 GB / 7 Days", detail: "Data pack", validity: "7 days", priceMMK: 1_500),
        .init(telecom: .mectel, kind: .data, title: "3 GB / 30 Days", detail: "Data pack", validity: "30 days", priceMMK: 4_500),
        .init(telecom: .mectel, kind: .combo, title: "MECtel Combo 5 GB", detail: "5 GB + 60 min", validity: "30 days", priceMMK: 5_500),
    ]
}
