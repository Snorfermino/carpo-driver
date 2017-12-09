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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: Global.currentScreenTitle)
    }
    
}

extension MapViewController: AlertPresenting, ChartModePickerDelegate {
    func chartMode(title: String, index: Int) {
        SVProgressHUD.show()
        
    }
    
    func datePicked(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from:date as Date)
        print(dateString)
        lbDate.text = dateString
        let completion = {(result: HistoryResult?, error: String?) -> Void in
            print(result?.toJSON())
            if let result = result {
                if result.status == 0 {
                    self.alert(title: "Không tìm thấy kết quả", message: "")
                } else {
                    var i = 0
                     var markers:[(id:String, location: CGLocation)] = []
                    for location in (result.data?.listLocation)! {
                        
                       
                        markers.append((id: "\(i)", location: CGLocation(lat: (location.locationLat?.doubleValue)!, long: (location.locationLong?.doubleValue)!)))
                        i += 1
                       
                    }
                    self.formatLabel(field: "Tổng hành trình", info: NSString(format: "%.2f", (result.data?.totalDistace)!).description, label: self.lbTravelDistance)
                    
//                    self.lbTravelDistance.text = "\(result.data?.totalDistace) km"
                    self.viewGoogleMap.updateDriversLocation(infos: markers)
                }
            } else {
                self.alert(title: "Không tìm thấy kết quả", message: "")
            }
        }
        ApiManager.getHistory(date.format(), completion: completion)
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
        showAlert(self.view, delegate: self, isDatePicker: true)
    }
    
}
