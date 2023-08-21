//
//  NetworkSessionManager.swift
//  
//
//  Created by Shine on 2022/3/13.
//

import Foundation

public protocol NetworkSessionManager {
    typealias SessionCompletion = (Data?, Error?) -> Void
    typealias DownloadSessionCompletion = (URL?, Error?) -> Void
    func sessionRequest(url: URLComponents ,
                        endPoint: Requestable,
                        in completion :@escaping SessionCompletion)
  
}

public struct ActionInfo{
    public var rtnTitle: String
    public var rtnMsg: String
    public var info: String
}

public class URLSessionManager: NetworkSessionManager {
    
    public init() {}

    
    public func sessionRequest(url: URLComponents, endPoint: Requestable, in completion: @escaping SessionCompletion) {
        
        guard let url = url.url else {return}
        
        let request = URLRequest(url: url)
           
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data,error)
        }
        
        task.resume()
    }
}
