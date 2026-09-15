import SwiftUI

@MainActor
@Observable
final class TopUpViewModel {
    private let service: TopUpService
    private var packageCache: [Telecom: [DataPackage]] = [:]

    var phoneNumber = ""

    var selectedPackage: DataPackage?
    private(set) var packages: [DataPackage] = []
    private(set) var isLoadingPackages = false
    private(set) var isRecharging = false
    private(set) var resultTransaction: TopUpTransaction?
    private(set) var errorMessage: String?

    var detectedOperator: Telecom? {
        TelecomDetector.detect(from: phoneNumber)
    }

    var isValidNumber: Bool {
        TelecomDetector.isValidLength(phoneNumber)
    }

    var canRecharge: Bool {
        isValidNumber && selectedPackage != nil && !isRecharging
    }

    init(service: TopUpService) {
        self.service = service
    }

    // MARK: - Actions

    func updatePhoneNumber(_ input: String) {
        let sanitized = String(input.filter { ("0"..."9").contains($0) }.prefix(AppConstants.maxPhoneNumberLength))
        guard sanitized != phoneNumber else { return }

        let previousOperator = detectedOperator
        phoneNumber = sanitized
        errorMessage = nil

        let newOperator = detectedOperator
        if previousOperator != newOperator {
            selectedPackage = nil
            if newOperator == nil {
                packages = []
            }
        }
    }

    func selectPackage(_ package: DataPackage) {
        selectedPackage = package
    }

    func loadPackages() async {
        guard let currentOperator = detectedOperator else {
            packages = []
            return
        }

        // Return cached packages if already loaded
        if let cached = packageCache[currentOperator], !cached.isEmpty {
            packages = cached
            return
        }

        isLoadingPackages = true
        defer { isLoadingPackages = false }

        do {
            let fetched = try await service.fetchPackages(for: currentOperator)
            packageCache[currentOperator] = fetched
            packages = fetched
        } catch is CancellationError {
            // Task canceled; retain existing state quietly
        } catch {
            errorMessage = error.localizedDescription
            packages = []
        }
    }

    func recharge() async {
        guard canRecharge, let package = selectedPackage else { return }

        isRecharging = true
        errorMessage = nil
        defer { isRecharging = false }

        do {
            let transaction = try await service.topUp(phoneNumber: phoneNumber, package: package)
            if transaction.status == .success {
                selectedPackage = nil
            }
            resultTransaction = transaction
        } catch is CancellationError {
            // Task canceled
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func retryRecharge() async {
        resultTransaction = nil
        await recharge()
    }

    func dismissResult() {
        resultTransaction = nil
    }

    func clearError() {
        errorMessage = nil
    }

    func applyPrefill(_ number: String?) {
        guard let number, !number.isEmpty else { return }
        updatePhoneNumber(number)
    }
}
