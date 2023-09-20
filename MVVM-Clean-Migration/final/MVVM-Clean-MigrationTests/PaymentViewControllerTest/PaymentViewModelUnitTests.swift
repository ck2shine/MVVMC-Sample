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
import MVVM_Clean_Migration
import XCTest
class PaymentViewModelUnitTests: XCTestCase {
    private var subscription = Set<AnyCancellable>()
    
    private class MockRPPaymentMethodUseCase: RPPaymentMethodUseCase {
        private var isFail: Bool
        
        init(isFail: Bool = false) {
            self.isFail = isFail
        }
        
        func retrieveUserInformation(shopperEntity: MVVM_Clean_Migration.RPPaymentMethodEntity?) -> AnyPublisher<MVVM_Clean_Migration.RPPaymentMethodEntity, MVVM_Clean_Migration.APIError> {
            return Future { promise in
                if self.isFail {
                    let error = APIError(errorCode: "404", errorMessage: "APIError")
                    promise(.failure(error))
                } else {
                    let entity = RPPaymentMethodEntity(firstName: "Shine", lastName: "Shine", barcodeName: "TestingBarcode", qrcodeName: "QR", easyID: "12345")
                    promise(.success(entity))
                }
                
            }.eraseToAnyPublisher()
        }
    }
    
    func test_RetrieveBarcode_WithoutEasyID_SuccessResult() {
        // 3A
        /// Arrange
        let sut = makeSUT().sut
        let exp = expectation(description: "test_RetrieveBarcode_WithoutEasyID_SuccessResult fail")
        exp.expectedFulfillmentCount = 1
      
        /// Assert
        sut.$responseDataPublisher
            .dropFirst()
            .sink { response in
              
                /// Assert
                let qrcodeName = response.qrImage
                let barcodeName = response.brImage
                let lastName = response.name
              
                XCTAssertEqual(qrcodeName, "QR")
                XCTAssertEqual(barcodeName, "TestingBarcode")
                XCTAssertEqual(lastName, "Shine")
                exp.fulfill()
            }
            .store(in: &subscription)
        /// Act
        sut.userAuthTrigger = ()
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_RetrieveBarcode_WithoutEasyID_ResponseFail() {
        let sut = makeSUT(failCase: true).sut
        let exp = expectation(description: "test_RetrieveBarcode_WithoutEasyID_ResponseFail fail")
        exp.expectedFulfillmentCount = 1
      
        /// Assert
        sut.$alertPublisher
            .dropFirst()
            .sink { errorTuple in
                XCTAssertEqual(errorTuple.title, "404")
                XCTAssertEqual(errorTuple.message, "APIError")
                exp.fulfill()
            }
            .store(in: &subscription)
             
        /// Act
        sut.userAuthTrigger = ()
        wait(for: [exp], timeout: 0.5)
    }
    
    private func makeSUT(failCase: Bool = false) -> (sut: RPPaymentMethodViewModel, spy: MockRPPaymentMethodUseCase) {
        let spy = MockRPPaymentMethodUseCase(isFail: failCase)
        let sut = RPPaymentMethodViewModel(useCase: spy)
        return (sut, spy)
    }
}
