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
public struct Shopper {
    var firstName: String?
    var lastName: String?
    var barcodeName: String
    var qrcodeName: String
    var easyID: String

    public init(shopperAuth: AuthResponse) {
        self.firstName = shopperAuth.firstName
        self.lastName = shopperAuth.lastName
        self.barcodeName = shopperAuth.barcodeName
        self.qrcodeName = shopperAuth.qrcodeName
        self.easyID = shopperAuth.easyID
    }
}
