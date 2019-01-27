//
//  MapViewController.swift
//  drivers
//
//  Created by Tien Dat on 3/13/17.
//  Copyright © 2017 Đinh Anh Huy. All rights reserved.
//

import UIKit
import SVProgressHUD
class MapViewController: BaseViewController {
    @IBOutlet weak var lbTravelDistance: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var viewGoogleMap: DriverGoogleMap!
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: Global.currentScreenTitle)
    }
    
    func setupView(){
        lbDate.text = Date().format("dd/MM/yyyy")
        datePicked(date: Date())
        self.formatLabel(field: "Tổng hành trình", info: "0.0", label: self.lbTravelDistance)
        printMyFonts()
    }
    
}

extension MapViewController: AlertPresenting, ChartModePickerDelegate {
    func chartMode(title: String, index: Int) {
//        SVProgressHUD.show()
        
    }
    
    func datePicked(date: Date) {
        lbDate.text = date.format("dd/MM/yyyy")
        let completion = {(result: HistoryResult?, error: String?) -> Void in
            if let result = result {
                if result.status == 0 {
                    self.alert(title: "Không tìm thấy kết quả", message: "")
                    self.formatLabel(field: "Tổng hành trình", info: "0.0", label: self.lbTravelDistance)
                    self.viewGoogleMap.clearMarker()
                    self.viewGoogleMap.clear()
                } else {
                    var i = 0
                     var markers:[(id:String, location: CGLocation)] = []
                    var locations:[CGLocation] = []
                    for location in (result.data?.listLocation)! {
                        
                        if i < 1 {
                        markers.append((id: "\(i)", location: CGLocation(lat: (location.locationLat?.doubleValue)!, long: (location.locationLong?.doubleValue)!)))
                        }
                        locations.append(CGLocation(lat: (location.locationLat?.doubleValue)!, long: (location.locationLong?.doubleValue)!))
                        i += 1
                       
                    }
//                    self.viewGoogleMap.requestDrawRoute(from: (markers.first?.location)!, to: CGLocation(lat: 10.77655, long: 106.6783622))
                    self.formatLabel(field: "Tổng hành trình", info: NSString(format: "%.1f", (result.data?.totalDistace)!).description, label: self.lbTravelDistance)
                    
//                    self.lbTravelDistance.text = "\(result.data?.totalDistace) km"
//                    for lo in locations {
//                        let newDriver = CGDriverMarker(map: self.viewGoogleMap, image: #imageLiteral(resourceName: "ic_markerActive"))
//                        newDriver.changeSize(size: 20)
//                        newDriver.map = self.viewGoogleMap
//                        newDriver.updateLocation(location: lo,
//                                                 updateRotation: true,
//                                                 useAnimation: true)
//                    }
                    let fromLocation = locations.first
                    let fromLocationMarker = CGDriverMarker(map: self.viewGoogleMap, image: #imageLiteral(resourceName: "ic_markerActive"))
                    fromLocationMarker.changeSize(size: 20)
                    fromLocationMarker.map = self.viewGoogleMap
                    fromLocationMarker.updateLocation(location: fromLocation!,
                                             updateRotation: true,
                                             useAnimation: true)
                    
                    let destination = locations.last
                    let destinationMarker = CGDriverMarker(map: self.viewGoogleMap, image: #imageLiteral(resourceName: "ic_markerDisable"))
                    destinationMarker.changeSize(size: 20)
                    destinationMarker.map = self.viewGoogleMap
                    destinationMarker.updateLocation(location: destination!,
                                             updateRotation: true,
                                             useAnimation: true)
                    
                    self.viewGoogleMap.updateDriversPath(infos: locations)
                }
            } else {
                self.alert(title: "Không tìm thấy kết quả", message: "")
            }
        }
        if userID != "" {
            ApiManager.getHistory(userID,date.format(), completion: completion)
        } else {
            guard let id = Global.user?.data.id else { return }
             ApiManager.getHistory(id,date.format(), completion: completion)
        }

    }
    func printMyFonts() {
        print("--------- Available Font names ----------")
        for name in UIFont.familyNames {
            print(name)
            print(UIFont.fontNames(forFamilyName: name))
        }
    }
    func formatLabel(field: String, info: String, label: UILabel) {
        let rawString = "\(field): \(info) km"
        let myMutableString = NSMutableAttributedString(
            string: rawString,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Roboto-Light",
                size: 14.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "Roboto-Medium",
                                        size: 17.0)!,
                                     range: NSRange(
                                        location: field.count.hashValue + 2,
                                        length: info.length))
        myMutableString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(
            location:field.count.hashValue + 2,
            length:info.length))
        
        label.attributedText = myMutableString
        
    }
    
    @IBAction func lbDatePressed(_ sender: UIButton){
        showAlert(self.view, delegate: self, isDatePicker: true, date: lbDate.text!)
    }
    
}
