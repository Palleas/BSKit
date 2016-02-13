//
//  FetchEpisodesSpec.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2016-02-13.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import Quick
import Nimble
import OHHTTPStubs

@testable import BetaSeriesKit

class FetchEpisodesSpec: QuickSpec {
    override func spec() {
        describe("Fetch a list of episodes for a TV show") {
            beforeEach {
                stub(isHost("betaseries.com") && isPath("/shows/episodes") && isMethodGET() && containsQueryParams(["id": "159"]), response: { (_) -> OHHTTPStubsResponse in
                    return OHHTTPStubsResponse(fileAtPath: OHPathForFile("episodes.json", self.dynamicType)!, statusCode: 200, headers: nil)
                })
            }
            
            it("should fetch a list of episodes") {
                waitUntil(timeout: 5) { done in
                    FetchEpisodes(id: 159)
                        .send(NSURLSession.sharedSession(), baseURL: NSURL(string: "https://betaseries.com")!, key: "key", token: "token")
                        .collect()
                        .on(failed: { _ in done() })
                        .startWithNext({ episodes in
                            expect(episodes).to(haveCount(137))
                            
                            guard let episode = episodes.first else {
                                fail("It should have retrieved at least one episode")
                                return
                            }
                            
                            expect(episode.id).to(equal(264977))
                            expect(episode.title).to(equal("Rose"))
                            expect(episode.season).to(equal(1))
                            expect(episode.episode).to(equal(1))
                            expect(episode.summary).to(beginWith("Rose Tyler rencontre un"))
                            expect(episode.seen).to(beTrue())
                            
                            done()
                        })
                }
            }
        }
    }
}
