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
class HomeViewController: BaseViewController {
    var lineChartEntry = [ChartDataEntry]()
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var lbBtnChartMode: UILabel!
    @IBOutlet weak var lbChartMode: UILabel!
    @IBOutlet weak var viewSwitch: UIView!
    var dataforPicker = ["Hôm nay", "Ngày trước","7 ngày gần nhất","30 ngày gần nhất","Tháng trước"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //TO-DO: input chart data
        for i in 0..<10 {
            let value =  ChartDataEntry(x: Double(i), y: Double(i) * 2.5)
            lineChartEntry.append(value)
        }
        
        setupLineChart()
//        let gpsSwitch = JTMaterialSwitch()
//        gpsSwitch?.frame = viewSwitch.bounds
//        gpsSwitch?.center = CGPoint(x: 200, y: 200)
//        viewSwitch.addSubview(gpsSwitch!)
////        view.addSubview(gpsSwitch)
//        self.view.setNeedsDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        

    }
    
    func setupLineChart(){
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        line1.colors = [NSUIColor.orange]
        line1.circleColors = [NSUIColor.orange]
        line1.circleHoleColor = NSUIColor.white
        line1.mode = .cubicBezier
        line1.lineWidth = 5
        line1.circleRadius = 6
        line1.circleHoleRadius = 4
        let data = LineChartData()
        data.addDataSet(line1)
        data.setDrawValues(false)
        chart.data = data
        chart.chartDescription?.text = ""
        chart.drawGridBackgroundEnabled = false
        chart.drawBordersEnabled = false
        chart.borderLineWidth = 4
        
        chart.xAxis.enabled = false
        chart.xAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = true
        chart.rightAxis.zeroLineColor = NSUIColor.black
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.enabled = false
        chart.isUserInteractionEnabled = false
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
    

}
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataforPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  dataforPicker[row]
    }
}
extension HomeViewController: AlertPresenting, ChartModePickerDelegate {
    func chartMode(title: String, index: Int) {
        SVProgressHUD.show()
        lbChartMode.text = title
        lbBtnChartMode.text = title
    }
    
    func datePicked(date: Date) {
        print(date.description)
    }
    
    @IBAction func changeChartMode(_ sender: UIButton){
        showAlert(self.view, delegate: self, isDatePicker: false)
    }

}
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        imgViewProfilePicture.contentMode = .scaleAspectFit //3
//        imgViewProfilePicture.image = chosenImage //4
//        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

