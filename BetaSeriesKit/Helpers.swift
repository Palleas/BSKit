//
//  Helpers.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-01-23.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation

func codeFromURL(url: NSURL) -> String? {
    let comps = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
    
    return comps?.queryItems?.filter({ $0.name == "code" }).first?.value
    
}
