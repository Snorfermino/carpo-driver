//
//  Driver.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import ObjectMapper
struct Driver: Mappable {
    
    var name: String!
    var plate: String!
    var vehicleBrand: String?
    var vehicleColor: String?
    var totalTravelDistance: Float?
    init?(map: Map) {
        
    }
    
    init() {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        plate <- map["plate"]
        vehicleBrand <- map["vehicleBrand"]
        vehicleColor <- map["vehicleColor"]
        totalTravelDistance <- map["totalTravelDistance"]
    }
}
