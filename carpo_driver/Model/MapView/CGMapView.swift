//
//  CGMapView.swift
//  CGMapView
//
//  Created by Đinh Anh Huy on 10/25/16.
//  Copyright © 2016 Đinh Anh Huy. All rights reserved.
//

import UIKit
import GoogleMaps

enum CGMapViewType {
    case passenger
    case delivery
    case tour
    case carHire
}

enum CGMapInputType: Int {
    case from
    case to
    case none
}

class CGMapView: GMSMapView {
    var imgPin = UIImageView(image: #imageLiteral(resourceName: "ic_markerActive").resizeImage(newWidth: 20))
    var startMarker = CGMarker()
    var endMarker = CGMarker()
    var drivers = [CGDriverMarker]()
    var riders = [CGRiderMarker]()
    var directionLine: GMSPolyline!
    var currentLocation = CGLocation()

    var driverMarker = #imageLiteral(resourceName: "ic_markerActive")

    var isCurrentLocation = false
    //var markerSize:CGFloat = 50
    var scale =  10
    var currentLocationManager = CLLocationManager()
    
    func clearMarker() {
        startMarker.map = nil
        endMarker.map = nil
        if directionLine != nil { directionLine.map = nil }
    }
    
    
    //default type CMMapView
    var type: CGMapViewType = .passenger
    var pinType = CGMapInputType.from {
        didSet {
            if pinType == .from {
                imgPin.image = imgPin.image!.imageWithColor(UIColor.blue)
            } else if pinType == .to {
                imgPin.image = imgPin.image!.imageWithColor(UIColor.red)
            } else {
                imgPin.image = imgPin.image!.imageWithColor(UIColor.gray)
            }
        }
    }
    
    //MARK: init control
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        initControl()
    }

    func initControl() {
        //        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//        mapStyle = try? GMSMapStyle(jsonString: Config.shareInstance.googleMapJsonStyle) 
        
        currentLocationManager.delegate = self
        currentLocationManager.startUpdatingLocation()
//        guard Session.shareInstance.loginResult.data?.vehicle?.id != nil ||
//            Session.shareInstance.loginResult.data?.vehicle?.id == ""
//            else {
//                isMyLocationEnabled = true
//                return
//        }
        isMyLocationEnabled = false
//        startMarker.map = self
        endMarker.map = self
//        startMarker.icon = #imageLiteral(resourceName: "ic_pin").imageWithColor(UIColor.blue).resizeImage(newWidth: 20)
//        endMarker.icon = #imageLiteral(resourceName: "ic_desPin").imageWithColor(UIColor.red).resizeImage(newWidth: 20)
    }
    
    func setupPin(type: CGMapInputType) {
        imgPin.isHidden = false
        
        imgPin.translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(imgPin)
        _ = imgPin.addConstraintCenterXToView(view: self, commonParrentView: superview!)
        _ = imgPin.addConstraintCenterYToView(view: self, commonParrentView: superview!)
        
        if type == .from {
            imgPin.image = imgPin.image!.imageWithColor(UIColor.red)
        } else {
            imgPin.image = imgPin.image!.imageWithColor(UIColor.blue)
        }
    }
    
