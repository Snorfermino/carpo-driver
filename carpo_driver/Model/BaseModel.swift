//
//  User.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseModel: Mappable {
    var  status: Int!
    var error: ErrorResponse!

    required init?(map: Map) {
    }
    
    init() {}
    
    func mapping(map: Map) {
        status <- map["status"]
        error <- map["error"]
    }
}


