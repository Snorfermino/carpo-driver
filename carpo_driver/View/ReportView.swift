//
//  ReportView.swift
//  carpo_driver
//
//  Created by Tien Dat on 1/5/19.
//  Copyright © 2019 Tien Dat. All rights reserved.
//

import UIKit
import SnapKit
class ReportView: UIView {
    // Container View
    var viewContainer: UIView!
    // Report Image View
    var imgViewOdor: UIImageView!
    var imgViewLeft: UIImageView!
    var imgViewRight: UIImageView!
    
    // Submit Button
    var btnSubmit: UIButton!
    
    var imgViewHeight: CGFloat!
    var btnHeight: CGFloat!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupContainerView()
        setupImageView()
    }
    
    func setupContainerView(){
//        viewContainer = UIView()
//        self.addSubview(viewContainer)
//        viewContainer.snp.makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
        imgViewHeight = (window?.screen.nativeBounds.width)! * 65 / 375
    }
    
    func setupImageView(){
        imgViewOdor = UIImageView()
        self.addSubview(imgViewOdor)
        
        imgViewOdor.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(65)
            make.centerX.equalTo(self)
            make.height.equalTo(imgViewHeight)
            make.width.equalTo(imgViewHeight)
        }
        
        imgViewLeft = UIImageView()
        self.addSubview(imgViewLeft)
        
        imgViewLeft.snp.makeConstraints { (make) in
            make.top.equalTo(imgViewOdor.snp.bottom).offset(100)
            make.left.equalTo(self).offset(30)
            make.height.equalTo(imgViewHeight)
            make.width.equalTo(imgViewHeight)
            
        }
        
        imgViewRight = UIImageView()
        self.addSubview(imgViewRight)
        
        imgViewRight.snp.makeConstraints { (make) in
            make.top.equalTo(imgViewLeft.snp.top)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(imgViewHeight)
            make.width.equalTo(imgViewHeight)
            
        }
    }
}
