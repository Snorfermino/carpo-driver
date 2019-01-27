//
//  HomeViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import JTMaterialSwitch
import RKPieChart
import IBAnimatable
import CoreLocation
class HomeViewController: BaseViewController {
    @IBOutlet weak var viewPieChart: AnimatableView!
    @IBOutlet weak var viewSwitch: UIView!
    @IBOutlet weak var imgViewProof:UIImageView!
    @IBOutlet var viewDistanceDisplay: [UIView]!
    @IBOutlet weak var lbTraveledPercentages:UILabel!
    @IBOutlet weak var lbUntraveledPercentages:UILabel!
    @IBOutlet weak var lbTraveledDistanceToday:UILabel!
    @IBOutlet weak var lbTraveledDistanceThreeDaysAgo:UILabel!
    @IBOutlet weak var lbTraveledDistanceSevenDaysAgo:UILabel!
    @IBOutlet weak var lbTotalTraveledDistanceInCurrentMonth:UILabel!
    let pieChartView = PieChartView()
    var locationUpdateTimer: Timer!
    let locationManager = CLLocationManager()
    var currentLocation:CGLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
                getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem(title: "Trang chủ")
        pieChartView.frame = viewPieChart.bounds
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pieChartView.frame = viewPieChart.bounds
    }
    func setupView(){
        SVProgressHUD.dismiss()
        if !DataManager.isLogged() {
            slideMenuController()?.changeMainViewController(UIStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController"), close: true)
        }
        guard let tokenExpiredString = Global.user?.data.tokenExpire else {
            slideMenuController()?.changeMainViewController(UIStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController"), close: true)
            return
        }
        let tokenExpiredDate = Date(tokenExpiredString, format: "yyyy-MM-dd")
        let currentDate = Date()
        if tokenExpiredDate >= currentDate {
            
        }
        
        for view in viewDistanceDisplay {
            
            view.layer.cornerRadius = 5
        }
    }
    
    @objc func startUpdateLocation(_ mySwitch: UISwitch){
        let value = mySwitch.isOn
        if value {
            locationUpdateTimer = Timer(timeInterval: 5, target: self, selector: #selector(uploadLocation), userInfo: nil, repeats: true)
        } else {
            locationUpdateTimer.invalidate()
        }
    }
    func formatDistanceLabelText(_ distance: Double, label: UILabel) {
        let rawString = "\(distance)km"
        let myMutableString = NSMutableAttributedString(
            string: rawString,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "MyriadPro-Regular",
                size: 17.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "MyriadPro-Bold",
                                        size: 33.0)!,
                                     range: NSRange(
                                        location: 0,
                                        length: distance.description.length))
        myMutableString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(
            location: 0,
            length:rawString.length))
        
        label.attributedText = myMutableString
        
    }
    
    func formatLegendsText(field: String, info: String, label: UILabel) {
        let indexEndOfText = info[..<info.index(info.startIndex, offsetBy: 5)]
        let rawString = "\(field): \(indexEndOfText) %"
        let myMutableString = NSMutableAttributedString(
            string: rawString,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "MyriadPro-Regular",
                size: 12.0)!])
        myMutableString.addAttribute(.foregroundColor, value: UIColor(hex: "808080"), range: NSRange(
            location: 0,
            length: field.length))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "MyriadPro-Bold",
                                        size: 33.0)!,
                                     range: NSRange(
                                        location: field.count.hashValue + 2,
                                        length: 5))
        myMutableString.addAttribute(.foregroundColor,
                                     value: UIColor(hex: "FF9300"),
                                     range: NSRange(
                                        location:field.count.hashValue + 2,
                                        length: 5))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "MyriadPro-Bold",
                                        size: 17.0)!,
                                     range: NSRange(
                                        location: field.count.hashValue + 2 + 5 + 1,
                                        length: 1))
        myMutableString.addAttribute(.foregroundColor, value: UIColor(hex: "808080"), range: NSRange(
            location: field.count.hashValue + 2 + 5 + 1,
            length: 1))
        label.attributedText = myMutableString
        
    }
    
    
    func setupPieChart(_ value: Float){
        pieChartView.removeFromSuperview()
        pieChartView.frame = viewPieChart.frame
        pieChartView.segments = [
            Segment(color: UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0), name: "", value: CGFloat(value)),
            Segment(color: UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1.0), name: "", value: CGFloat(100 - value))
        ]
        pieChartView.segmentLabelFont = UIFont(name: "MyriadPro-Bold", size: 30)!
        pieChartView.showSegmentValueInLabel = false
        viewPieChart.addSubview(pieChartView)
    }
    
    @IBAction func proofPhotoPressed(_ sender: Any){
        print("camera action")
        let imgPicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPicker.sourceType = .camera
            imgPicker.isEditing = false
            imgPicker.delegate = self
            present(imgPicker, animated: true, completion: nil)
        } else {
            alert(title: "Camera Error", message: "Camera not Available")
            print("camera not available")
        }
    }
    
    @objc func uploadLocation(){
        ApiManager.uploadLocation(Global.user!, currentLocation)
    }
    
    func getInfo(){
//        SVProgressHUD.show()
        let completion = {(result: GetInfoForHomeScreenResult?, error: String?) -> Void in
            if let result = result {
                if result.status == 0 {
                    SVProgressHUD.dismiss()
//                    self.alert(title: "Lỗi", message: "Không có kết quả")
                } else {
                    SVProgressHUD.dismiss()
                    self.updateScreen(result)
                }
            } else {
                SVProgressHUD.dismiss()
//                self.alert(title: "Lỗi", message: "Không có kết quả")
            }
        }
        guard let userID = Global.user?.data.id else {return}
        ApiManager.getInfoHomeScreen(userID, completion: completion)
    }
    
    func updateScreen(_ result: GetInfoForHomeScreenResult){
        guard result.error != nil else { return }
        formatLegendsText(field: "% đi được",
                          info: String(describing: (result.data?.totalPercentMonth ?? 0)!),
                          label: lbTraveledPercentages)
        formatLegendsText(field: "% còn thiếu",
                          info: String(describing: 100 - (result.data?.totalPercentMonth ?? 0)!),
                          label: lbUntraveledPercentages)
        formatDistanceLabelText((result.data?.totalKmToday ?? 0)!,label: lbTraveledDistanceToday)
        formatDistanceLabelText((result.data?.totalKmThreeDayBefore ?? 0)!,label: lbTraveledDistanceThreeDaysAgo)
        formatDistanceLabelText((result.data?.totalKmSevenDayBefore ?? 0)!,label: lbTraveledDistanceSevenDaysAgo)
        lbTotalTraveledDistanceInCurrentMonth.text = "\(String(describing:(result.data?.totalKmMonth ?? 0)!))"
        setupPieChart((Float(result.data?.totalPercentMonth ?? 0)))
    }
    
    func updateScreenLabels(_ data: GetInfoForHomeScreenResult.Data) {
        
    }
    
    func uploadProof(_ image: UIImage){
        SVProgressHUD.show()
        let completion = {(result: ChangeAvatarResult?, error: String?) -> Void in
            if result?.status == 0 {
                self.alert(title: "Lỗi", message: "Cập nhập hình ảnh thất bại")
            } else {
                self.alert(title: "Đã cập nhập", message: "")
            }
            SVProgressHUD.dismiss()
        }
        ApiManager.uploadProof(image, completion: completion)
    }
}
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        imgViewProof.contentMode = .scaleAspectFit //3
//        imgViewProof.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        uploadProof(chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate.cgLocation
    }
}
