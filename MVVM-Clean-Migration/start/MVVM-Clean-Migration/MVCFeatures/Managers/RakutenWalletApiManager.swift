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

enum AuthAPIResponseStatus {
    case success(shopper: Shopper)
    case error(error: APIError)
}

enum HistoryAPIResponseStatus {
    case success(transaction: [Transaction])
    case error(error: APIError)
}

enum RakutenWalletApiManager {
    static func auth(completion: @escaping (_ responseStatus: AuthAPIResponseStatus) -> Void) {
        APIManager.auth { response in
            switch response {
            case .success(let result):
                let shopper = Shopper(shopperAuth: result)
                completion(AuthAPIResponseStatus.success(shopper: shopper))
            case .error(let error):
                completion(AuthAPIResponseStatus.error(error: error))
            }
        }
    }

    static func history(easyID: String, completion: @escaping (_ responseStatus: HistoryAPIResponseStatus) -> Void) {
        APIManager.getPaymentHistory(easyID: easyID) { response in
            switch response {
            case .success(let result):
                let transactionList = result.payments.compactMap {
                    Transaction(address: $0.address, cardPaymentAmount: $0.cardPaymentAmount, merchantCode: $0.merchantCode, merchantName: $0.merchantName)
                }
                completion(HistoryAPIResponseStatus.success(transaction: transactionList))
            case .error(let error):
                completion(HistoryAPIResponseStatus.error(error: error))
            }
        }
    }
}
