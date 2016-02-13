//
//  FetchMemberInfosSpec.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-02.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import Quick
import Nimble
import OHHTTPStubs

@testable import BetaSeriesKit

class FetchMemberInfosSpec: QuickSpec {
    override func spec() {
        describe("Fetch Member Infos") {
            beforeEach {
                stub(isHost("betaseries.com") && isPath("/members/infos") && isMethodGET(), response: { (_) -> OHHTTPStubsResponse in
                    return OHHTTPStubsResponse(fileAtPath: OHPathForFile("member_infos.json", self.dynamicType)!, statusCode: 200, headers: nil)
                })
            }
            
            it("should fetch a token") {
                waitUntil(timeout: 5) { done in
                    FetchMemberInfos()
                        .send(NSURLSession.sharedSession(), baseURL: NSURL(string: "https://betaseries.com")!, key: "key", token: "token")
                        .on(failed: { _ in done() })
                        .startWithNext({ (model) -> () in
                            
                            expect(model.id).to(equal(384698))
                            expect(model.login).to(equal("PalleasQc"))
                            expect(model.avatar).to(equal(NSURL(string: "https://www.betaseries.com/data/avatars/31/31565939ce458c380216a64f8e464535.jpg")))
                            
                            done()
                        })
                }
            }
        }
    }
}
