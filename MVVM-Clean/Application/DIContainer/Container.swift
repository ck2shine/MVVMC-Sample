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

public class Container {
    private var dependencies: [ObjectIdentifier: () -> Any] = [:]

    public func register<T>(forKey key: T.Type, _ factory: @escaping () -> T) {
        let objectKey = ObjectIdentifier(key)
        dependencies[objectKey] = factory
    }

    public func resolve<T>(forKey: T.Type) -> T? {
        let key = ObjectIdentifier(forKey)
        let factory = dependencies[key]
        return factory?() as? T
    }
}


