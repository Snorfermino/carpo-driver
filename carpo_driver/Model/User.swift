//
//  User.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import ObjectMapper
struct User: Mappable {
    
    var username: String!
    var email: String!
    var createdAt: Date?
    var name: String?
    var avatarUrl: URL?
    var avatar: UIImage?
    var dob: Date?
    var postalCode: Int?
    var contactNumber: String?
    var deliverAddress: String?
    var invitationCode: String?
    var gender: String?
    var rebateBalance: Double?
    var creditBalance: Double?
    var token: String?
    var creditPoints: Int?
    var password: String?
    init?(map: Map) {
        
    }
    
    init() {}
    
    mutating func mapping(map: Map) {
        username <- map["username"]
        email <- map["email"]
        createdAt <- (map["created_at"], DateTransform())
        name <- map["name"]
        avatarUrl <- (map["avatar"], URLTransform())
        dob <- (map["dob"], DateTransform())
        postalCode <- map["postal_code"]
        contactNumber <- map["contact_number"]
        deliverAddress <- map["deliver_address"]
        invitationCode <- map["invitation_code"]
        gender <- map["gender"]
        rebateBalance <- map["rebate_balance"]
        creditBalance <- map["credit_balance"]
        token <- map["token"]
        creditPoints <- map["points"]
        password <- map["password"]
    }
}

