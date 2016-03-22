import Foundation
import SwiftyJSON

public struct Show {
    public let id: Int
    public let name: String
    
    init(payload: JSON) {
        self.id = payload["id"].intValue
        self.name = payload["name"].stringValue
    }
}