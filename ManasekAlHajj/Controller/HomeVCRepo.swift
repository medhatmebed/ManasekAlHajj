//
//  ViewCOntrollerRepo.swift
//  RitesOfPilgrimage
//
//  Created by Medhat Mebed on 7/25/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeVCRepoDelegate : class {
    func getMashaerSuccess(mashaer : [Mashaer])
    func getMashaerFail(error : String)
    func getDirectionTypesSuccess(directiontypes : [DirectionType])
    func getDirectionTypesFail(error : String)
    func getDirectionsSuccess(directions : [Directions])
    func getDirectionsFail(error : String)
    func getOfficeGroupAppartmentsSuccess(officGroupAppartments : [OfficeGroupAppartment])
    func getOfficeGroupAppartmentsSuccessFail(error : String)
}

class HomeVCRepo : WebserviceDataProtocol {
    
    public weak var delegate : HomeVCRepoDelegate?
    
    func getMashaer() {
        let envelope = GetMashaer(pathType: .GetMashaer)
        AppManager.shared().webServiceManager.requestData(envelope: envelope, delegate: self)
    }
    
    func getDirectionTypes() {
        let envelope = GetDirectionTypes(pathType:.GetDirectionTypes)
        AppManager.shared().webServiceManager.requestData(envelope: envelope, delegate: self)
    }
    
    func getDirections(directionTypeId : Int) {
        let envelope = GetDirections(pathType: .GetDirections(directionType: directionTypeId))
        AppManager.shared().webServiceManager.requestData(envelope: envelope, delegate: self)
    }
    
    func GetOfficeGroupAppartment(mashaerId: Int,directionTypeId: Int,directionId: Int) {
        let envelope = GetOfficeGroupApparments(pathType: .GetOfficeGroupAppartments(mashaerId: mashaerId,
                                                                                     directionTypeId: directionTypeId,
                                                                                     directionId: directionId))
        AppManager.shared().webServiceManager.requestData(envelope: envelope, delegate: self)
    }
    
    
    func dataRecieved(data: [ResponseParser]?, errorMessage: String?, envelope: Requestable) {
        if envelope.apiPath.contains(ApiPath.GET_MASHAER) {
            if let error = errorMessage {
                #if DEBUG
                print(error)
                #endif
                //   self.delegate?.getMovieImagesFail(error: error)
            }
            if let response = data as? [Mashaer] {
                self.delegate?.getMashaerSuccess(mashaer: response)
            } else {
                self.delegate?.getMashaerFail(error: "failed to get mashaer")
            }
        }
        else if envelope.apiPath.contains(ApiPath.GET_DIRECTION_TYPES) {
            if let error = errorMessage {
                #if DEBUG
                print(error)
                #endif
                self.delegate?.getDirectionTypesFail(error: error)
            }
            if let response = data as? [DirectionType] {
                print(response)
                self.delegate?.getDirectionTypesSuccess(directiontypes: response)
            } else {
                self.delegate?.getDirectionTypesFail(error: "failed to get DirectionTypes")
            }
        }
        else if envelope.apiPath.contains(ApiPath.GET_DIRECTIONS) {
            if let error = errorMessage {
                #if DEBUG
                print(error)
                #endif
                self.delegate?.getDirectionsFail(error: error)
            }
            if let response = data as? [Directions] {
                print(response)
                self.delegate?.getDirectionsSuccess(directions: response)
            } else {
                self.delegate?.getDirectionsFail(error: "failed to get Directions")
            }
        }
    }
    
    
}
