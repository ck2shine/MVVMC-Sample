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

// MARK: for business logic

public struct BookListModel {
    public func convertDataToModels(entity: BookListEntity) -> [BookImageCellViewModel] {
        let viewModels = entity.items.map {
            BookImageCellViewModel(mainTitle: $0.bookName, subTitle: $0.bookDescription, imageName: $0.bookImageName)
        }
        return viewModels
    }

    public func converToBookItemDetailEntity(cellViewModel: BookImageCellViewModel) -> RPBookItemDetailEntity {
        return RPBookItemDetailEntity(bookName: cellViewModel.mainTitle.value , bookImageName: cellViewModel.imageName.value ?? "", bookDescription: cellViewModel.subTitle.value)
    }
}
