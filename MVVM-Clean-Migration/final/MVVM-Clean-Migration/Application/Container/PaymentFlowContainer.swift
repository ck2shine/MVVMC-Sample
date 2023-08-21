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

import Foundation

public final class PaymentFlowContainer: Container {
    
    ///first flow
    public func registerPaymentMethodDependency() {
        self.register(forKey: RPPaymentMethodViewModel.self) {
            let repository = RPPaymentMethodDefaultRepository()
            let useCase = RPPaymentMethodDefaultUseCase(repository: repository)
            let viewModel = RPPaymentMethodViewModel(useCase: useCase)
            return viewModel
        }
    }
    
    ///second flow
    public func registerCustomerDetailDependency(entity: RPPaymentMethodEntity?){
        self.register(forKey: RPCusomerDetailViewModel.self) {
            let repository = RPCusomerDetailDefaultRepository()
            let useCase = RPCusomerDetailDefaultUseCase(repository: repository)
            let viewModel = RPCusomerDetailViewModel(useCase: useCase, entity: entity)
            return viewModel
        }
    }
}
