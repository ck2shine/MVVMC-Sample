//
//  NetworkEndpoint.swift
//  
//
//  Created by Shine on 2022/3/13.
//


import Foundation

public enum HTTPRestfulType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public class NetworkEndpoint<R:Decodable>: Responseable {
    public var isAjax: Bool
    public var headers: [String: String]
    public var APIParameters: [String: Any]
    public var method: HTTPRestfulType
    public var path: String?
    public typealias Response = R
    public init(APIParameters: [String: Any] ,
                method: HTTPRestfulType ,
                headers: [String: String] = [:],
                isAjax: Bool = true,
                path: String? = nil
               ) {
        self.method = method     
        self.headers = headers
        self.APIParameters = APIParameters
        self.isAjax = isAjax
        self.path = path
    }
}


public protocol Requestable {
    var isAjax: Bool{ get }
    var method: HTTPRestfulType { get }
    var headers: [String: String] { get }
    var APIParameters: [String: Any] { get }
    var path: String?{ get }
}

public protocol Responseable: Requestable , Decisionable {
//    associatedtype Response: Decodable
}

extension Requestable{
    public func url(config : NetworkConfig )->URLComponents{
        let url = config.fetchUrl
       
        guard var urlComponent = URLComponents(string: url.absoluteString) else{
            fatalError("generate url error")
        }
 
        if method == .get{
            urlComponent.queryItems =  APIParameters.map{
                let value = $0.value as? String ?? ""
                return URLQueryItem(name: $0.key, value: value)
            }
        }
        
        if let pathString = self.path{
            urlComponent.path = pathString
        }
      
        return urlComponent
    }
}

