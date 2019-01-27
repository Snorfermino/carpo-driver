//
//  APIConfig.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let changeMenuTab = Notification.Name("ChangeMenuTab")
}

struct APIConfiguration {
    //New API URL
    static let qAPIURL = URL(string: "http://api.carpo.vn/v1/")!
    
    //Server
    static let myServerAPIURL = URL(string: "http://103.27.237.20:8080/API_CARPO/")!
    static let googleMapURL = URL(string: "https://maps.googleapis.com/")!
    static let facebookURL = URL(string: "https://graph.facebook.com/304466529572881/posts")!

}
