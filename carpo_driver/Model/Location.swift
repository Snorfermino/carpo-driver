//
//  ListLocation.swift
//
//  Created by Tien Dat on 11/30/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
public class CPLocation: Mappable {

    private struct SerializationKeys {
        static let locationLong = "location_long"
        static let locationLat = "location_lat"
    }
    
    public var locationLong: Float = 0
    public var locationLat: Float = 0

    public required init?(map: Map){
        
    }
    public func mapping(map: Map) {
        locationLong <- map[SerializationKeys.locationLong]
        locationLat <- map[SerializationKeys.locationLat]
    }

}

