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

public struct RPCusomerDetailEntity {
    let easyID: String
    let payments: [PaymentEntity]

    public struct PaymentEntity: Codable {
        let address: String
        let cardPaymentAmount: String
        let merchantCode: String
        let merchantName: String
    }
}
