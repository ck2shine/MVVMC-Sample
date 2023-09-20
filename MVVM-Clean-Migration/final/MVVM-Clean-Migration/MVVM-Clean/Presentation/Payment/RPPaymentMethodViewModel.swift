/*
 * Copyright (c) Rakuten Payment, Inc. All Rights Reserved.
 *
 * This program is the information asset which are handled
 * as "Strictly Confidential".
 * Permission of use is only admitted in Rakuten Payment, Inc.
 * If you don't have permission, MUST not be published,
 * broadcast, rewritten for broadcast or publication
 * or redistributed directly or indirectly in any medium.
 */

import Combine
import Foundation

public class RPPaymentMethodViewModel {
    private var subscription = Set<AnyCancellable>()
    private let useCase: RPPaymentMethodUseCase

    public init(useCase: RPPaymentMethodUseCase) {
        self.useCase = useCase
        self.initializeAction()
    }

    /// input
    @Published public var userAuthTrigger: Void = ()
    @Published public var transitTrigger: Void = ()
    /// output
    @Published public var responseDataPublisher: (qrImage: String, brImage: String, name: String) = ("", "", "")
    @Published public var loadingActivityPublisher: Bool = false
    @Published public var alertPublisher: (title: String, message: String) = ("","")
    @Published public var transitPublisher: RPPaymentMethodEntity?

    /// store properties
    private var shopper: RPPaymentMethodEntity?
}

extension RPPaymentMethodViewModel {
    private func initializeAction() {
        // binding input and output
        self.$userAuthTrigger
            .flatMap { [unowned self] _ in
                self.loadingActivityPublisher = true
                return Just(())
            }
            .receive(on: DispatchQueue.global())
            .setFailureType(to: APIError.self)
            .flatMap { [unowned self] in
                self.useCase.retrieveUserInformation(shopperEntity: self.shopper)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] item in
                if case .failure(let error) = item {
                    self.handleAuthFail(apiError: error)
                }

            } receiveValue: { [unowned self] entity in
                self.handleAuthResponse(entity)
            }
            .store(in: &self.subscription)

        self.$transitTrigger
            .sink { [unowned self] _ in
                self.transitPublisher = self.shopper
            }
            .store(in: &self.subscription)
    }
}

// MARK: response handle

extension RPPaymentMethodViewModel {
    private func handleAuthResponse(_ shopper: RPPaymentMethodEntity) {
        self.shopper = shopper
        // stop animate
        self.loadingActivityPublisher = false 
        self.responseDataPublisher = (shopper.qrcodeName, shopper.barcodeName, shopper.lastName ?? "")
    }

    private func handleAuthFail(apiError: APIError) {
        self.loadingActivityPublisher = false
        self.alertPublisher = (apiError.errorCode, apiError.errorMessage)
    }
}
