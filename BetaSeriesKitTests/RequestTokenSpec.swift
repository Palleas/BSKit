//
//  RequestTokenSpec.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-01.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import Quick
import Nimble
import OHHTTPStubs

@testable import BetaSeriesKit

class RequestTokenSpec: QuickSpec {
    
    override func spec() {
        describe("Requesting Token") {
            beforeEach({ () -> () in
                stub(isHost("betaseries.com") && isMethodPOST() && isPath("/members/access_token")) { (request) -> OHHTTPStubsResponse in
                    OHHTTPStubsResponse(JSONObject: ["token": "superdupertoken"], statusCode: 200, headers: nil)
                }
            })
            
            it("should fetch a token") {
                waitUntil(timeout: 5) { done in
                    RequestToken(code: "code")
                        .send(NSURLSession.sharedSession(), baseURL: NSURL(string: "https://betaseries.com")!, key: "key")
                        .on(failed: { _ in done() })
                        .startWithNext { model in
                            if let token = model.token {
                                expect(token).to(equal("superdupertoken"))
                            } else {
                                fail("token should not be nil")
                            }
                            
                            done()
                        }
                }
            }
        }
        
    }
}
