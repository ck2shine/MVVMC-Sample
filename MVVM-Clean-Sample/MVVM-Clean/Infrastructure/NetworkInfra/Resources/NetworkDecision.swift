//
//  NetworkDecision.swift
//  
//
//  Created by Shine on 2022/3/13.
//


import Foundation

public enum NetworkConfigTest{
    case online , offline
}

public protocol Decisionable{
    var decisions: [NetworkDecision] { get }
    associatedtype Response: Decodable
}

extension Decisionable{
    
    public var decisions: [NetworkDecision]{
        return [           
            ParseNetworkResultDecision()]
    }
}

public protocol NetworkDecision{
    func shouldApply(params: [String: Any])->Bool
    func apply<EndPoint: Decisionable>(
        endPoint: EndPoint,
        data: Data,
        info: String?,
        complete handler: @escaping((NetworkDecisionActions<EndPoint>)->())
    )
}

public enum NetworkDecisionActions<EndPoint: Decisionable>{
    case continueWith(Data)
    case errorOccur(DataLoaderError)
    case done(EndPoint.Response)
}

public struct ParseNetworkResultDecision: NetworkDecision{
    
    public func apply<EndPoint>(endPoint: EndPoint, data: Data, info: String? = nil, complete handler: @escaping ((NetworkDecisionActions<EndPoint>) -> ())) where EndPoint : Decisionable {
        let deconder = JSONDecoder()
        
        do {
            let decodeObject = try deconder.decode(EndPoint.Response.self, from: data)
            handler(.done(decodeObject))
        } catch {
            handler(.errorOccur(.parseDataError(error)))
        }
    }
    
    public func shouldApply(params: [String : Any]) -> Bool {
        return true
    }
    
   
}
