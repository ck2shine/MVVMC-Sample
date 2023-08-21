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

public struct RPPaymentMethodDTO: Codable {
    let firstName: String?
    let lastName: String?
    var barcodeName: String
    var qrcodeName: String
    var easyID: String
}

public extension RPPaymentMethodDTO {
    func toDomain() -> RPPaymentMethodEntity {
        return RPPaymentMethodEntity(firstName: firstName, lastName: lastName, barcodeName: barcodeName, qrcodeName: qrcodeName, easyID: easyID)
    }
}
