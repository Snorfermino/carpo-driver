//
//  Global.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import UIKit

class Global {
    static var logined: Bool = false
    static var navigationBarColor = UIColor(red: 240.0/255.0, green: 153.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    static var userInfo: User?
    static var user: User? {
        set {
            userInfo = newValue
            NotificationCenter.default.post(name: Notification.Name("UserLoginedNotification"), object: nil)
//            DataManager.saveUserInfo(user: newValue)
        }
        get {
            return userInfo
        }
    }
}

