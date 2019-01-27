//
//  OTP.swift
//
//  Created by Tien Dat on 11/28/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

class OTP: BaseModel{
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let data = "data"
    }
    
    
    public var data: Int?
    
    
    public required init?(map: Map){
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map[SerializationKeys.data]
    }
    
}


