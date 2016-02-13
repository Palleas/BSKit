import Foundation
import SwiftyJSON

struct Episode: Model {
    let id: Int
    let title: String
    let episode: Int
    let season: Int
    let summary: String
    let seen: Bool
    
    init(payload: JSON) {
        id = payload["id"].intValue
        title = payload["title"].stringValue
        episode = payload["episode"].intValue
        season = payload["season"].intValue
        summary = payload["description"].stringValue
        seen = payload["user"]["seen"].boolValue
    }
}