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
    override public func mapping(map: Map) {
        super.mapping(map: map)
        data <- map[SerializationKeys.data]
    }
}
extension GetInfoForHomeScreenResult {
     class Data: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let totalKmToday = "total_km_today"
            static let totalPercentMonth = "total_percent_month"
            static let totalKmThreeDayBefore = "total_km_three_day_before"
            static let totalKmMonth = "total_km_month"
            static let totalKmSevenDayBefore = "total_km_seven_day_before"
        }
        
        // MARK: Properties
        public var totalKmToday: Float?
        public var totalPercentMonth: Float?
        public var totalKmThreeDayBefore: Float?
        public var totalKmMonth: Float?
        public var totalKmSevenDayBefore: Float?
        
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
            totalKmThreeDayBefore <- map[SerializationKeys.totalKmThreeDayBefore]
            totalKmMonth <- map[SerializationKeys.totalKmMonth]
            totalKmSevenDayBefore <- map[SerializationKeys.totalKmSevenDayBefore]
        }
    }
    
}

