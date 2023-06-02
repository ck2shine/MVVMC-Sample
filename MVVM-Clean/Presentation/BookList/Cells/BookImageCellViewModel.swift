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
public class BookImageCellViewModel: BookItemViewModelProtocol{
    public var cellHeight: CGFloat = 100
    

    public var mainTitle: CurrentValueSubject<String,Never>
    public var subTitle: CurrentValueSubject<String,Never>
    public var imageName: CurrentValueSubject<String?,Never>
    
    public init(mainTitle: String, subTitle: String, imageName: String?) {
        self.mainTitle =  CurrentValueSubject<String,Never>(mainTitle)
        self.subTitle =  CurrentValueSubject<String,Never>(subTitle)
        self.imageName = CurrentValueSubject<String?,Never>(imageName)
    }
    
}
