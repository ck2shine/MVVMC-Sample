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

public struct RPPaymentMethodEntity {
    public init(firstName: String? = nil, lastName: String? = nil, barcodeName: String, qrcodeName: String, easyID: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.barcodeName = barcodeName
        self.qrcodeName = qrcodeName
        self.easyID = easyID
    }

    var firstName: String?
    var lastName: String?
    var barcodeName: String
    var qrcodeName: String
    var easyID: String
}
