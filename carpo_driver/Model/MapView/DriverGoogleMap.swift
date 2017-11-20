//
//  DriverGoogleMaps.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import GoogleMaps
class PinMarker: GMSMarker {
    override init() {
        super.init()
        
        icon = UIImage(named: "icon_pin")?.resizeImage(newWidth: 35)?.imageWithColor(UIColor.blue)
        snippet = "StartLocation"
        appearAnimation = kGMSMarkerAnimationPop
    }
    
    convenience init(color: UIColor) {
        self.init()
        icon = icon?.imageWithColor(color)
    }
}

class DriverGoogleMap: CGMapView {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initControl()
    }
    
    override func initControl() {
        super.initControl()
        setMinZoom(1, maxZoom: 20)
        
        //        startMarker.addPulsatorWith(image: #imageLiteral(resourceName: "ic_pin"))
        endMarker.addPulsatorWith(image: #imageLiteral(resourceName: "ic_gender"),
                                  pulseColor: UIColor(hex: "FF005B"))
        
        //       startMarker.pulsator.start()
        //        endMarker.pulsator.start()
        let camera = GMSCameraPosition.camera(withLatitude: 0,
                                              longitude: 0,
                                              zoom: Config.shareInstance.zoomLevel)
        isMyLocationEnabled = false
        self.camera = camera
    }
    
    
    @discardableResult
    func drawPath() -> String {
        return " "
//        guard let mapData = Session.shareInstance.currentGoogleMapData else { return " " }
//        let encodePath = mapData.routes?.first?.overviewPolyline?.points
//        let gmsPath = GMSPath(fromEncodedPath: encodePath!)
//        let northeast   = mapData.routes!.first!.bounds!.northeast!.CLLocation()
//        let southwest   = mapData.routes!.first!.bounds!.southwest!.CLLocation()
//        guard let startLocation = mapData.routes?.first?.legs?.first?.startLocation else {
//            print()
//            return " "
//        }
//        guard let endLocation = mapData.routes?.first?.legs?.last?.endLocation else {
//            print()
//            return " "
//        }
//
//
//        let cgStart = startLocation.CLLocation().cgLocation
//        let cgEnd = endLocation.CLLocation().cgLocation
//
//        //update start, end marker location
//        self.updateStartMarkerLocation(location: cgStart)
//        self.updateEndMarkerLocation(location: cgEnd)
//
//        let queue = DispatchQueue(label: "drawRoute before scaletofit", target: .main)
//        let group1 = DispatchGroup()
//
//        queue.async(group: group1) {
//            self.drawRoute(gmsPath: gmsPath!,
//                           northeast: northeast,
//                           southwest: southwest)
//
//        }
//        group1.notify(queue: .main) {
//
//            self.scaleToFit(gmsPath: gmsPath!)
//
//        }
//
//
//
//        guard let duration = mapData.routes?.first?.legs?.first?.duration?.text  else {
//            return ""
//        }
//
//        return duration
//
    }
}

