//
//  GetInfoForHomeScreenResult.swift
//
//  Created by Tien Dat on 12/13/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
class GetInfoForHomeScreenResult: BaseModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let data = "data"
    }
    
    // MARK: Properties
    public var data: Data?
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public required init?(map: Map){
        super.init(map: map)
    }
    
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public override func mapping(map: Map) {
        data <- map[SerializationKeys.data]
    }
}
extension GetInfoForHomeScreenResult {
     class Data: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let totalKmToday = "total_km_today"
            static let totalPercentMonth = "total_percent_month"
            static let createdTimeLocation = "created_time_location"
            static let totalKmYesterday = "total_km_yesterday"
            static let createdDateLocation = "created_date_location"
            static let totalKmMonth = "total_km_month"
            static let createdDate = "created_date"
            static let totalKmSevenDayBefore = "total_km_seven_day_before"
            static let createdTime = "created_time"
            static let totalKmThreeDayBefore = "total_km_three_day_before"
            static let totalKm30DayBefore = "total_km_30_day_before"
            static let totalKmMonthOutCty = "total_km_month_out_cty"
            static let id = "_id"
            static let locationLat = "location_lat"
            static let userId = "user_id"
            static let locationLong = "location_long"
            static let deviceId = "device_id"
            static let campaignId = "campaign_id"
        }
        
        // MARK: Properties
        public var totalKmToday: Double?
        public var totalPercentMonth: Double?
        public var createdTimeLocation: String?
        public var totalKmYesterday: Double?
        public var createdDateLocation: String?
        public var totalKmMonth: Double?
        public var createdDate: String?
        public var totalKmSevenDayBefore: Double?
        public var createdTime: String?
        public var totalKmThreeDayBefore: Double?
        public var totalKm30DayBefore: Float?
        public var totalKmMonthOutCty: Float?
        public var id: Id?
        public var locationLat: String?
        public var userId: String?
        public var locationLong: String?
        public var deviceId: String?
        public var campaignId: String?
        
        // MARK: ObjectMapper Initializers
        /// Map a JSON object to this class using ObjectMapper.
        ///
        /// - parameter map: A mapping from ObjectMapper.
        public required init?(map: Map){
            
        }
        
        /// Map a JSON object to this class using ObjectMapper.
        ///
        /// - parameter map: A mapping from ObjectMapper.
        public func mapping(map: Map) {
            totalKmToday <- map[SerializationKeys.totalKmToday]
            totalPercentMonth <- map[SerializationKeys.totalPercentMonth]
            createdTimeLocation <- map[SerializationKeys.createdTimeLocation]
            totalKmYesterday <- map[SerializationKeys.totalKmYesterday]
            createdDateLocation <- map[SerializationKeys.createdDateLocation]
            totalKmMonth <- map[SerializationKeys.totalKmMonth]
            createdDate <- map[SerializationKeys.createdDate]
            totalKmSevenDayBefore <- map[SerializationKeys.totalKmSevenDayBefore]
            createdTime <- map[SerializationKeys.createdTime]
            totalKmThreeDayBefore <- map[SerializationKeys.totalKmThreeDayBefore]
            totalKm30DayBefore <- map[SerializationKeys.totalKm30DayBefore]
            totalKmMonthOutCty <- map[SerializationKeys.totalKmMonthOutCty]
            id <- map[SerializationKeys.id]
            locationLat <- map[SerializationKeys.locationLat]
            userId <- map[SerializationKeys.userId]
            locationLong <- map[SerializationKeys.locationLong]
            deviceId <- map[SerializationKeys.deviceId]
            campaignId <- map[SerializationKeys.campaignId]
        }
    }
    
    class Id: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let machineIdentifier = "machineIdentifier"
            static let processIdentifier = "processIdentifier"
            static let counter = "counter"
            static let timestamp = "timestamp"
        }
        
        // MARK: Properties
        public var machineIdentifier: Int?
        public var processIdentifier: Int?
        public var counter: Int?
        public var timestamp: Int?
        
        // MARK: ObjectMapper Initializers
        /// Map a JSON object to this class using ObjectMapper.
        ///
        /// - parameter map: A mapping from ObjectMapper.
        public required init?(map: Map){
            
        }
        
        /// Map a JSON object to this class using ObjectMapper.
        ///
        /// - parameter map: A mapping from ObjectMapper.
        public func mapping(map: Map) {
            machineIdentifier <- map[SerializationKeys.machineIdentifier]
            processIdentifier <- map[SerializationKeys.processIdentifier]
            counter <- map[SerializationKeys.counter]
            timestamp <- map[SerializationKeys.timestamp]
        }
        
        /// Generates description of the object in the form of a NSDictionary.
        ///
        /// - returns: A Key value pair containing all valid values in the object.
        public func dictionaryRepresentation() -> [String: Any] {
            var dictionary: [String: Any] = [:]
            if let value = machineIdentifier { dictionary[SerializationKeys.machineIdentifier] = value }
            if let value = processIdentifier { dictionary[SerializationKeys.processIdentifier] = value }
            if let value = counter { dictionary[SerializationKeys.counter] = value }
            if let value = timestamp { dictionary[SerializationKeys.timestamp] = value }
            return dictionary
        }
    }
}

