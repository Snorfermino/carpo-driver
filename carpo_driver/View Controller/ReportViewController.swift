//
//  ReportViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 1/5/19.
//  Copyright © 2019 Tien Dat. All rights reserved.
//

import UIKit
import SnapKit
class ReportViewController: BaseViewController {
    var reportView: ReportView!
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: Global.currentScreenTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportView = ReportView()
        self.view.addSubview(reportView)
        reportView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
