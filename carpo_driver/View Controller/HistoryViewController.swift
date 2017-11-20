//
//  HistoryViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
    @IBOutlet weak var lbTotalTravelDistance: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
extension HistoryViewController: AlertPresenting {
    @IBAction func pickDate(_ sender: UIButton){
        showAlert(self.view, delegate: self, isDatePicker: true)
    }
}
extension HistoryViewController: ChartModePickerDelegate {
    func datePicked(date: Date) {
        
    }
    func chartMode(title: String, index: Int) {
        
    }
}
