//
//  ClientSpec.swift
//  BetaSeriesKit
//
//  Created by Romain Pouclet on 2015-12-27.
//  Copyright © 2015 Perfectly-Cooked. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import BetaSeriesKit

class ClientSpec: QuickSpec {
    override func spec() {
        describe("Authentication") {
            it("should open a browser with the authentication page") {
                
            }
            
            it("should extract the code from the completion URL") {
                let validURL = NSURL(string: "app://callback?code=1234567890")!
                expect(codeFromURL(validURL)).to(equal("1234567890"))
                
                let invalidURL = NSURL(string: "app://callback")!
                expect(codeFromURL(invalidURL)).to(beNil())
            }
            
            it("should request a token") {
            
            }
        }
        
        describe("User") {
            it("should fetch a user profile") {
                
            }
        }
        
        describe("Episodes") {
            it("should fetch the episodes list for a TV Show") {
            
            }
        }
    }
}
