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


public class RPCusomerDetailViewModel {
    private var subscription = Set<AnyCancellable>()
    private let useCase: RPCusomerDetailUseCase

    public init(useCase: RPCusomerDetailUseCase, entity: RPPaymentMethodEntity?) {
        self.useCase = useCase
        self.entity = entity
        self.initializeAction()
    }

    /// input
    @Published public var userHistoryTrigger: Void  = ()
    /// output
    @Published public var userNamePublisher: String  = ""
    @Published public var loadingActivityPublisher: Bool = false
    @Published public var alertPublisher: (title: String, message: String) = ("","")
    @Published public var transactionItemsPublisher: CurrentValueSubject<[CustomerItemViewModelProtocol], Never> = .init([])

    /// store properties
    private var entity: RPPaymentMethodEntity?
}

extension RPCusomerDetailViewModel {
    private func initializeAction() {
        // binding input and output
        self.$userHistoryTrigger
            .flatMap { [unowned self] _ in
                self.loadingActivityPublisher = true
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
        self.loadingActivityPublisher = false

        let model = RPCusomerDetailModel()

        // assign transactions to table
        self.transactionItemsPublisher.value = model.convertDataToCellViewModel(entity: entity)

        // assign name label value
        self.userNamePublisher = "\(self.entity?.lastName ?? "") \(self.entity?.firstName ?? "") Payment History"
    }

    private func didFinishRecordWithError(error: APIError) {
        self.loadingActivityPublisher = false
        self.alertPublisher = (error.errorCode, error.errorMessage)
    }
}
