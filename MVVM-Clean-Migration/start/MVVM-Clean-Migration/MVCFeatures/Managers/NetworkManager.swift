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

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

enum APIResult<T> {
    case success(T)
    case error(APIError)
}

class NetworkRequest {
    static func request<T: Codable>(path: String, method: HTTPMethod, parameters: [String: Any]? = nil, responseObject: T.Type, showProgress: Bool = true, completion: @escaping (APIResult<T>) -> Void) {
        var dataResult = Data()
        if path == "ShopperAuth" {
            dataResult = "{\"firstName\":\"Williams\" , \"lastName\":\"David\", \"barcodeName\":\"RPayBarcode\", \"qrcodeName\":\"RPayQRCode\",\"easyID\":\"54236513\"}".data(using: .utf8)!
        } else if path == "ShopperPaymentHistory" {
            dataResult = "{\"easyID\":\"54236513\",\"payments\":[{\"address\":\"Toyko 15-3-8\" , \"cardPaymentAmount\":\"9000\", \"merchantCode\":\"402\", \"merchantName\":\"Loteria\"},{\"address\":\"Shinagawa 11-2-1\" , \"cardPaymentAmount\":\"4500\", \"merchantCode\":\"402\", \"merchantName\":\"McDonald's\"}]}".data(using: .utf8)!
        }
     
        if let jsonObject = try? JSONDecoder().decode(responseObject.self, from: dataResult) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                completion(.success(jsonObject))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                completion(.error(APIError(errorCode: "999", errorMessage: "systemError")))
            }
        }
    }
}
