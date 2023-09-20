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
public protocol RetainCycleDependency {
    func start()
}

public class RetainCycleDefaultDependency: RetainCycleDependency {
    private var timer: Timer = .init()
    private var prise = 100
    public init(){}
    public func start() {
        self.timer = Timer(timeInterval: 1, repeats: false, block: { _ in

            self.prise += 100
        })
    }

    deinit {
        print("RetainCycleDefaultDependency has been deallocated")
    }
}
