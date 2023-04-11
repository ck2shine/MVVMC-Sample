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

import XCTest
import iOSSnapshotTestCase
import MVVM_Clean

class BookListViewControllerSnapshotTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = true
    }
    
    
    private class  MockBookListUseCase: BookListUseCase{
        
    }
    
    func test_bookListViewControllerUI(){
      
        let mockUserCase = MockBookListUseCase()
        
        let viewModel = BookListViewModel(useCase: mockUserCase)
        
        let sut = BookListViewController(viewModel: viewModel)
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.bookTitleLabel)
        XCTAssertNotNil(sut.searchButton)
        FBSnapshotVerifyViewController(sut)
    }

 

}

