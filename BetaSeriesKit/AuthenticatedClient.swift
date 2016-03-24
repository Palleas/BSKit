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
    
    private static let baseURL = NSURL(string: "https://api.betaseries.com")!
    
    let key: String
    public let token: String
    
    public init(key: String, token: String) {
        self.key = key
        self.token = token
    }

    public func fetchMemberInfos() -> SignalProducer<Member, AuthenticatedClientError> {
        return FetchMemberInfos()
            .send(NSURLSession.sharedSession(), baseURL: AuthenticatedClient.baseURL, key: key, token: token)
            .flatMapError {
                return SignalProducer(error: AuthenticatedClientError.InternalError(actualError: $0))
        }
    }

    public func fetchShows() -> SignalProducer<Show, AuthenticatedClientError> {
        let request = FetchMemberInfos().send(NSURLSession.sharedSession(), baseURL: AuthenticatedClient.baseURL, key: key, token: token)
        
        let showsSignalProducer = request.flatMap(.Latest, transform: { return SignalProducer(values: $0.shows) })
        
        return showsSignalProducer.flatMapError {
            return SignalProducer(error: AuthenticatedClientError.InternalError(actualError: $0))
        }
    }
    
    public func fetchEpisodes(id: Int) -> SignalProducer<Episode, AuthenticatedClientError> {
        let request = FetchEpisodes(id: id)
            .send(NSURLSession.sharedSession(), baseURL: AuthenticatedClient.baseURL, key: key, token: token)
        
        return request.flatMapError {
            return SignalProducer(error: AuthenticatedClientError.InternalError(actualError: $0))
        }
    }

    public func fetchImageForEpisode(id: Int, width: Int, height: Int) -> SignalProducer<UIImage, AuthenticatedClientError> {
        return FetchEpisodePicture(id: id, width: width, height: height)
            .send(NSURLSession.sharedSession(), baseURL: AuthenticatedClient.baseURL, key: key, token: token)
            .flatMapError {
                return SignalProducer(error: AuthenticatedClientError.InternalError(actualError: $0))
            }
    }
}
