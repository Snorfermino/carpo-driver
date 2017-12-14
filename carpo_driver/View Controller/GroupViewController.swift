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
class DriverTitleCell: UITableViewCell {
    
}
class DriverCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbMonthlyDistance: UILabel!
    @IBOutlet weak var lbDriverIndex: UILabel!
}
class GroupViewController: BaseViewController {
    @IBOutlet weak var viewGroupDriversDetail: UIView!
    @IBOutlet weak var tableView: UITableView!
    let pieChart = PieChartView()
    @IBOutlet weak var viewPieChart: AnimatableView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var viewGroupGeneral: UIView!
    @IBOutlet var viewsDistance: [UIView]!
    @IBOutlet weak var lbTraveledPercentages:UILabel!
    @IBOutlet weak var lbUntraveledPercentages:UILabel!
    @IBOutlet weak var lbTraveledDistanceToday:UILabel!
    @IBOutlet weak var lbTraveledDistanceThreeDaysAgo:UILabel!
    @IBOutlet weak var lbTraveledDistanceSevenDaysAgo:UILabel!
    @IBOutlet weak var lbTotalTraveledDistanceInCurrentMonth:UILabel!
    var tableViewDriversData:[GetInfoForGroupMemberDetailScreenResult.Data] = []
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
//        setupPieChart()
//        setupBarChart()
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 24/667 * UIScreen.main.bounds.size.height
        getInfo()
    }
    
    func setupPieChart(_ value: Float){
        viewPieChart.maskType = .circle
        viewPieChart.borderWidth = 15
        viewPieChart.borderType = .solid
        viewPieChart.borderColor = UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        pieChart.segments = [
            Segment(color: UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0),
                    name: "",
                    value: CGFloat(value)),
            Segment(color: UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1.0),
                    name: "",
                    value: CGFloat(100 - value))
        ]
        pieChart.segmentLabelFont = UIFont(name: "MyriadPro-Bold", size: 27)!
        pieChart.showSegmentValueInLabel = false
        viewPieChart.addSubview(pieChart)
    }
    
    func setupBarChart(_ values: [Float]){
        barChart.layer.addBorder(edge: [.bottom,.left,.right], color: UIColor.black, thickness: 0.5)
        var driverIndex:[String] = []
        var barChartDataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            driverIndex.append(i.description)
            barChartDataEntries.append(dataEntry)
        }
        barChart.chartDescription?.text = ""
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = true
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawLabelsEnabled = false
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.gridBackgroundColor = NSUIColor.clear
        barChart.xAxis.labelCount = values.count
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelTextColor = UIColor(hex: "808080")
        barChart.leftAxis.spaceBottom = 0.3
        barChart.xAxis.axisLineWidth = 5

        barChart.xAxis.labelHeight = 10
        barChart.xAxis.labelFont = UIFont(name: "MyriadPro-Regular", size: 12)!
        barChart.noDataText = "Không có kết quả"
        barChart.legend.enabled = false
        barChart.legend.textColor = UIColor(hex: "808080")
        let barChartDataSet = BarChartDataSet(values: barChartDataEntries, label: "Số km theo khu vực")
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueTextColor(NSUIColor(hex: "808080"))
        barChart.data = barChartData
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: driverIndex)
        barChart.xAxis.granularity = 1
        barChartDataSet.colors = [NSUIColor(hex: "2CAEE4" )]
        
        
    }
    
    func formatDistanceLabelText(_ distance: Float, label: UILabel) {
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
        let rawString = "\(field): \(info) %"
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
                                        length: info.length))
        myMutableString.addAttribute(.foregroundColor, value: UIColor(hex: "FF9300"), range: NSRange(
            location:field.count.hashValue + 2,
            length:info.length))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(
                                        name: "MyriadPro-Bold",
                                        size: 17.0)!,
                                     range: NSRange(
                                        location: field.count.hashValue + 2 + info.count.hashValue + 1,
                                        length: 1))
        myMutableString.addAttribute(.foregroundColor, value: UIColor(hex: "808080"), range: NSRange(
            location: field.count.hashValue + 2 + info.count.hashValue + 1,
            length: 1))
        label.attributedText = myMutableString
        
    }

    func updateScreen(_ result: GetInfoForHomeScreenResult){
        formatLegendsText(field: "Tổng % đi được",
                          info: String(describing: (result.data?.totalPercentMonth)!),
                          label: lbTraveledPercentages)
        formatLegendsText(field: "Tổng % chưa đi được",
                          info: String(describing: 100 - (result.data?.totalPercentMonth)!),
                          label: lbUntraveledPercentages)
        formatDistanceLabelText((result.data?.totalKmToday)!,label: lbTraveledDistanceToday)
        formatDistanceLabelText((result.data?.totalKmThreeDayBefore)!,label: lbTraveledDistanceThreeDaysAgo)
        formatDistanceLabelText((result.data?.totalKmSevenDayBefore)!,label: lbTraveledDistanceSevenDaysAgo)
        lbTotalTraveledDistanceInCurrentMonth.text = "\(String(describing:(result.data?.totalKmMonth)!))"
        setupPieChart((result.data?.totalPercentMonth)!)
    }
    
    func updateTableViewAndBarChart(_ result: GetInfoForGroupMemberDetailScreenResult){
        tableView.reloadData()
        var entries:[Float] = []
        for data in result.data! {
            entries.append(data.totalKmMonth!)
        }
        setupBarChart(entries)
        
    }
    
    @IBAction func changeToDetailScreen(_ sender: Any){
        isDetailPressed = true
        getGroupDetail()
        viewGroupGeneral.leftToRightAnimation(duration: 0.5, completionDelegate: self)
    }
    
    @objc func changeToGeneralScreen(_ sender: Any){
        isDetailPressed = false
        viewGroupDriversDetail.rightToLeftAnimation(duration: 0.5, completionDelegate: self)
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
    
    func getInfo(){
        SVProgressHUD.show()
        let completion = {(result: GetInfoForHomeScreenResult?, error: String?) -> Void in
            if let result = result {
                if result.status == 0 {
                    SVProgressHUD.dismiss()
                    self.alert(title: "Lỗi", message: "Không có kết quả")
                } else {
                    SVProgressHUD.dismiss()
                    self.updateScreen(result)
                }
            } else {
                SVProgressHUD.dismiss()
                self.alert(title: "Lỗi", message: "Không có kết quả")
            }
        }
        guard let userID = Global.user?.data.id else {return}
        ApiManager.getInfoForManageGroupScreen(userID, completion: completion)
    }
    
    func getGroupDetail(){
        SVProgressHUD.show()
        let completion = {(result: GetInfoForGroupMemberDetailScreenResult?, error: String?) -> Void in
            SVProgressHUD.dismiss()
            if let result = result {
                if result.status == 0 {
                    SVProgressHUD.dismiss()
                    self.alert(title: "Lỗi", message: "Không có kết quả")
                } else {
                    SVProgressHUD.dismiss()
                    self.tableViewDriversData = result.data!
                    self.updateTableViewAndBarChart(result)
                }
            } else {
                SVProgressHUD.dismiss()
                self.alert(title: "Lỗi", message: "Không có kết quả")
            }
        }
        guard let user = Global.user else {
            SVProgressHUD.dismiss()
            self.alert(title: "Lỗi", message: "Không tìm thấy kết quả")
            return
        }
        ApiManager.getInfoForGroupMemberDetailScreen((user.data.id)!, completion: completion)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            //TO-DO:
            return tableViewDriversData.count
//            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case  0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriverTitleCell") as! DriverTitleCell
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell") as! DriverCell
            //TO-DO:
            //        cell.lbName.text = sortedDrivers[indexPath.row].name
            cell.lbDriverIndex.text = "\(indexPath.row + 1)"
            cell.lbName.text = tableViewDriversData[indexPath.row].name
            cell.lbMonthlyDistance.text = tableViewDriversData[indexPath.row].totalKmMonth?.description
            cell.selectionStyle = .none
            if indexPath.row % 2 == 0 {
                cell.contentView.backgroundColor = UIColor(hex: "DBE9F6")
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 33.3/667 * UIScreen.main.bounds.size.height
        default:
            return 24/667 * UIScreen.main.bounds.size.height
        }
    }
}
extension GroupViewController: CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        SVProgressHUD.show()
        if isDetailPressed {
            
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isDetailPressed {
            SVProgressHUD.dismiss()
            //TO-DO: call API get group drivers
            self.view.bringSubview(toFront: viewGroupDriversDetail)
            setNavigationBarItemForBack(title: "So sánh trong nhóm" ,#selector(changeToGeneralScreen(_:)))
            //        setNavigationBarItem(title: "So sách trong nhóm")
            
            //            getGroupDriversInfo()
        } else {
            SVProgressHUD.dismiss()
            //TO-DO: call API get group drivers
            self.view.bringSubview(toFront: viewGroupGeneral)
            setNavigationBarItem(title: "Quản lý nhóm")
        }
    }
}
