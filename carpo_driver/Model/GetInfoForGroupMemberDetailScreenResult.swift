//
//  GetInfoForGroupMemberDetailScreenResult.swift
//
//  Created by Tien Dat on 12/13/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
class GetInfoForGroupMemberDetailScreenResult: BaseModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let data = "data"
    }
    
    // MARK: Properties
    public var data: [Data]?
    
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
        super.mapping(map: map)
        data <- map[SerializationKeys.data]
    }
}
extension GetInfoForGroupMemberDetailScreenResult {
    
    class Data: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let name = "name"
            static let totalKmMonth = "total_km_month"
        }
        
        // MARK: Properties
        public var name: String?
        public var totalKmMonth: Float?
        
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
            name <- map[SerializationKeys.name]
            totalKmMonth <- map[SerializationKeys.totalKmMonth]
        }
    }
}

