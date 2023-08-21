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

public struct RPCusomerDetailDTO: Codable {
    let easyID: String
    let payments: [PaymentResponse]

    public struct PaymentResponseDTO: Codable {
        let address: String
        let cardPaymentAmount: String
        let merchantCode: String
        let merchantName: String
    }
}

public extension RPCusomerDetailDTO {
    func toDomain() -> RPCusomerDetailEntity {
        return RPCusomerDetailEntity(easyID: easyID, payments: payments.map { RPCusomerDetailEntity.PaymentEntity(address: $0.address, cardPaymentAmount: $0.cardPaymentAmount, merchantCode: $0.merchantCode, merchantName: $0.merchantName) })
    }
}
