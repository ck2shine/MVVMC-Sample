//
//  MVVM_Clean_MigrationTests.swift
//  MVVM-Clean-MigrationTests
//
//  Created by Chang, Chih Hsiang | Shine | RP on 2023/08/21.
//

import XCTest
import MVVM_Clean_Migration
import SnapshotTesting
final class MVVM_Clean_MigrationTests: XCTestCase {
   

    override class func setUp() {
        let env = ProcessInfo().environment
        
        super.setUp()
//        isRecording = true
    }
    
    func testPaymentViewController()  {
        let container = PaymentFlowContainer()
        container.registerPaymentMethodDependency()
        
        let vc = RPPaymentMethodViewController(dependency: container)
        assertSnapshot(of: vc, as: .image)
     
    }
    
    private func testViewOndifferentDevices(){
        
    }

}
