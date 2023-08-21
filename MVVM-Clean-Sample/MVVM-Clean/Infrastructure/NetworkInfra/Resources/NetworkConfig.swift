//
//  NetworkConfig.swift
//  
//
//  Created by Shine on 2022/3/13.
//

import Foundation
public protocol NetworkConfig {
    var fetchUrl: URL { get set }
}

public struct RemoteConfing: NetworkConfig {
    public var fetchUrl: URL

    public init(fetchUrl: URL ) {
        self.fetchUrl = fetchUrl
    }
}
