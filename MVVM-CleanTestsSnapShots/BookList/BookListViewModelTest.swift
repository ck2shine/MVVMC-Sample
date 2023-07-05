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
@testable import MVVM_Clean
import NetworkInfra
import XCTest

class BookListViewModelTest: XCTestCase {
    private var subscription = Set<AnyCancellable>()

    private class MockBookListUseCase: BookListUseCase {
        func fetchBookItems() -> AnyPublisher<MVVM_Clean.BookListEntity, Error> {
            return Future { prmoise in
                let entity1 = BookItemEntity(bookName: "1st Book", bookImageName: "pencil", bookDescription: "My first Book")
                let entity2 = BookItemEntity(bookName: "2nd Book", bookImageName: "eraser", bookDescription: "My second Book")
                let entity3 = BookItemEntity(bookName: "3rd Book", bookImageName: "sun.dust.fill", bookDescription: "My Third Book")

                let entity = BookListEntity(items: [entity1, entity2, entity3])

                prmoise(.success(entity))

            }.eraseToAnyPublisher()
        }
    }

    func testRefreshTriggerToRetriveDataWithCorectEntity() {
        /// 3A
        /// Arrange
        let suit = makeSUT()
        let sut = suit.sut

        let exp = expectation(description: "testRefreshTriggerToRetriveDAtaWithCorectEntity fail")
        exp.expectedFulfillmentCount = 1
        /// output
        sut.output.bookItemsPublisher
            .dropFirst()
            .sink {[weak sut] itmes in
                guard let sut = sut else{return}
                /// Assert
                if let firstItem = itmes[0] as? BookImageCellViewModel {
                    XCTAssertEqual(firstItem.mainTitle.value, "1st Book")
                } else {
                    XCTFail("case BookImageCellViewModel error ")
                }
                XCTAssertEqual(sut.activityItemPublisher.value,false)
                exp.fulfill()
            }
            .store(in: &subscription)

//        /// Act
//        /// input
        sut.input.refreshTableContent.send(())

        wait(for: [exp], timeout: 0.5)
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (
        sut: BookListViewModel, useCase: BookListUseCase)
    {
        let useCase = MockBookListUseCase()
        let sut = BookListViewModel(useCase: useCase)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(useCase, file: file, line: line)
        return (sut, useCase)
    }

    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
