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

public final class RPCusomerDetailDefaultRepository: RPCusomerDetailRepository {
    /// inject service loader
    private let remoteDataLoader: DataServiceLoader
    
    public init(remoteDataLoader: DataServiceLoader = RemoteDataLoader()) {
        self.remoteDataLoader = remoteDataLoader
    }
    
    public func retrieveHistoryData(easyID: String) -> AnyPublisher<RPCusomerDetailEntity, APIError> {
        var parameters = [String: Any]()
        parameters["easyID"] = easyID
       
        let endpoint = NetworkEndpoint<RPCusomerDetailDTO>(path: Constants.APIPath.HISTORY, method: HTTPMethod.post, parameters: parameters)

        return self.remoteDataLoader.load(with: endpoint)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
