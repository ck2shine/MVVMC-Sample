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
import NetworkInfra
public final class BookListDefaultRepository: BookListRepository {
    private let bookListServiceLoader: DataServiceLoader
    
    public init(bookListServiceLoader: DataServiceLoader) {
        self.bookListServiceLoader = bookListServiceLoader
    }
    
    public func retrieveBookItems() -> AnyPublisher<BookListEntity, Error> {
        Future { promise in
            var param = [String: String]()
            param["name"] = "John"
            let endPoint = NetworkEndpoint<BookListDTO>(APIParameters: param, method: .post)
                
            self.bookListServiceLoader.load(with: endPoint) { result in
                switch result {
                case .success(let responseDTO):
                    promise(.success(responseDTO.toDomain()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func retrieveBookFromCache() -> AnyPublisher<BookListEntity, Error> {
        Future { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                promise(.failure(APIError.networkError("Customer error")))
                
                let entity = BookItemEntity(bookName: "1st Book", bookImageName: "book1", bookDescription: "My first Book")
                
                let list = BookListEntity(items: [entity])
                promise(.success(list))
            }
        }
        .eraseToAnyPublisher()
    }
}

enum APIError: Error {
    case networkError(String)
}

/*
 
 func customPublisher() -> AnyPublisher<String, Error> {
     return Future { promise in
         promise(.success("Hello, world!"))
     }
     .map { string -> String in
         // Custom transformation of the input string
         return string.uppercased()
     }
     .flatMap { _ -> AnyPublisher<String, Error> in
         // Custom network call or another async operation
         let value = "Custom async value"
         return Just(value)
             .setFailureType(to: Error.self)
             .eraseToAnyPublisher()
     }
     .mapError { error -> Error in
         // Custom error mapping
         return CustomError.someError
     }
     .eraseToAnyPublisher()
 }
 
 */
