//
//  RequestToken.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-01.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa

public class RequestTokenModel: Model {
    let token: String?

    required public init(payload: JSON) {
        token = payload["token"].string
    }
}

public class RequestToken: NSObject, Request {
    typealias ObjectModel = RequestTokenModel
    
    var endpoint = "/lol"
    
    var method: RequestMethod = .Post

    var body: [String: AnyObject]? {
        return ["code": code]
    }
    
    let code: String

    public init(code: String) {
        self.code = code
    }
}
