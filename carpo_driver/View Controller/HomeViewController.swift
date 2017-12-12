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
class HomeViewController: BaseViewController {
    var lineChartEntry = [ChartDataEntry]()
    @IBOutlet weak var pieChart: RKPieChartView!
    @IBOutlet weak var viewPieChart: AnimatableView!
    @IBOutlet weak var lbBtnChartMode: UILabel!
    @IBOutlet weak var lbChartMode: UILabel!
    @IBOutlet weak var viewSwitch: UIView!
    @IBOutlet weak var imgViewProof:UIImageView!
    @IBOutlet var viewDistanceDisplay: [UIView]!
    let pieChartView = PieChartView()
    var dataforPicker = ["Hôm nay", "Ngày trước","7 ngày gần nhất","30 ngày gần nhất","Tháng trước"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
        if !DataManager.isLogged() {
            slideMenuController()?.changeMainViewController(UIStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController"), close: true)
        }
        SVProgressHUD.dismiss()
        //TO-DO: input chart data
        for i in 0..<10 {
            let value =  ChartDataEntry(x: Double(i), y: Double(i) * 2.5)
            lineChartEntry.append(value)
        }
        
        for view in viewDistanceDisplay {
            let roundedHeight = view.frame.height / 2 * 0.9
            view.layer.cornerRadius = roundedHeight.rounded(.down)
        }
         setupPieChart()
    }
    
    func setupPieChart(){
        viewPieChart.maskType = .circle
        viewPieChart.borderWidth = 15
        viewPieChart.borderType = .solid
        viewPieChart.borderColor = UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        pieChartView.segments = [
            Segment(color: UIColor(red: 90/255.0, green: 174.0/255.0, blue: 224.0/255.0, alpha: 1.0), name: "25%", value: 25),
            Segment(color: UIColor(red: 100.0/255.0, green: 241.0/255.0, blue: 183.0/255.0, alpha: 0.0), name: "", value: 75)
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

