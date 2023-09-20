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
public class APIError: Swift.Error {
    public init(errorCode: String = "", errorMessage: String = "") {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

    // MARK: Properties

    /// Error Code.
    var errorCode: String = ""
    /// Error Message.
    var errorMessage: String = ""
}
