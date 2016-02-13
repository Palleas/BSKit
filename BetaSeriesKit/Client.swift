import UIKit
import Foundation
import ReactiveCocoa

public enum ClientError: ErrorType {
    case InvalidCode
    case InvalidToken
    case InternalError
}

public class Client {
    let baseURL = NSURL(string: "https://api.betaseries.com")!
    let key: String
    
    private lazy var browserPipe = Signal<NSURL, NoError>.pipe()
    
    init(key: String) {
        self.key = key
    }
    
    public func requestToken(code: String) -> SignalProducer<String?, ClientError> {
        return RequestToken(code: code)
            .send(NSURLSession.sharedSession(), baseURL: baseURL, key: key, token: nil)
            .map({ $0.token })
            .mapError({ _ in return ClientError.InternalError })
    }

    func authorize() -> SignalProducer<String?, NoError> {
        let comps = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: true)!
        comps.path = "/authorize"
        
        var items = [NSURLQueryItem]()
        items.append(NSURLQueryItem(name: "client_id", value: key))
        items.append(NSURLQueryItem(name: "redirect_uri", value: "rewatch://oauth/handle"))
        
        comps.queryItems = items
        
        if let url = comps.URL {
            UIApplication.sharedApplication().openURL(url)
        }

        let urlSignal = browserPipe.0.map({ codeFromURL($0) })
        return SignalProducer(signal: urlSignal)
    }
}