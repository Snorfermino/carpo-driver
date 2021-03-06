//
//  WrongPassword.swift
//  carpo_driver
//
//  Created by Tien Dat on 12/16/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
extension AlertPresenting {
    func showWrongPwd(_ onView: UIView, _ msg: String? = "Không có phản hồi") {
        let wrongPwdView = WrongPassword(frame: onView.bounds, msg: msg!)
        onView.addSubview(wrongPwdView)
        onView.bringSubview(toFront: wrongPwdView)
        let views = ["alert": wrongPwdView,
                     "view": onView]
        var allConstraints = [NSLayoutConstraint]()
        let hFormat = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[alert]-0-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += hFormat
        let vFormat = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[alert]-0-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += vFormat
        NSLayoutConstraint.activate(allConstraints)
    }
}
class WrongPassword: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    var msgText: String!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    init(frame: CGRect, msg: String) {
        super.init(frame: frame)
        msgText = msg
        commonInit()
    }
    func commonInit(){
        Bundle.main.loadNibNamed("WrongPassword", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.15)
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outterScreenTaped(_:))))
        msgLabel.text = msgText
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        msgLabel.text = msgText
    }
    
    @objc @IBAction func outterScreenTaped(_ sender: Any){
        self.removeFromSuperview()
    }
}
