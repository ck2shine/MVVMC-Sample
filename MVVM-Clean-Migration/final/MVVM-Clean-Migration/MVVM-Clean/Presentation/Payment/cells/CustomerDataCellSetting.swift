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

public protocol CustomerCellSettingProtocol{
    var nibID: String {get set}
    var cellViewModel: CustomerItemViewModelProtocol?{get set}
    func setupCell(_ viewModel: CustomerItemViewModelProtocol)
}

public protocol CustomerItemViewModelProtocol{
    var cellHeight: CGFloat{get set}
}
