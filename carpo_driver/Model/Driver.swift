//
//  Driver.swift
//
//  Created by Tien Dat on 11/30/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
class Driver: BaseModel {
    private struct SerializationKeys {
        static let data = "data"
    }
    public var data: Data?
    
    public required init?(map: Map){
        super.init(map: map)
    }
    public override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map[SerializationKeys.data]
    }
}
extension Driver {
    public class Data: Mappable {

        private struct SerializationKeys {
            static let carColor = "car_color"
            static let startTime = "start_time"
            static let id = "_id"
            static let endTime = "end_time"
            static let groupId = "group_id"
            static let createdTime = "created_time"
            static let driverId = "driver_id"
            static let campaignId = "campaign_id"
            static let userId = "user_id"
            static let type = "type"
            static let licensePlate = "license_plate"
            static let name = "name"
            static let phone = "phone"
        }

        public var carColor: String?
        public var startTime: String?
        public var id: String?
        public var endTime: String?
        public var groupId: String?
        public var createdTime: String?
        public var driverId: String?
        public var campaignId: String?
        public var userId: String?
        public var type: String?
        public var licensePlate: String?
        public var name: String!
        public var phone: String!
        public required init?(map: Map){
            
        }
        public func mapping(map: Map) {
            name <- map[SerializationKeys.name]
            phone <- map[SerializationKeys.phone]
            carColor <- map[SerializationKeys.carColor]
            startTime <- map[SerializationKeys.startTime]
            id <- map[SerializationKeys.id]
            endTime <- map[SerializationKeys.endTime]
            groupId <- map[SerializationKeys.groupId]
            createdTime <- map[SerializationKeys.createdTime]
            driverId <- map[SerializationKeys.driverId]
            campaignId <- map[SerializationKeys.campaignId]
            userId <- map[SerializationKeys.userId]
            type <- map[SerializationKeys.type]
            licensePlate <- map[SerializationKeys.licensePlate]
        }
    }
}

