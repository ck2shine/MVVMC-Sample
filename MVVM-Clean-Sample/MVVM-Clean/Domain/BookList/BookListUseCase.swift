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
import Combine
public protocol BookListUseCase{
    
    func fetchBookItems() -> AnyPublisher<BookListEntity,Error>
}

public class BookListDefaultUseCase: BookListUseCase{
 
    private let repository: BookListRepository
    
    public init(repository: BookListRepository){
        self.repository = repository
    }
    
    public func fetchBookItems() -> AnyPublisher<BookListEntity, Error> {
        return self.repository.retrieveBookItems()
    }
}
