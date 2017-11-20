//
//  CGLocation.swift
//  CGMapView
//
//  Created by Đinh Anh Huy on 10/25/16.
//  Copyright © 2016 Đinh Anh Huy. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

public class CGLocation: Mappable {
    var latitude: Double = 0
    var longitude: Double = 0
    var timeStamp: TimeInterval = 0 //time in second
    
    var clLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init() {
        
    }
    
    init(lat: Double, long: Double, timeStamp: TimeInterval = 0) {
        self.latitude = lat
        self.longitude = long
        self.timeStamp = timeStamp
    }
    
    init(location: CLLocationCoordinate2D) {
        latitude = location.latitude
        longitude = location.longitude
    }
    
    required public init?(map: Map) {
        
    }
    
    var copyValue: CGLocation {
        return CGLocation(lat: latitude, long: longitude, timeStamp: timeStamp)
    }
    
    public func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        timeStamp <- map["timeStamp"]
    }
}

extension CGLocation {
    static func ==(left: CGLocation, right: CGLocation) -> Bool {
        return left.latitude == right.longitude && left.longitude == right.latitude
    }
}

extension TimeInterval {
    mutating func rounded() -> TimeInterval {
        self = TimeInterval(Int(self))
        return self
    }
}
