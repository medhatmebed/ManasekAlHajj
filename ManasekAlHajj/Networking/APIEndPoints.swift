//
//  APIEndPoints.swift
//  AvisBudgetGroup
//
//  Created by Medhat on 2019-02-26.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

import Foundation
import Alamofire

protocol ParameterBodyMaker {
    func httpBodyEnvelop() -> [String: Any]?
    func encodeBodyEnvelop() throws -> Data?
}

internal enum ServicePath: ParameterBodyMaker {
    
    func encodeBodyEnvelop() throws -> Data? {
        do {
            if let body = self.httpBodyEnvelop() {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                return data
            }
        } catch {
            throw error
        }
        return nil
    }
    
    //MARK: - API Request Parameters
    case GetMashaer
    case GetDirectionTypes
    case GetDirections(directionType : Int)
    case GetOfficeGroupAppartments(mashaerId : String,directionTypeId : String, directionId : String)
    
    func httpBodyEnvelop() -> [String : Any]? {
        switch self {
        case .GetMashaer:
            return [:]
        case .GetDirectionTypes:
            return [:]
        case .GetDirections(directionType: let directionType):
            let getQuery = ["DirectionTypeID" : directionType]
            return getQuery
        case .GetOfficeGroupAppartments(mashaerId: let mashaerId,
                             directionTypeId: let directionTypeId,
                             directionId: let directionId):
            let getQuery = ["MashaerID" : mashaerId,
                            "DirectionTypeID" : directionTypeId,
                            "DirectionID" : directionId]
            return getQuery
        }
    }
}

// MARK: - API Category - Customer
struct GetMashaer : Requestable {
    var apiPath: String { return ApiPath.GET_MASHAER }
    var httpType: HTTPMethod { return .post }
    var ref: ResponseParser.Type { return Mashaer.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Query }
    var pathType: ServicePath
}
struct GetDirectionTypes : Requestable {
    var apiPath: String { return ApiPath.GET_DIRECTION_TYPES }
    var httpType: HTTPMethod { return .post }
    var ref: ResponseParser.Type { return DirectionType.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Query }
    var pathType: ServicePath
}
struct GetDirections : Requestable {
    var apiPath: String { return ApiPath.GET_DIRECTIONS }
    var httpType: HTTPMethod { return .post }
    var ref: ResponseParser.Type { return Direction.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Body }
    var pathType: ServicePath
}
struct GetOfficeGroupApparments : Requestable {
    var apiPath: String { return ApiPath.GET_GROUP_APPARTMENTS }
    var httpType: HTTPMethod { return .post }
    var ref: ResponseParser.Type { return OfficeGroupAppartment.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Body }
    var pathType: ServicePath
}

