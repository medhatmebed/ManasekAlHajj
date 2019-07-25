
import Foundation

// MARK: - MashaerElement
struct Mashaer: Codable, ResponseParser {
  
    let mashaerID: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case mashaerID = "MashaerID"
        case name = "Name"
    }
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([[String : AnyObject]]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode([Mashaer].self, from: jsonData)
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
