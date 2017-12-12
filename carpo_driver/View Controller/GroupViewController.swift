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
import Charts
import IBAnimatable
class DriverCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
}
class GroupViewController: BaseViewController {
    @IBOutlet weak var viewGroupDriversDetail: UIView!
    @IBOutlet weak var tableView: UITableView!
    let pieChart = PieChartView()
    @IBOutlet weak var viewPieChart: AnimatableView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var viewGroupGeneral: UIView!
    @IBOutlet var viewsDistance: [UIView]!
    var isSelectedDriver = false
    var selectedIndex = 0
    var isDetailPressed = false {
        didSet{
            if isDetailPressed {
//                setNavigationBarItemForBack(#selector(method))
            }
        }
    }
    var sortedDrivers:[Driver.Data] = []
    var drivers:[Driver.Data] = [] {
        didSet{
           sortedDrivers = drivers
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
             setupView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: Global.currentScreenTitle)
         pieChart.frame = viewPieChart.bounds
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pieChart.frame = viewPieChart.bounds
    }
    func setupView(){
        for view in viewsDistance {
            view.layer.cornerRadius = 5
        }
        //        getGroup()
        self.view.bringSubview(toFront: viewGroupGeneral)
        setupPieChart()
        setupBarChart()
    }
    
    func setupPieChart(){
        viewPieChart.maskType = .circle
        viewPieChart.borderWidth = 15
        viewPieChart.borderType = .solid
        viewPieChart.borderColor = UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        pieChart.segments = [
            Segment(color: UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0), name: "35%", value: 25),
            Segment(color: UIColor(red: 100.0/255.0, green: 241.0/255.0, blue: 183.0/255.0, alpha: 0.0), name: "", value: 75)
        ]
        pieChart.segmentLabelFont = UIFont(name: "MyriadPro-Bold", size: 27)!
        pieChart.showSegmentValueInLabel = false
        viewPieChart.addSubview(pieChart)
    }
    
    func setupBarChart(){
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,6.0, 3.0, 12.0, 16.0]
        var barChartDataEntries: [BarChartDataEntry] = []
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: unitsSold[i])
            barChartDataEntries.append(dataEntry)
        }
        barChart.chartDescription?.text = ""
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawLabelsEnabled = false
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.gridBackgroundColor = NSUIColor.clear
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelTextColor = UIColor(hex: "808080")
        barChart.noDataText = "No Data"
        barChart.legend.enabled = false
        barChart.legend.textColor = UIColor(hex: "808080")
        let barChartDataSet = BarChartDataSet(values: barChartDataEntries, label: "Số km theo khu vực")
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueTextColor(NSUIColor(hex: "808080"))
        barChart.data = barChartData
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChart.xAxis.granularity = 1
        barChartDataSet.colors = [NSUIColor(hex: "2CAEE4" )]
        

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
    
    @IBAction func changeToDetailScreen(_ sender: Any){
        viewGroupGeneral.leftToRightAnimation(duration: 0.5, completionDelegate: self)
    }
    
    func getGroupDriversInfo(){

        let completion = {(driver: User?, error: String?) -> Void in
            if let driverInfo = driver {
                if driverInfo.status == 0 {
                    self.alert(title: "Lỗi", message: "Không tìm thấy thông tin tài xế")
                } else {
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            } else {
                self.alert(title: "Lỗi", message: "Không tìm thấy kết quả")
            }
        }
        ApiManager.getInfoCarByUserId(sortedDrivers[selectedIndex].userId!, completion: completion)
    }
    
}
extension GroupViewController{

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
//        selectedIndex = indexPath.row
//        isSelectedDriver = true
//        viewSearchDriver.leftToRightAnimation(duration: 0.5, completionDelegate: self)
    }
}
extension GroupViewController: CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        if isSelectedDriver {
            viewGroupGeneral.alpha = 0
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isSelectedDriver {
            SVProgressHUD.show()
            getGroupDriversInfo()
        }
    }
}
