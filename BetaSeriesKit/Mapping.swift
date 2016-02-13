//
//  Mapping.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-10.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftyJSON

extension SignalProducerType where Value == NSData, Error == RequestError {
    func mapObject<T: Model>(type: T.Type) -> SignalProducer<T, Error> {
        return producer.flatMap(FlattenStrategy.Latest) { data -> SignalProducer<T, Error> in
            return SignalProducer(value: T(payload: JSON(data: data)))
        }
    }
    
    func mapArray<T: Model>(type: T.Type, rootKey: String) -> SignalProducer<T, Error> {
        return producer.flatMap(FlattenStrategy.Latest) { data -> SignalProducer<T, Error> in
            let rootNode = JSON(data: data)[rootKey].arrayValue
            return SignalProducer<JSON, Error>(values: rootNode).map({ T(payload: $0) })
        }
    }

}

