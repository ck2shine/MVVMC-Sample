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
class APIManager {
    /// Auth API call.
    /// - Parameter completion: Completion block.
    static func auth(completion: @escaping (APIResult<AuthResponse>) -> Void) {
        let parameters: [String: Any] = [
            "targetOS": 1,
        ]
      
        NetworkRequest.request(path: Constants.APIPath.AUTH, method: HTTPMethod.post, parameters: parameters, responseObject: AuthResponse.self, showProgress: false) { result in
            completion(result)
        }
    }

    static func getPaymentHistory(easyID: String, completion: @escaping (APIResult<GetPaymentHistoryResponse>) -> Void) {
        var parameters = [String: Any]()
        parameters["easyID"] = easyID
       
        NetworkRequest.request(path: Constants.APIPath.HISTORY, method: HTTPMethod.post, parameters: parameters, responseObject: GetPaymentHistoryResponse.self) { result in
            completion(result)
        }
    }
}
