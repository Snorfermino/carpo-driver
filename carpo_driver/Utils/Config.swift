//
//  Config.swift
//  drivers
//
//  Created by Đinh Anh Huy on 10/11/16.
//  Copyright © 2016 Đinh Anh Huy. All rights reserved.
//

import UIKit

class Config {
    private static var store: Config?
    static var shareInstance: Config {
        get {
            if Config.store == nil { Config.store = Config() }
            return Config.store!
        }
    }
    
    private var plistValue: NSDictionary {
        get {
            var myDict: NSDictionary!
            if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
                myDict = NSDictionary(contentsOfFile: path)!
            }
            return myDict
        }
    }
    
    private var googleMapValue: NSDictionary {
        get {
            return plistValue["GoogleMap"] as! NSDictionary
        }
    }
    
    private var userInterface: NSDictionary {
        get {
            return plistValue["UserInterface"] as! NSDictionary
        }
    }
    
    var googleMapBundleId: String {
        get {
            return googleMapValue["GoolgeMap-BundleId"] as! String
        }
    }
    
    var googleMapKey: String {
        get {
            return googleMapValue["GoolgeMap-Key"] as! String
        }
    }
    
    var googleMapAPIKey: String {
        get {
            return googleMapValue["GoogleMapAPI-Key"] as! String
        }
    }
    
    var socketURL: String {
        return plistValue["SocketURL"] as! String
    }
    
    var apiURL: String {
        return plistValue["ApiURL"] as! String
    }
    
    var animateDuration: TimeInterval {
        return userInterface["animateDuration"] as! TimeInterval
    }
    
    var defaultWidth: CGFloat {
        return userInterface["defaultWidth"] as! CGFloat
    }
    var defaultHeight: CGFloat {
        return userInterface["defaultHeight"] as! CGFloat
    }
    
    var zoomLevel: Float {
        return userInterface["zoomLevel"] as! Float
    }
    
    var googleMapJsonStyle: String {
        return userInterface["googleMapJsonStyle"] as! String
    }
    var stripe: NSDictionary { return plistValue["Stripe"] as! NSDictionary }
    
    var stripePublishableKey: String {
        return stripe["publishableKey"] as! String
    }
    var onePay: NSDictionary { return plistValue["OnePay"] as! NSDictionary }

    var onePayBaseURL: String {
        return onePay["baseURL"] as! String
    }
    var updateLocationTimeDuration :Int {
        return userInterface["updateLocationTimeDuration "] as! Int
    }
    var socketDelayDuration:Int {
        return userInterface["socketDelayDuration"] as! Int
    }
    func getAvatarURL(id: String) -> String {
        return "\(apiURL)avatars/\(id)"
    }
    var bookingDuration: Int {
        return userInterface["bookingDuration"] as! Int
    }
}
