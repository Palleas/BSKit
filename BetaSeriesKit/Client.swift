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
    
    private static let browserPipe = Signal<NSURL, ClientError>.pipe()
    
    public init(key: String) {
        self.key = key
    }
    
    public func requestToken(code: String, secret: String) -> SignalProducer<String?, ClientError> {
        return RequestToken(clientId: key, clientSecret: secret, redirectURI: "rewatch://oauth/handle", code: code)
            .send(NSURLSession.sharedSession(), baseURL: baseURL, key: key, token: nil)
            .map({ $0.token })
            .mapError({ _ in return ClientError.InternalError })
    }

    public func authorize() -> SignalProducer<String?, ClientError> {
        let comps = NSURLComponents(URL: NSURL(string: "https://www.betaseries.com")!, resolvingAgainstBaseURL: true)!
        comps.path = "/authorize"
        
        var items = [NSURLQueryItem]()
        items.append(NSURLQueryItem(name: "client_id", value: key))
        items.append(NSURLQueryItem(name: "redirect_uri", value: "rewatch://oauth/handle"))
        
        comps.queryItems = items
        
        if let url = comps.URL {
            UIApplication.sharedApplication().openURL(url)
        }

        let urlSignal = Client.browserPipe.0.map({ codeFromURL($0) })
        return SignalProducer(signal: urlSignal)
    }
    
    public func authenticate(secret: String) -> SignalProducer<AuthenticatedClient, ClientError> {
        return authorize().flatMap(FlattenStrategy.Latest) { (code) -> SignalProducer<AuthenticatedClient, ClientError> in
            guard let code = code else {
                return SignalProducer(error: .InvalidCode)
            }
            
            return self
                .requestToken(code, secret: secret)
                .flatMap(.Latest) { (token) -> SignalProducer<AuthenticatedClient, ClientError> in
                    if let token = token {
                        return SignalProducer(value: AuthenticatedClient(key: self.key, token: token))
                    }
                    
                    return SignalProducer(error: ClientError.InvalidToken)
                }
                    
        }
    }
    
    public static func completeSignIn(callbackURL: NSURL) {
        Client.browserPipe.1.sendNext(callbackURL)
    }
}