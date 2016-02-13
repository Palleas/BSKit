//
//  FetchMemberInfos.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-02.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa

public class Member: Model {
    public let id: Int
    public let login: String
    public let avatar: NSURL?

    required public init(payload: JSON) {
        id = payload["member"]["id"].intValue
        login = payload["member"]["login"].stringValue
        avatar = payload["member"]["avatar"].URL
    }
}

public class FetchMemberInfos: NSObject, Request {
    typealias ObjectModel = Member
    
    var endpoint = "/members/infos"
    
    var method: RequestMethod = .Get
    
    var body: [String: AnyObject]? {
        return nil
    }
    
    var params: [String: AnyObject]? {
        return nil
    }
    
    func send(session: NSURLSession, baseURL: NSURL, key: String, token: String?) -> SignalProducer<FetchMemberInfos.ObjectModel, RequestError> {
        return performRequest(session, baseURL: baseURL, key: key, token: token)
            .mapObject(Member.self)
    }
    
}
