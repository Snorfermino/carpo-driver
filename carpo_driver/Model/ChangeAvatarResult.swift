//
//  ChangeAvatarResult.swift
//
//  Created by Tien Dat on 12/14/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
public class ChangeAvatarResult: Mappable {
    
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
extension ChangeAvatarResult {
    public class Data: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let imageUrl = "image_url"
        }
        
        // MARK: Properties
        public var imageUrl: String?
        
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
            imageUrl <- map[SerializationKeys.imageUrl]
        }
    }
}

