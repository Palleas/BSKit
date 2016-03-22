import Foundation
import SwiftyJSON

public struct Episode: Model {
    public let id: Int
    public let title: String
    public let episode: Int
    public let season: Int
    public let summary: String
    public let seen: Bool
    
    init(payload: JSON) {
        id = payload["id"].intValue
        title = payload["title"].stringValue
        episode = payload["episode"].intValue
        season = payload["season"].intValue
        summary = payload["description"].stringValue
        seen = payload["user"]["seen"].boolValue
    }
}