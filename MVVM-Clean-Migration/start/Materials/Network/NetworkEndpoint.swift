//
//  NetworkEndpoint.swift
//
//
//  Created by Shine on 2022/3/13.
//

import Foundation

public class NetworkEndpoint<R: Codable>: Responseable {
    public var path: String
    public var method: HTTPMethod
    public var parameters: [String: Any]

    public typealias Response = R
    public init(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}

public protocol Requestable {
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var path: String { get }
}

public protocol Responseable: Requestable {
    associatedtype Response: Codable
}
