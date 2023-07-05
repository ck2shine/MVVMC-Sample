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
import SnapshotTesting
import MVVM_Clean
import NetworkInfra
class BookListViewControllerSnapshotTest: XCTestCase {

   
    
    override func setUp() {
        super.setUp()
    }
    
    func test_bookListViewControllerUI(){
      
        let sut = self.makeSnapShotSUT()

        sut.loadViewIfNeeded()

        assertSnapshot(matching: sut, as: .image)

        isRecording = false

    }
    
    private func makeSnapShotSUT()-> BookListViewController{
       

        let service = RemoteNetworkService(config: RemoteConfing(fetchUrl: URL(string: "www.test.com")!))
        let mockLoader = RemoteDataLoader(inService: service)
        
        let dependency = BookListDependency(denpendency: BookListDependency.Dependency(bookListAPILoader: mockLoader))
        let sut = BookListViewController(dependency: dependency)
        return sut
    }

    

}

