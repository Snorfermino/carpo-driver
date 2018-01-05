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
    #if DEBUG
    static let myServerAPIURL = URL(string: "http://45.119.81.181:8080/API_CARPO/")!
    #else
    // TODO: change this url to deploy server
    static let myServerAPIURL = URL(string: "https://wongyiunam-php.herokuapp.com/api")!
    #endif
    
    static let googleMapURL = URL(string: "https://maps.googleapis.com/")!
    static let facebookURL = URL(string: "https://graph.facebook.com/304466529572881/posts")!
    static let youtubeURL = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    
    static let privacyURL = URL(string: "http://wongyiunam.com/article_cat_event.php?id=19")!
    static let termURL = URL(string: "http://wongyiunam.com/article_cat_event.php?id=12")!
}
