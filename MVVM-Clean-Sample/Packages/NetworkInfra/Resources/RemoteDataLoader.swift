//
//  RemoteDataLoader.swift
//  
//
//  Created by Shine on 2022/3/13.
//

import Foundation

public enum DataLoaderError: Swift.Error {
    case noResponse
    case parseDataError(Error)
    case customerError((title:String , msg : String))
    case specialControlError((title:String , msg : String , code:Int))
    case unknowNetworkFailure(Error)
    
    public var description : (title:String , msg : String) {
        switch self {
        case .customerError(let messagePackage):
            return (messagePackage.title,messagePackage.msg)
        default:
            return ("","")
        }
    }
}

public enum DataLoaderResult<T> {
    case success(T)
    case failure(DataLoaderError)
}


public protocol DataServiceLoader {   
    
    typealias CompletionHanlder<T> = (DataLoaderResult<T>) -> Void
    
    func load<T, E: Responseable>(with endPoint: E, completion :@escaping CompletionHanlder<T>) where E.Response == T
}

public protocol NetworkDataRequest{
    associatedtype response: Decodable
}


public final class RemoteDataLoader: DataServiceLoader {

    private func handleNetworkDecision<EndPoint: Decisionable>(_ endPoint: EndPoint ,params: [String : Any] , data: Data ,info: String, decisions: [NetworkDecision] , completion :@escaping CompletionHanlder<EndPoint.Response>){
        guard decisions.isEmpty == false else {
            fatalError("no any decisions , can not stop the network process")
        }

        var decisions = decisions
        let currentDecision = decisions.removeFirst()
        guard currentDecision.shouldApply(params: params) else {
            handleNetworkDecision(endPoint, params: params, data: data, info: info, decisions: decisions,completion: completion)
            return
        }

        currentDecision.apply(endPoint: endPoint, data: data, info: info){ afterAction in
            switch afterAction{
            case .continueWith(let data):
                self.handleNetworkDecision(endPoint, params: params, data:data, info: info , decisions:decisions,completion: completion)
            case .errorOccur(let error):
                completion(.failure(error))
            case .done(let value):
                completion(.success(value))
            }
        }

    }


    public var networkSerivce: NetworkService

    public init(inService networkSerivce: NetworkService) {
        self.networkSerivce = networkSerivce
    }
    
    public func load<T, E: Responseable>(with endPoint: E, completion :@escaping CompletionHanlder<T>) where E.Response == T {
        self.networkSerivce.request(endPoint: endPoint) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):

                DispatchQueue.main.async {

                    guard let data = data else {
                        completion(.failure(.noResponse))
                        return
                    }

                    let urlInfo =  self.networkSerivce.config.fetchUrl.absoluteString
                    self.handleNetworkDecision(endPoint, params: endPoint.APIParameters, data: data, info: urlInfo, decisions: endPoint.decisions, completion: completion)
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(self.parseError(error: error)))
                }
            }
        }
    }

    private struct DecodeResultData<T>{
        var result: DataLoaderResult<T>
        var rtnMsgTitle: String
        var rtnMsg: String
        var rtnCode: Int
    }
    
    // MARK: parse error
    private func parseError(error: Error) -> DataLoaderError {
        if let tempError = error as? NetworkError {
            return .customerError( tempError.description)
        } else {
            return .unknowNetworkFailure(error)
        }
    }
}
