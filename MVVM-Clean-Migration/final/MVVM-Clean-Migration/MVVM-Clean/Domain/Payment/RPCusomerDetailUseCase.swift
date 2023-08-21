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

public protocol RPCusomerDetailUseCase {
    func retrieveHistoryData(easyID: String?) -> AnyPublisher<RPCusomerDetailEntity, APIError>
}

public final class RPCusomerDetailDefaultUseCase: RPCusomerDetailUseCase {
    private var repository: RPCusomerDetailRepository

    public init(repository: RPCusomerDetailRepository) {
        self.repository = repository
    }

    public func retrieveHistoryData(easyID: String?) -> AnyPublisher<RPCusomerDetailEntity, APIError> {
        guard let easyID = easyID else {
            return Fail(error: APIError(errorCode: "parameter error", errorMessage: "easyId can not be empty")).eraseToAnyPublisher()
        }
        return self.repository.retrieveHistoryData(easyID: easyID)
    }
}
