
import Foundation

// MARK: - OfficeGroupAppartment
struct OfficeGroupAppartment: Codable, ResponseParser {
    let officeGroupAppartmentID, mashaerID, directionTypeID, directionID: Int?
    let officeGroupName, region, regionSection, street: String?
    let mokhaiam, nationalityName, responsibleName, phone: String?
    let longitude, latitude: String?
    
    enum CodingKeys: String, CodingKey {
        case officeGroupAppartmentID = "OfficeGroupAppartmentID"
        case mashaerID = "MashaerID"
        case directionTypeID = "DirectionTypeID"
        case directionID = "DirectionID"
        case officeGroupName = "OfficeGroupName"
        case region = "Region"
        case regionSection = "RegionSection"
        case street = "Street"
        case mokhaiam = "Mokhaiam"
        case nationalityName = "NationalityName"
        case responsibleName = "ResponsibleName"
        case phone = "Phone"
        case longitude = "Longitude"
        case latitude = "Latitude"
    }
    
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([[String : AnyObject]]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode([OfficeGroupAppartment].self, from: jsonData)
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
