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

public protocol RPCusomerDetailViewModelInput {
    var userHistoryTrigger: PassthroughSubject<Void, Never> { get set }
}

public protocol RPCusomerDetailViewModelOutput {
    var userNamePublisher: CurrentValueSubject<String, Never> { get set }
    var loadingActivityPublisher: PassthroughSubject<Bool, Never> { get set }
    var alertPublisher: PassthroughSubject<(title: String, message: String), Never> { get set }
    var transactionItemsPublisher: CurrentValueSubject<[CustomerItemViewModelProtocol], Never> { get set }
}

public protocol RPCusomerDetailViewModelManager {
    var input: RPCusomerDetailViewModelInput { get }
    var output: RPCusomerDetailViewModelOutput { get }
}

public class RPCusomerDetailViewModel: RPCusomerDetailViewModelInput, RPCusomerDetailViewModelOutput, RPCusomerDetailViewModelManager {
    private var subscription = Set<AnyCancellable>()
    private let useCase: RPCusomerDetailUseCase

    public init(useCase: RPCusomerDetailUseCase, entity: RPPaymentMethodEntity?) {
        self.useCase = useCase
        self.entity = entity
        self.initializeAction()
    }

    public var input: RPCusomerDetailViewModelInput {
        return self
    }

    public var output: RPCusomerDetailViewModelOutput {
        return self
    }

    /// input
    public var userHistoryTrigger: PassthroughSubject<Void, Never> = .init()
    /// output
    public var userNamePublisher: CurrentValueSubject<String, Never> = .init("")
    public var loadingActivityPublisher: PassthroughSubject<Bool, Never> = .init()
    public var alertPublisher: PassthroughSubject<(title: String, message: String), Never> = .init()

    public var transactionItemsPublisher: CurrentValueSubject<[CustomerItemViewModelProtocol], Never> = .init([])

    /// store properties
    private var entity: RPPaymentMethodEntity?
}

extension RPCusomerDetailViewModel {
    private func initializeAction() {
        // binding input and output
        self.userHistoryTrigger
            .flatMap { [unowned self] _ in
                self.loadingActivityPublisher.send(true)
                return Just(())
            }
            .receive(on: DispatchQueue.global())
            .setFailureType(to: APIError.self)
            .flatMap { [unowned self] _ in
                self.useCase.retrieveHistoryData(easyID: self.entity?.easyID)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] item in
                if case .failure(let error) = item {
                    self.didFinishRecordWithError(error: error)
                }

            } receiveValue: { [unowned self] entity in
                self.didFinishRecordsRequest(entity)
            }
            .store(in: &self.subscription)
    }

    private func didFinishRecordsRequest(_ entity: RPCusomerDetailEntity) {
        self.loadingActivityPublisher.send(false)

        let model = RPCusomerDetailModel()

        // assign transactions to table
        self.transactionItemsPublisher.value = model.convertDataToCellViewModel(entity: entity)

        // assign name label value
        self.userNamePublisher.value = "\(self.entity?.lastName ?? "") \(self.entity?.firstName ?? "") Payment History"
    }

    private func didFinishRecordWithError(error: APIError) {
        self.loadingActivityPublisher.send(false)
        self.alertPublisher.send((error.errorCode, error.errorMessage))
    }
}
