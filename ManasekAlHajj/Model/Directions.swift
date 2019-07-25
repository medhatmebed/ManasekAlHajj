
import Foundation

// MARK: - Direction
struct Directions: Codable, ResponseParser  {
    let directionID, directionTypeID: Int?
    let directionName: String?
    
    enum CodingKeys: String, CodingKey {
        case directionID = "DirectionID"
        case directionTypeID = "DirectionTypeID"
        case directionName = "DirectionName"
    }
    
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([[String : AnyObject]]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode([Directions].self, from: jsonData)
                #if DEBUG
                print(decodedResponseInfo)
                #endif
                return decodedResponseInfo
            } catch {
                #if DEBUG
                print(error)
                #endif
                return []
            }
        }
        return []
    }
    
}
