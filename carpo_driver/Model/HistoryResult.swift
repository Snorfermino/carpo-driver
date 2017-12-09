////
////  HistoryResult.swift
////
////  Created by Tien Dat on 11/30/17
////  Copyright (c) . All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//class HistoryResult: BaseModel {
//    private struct SerializationKeys {
//        static let data = "data"
//    }
//    public var data: Data?
//    public required init?(map: Map){
//        super.init(map: map)
//    }
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//        data <- map[SerializationKeys.data]
//    }
//}
//extension HistoryResult {
//    public class Data: Mappable {
//        private struct SerializationKeys {
//            static let listLocation = "list_location"
//            static let totalDistance = "total_distance"
//        }
//        public var listLocation: [CPLocation]?
//        public var totalDistance: Float?
//        public required init?(map: Map){}
//        public func mapping(map: Map) {
//            listLocation <- map[SerializationKeys.listLocation]
//            totalDistance <- map[SerializationKeys.totalDistance]
//        }
//    }
//}

//
//  HistoryResult.swift
//
//  Created by Tien Dat on 12/5/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
public class HistoryResult: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let status = "status"
        static let data = "data"
    }
    
    // MARK: Properties
    public var status: Int?
    public var data: Data?
    
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
        status <- map[SerializationKeys.status]
        data <- map[SerializationKeys.data]
    }
}
extension HistoryResult {
    
    public class Data: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let totalDistace = "total_distace"
            static let listLocation = "list_location"
        }
        
        // MARK: Properties
        public var totalDistace: Float?
        public var listLocation: [ListLocation]?
        
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
            totalDistace <- map[SerializationKeys.totalDistace]
            listLocation <- map[SerializationKeys.listLocation]
        }
        
    }
    
    public class ListLocation: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let locationLong = "location_long"
            static let locationLat = "location_lat"
        }
        
        // MARK: Properties
        public var locationLong: String? {
            didSet{
                long = (locationLong?.floatValue)!
            }
        }
        
        public var locationLat: String?
        public var long: Float = 0
        public var lat: Double = 0
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
            locationLong <- map[SerializationKeys.locationLong]
            locationLat <- map[SerializationKeys.locationLat]
        }
    }
}
