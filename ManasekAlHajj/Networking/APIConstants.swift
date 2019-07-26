//
//  ApiConstants.swift
//  AvisBudgetGroup
//
//  Created by Medhat on 2019-02-26.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

import Foundation
import Alamofire

//Client Info
let G_BASE_URL = "http://35.176.210.80/TaskeenAPI/api/Taskeen/"
let APP_ROUND_BUTTON_CORNER_RADIUS : CGFloat = 10
let APP_LOADING_VIEW_TAG = 4000

struct ApiPath {
    //POST Methods
    
    //UPLOAD POST Methods
    
    //GET Methods
    static let GET_MASHAER = "getMashaers"
    static var GET_DIRECTION_TYPES = "getDirectionTypes"
    static var GET_DIRECTIONS = "getDirections"
    static var GET_GROUP_APPARTMENTS = "getOfficeGroupAppartments"
}
