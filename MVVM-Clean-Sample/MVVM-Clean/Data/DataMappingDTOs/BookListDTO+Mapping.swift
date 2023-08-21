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



public struct BookListDTO: Decodable{
    public var items: [BookListItemDTO]
}

extension BookListDTO {
    public func toDomain() -> BookListEntity {
        return BookListEntity(items: items.map{$0.toDomain()})
    }
}

public struct BookListItemDTO: Decodable {
    public var bookName: String
    public var bookImageName: String
    public var bookDescription: String
}

extension BookListItemDTO {
    public func toDomain() -> BookItemEntity {
        return BookItemEntity(bookName: bookName, bookImageName: bookImageName, bookDescription: bookDescription)
    }
}