    //MARK: function
    public func zoomCamera(locationsToDisplay: [CGLocation],
                           marginRation: CLLocationDegrees = 0.1,
                           animationDuration: TimeInterval = 0,
                           zoomIndex: Float = 14) {
        
        var centerLat: Double = 0
        var centerLong: Double = 0
        var count: Double = 0
        
        for location in locationsToDisplay {
            count += 1
            centerLat += location.latitude
            centerLong += location.longitude
        }
        centerLat /= count
        centerLong /= count
        
        let location = CGLocation(lat: centerLat, long: centerLong)
        
        moveCamera(location: location,
                   duration: animationDuration,
                   zoom: zoomIndex)
        
        //hard-code aa
        return
        
        //find northest, southwest point
        var northeast = CLLocationCoordinate2D()
        var southwest = CLLocationCoordinate2D()
        northeast.latitude = Double.min
        northeast.longitude = Double.min
        southwest.latitude = Double.max
        southwest.longitude = Double.max
        for location in locationsToDisplay {
            if northeast.latitude < location.latitude {
                northeast.latitude = location.latitude
            }
            if northeast.longitude < location.longitude {
                northeast.longitude = location.longitude
            }
            
            if southwest.latitude > location.latitude {
                southwest.latitude = location.latitude
            }
            if southwest.longitude > location.longitude {
                southwest.longitude = location.longitude
            }
        }
        
        //caculate margin space
        var marginSpace: CLLocationDegrees = 0
        let deltaX = abs(northeast.latitude - southwest.latitude)
        let deltaY = abs(northeast.longitude - southwest.longitude)
        if deltaX > deltaY { marginSpace = deltaX * marginRation }
        else { marginSpace = deltaY * marginRation }
        marginSpace = 0
        northeast.latitude += marginSpace
        northeast.longitude += marginSpace
        southwest.latitude -= marginSpace
        southwest.longitude -= marginSpace
        //change camera to view contain list location after add margin space
        let bounds = GMSCoordinateBounds(coordinate: northeast,
                                         coordinate: southwest)
        let camera = self.camera(for: bounds, insets: UIEdgeInsets())
        if animationDuration == 0 { self.camera = camera! }
        else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
            self.camera = camera!
            CATransaction.commit()
        }
    }
    
    public func moveCamera(location: CGLocation,
                           duration: TimeInterval = 0,
                           zoom: Float? = nil) {
        
        var newZoomLevel = camera.zoom
        if zoom != nil { newZoomLevel = zoom! }
        
        
        if duration == 0 {
            self.animate(to: GMSCameraPosition.camera(
                withLatitude: location.latitude,
                longitude: location.longitude,
                zoom: newZoomLevel))
        } else {
            UIView.animate(withDuration: duration) {
                self.animate(to: GMSCameraPosition.camera(
                    withLatitude: location.latitude,
                    longitude: location.longitude,
                    zoom: newZoomLevel))
            }
        }
    }
    
    private func updateMarkersLocation(currentMarkers: inout [CGMarker],
                                       infos: [(id: String, location: CGLocation)]) {
        
        var newMarkers = [CGMarker]()
        
        for markerInfo in infos {
            if let driver = driver(id: markerInfo.id) {
                driver.updateLocation(location: markerInfo.location,
                                      updateRotation: true,
                                      useAnimation: true)
                newMarkers.append(driver)
            } else {
                //hard-code
                let newDriver = CGDriverMarker(map: self, image: driverMarker.resizeImage(newWidth: 2)!)
                newDriver.map = self
                newDriver.updateLocation(location: markerInfo.location,
                                         updateRotation: true,
                                         useAnimation: true)
                drivers.append(newDriver)
            }
        }
        
        //remove drivers no more exist on map
        let removeDrivers = drivers.filter { newMarkers.index(of: $0) == nil }
        _ = removeDrivers.map { $0.map = nil }
        
        //refresh list driver of google map
        currentMarkers = newMarkers
    }
    
    public func updateDriversPath(infos: [CGLocation]) {

        let completion = {(result: GetDirectionResult?, error: String?) -> Void in
            guard let result = result else { return }
            guard let startLocation = result.routes?.first?.legs?.first?.startLocation else { return }
            guard let endLocation = result.routes?.first?.legs?.first?.endLocation else { return }
            let cgStart = startLocation.CLLocation().cgLocation
            let cgEnd = endLocation.CLLocation().cgLocation
            
            //update start, end marker location
            self.updateStartMarkerLocation(location: cgStart)
            self.updateEndMarkerLocation(location: cgEnd)
            
            guard let encodePath = result.routes?.first?.overviewPolyline?.points else {
                return
            }
            guard let gmsPath = GMSPath(fromEncodedPath: encodePath) else {
                return
            }
            let northeast   = result.routes!.first!.bounds!.northeast!.CLLocation()
            let southwest   = result.routes!.first!.bounds!.southwest!.CLLocation()
            self.drawRoute(gmsPath: gmsPath,
                           northeast: northeast,
                           southwest: southwest)
            self.scaleToFit(gmsPath: gmsPath)
        }
        GoogleMapAPIManager.getWaypoints(locations: infos, completion: completion)
    }
    
    public func updateDriversLocation(infos: [(id: String, location: CGLocation)]) {
        
        var newDrivers = [CGDriverMarker]()
        
        for driverInfo in infos {
            if let driver = driver(id: driverInfo.id) {
                driver.updateLocation(location: driverInfo.location, updateRotation: true, useAnimation: true)
                newDrivers.append(driver)
            } else {
                //hard-code update location 1 driver
                print("location.toJSON() \(driverInfo.location.toJSON())")
                let newDriver = CGDriverMarker(map: self, image: driverMarker)

                //newDriver.changeSize(size: markerSize)
                
                newDriver.scaleSize(image: driverMarker, size: CGFloat(scale))
                newDriver.id = driverInfo.id
                newDriver.map = self
                newDriver.updateLocation(location: driverInfo.location,
                                         updateRotation: true,
                                         useAnimation: true)
                newDrivers.append(newDriver)

            }
        }
        
        //remove no more exist drivers
                let removeDrivers = drivers.filter { newDrivers.index(of: $0) == nil }
                _ = removeDrivers.map { $0.map = nil }
        
        //refresh list driver of google map
        drivers = newDrivers
    }
    
    func driver(id: String) -> CGDriverMarker? {
        for driver in drivers {
            if driver.id == id { return driver }
        }
        return nil
    }
    
    
    
    public func updateRidersLocation(infos: [(id: String, location: CGLocation)]) {
        var currentInfo: (id: String, location: CGLocation)!
        for i in 0...infos.count - 1 {
            currentInfo = infos[i]
            for rider in riders {
                if rider.id == currentInfo.id {
                    rider.updateLocation(location: currentInfo.location,
                                         updateRotation: true, useAnimation: true)
                }
            }
        }
    }
    
    func requestDrawRoute(from: CGLocation, 
                          to: CGLocation,
                          completion:  ( (_ travelTime: String?) -> ())? = nil) {
        
        let completion = {(result: GetDirectionResult?, error: String?) -> Void in
            guard let result = result else { return }
            guard let startLocation = result.routes?.first?.legs?.first?.startLocation else { return }
            guard let endLocation = result.routes?.first?.legs?.first?.endLocation else { return }
            let cgStart = startLocation.CLLocation().cgLocation
            let cgEnd = endLocation.CLLocation().cgLocation
            
            //update start, end marker location
            self.updateStartMarkerLocation(location: cgStart)
            self.updateEndMarkerLocation(location: cgEnd)

            guard let encodePath = result.routes?.first?.overviewPolyline?.points else {
                return
            }
            guard let gmsPath = GMSPath(fromEncodedPath: encodePath) else {
                return
            }
            let northeast   = result.routes!.first!.bounds!.northeast!.CLLocation()
            let southwest   = result.routes!.first!.bounds!.southwest!.CLLocation()
            self.drawRoute(gmsPath: gmsPath,
                           northeast: northeast,
                           southwest: southwest)
            self.scaleToFit(gmsPath: gmsPath)
        }
        GoogleMapAPIManager.getRoute(from: from, to: to, completion: completion)
//        let api = GoogleMapApi()
//        _ = api.getRoute(originAddress: from, destinationAddress: to, completeBlock: { (task) -> APITask in
//
//            do {
//                guard let objectData = task.result as? GetDirectionResult else {
//                    throw APIError.conflictTypeResponse
//                }
//                guard let startLocation = objectData.routes?.first?.legs?.first?.startLocation else {
//                    throw APIError.dontHaveResponse
//                }
//                guard let endLocation = objectData.routes?.first?.legs?.last?.endLocation else {
//                    throw APIError.dontHaveResponse
//                }
//
//
//                let cgStart = startLocation.CLLocation().cgLocation
//                let cgEnd = endLocation.CLLocation().cgLocation
//
//                //update start, end marker location
//                self.updateStartMarkerLocation(location: cgStart)
//                self.updateEndMarkerLocation(location: cgEnd)
////                self.startMarker.pulsator.start()
////                self.endMarker.pulsator.start()
//                //draw and zoom camera to that route of input location
//                guard let encodePath = objectData.routes?.first?.overviewPolyline?.points else {
//                    throw APIError.dontHaveResponse
//                }
//                guard let gmsPath = GMSPath(fromEncodedPath: encodePath) else {
//                    throw APIError.conflictTypeResponse
//                }
//                let northeast   = objectData.routes!.first!.bounds!.northeast!.CLLocation()
//                let southwest   = objectData.routes!.first!.bounds!.southwest!.CLLocation()
//                self.drawRoute(gmsPath: gmsPath,
//                               northeast: northeast,
//                               southwest: southwest)
//                self.scaleToFit(gmsPath: gmsPath)
//                completion?(objectData.routes?.last?.legs?.last?.duration?.text)
//                Session.shareInstance.travelDuration = objectData.routes?.last?.legs?.last?.duration?.text
//            } catch APIError.dontHaveResponse {
//                print("error dont have response")
//                vc.alert(title: "error", message: "dont have response")
//            } catch APIError.conflictTypeResponse {
//                print("error ConflictTypeResponse")
//                vc.alert(title: "error", message: "ConflictTypeResponse")
//
//            } catch {
//                print("error Undefined")
//                vc.alert(title: "error", message: "Undefined")
//            }
//            return task
//        })
    }
    
    
    public func drawRoute(gmsPath: GMSPath,
                          northeast: CLLocationCoordinate2D? = nil,
                          southwest: CLLocationCoordinate2D? = nil) {
        if directionLine != nil { directionLine.map = nil } //remove it from map
        directionLine = GMSPolyline(path: gmsPath)
        directionLine!.strokeWidth = 4
        directionLine!.strokeColor = UIColor(hex: "ff9300")
        directionLine!.map = self
    }
    
    public func updateStartMarkerLocation(location: CGLocation,
                                          animationDuration: TimeInterval = 0) {
        startMarker.map = self
        startMarker.updateLocation(location: location)
    }
    
    public func updateEndMarkerLocation(location: CGLocation,
                                        animationDuration: TimeInterval = 0) {
        endMarker.map = self
        endMarker.updateLocation(location: location)
    }
    
    public func scaleToFit(gmsPath: GMSPath) {

        let edgeInset =  UIEdgeInsets(top: 150, left: 25, bottom: self.frame.height - 320, right: 25)

        let bounds = GMSCoordinateBounds(path: gmsPath)
        self.animate(with: GMSCameraUpdate.fit(bounds, with: edgeInset))
        
    }
    
    public func showCurrentLocation() {
        isCurrentLocation = false
        currentLocationManager.startUpdatingLocation()
    }
    
    func refresh() {
        isMyLocationEnabled = false
        startMarker.map = nil
        endMarker.map = nil
        _ = riders.map { $0.map = nil }
        _ = drivers.map { $0.map = nil }
        riders.removeAll()
        drivers.removeAll()
    }
    func refreshVehicle(){
        isMyLocationEnabled = false
        _ = riders.map { $0.map = nil }
        _ = drivers.map { $0.map = nil }
        riders.removeAll()
        drivers.removeAll()
        print("refreshVehicle done")
    }

}

extension CGMapView: CLLocationManagerDelegate  {
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if manager == currentLocationManager && !isCurrentLocation {
            currentLocationManager.stopUpdatingLocation()
            currentLocation = locations.last!.cgLocation
            self.moveCamera(location: currentLocation)
            
            isCurrentLocation = true
        }
    }
    
}


extension Double {
    static var min = DBL_MIN
    static var max = DBL_MAX
}
extension CLLocation {
    var cgLocation: CGLocation {
        return CGLocation(lat: coordinate.latitude, long: coordinate.longitude)
    }
}
extension CLLocationCoordinate2D {
    var cgLocation: CGLocation {
        return CGLocation(lat: latitude, long: longitude)
    }
}
extension Location {
    var cgLocation: CGLocation {
        return CGLocation(lat: lat, long: lng)
    }
}
