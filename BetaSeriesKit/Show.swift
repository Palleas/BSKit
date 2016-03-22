import Foundation
import SwiftyJSON

public struct Show {
    public let id: Int
    public let title: String
    
    init(payload: JSON) {
        self.id = payload["id"].intValue
        self.title = payload["title"].stringValue
    }
}