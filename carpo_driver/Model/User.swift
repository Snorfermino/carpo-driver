//
//  User.swift
//
//  Created by Tien Dat on 12/19/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
class User: BaseModel {
    private struct SerializationKeys {
        static let data = "data"
    }
    
    public var data: Data!
    public required init?(map: Map){
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map[SerializationKeys.data]
    }
}
extension User {
    public class Data: Mappable {
        
        private struct SerializationKeys {
            static let carId = "car_id"
            static let email = "email"
            static let token = "token"
            static let groupId = "group_id"
            static let carManufacturer = "car_manufacturer"
            static let faceId = "face_id"
            static let googleId = "google_id"
            static let createdTime = "created_time"
            static let driverId = "driver_id"
            static let birthday = "birthday"
            static let type = "type"
            static let carColor = "car_color"
            static let totalDistanceRunOneMonth = "total_distance_run_one_month"
            static let id = "_id"
            static let roleCode = "role_code"
            static let tokenExpire = "token_expire"
            static let statusLeader = "status_leader"
            static let photo = "photo"
            static let phone = "phone"
            static let fullname = "fullname"
            static let campaignId = "campaign_id"
            static let sex = "sex"
            static let licensePlate = "license_plate"
        }
        
        public var carId: String?
        public var email: String?
        public var token: String?
        public var groupId: String?
        public var carManufacturer: String?
        public var faceId: String?
        public var googleId: String?
        public var createdTime: String?
        public var driverId: String?
        public var birthday: String?
        public var type: String?
        public var carColor: String?
        public var totalDistanceRunOneMonth: String?
        public var id: String?
        public var roleCode: String?
        public var tokenExpire: String?
        public var statusLeader: String?
        public var photo: String?
        public var phone: String?
        public var fullname: String?
        public var campaignId: String?
        public var sex: String?
        public var licensePlate: String?
        
        public required init?(map: Map){
            
        }
        public func mapping(map: Map) {
            carId <- map[SerializationKeys.carId]
            email <- map[SerializationKeys.email]
            token <- map[SerializationKeys.token]
            groupId <- map[SerializationKeys.groupId]
            carManufacturer <- map[SerializationKeys.carManufacturer]
            faceId <- map[SerializationKeys.faceId]
            googleId <- map[SerializationKeys.googleId]
            createdTime <- map[SerializationKeys.createdTime]
            driverId <- map[SerializationKeys.driverId]
            birthday <- map[SerializationKeys.birthday]
            type <- map[SerializationKeys.type]
            carColor <- map[SerializationKeys.carColor]
            totalDistanceRunOneMonth <- map[SerializationKeys.totalDistanceRunOneMonth]
            id <- map[SerializationKeys.id]
            roleCode <- map[SerializationKeys.roleCode]
            tokenExpire <- map[SerializationKeys.tokenExpire]
            statusLeader <- map[SerializationKeys.statusLeader]
            photo <- map[SerializationKeys.photo]
            phone <- map[SerializationKeys.phone]
            fullname <- map[SerializationKeys.fullname]
            campaignId <- map[SerializationKeys.campaignId]
            sex <- map[SerializationKeys.sex]
            licensePlate <- map[SerializationKeys.licensePlate]
        }
    }
}

