//
//  FetchEpisodes.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-05.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa

class FetchEpisodes: NSObject, Request {
    typealias ObjectModel = Episode
    
    var endpoint: String {
        return "/shows/episodes"
    }
    
    var method: RequestMethod = .Get
    
    var body: [String: AnyObject]? {
        return nil
    }

    var params: [String: AnyObject]? {
        return ["id": id]
    }
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func send(session: NSURLSession, baseURL: NSURL, key: String, token: String?) -> SignalProducer<FetchEpisodes.ObjectModel, RequestError> {
        return performRequest(session, baseURL: baseURL, key: key, token: token)
            .mapArray(Episode.self, rootKey: "episodes")
    }
}
