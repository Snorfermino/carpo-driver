//
//  MenuCell.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    
    open class func height() -> CGFloat {
        return 60
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open func setData(string: String?) {
        if let string = string {
            lbTitle.text = string
        }
//        if let image = image {
//            dataImage.image = image
//        }
//        switch corner {
//        case .top:
//            containerView.roundCorners([.topLeft, .topRight], radius: 5)
//        case .bottom:
//            //containerView.roundCorners([.bottomLeft, .bottomRight], radius: 5)
//            break
//        case .full:
//            containerView.layer.cornerRadius = 5
//        default:
//            break
//        }
//        if parent == false {
//            menuParentImageView.isHidden = true
//        }
        layoutIfNeeded()
//        lineView.isHidden = true
//        dataImage.image = dataImage.image!.withRenderingMode(.alwaysTemplate)
//        dataImage.tintColor = UIColor.init(red: 235, green: 52, blue: 55)
    }
}
