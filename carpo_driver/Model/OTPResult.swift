//
//  User.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import ObjectMapper
class OTPResult: BaseModel {
    var data: String!
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}