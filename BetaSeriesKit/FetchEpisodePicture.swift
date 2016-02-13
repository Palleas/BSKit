//
//  FetchEpisodePicture.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-13.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import ReactiveCocoa

class FetchEpisodePicture: Request {
    typealias ObjectModel = UIImage
    
    var endpoint: String {
        return "/pictures/episodes"
    }
    
    var method: RequestMethod = .Get
    
    var body: [String: AnyObject]? {
        return nil
    }
    
    var params: [String: AnyObject]? {
        return ["id": id, "width": width, "height": height]
    }
    
    let id: Int
    let width: Int
    let height: Int
    
    init(id: Int, width: Int, height: Int) {
        self.id = id
        self.width = width
        self.height = height
    }
    
    func send(session: NSURLSession, baseURL: NSURL, key: String, token: String?) -> SignalProducer<FetchEpisodePicture.ObjectModel, RequestError> {
        return performRequest(session, baseURL: baseURL, key: key, token: token)
            .flatMap(.Latest, transform: { (data) -> SignalProducer<UIImage, RequestError> in
                if let image = UIImage(data: data) {
                    return SignalProducer(value: image)
                }
                
                return SignalProducer(error: RequestError.NotFound)
            })
    }

}
