//
//  GroupResult.swift
//  carpo_driver
//
//  Created by Tien Dat on 12/1/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupResult: BaseModel {
    private struct SerializationKeys {
        static let data = "data"
    }
    public var data: [Driver.Data]?
    public required init?(map: Map){
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

