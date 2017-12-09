//
//  ChartModePicker.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
protocol AlertPresenting {}

extension AlertPresenting {
    func showAlert(_ onView: UIView, delegate: ChartModePickerDelegate, isDatePicker: Bool) {
        let alertView = ChartModePicker(frame: onView.bounds, isDatePicker: isDatePicker)
        alertView.isDatePicker = isDatePicker
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.delegate = delegate
        onView.addSubview(alertView)
        onView.bringSubview(toFront: alertView)
        let views = ["alert": alertView,
                     "view": onView]
        var allConstraints = [NSLayoutConstraint]()
        let hFormat = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[alert]-0-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += hFormat
        let vFormat = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[alert]-0-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += vFormat
        NSLayoutConstraint.activate(allConstraints)
    }
}
protocol ChartModePickerDelegate {
    func chartMode(title: String, index: Int)
    func datePicked(date: Date)
}
class ChartModePicker: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var modePicker: UIPickerView!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgViewClose: UIImageView!
    @IBOutlet weak var testDatePicker: UIDatePicker!
    var isDatePicker = false
    var datePicked: Date!
    var datePicker: UIDatePicker!
    lazy var modes = ["Hôm nay", "Ngày trước","7 ngày gần nhất","30 ngày gần nhất","Tháng trước"]
    var delegate: ChartModePickerDelegate?
    var chosenIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    init(frame: CGRect, isDatePicker: Bool){
        super.init(frame: frame)
        self.isDatePicker = isDatePicker
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ChartModePicker", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.15)
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outterScreenTaped(_:))))
        imgViewClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outterScreenTaped(_:))))
        changeCenterView(isDatePicker)
     
    }
    
    func changeCenterView(_ isDatePicker: Bool){
        
        if isDatePicker {
            //            datePicker.removeFromSuperview()
               datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: viewCenter.bounds.width, height: viewCenter.bounds.height))
            lbTitle.text = "Chọn ngày"
//            datePicker.addTarget(self, action: #selector(ChartModePicker.datePickerValueChanged), for: UIControlEvents.valueChanged)
//            datePicker.datePickerMode = .date
            
//            datePicker.frame = viewCenter.bounds
            testDatePicker.datePickerMode = .date
            testDatePicker.addTarget(self, action: #selector(ChartModePicker.datePickerValueChanged), for: UIControlEvents.valueChanged)
            modePicker.isHidden = true
            viewCenter.addSubview(testDatePicker)
        } else {
            //            modePicker.removeFromSuperview()
            lbTitle.text = "Thống kê theo"
            modePicker.frame = viewCenter.bounds
//            datePicker.isHidden = true
            viewCenter.addSubview(modePicker)
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        //        dateFormatter.date(from: dateFormatter.string(from: sender.date))
        datePicked = dateFormatter.date(from: dateFormatter.string(from: sender.date))!
        print("\(datePicked)    \(dateFormatter.date(from: dateFormatter.string(from: sender.date)))")
    }
    
    @objc func outterScreenTaped(_ sender: Any){
        self.removeFromSuperview()
    }
    @IBAction func confirmPressed(_ sender: Any){
        self.removeFromSuperview()
        if isDatePicker {
            delegate?.datePicked(date: datePicked)
        } else {
            delegate?.chartMode(title: modes[chosenIndex], index: chosenIndex)
        }
        
    }
    
}
extension ChartModePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenIndex = row
        pickerView.reloadAllComponents()

    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let pickerLabel = UILabel()
//
//        if pickerView.selectedRow(inComponent: component) == row {
//            pickerLabel.attributedText = NSAttributedString(string: String(modes[row]), attributes: [NSAttributedStringKey.font:UIFont(name: "SanFranciscoText-Regular", size: 15.0)!, NSAttributedStringKey.foregroundColor: UIColor(hex: "ff9300")])
//
//        } else {
//            pickerLabel.attributedText = NSAttributedString(string: String(modes[row]), attributes: [NSAttributedStringKey.font:UIFont(name: "SanFranciscoText-Regular", size: 15.0)!, NSAttributedStringKey.foregroundColor: UIColor(hex: "808080")])
//        }
//
//        pickerLabel.textAlignment = .center
//        return pickerLabel
//    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return  String( modes[row])
//    }
//
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = String(modes[row])
        var color = UIColor()
        if row == pickerView.selectedRow(inComponent: component) {
            color = UIColor(hex: "ff9300")
        } else {
            color = UIColor(hex: "808080")
        }

        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "RobotoMonoForPowerline-Light", size: 15.0)!,NSAttributedStringKey.foregroundColor:color])
        return myTitle
    }
    
    
}
