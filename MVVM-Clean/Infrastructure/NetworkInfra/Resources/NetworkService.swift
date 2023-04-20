//
//  NetworkService.swift
//  
//
//  Created by Shine on 2022/3/13.
//

import Foundation

public enum NetworkError: Swift.Error {
    case error(NetworkInformation)
    case notConnect
    case canceled
    
    var description : (title:String , msg :String ){
        switch self {
        case .error(let information):
            return (information.title,information.errMessage)
        default:
            return ("","")
        }
    }
    
    var errorCode : Int{
        switch self {
        case .error(let information):
            return information.sessionManagerCode
        default:
            return -999
        }
    }
    
    public struct NetworkInformation{
        var title:String
        var errMessage:String
        var responseHttpStatusCode: Int
        var sessionManagerCode: Int
        var fullDescription:String
    }
    
}

public protocol NetworkCancellable {
    func cancel()
}

public protocol NetworkService {
    
    var config : NetworkConfig{get set}
    
    typealias NetworkServiceCompleteHandler = (Result<Data?, Error>) -> Void
    
    typealias NetworkServiceDownloadCompleteHandler = (Result<URL? ,Error>) -> Void
    
    func request<R:Responseable>(endPoint: R, completion : @escaping NetworkServiceCompleteHandler )
  
}

public final class RemoteNetworkService: NetworkService {
    
    
    
    private var sessionManager: NetworkSessionManager
    public var config: NetworkConfig
    
    
    
    public init(config: NetworkConfig,
                sessionManager: NetworkSessionManager = URLSessionManager()) {
        self.config = config
        self.sessionManager = sessionManager      
    }
    
    public func request<R:Responseable>(endPoint: R, completion: @escaping NetworkServiceCompleteHandler) {
              
        let urlComponent = endPoint.url(config: config)
        
        self.sessionManager.sessionRequest(url: urlComponent, endPoint: endPoint) { data, error in
            if let networkError = error as? NetworkError {
                completion(.failure(networkError))
                
            } else {
                completion(.success(data))
            }
        }
    }
}

