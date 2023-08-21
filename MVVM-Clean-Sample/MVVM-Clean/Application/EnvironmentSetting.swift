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
public enum Environment {
    case debug, release
}
  
public struct EnvironmentSetting {
    public enum Environment {
        case debug, stage ,  release
    }
      
    static var type: Environment {
        #if DEBUG
            return .debug
        #elseif STAGE
            return .stage
        #elseif RELEASE
            return .release
        #endif
    }
}

extension EnvironmentSetting{
    public static let BOOKLIST_REST_API_URL: URL = {
        let urlString: String
        guard let url = URL(string: "https://testing.org/api/") else {
            fatalError("get backend url error")
        }
        return url
    }()
}
