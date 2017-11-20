//
//  GetDirectionResult.swift
//  drivers
//
//  Created by Đinh Anh Huy on 10/11/16.
//  Copyright © 2016 Đinh Anh Huy. All rights reserved.
//


import UIKit
import ObjectMapper
import CoreLocation

public class Location: Mappable {
    
    var lat: Double = 0
    var lng: Double = 0
    
    func CLLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}

class GetDirectionResult: Mappable {
    
    var routes: [Route]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        routes <- map["routes"]
    }
}

extension GetDirectionResult {
    class Route: Mappable {
        var overviewPolyline: OverviewPolyline?
        var bounds: Bound?
        var legs: [Leg]?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            overviewPolyline <- map["overview_polyline"]
            bounds           <- map["bounds"]
            legs             <- map["legs"]
        }
    }
}

extension GetDirectionResult.Route {
    class Leg: Mappable {
        var startLocation: Location?
        var endLocation: Location?
        var distance: PairTextValue?
        var duration: PairTextValue?
        
        class PairTextValue: Mappable {
            var text: String?
            var value: Double?
            
            required init?(map: Map) {
                
            }
            
            func mapping(map: Map) {
                text  <- map["text"]
                value <- map["value"]
            }
        }
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            startLocation   <- map["start_location"]
            endLocation     <- map["end_location"]
            distance        <- map["distance"]
            duration        <- map["duration"]
        }
    }
    
    class Bound: Mappable {
        var northeast: Location?
        var southwest: Location?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            northeast <- map["northeast"]
            southwest <- map["southwest"]
        }
    }
    
    class OverviewPolyline: Mappable {
        var points: String?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            points <- map["points"]
        }
    }
}

