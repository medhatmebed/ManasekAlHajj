
import Foundation

// MARK: - DirectionType
struct DirectionType: Codable, ResponseParser {
    let directionTypeID: Int?
    let directionTypeName: String?
    
    enum CodingKeys: String, CodingKey {
        case directionTypeID = "DirectionTypeID"
        case directionTypeName = "DirectionTypeName"
    }
    
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([[String : AnyObject]]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode([DirectionType].self, from: jsonData)
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

