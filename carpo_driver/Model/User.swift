//
//  User.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import ObjectMapper
class User: BaseModel {
    var data: Data!
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
extension User {
    struct Data: Mappable {
        private struct SerializationKeys {
            static let email = "email"
            static let carId = "car_id"
            static let token = "token"
            static let faceId = "face_id"
            static let googleId = "google_id"
            static let groupId = "group_id"
            static let carManufacturer = "car_manufacturer"
            static let createdTime = "created_time"
            static let driverId = "driver_id"
            static let type = "type"
            static let carColor = "car_color"
            static let totalDistanceRunOneMonth = "total_distance_run_one_month"
            static let id = "_id"
            static let roleId = "role_id"
            static let photo = "photo"
            static let phone = "phone"
            static let fullname = "fullname"
            static let campaignId = "campaign_id"
            static let licensePlate = "license_plate"
        }
        public var email: String?
        public var carId: String?
        public var token: String?
        public var faceId: String?
        public var googleId: String?
        public var groupId: String?
        public var carManufacturer: String?
        public var createdTime: String?
        public var driverId: String?
        public var type: String?
        public var carColor: String?
        public var totalDistanceRunOneMonth: String?
        public var id: String?
        public var roleId: String?
        public var photo: String?
        public var phone: String?
        public var fullname: String?
        public var campaignId: String?
        public var licensePlate: String?
        public init?(map: Map){}
        public mutating func mapping(map: Map) {
            email <- map[SerializationKeys.email]
            carId <- map[SerializationKeys.carId]
            token <- map[SerializationKeys.token]
            faceId <- map[SerializationKeys.faceId]
            googleId <- map[SerializationKeys.googleId]
            groupId <- map[SerializationKeys.groupId]
            carManufacturer <- map[SerializationKeys.carManufacturer]
            createdTime <- map[SerializationKeys.createdTime]
            driverId <- map[SerializationKeys.driverId]
            type <- map[SerializationKeys.type]
            carColor <- map[SerializationKeys.carColor]
            totalDistanceRunOneMonth <- map[SerializationKeys.totalDistanceRunOneMonth]
            id <- map[SerializationKeys.id]
            roleId <- map[SerializationKeys.roleId]
            photo <- map[SerializationKeys.photo]
            phone <- map[SerializationKeys.phone]
            fullname <- map[SerializationKeys.fullname]
            campaignId <- map[SerializationKeys.campaignId]
            licensePlate <- map[SerializationKeys.licensePlate]
        }
    }
}
