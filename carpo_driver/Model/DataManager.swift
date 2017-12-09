//
//  DataManager.swift
//  WongYiuNam-User
//
//  Created by Admin on 9/25/17.
//  Copyright © 2017 RTH. All rights reserved.
//

import Foundation

class DataManager {
    
    static func saveUserInfo(user: User?) {
        var myUser = user
        if myUser?.data.token == nil, let savedUser = Global.user {
            myUser?.data.token = savedUser.data.token
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(myUser?.toJSON(), forKey: "userInfo")
    }
    
    static func getUserInfo() -> User? {
        guard let userJson = UserDefaults.standard.object(forKey: "userInfo")  else { return nil }
        if let userJSON = userJson as? [String: Any] {
            return User(JSON: userJSON)
        } else {
            return nil
        }
    }
    
    static func loggedOut(){

        if UserDefaults.standard.object(forKey: "userInfo") != nil {
            UserDefaults.standard.removeObject(forKey: "userInfo")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func isLogged() -> Bool {
        if let user = getUserInfo() {
            return true
        } else {
            return false
        }
    }
}

