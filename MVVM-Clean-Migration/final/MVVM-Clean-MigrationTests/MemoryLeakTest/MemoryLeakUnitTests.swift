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

import MVVM_Clean_Migration
import XCTest
class MemoryLeakUnitTests: XCTestCase {
    func testObjectIsLeaking() {
        let (sut, depenedency) = self.makeSUT()
//        sut.start()
    }

    private func makeSUT() -> (sut: RetainCycleObject, dependency: RetainCycleDefaultDependency) {
        let dependency = RetainCycleDefaultDependency()
        let object = RetainCycleObject(dependency: dependency)
        self.traceMemoryLeak(object: dependency)
        self.traceMemoryLeak(object: object)
        return (object, dependency)
    }

    private func traceMemoryLeak(object: AnyObject, path: StaticString = #filePath, codeLine: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "this object \(String(describing: object)) may cause memory leak", file: path, line: codeLine)
        }
    }
}
