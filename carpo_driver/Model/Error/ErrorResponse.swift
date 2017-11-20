//
//  ErrorResponse.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import ObjectMapper

struct ErrorResponse: Mappable {
    
    var invalidFields: String?
    var errorCode: Int?
    var message: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        errorCode <- map["error_code"]
        invalidFields <- map["invalid_fields"]
        message <- map["message"]
    }
}

