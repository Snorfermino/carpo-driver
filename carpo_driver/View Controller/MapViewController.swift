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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MapViewController: AlertPresenting, ChartModePickerDelegate {
    func chartMode(title: String, index: Int) {
        SVProgressHUD.show()

    }
    
    func datePicked(date: Date) {
        print(date.description)
    }
    
    @IBAction func lbDatePressed(_ sender: UIButton){
        showAlert(self.view, delegate: self, isDatePicker: true)
    }
    
}
