//
//  GroupViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
class DriverCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
}
class GroupViewController: BaseViewController {
    @IBOutlet weak var viewSearchDriver: UIView!
    @IBOutlet weak var viewDriverInfo: UIView!
    @IBOutlet weak var tfSearch: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPlate: UILabel!
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbColor: UILabel!
    @IBOutlet weak var lbTotalDistance: UILabel!
    var isSelectedDriver = false
    var selectedIndex = 0
    var sortedDrivers:[Driver.Data] = []
    var drivers:[Driver.Data] = [] {
        didSet{
           sortedDrivers = drivers
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tfSearch.delegate = self
        getGroup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: Global.currentScreenTitle)
        viewSearchDriver.alpha = 1
        self.view.bringSubview(toFront: viewSearchDriver)
    }
    
    func updateDriverInfo(_ info: User){
        lbPlate.text = info.data?.licensePlate
        lbName.text = sortedDrivers[selectedIndex].name
        lbBrand.text = info.data.carManufacturer
        lbColor.text = info.data?.carColor
        lbTotalDistance.text = info.data.totalDistanceRunOneMonth
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MapViewController {
            //TO-DO: Pass data to map
        }
    }
   
    func formatLabel(field: String, info: String, label: UILabel) {
        let rawString = "\(field): \(info)"
        let myMutableString = NSMutableAttributedString(
            string: rawString,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "RobotoMonoForPowerline-Light",
                size: 14.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "RobotoMonoForPowerline-Medium",
                                        size: 17.0)!,
                                     range: NSRange(
                                        location: field.count.hashValue + 2,
                                        length: info.length))
        myMutableString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(
            location:field.count.hashValue + 2,
            length:info.length))

            label.attributedText = myMutableString
   
    }
    
    func getDriverInfo(){
        self.view.bringSubview(toFront: viewDriverInfo)
        viewDriverInfo.alpha = 1
        let completion = {(driver: User?, error: String?) -> Void in
            if let driverInfo = driver {
                if driverInfo.status == 0 {
                    self.alert(title: "Lỗi", message: "Không tìm thấy thông tin tài xế")
                } else {
                    self.updateDriverInfo(driverInfo)
                    SVProgressHUD.dismiss()
                }
            } else {
                self.alert(title: "Lỗi", message: "Không tìm thấy kết quả")
            }
        }
        ApiManager.getInfoCarByUserId(sortedDrivers[selectedIndex].userId!, completion: completion)
    }
    
}
extension GroupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        sortDriverName(textField.text)
    }
    
    func getGroup(){
        SVProgressHUD.show()
        let completion = {(result: GroupResult?, error: String?) -> Void in
            
            if let result = result {
                if result.status == 0 {
                    self.alert(title: "Lỗi", message: "Không tìm thấy kết quả")
                } else {
                    self.drivers.removeAll()
                    for driver in result.data! {
                        self.drivers.append(driver)
                    }
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            } else {
                self.alert(title: "Lỗi", message: "Không tìm thấy kết quả")
            }
            
        }
        guard let user = Global.user else {
            SVProgressHUD.dismiss()
            self.alert(title: "Lỗi", message: "Không tìm thấy kết quả")
            return
        }
        ApiManager.getGroup(user.data.id!, completion: completion)
    }
    func sortDriverName(_ name: String? = ""){
        guard name != "" else {
            sortedDrivers = drivers
              tableView.reloadData()
            return
        }
        sortedDrivers.removeAll()
        for d in drivers {
//            if name?.lowercased().range(of: d.name.lowercased() ) != nil {
//                sortedDrivers.append(d)
//            }
            let charset = CharacterSet(charactersIn: d.name.lowercased())
            if name?.lowercased().rangeOfCharacter(from: charset) != nil {
                sortedDrivers.append(d)
            }
        }
        tableView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDrivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell") as! DriverCell
        cell.lbName.text = sortedDrivers[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        isSelectedDriver = true
        viewSearchDriver.leftToRightAnimation(duration: 0.5, completionDelegate: self)
    }
}
extension GroupViewController: CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        if isSelectedDriver {
            viewSearchDriver.alpha = 0
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isSelectedDriver {
            SVProgressHUD.show()
            getDriverInfo()
        }
    }
}
