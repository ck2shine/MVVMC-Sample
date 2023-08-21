//
//  RemoteDataLoader.swift
//
//
//  Created by Shine on 2022/3/13.
//

import Combine
import Foundation
// public enum DataLoaderResult<T> {
//    case success(T)
//    case failure(APIError)
// }

public protocol DataServiceLoader {
    func load<T, E>(with endPoint: E) -> AnyPublisher<T, APIError> where T == E.Response, E: Responseable
}

public final class RemoteDataLoader: DataServiceLoader {
    public init() {}
    public func load<T, E>(with endPoint: E) -> AnyPublisher<T, APIError> where T == E.Response, E: Responseable {
        return Future { promise in
            let parameters = endPoint.parameters
            let path = endPoint.path
            let method = endPoint.method
            NetworkRequest.request(path: path, method: method, parameters: parameters, responseObject: T.self, showProgress: false) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .error(let apiError):
                    promise(.failure(apiError))
                }
            }
        }.eraseToAnyPublisher()
    }
}
