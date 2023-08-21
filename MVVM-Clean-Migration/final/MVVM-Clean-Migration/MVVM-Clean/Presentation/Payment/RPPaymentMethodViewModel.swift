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

public protocol RPPaymentMethodViewModelInput {
    var userAuthTrigger: PassthroughSubject<Void, Never> { get set }
    var transitTrigger: PassthroughSubject<Void, Never> { get set }
}

public protocol RPPaymentMethodViewModelOutput {
    var responseDataPublisher: CurrentValueSubject<(qrImage: String, brImage: String, name: String), Never> { get set }
    var loadingActivityPublisher: PassthroughSubject<Bool, Never> { get set }
    var alertPublisher: PassthroughSubject<(title: String, message: String), Never> { get set }
    var transitPublisher: PassthroughSubject<RPPaymentMethodEntity?, Never> { get set }
}

public protocol RPPaymentMethodViewModelManager {
    var input: RPPaymentMethodViewModelInput { get }
    var output: RPPaymentMethodViewModelOutput { get }
}

public class RPPaymentMethodViewModel: RPPaymentMethodViewModelInput, RPPaymentMethodViewModelOutput, RPPaymentMethodViewModelManager {
    private var subscription = Set<AnyCancellable>()
    private let useCase: RPPaymentMethodUseCase

    public init(useCase: RPPaymentMethodUseCase) {
        self.useCase = useCase
        self.initializeAction()
    }

    public var input: RPPaymentMethodViewModelInput {
        return self
    }

    public var output: RPPaymentMethodViewModelOutput {
        return self
    }

    /// input
    public var userAuthTrigger: PassthroughSubject<Void, Never> = .init()
    public var transitTrigger: PassthroughSubject<Void, Never> = .init()
    /// output
    public var responseDataPublisher: CurrentValueSubject<(qrImage: String, brImage: String, name: String), Never> = .init(("", "", ""))
    public var loadingActivityPublisher: PassthroughSubject<Bool, Never> = .init()
    public var alertPublisher: PassthroughSubject<(title: String, message: String), Never> = .init()
    public var transitPublisher: PassthroughSubject<RPPaymentMethodEntity?, Never> = .init()

    /// store properties
    private var shopper: RPPaymentMethodEntity?
}

extension RPPaymentMethodViewModel {
    private func initializeAction() {
        // binding input and output
        self.userAuthTrigger
            .flatMap { [unowned self] _ in
                self.loadingActivityPublisher.send(true)
                return Just(())
            }
            .receive(on: DispatchQueue.global())
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

        self.transitTrigger
            .sink { [unowned self] _ in
                self.transitPublisher.send(self.shopper)
            }
            .store(in: &self.subscription)
    }
}

// MARK: response handle

extension RPPaymentMethodViewModel {
    private func handleAuthResponse(_ shopper: RPPaymentMethodEntity) {
        self.shopper = shopper
        // stop animate
        self.loadingActivityPublisher.send(false)
        self.responseDataPublisher.value = (shopper.qrcodeName, shopper.barcodeName, shopper.lastName ?? "")
    }

    private func handleAuthFail(apiError: APIError) {
        self.loadingActivityPublisher.send(false)
        self.alertPublisher.send((apiError.errorCode, apiError.errorMessage))
    }
}
