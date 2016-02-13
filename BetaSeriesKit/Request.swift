//
//  Request.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-01-31.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftyJSON

public enum RequestError: ErrorType {
    case InvalidURL
    case RequestError(wrapped: NSError)
}

enum RequestMethod {
    case Get
    case Post
}

extension RequestMethod: CustomStringConvertible {
    var description: String {
        switch self {
        case .Get: return "GET"
        case .Post: return "POST"
        }
    }
}

protocol Model {
    init(payload: JSON)
}

protocol Request {
    
    typealias ObjectModel: Model
    
    var endpoint: String { get }
    var method: RequestMethod { get }
    var body: [String: AnyObject]? { get }
    var params: [String: AnyObject]? { get }
    
    func send(session: NSURLSession, baseURL: NSURL, key: String, token: String?) -> SignalProducer<ObjectModel, RequestError>
}

extension Request {
    func performRequest(session: NSURLSession, baseURL: NSURL, key: String, token: String?) -> SignalProducer<NSData, RequestError> {
        guard let components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: true) else {
            return SignalProducer(error: RequestError.InvalidURL)
        }
        
        components.path = endpoint
        
        if let params = params {
            components.queryItems = params.map({ NSURLQueryItem(name: $0.0, value: "\($0.1)") })
        }
        
        guard let url = components.URL else {
            return SignalProducer(error: RequestError.InvalidURL)
        }
        
        print(url)
        
        let request = NSMutableURLRequest(URL: url)
        request.cachePolicy = .ReloadIgnoringLocalCacheData
        request.setValue(key, forHTTPHeaderField: "X-BetaSeries-Key")
        request.setValue("2.4", forHTTPHeaderField: "X-BetaSeries-Version")
        request.HTTPMethod = method.description
        
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "X-BetaSeries-Token")
        }

        return session
            .rac_dataWithRequest(request)
            .map({ $0.0 })
            .mapError({ return RequestError.RequestError(wrapped: $0) })
    }
    
}