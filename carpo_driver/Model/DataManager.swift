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
        guard let myUser = user else { return }
        if myUser.data.token == nil, let savedUser = Global.user {
            myUser.data.token = savedUser.data.token
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(myUser.toJSON(), forKey: "userLoggedInfo")
        NotificationCenter.default.post(name: Notification.Name("UserLoggedInNotification"), object: nil)
        print("save logged in info")
    }
    static func getUserInfo() -> User? {
        guard let userJson = UserDefaults.standard.object(forKey: "userLoggedInfo")  else { return nil }
        if let userJSON = userJson as? [String: Any] {
            return User(JSON: userJSON)
        } else {
            return nil
        }
    }
    
    static func loggedOut(){

        if UserDefaults.standard.object(forKey: "userInfo") != nil {
            UserDefaults.standard.removeObject(forKey: "userLoggedInfo")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func isLogged() -> Bool {
        if getUserInfo() != nil {
            return true
        } else {
            return false
        }
    }
}

