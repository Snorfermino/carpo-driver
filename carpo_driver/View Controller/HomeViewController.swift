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
class HomeViewController: BaseViewController {
    var lineChartEntry = [ChartDataEntry]()
    @IBOutlet weak var pieChart: RKPieChartView!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var lbBtnChartMode: UILabel!
    @IBOutlet weak var lbChartMode: UILabel!
    @IBOutlet weak var viewSwitch: UIView!
    @IBOutlet weak var imgViewProof:UIImageView!
    var dataforPicker = ["Hôm nay", "Ngày trước","7 ngày gần nhất","30 ngày gần nhất","Tháng trước"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem(title: "Trang chủ")
        

    }
    
    func setupView(){
        if !DataManager.isLogged() {
            slideMenuController()?.changeMainViewController(UIStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController"), close: true)
        }
        SVProgressHUD.dismiss()
        //TO-DO: input chart data
        for i in 0..<10 {
            let value =  ChartDataEntry(x: Double(i), y: Double(i) * 2.5)
            lineChartEntry.append(value)
        }
        
        setupPieChart()
        setupLineChart()
    }
    
    func setupPieChart(){
        let firstItem: RKPieChartItem = RKPieChartItem(ratio: 50, color: .orange, title: "1st Item ")
        let secondItem: RKPieChartItem = RKPieChartItem(ratio: 30, color: .gray, title: "2nd Item")
        let thirdItem: RKPieChartItem = RKPieChartItem(ratio: 20, color: .yellow, title: "3th Item")
        pieChart = RKPieChartView(items: [firstItem, secondItem, thirdItem])
        pieChart.style = .round
        pieChart.isIntensityActivated = true
//        pieChart.circleColor = .green
//        pieChart.arcWidt100 100
//
//        pieChart.drawSlicesUnderHoleEnabled = false
//        pieChart.transparentCircleColor = NSUIColor.appRed
//        let dataPoints = ["A","B"]
//        let values = [25.0,75]
//        var dataEntries: [ChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
//            dataEntries.append(dataEntry)
//        }
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 0
//        formatter.multiplier = 1.0
//        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "% đi được trong tháng")
//        let pieChartData = PieChartData(dataSet: pieChartDataSet)
////        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
//
//        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
//        pieChartDataSet.selectionShift = 0
//        pieChart.data = pieChartData
//
//        let colors: [UIColor] = [UIColor(hex: "50B0EC"), UIColor.clear]
//        pieChart.holeRadiusPercent = 0
//        pieChart.drawHoleEnabled = false
//        pieChart.entryLabelFont = UIFont(name: "Roboto Mono Medium for Powerline", size: 50)
//        pieChart.drawEntryLabelsEnabled = true
//        pieChartDataSet.drawValuesEnabled = true
//        pieChartDataSet.xValuePosition = .insideSlice
//
//
//        pieChartDataSet.colors = colors
//
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
        chart.legend.enabled = false
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imgViewProof.contentMode = .scaleAspectFit //3
        imgViewProof.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

