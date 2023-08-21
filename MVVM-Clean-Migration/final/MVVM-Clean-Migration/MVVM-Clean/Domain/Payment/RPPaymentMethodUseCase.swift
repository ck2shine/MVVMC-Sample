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

public protocol RPPaymentMethodUseCase {
    func retrieveUserInformation(shopperEntity: RPPaymentMethodEntity?) -> AnyPublisher<RPPaymentMethodEntity, APIError>
}

public final class RPPaymentMethodDefaultUseCase: RPPaymentMethodUseCase {
    private var repository: RPPaymentMethodRepository

    public init(repository: RPPaymentMethodRepository) {
        self.repository = repository
    }

    public func retrieveUserInformation(shopperEntity: RPPaymentMethodEntity?) -> AnyPublisher<RPPaymentMethodEntity, APIError> {
        // usecase logic
        if let entity = shopperEntity {
            return Just(entity)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        } else {
            // load from network
            return repository.retrieveUserInformation()
        }
    }
}
