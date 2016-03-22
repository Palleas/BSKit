//
//  AuthenticatedClient.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-14.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import ReactiveCocoa

public class AuthenticatedClient: NSObject {
    
    public enum AuthenticatedClientError: ErrorType {
        case InternalError(actualError: RequestError)
    }
    
    private static let baseURL = NSURL(string: "https://www.betaseries.com")!
    
    let key: String
    public let token: String
    
    public init(key: String, token: String) {
        self.key = key
        self.token = token
    }

    public func fetchShows() -> SignalProducer<Show, AuthenticatedClientError> {
        let request = FetchMemberInfos().send(NSURLSession.sharedSession(), baseURL: AuthenticatedClient.baseURL, key: key, token: token)
        
        let showsSignalProducer = request.flatMap(.Latest, transform: { return SignalProducer(values: $0.shows) })
        
        return showsSignalProducer.flatMapError {
            return SignalProducer(error: AuthenticatedClientError.InternalError(actualError: $0))
        }
    }
    
    public func fetchEpisodes(show: Show) -> SignalProducer<Episode, AuthenticatedClientError> {
        let request = FetchEpisodes(id: show.id)
            .send(NSURLSession.sharedSession(), baseURL: AuthenticatedClient.baseURL, key: key, token: token)
        
        return request.flatMapError {
            return SignalProducer(error: AuthenticatedClientError.InternalError(actualError: $0))
        }
    }

}
