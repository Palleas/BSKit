//
//  FetchEpisodePictureSpec.swift
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

class FetchEpisodePictureSpec: QuickSpec {
    override func spec() {
        describe("Fetch a picture") {
            beforeEach {
                stub(isHost("betaseries.com") && isPath("/pictures/episodes") && isMethodGET() && containsQueryParams(["id": "264977"]), response: { (_) -> OHHTTPStubsResponse in
                    return OHHTTPStubsResponse(fileAtPath: OHPathForFile("episode_264977.jpg", self.dynamicType)!, statusCode: 200, headers: nil)
                })
            }
            
            it("should fetch the picture of an episode") {
                waitUntil(timeout: 5) { done in
                    FetchEpisodePicture(id: 264977, width: 960, height: 540)
                        .send(NSURLSession.sharedSession(), baseURL: NSURL(string: "https://betaseries.com")!, key: "key", token: "token")
                        .on(failed: { _ in done() })
                        .startWithNext({ picture in
                            expect(picture).to(beAnInstanceOf(UIImage.self))
                            done()
                        })
                }
            }
        }
    }
}
