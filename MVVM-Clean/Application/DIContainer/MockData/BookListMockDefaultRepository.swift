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

public final class BookListMockDefaultRepository: BookListRepository{
    public func retrieveBookItems() -> AnyPublisher<BookListEntity, Error> {
        Future{ promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                
                let entity1 = BookItemEntity(bookName: "1st Book", bookImageName: "pencil", bookDescription: "My first Book")
                let entity2 = BookItemEntity(bookName: "2nd Book", bookImageName: "eraser", bookDescription: "My second Book")
                let entity3 = BookItemEntity(bookName: "About Cook", bookImageName: "sun.dust.fill", bookDescription: "Flavors Unleashed is a tantalizing culinary expedition that takes food enthusiasts on a vibrant and aromatic voyage through the diverse and delicious world of cooking. With a plethora of recipes, tips, and personal anecdotes, this book is a treasure trove for both novice and experienced cooks alike.")
                
                let list = BookListEntity(items: [entity1,entity2,entity3])
                
    
                    promise(.success(list))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    public func retrieveBookFromCache() -> AnyPublisher<BookListEntity, Error> {
        Future{ promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                
//                promise(.failure(APIError.networkError("Customer error")))
                
                let entity = BookItemEntity(bookName: "1st Book", bookImageName: "book1", bookDescription: "My first Book")
                
                let list = BookListEntity(items: [entity])
                    promise(.success(list))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
}
