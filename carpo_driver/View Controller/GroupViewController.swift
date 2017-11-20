//
//  GroupViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class DriverCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
}
class GroupViewController: BaseViewController {
    @IBOutlet weak var tfSearch: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPlate: UILabel!
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbColor: UILabel!
    @IBOutlet weak var lbTotalDistance: UILabel!
    var drivers:[Driver] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatLabel(field: "Plate", info: "123456789", label: lbPlate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MapViewController {
            //TO-DO: Pass data to map
        }
    }
    
    func formatLabel(field: String, info: String, label: UILabel) -> String {
        let rawString = "\(field): \(info)"
        let myMutableString = NSMutableAttributedString(
            string: rawString,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "SanFranciscoText-Regular",
                size: 14.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "SanFranciscoText-Semibold",
                                        size: 17.0)!,
                                     range: NSRange(
                                        location: field.count.hashValue + 2,
                                        length: info.length))
        myMutableString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(
            location:field.count.hashValue + 2,
            length:info.length))

            label.attributedText = myMutableString
        return rawString
    }
    
}
extension GroupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //TO-DO: Call API search driver's name
    }
}
extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell") as! DriverCell
        cell.lbName.text = "Nguyen Van A"
        return cell
    }
}
