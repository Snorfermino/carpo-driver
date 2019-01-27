//
//  ChangePassword.swift
//  carpo-customer
//
//  Created by Tien Dat on 11/21/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
protocol ChangePasswordDelegate {
    func changePwd(isSuccess:Bool)
    func newPwdNotMatch()
}
extension AlertPresenting {
    func showChangePwd(_ onView: UIView, delegate: ChangePasswordDelegate) {
        let changePwdView = ChangePassword(frame: onView.bounds)
        changePwdView.translatesAutoresizingMaskIntoConstraints = false
        changePwdView.delegate = delegate
        onView.addSubview(changePwdView)
        onView.bringSubview(toFront: changePwdView)
        let views = ["alert": changePwdView,
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
class ChangePassword: UIView {
    @IBOutlet weak var lbCurrentPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var lbNewPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var lbConfirmNewPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var contentView: UIView!
    var delegate: ChangePasswordDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ChangePassword", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.15)
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outterScreenTaped(_:))))
        lbCurrentPwd.delegate = self
        lbNewPwd.delegate = self
        lbConfirmNewPwd.delegate = self
    }
    
    @objc func outterScreenTaped(_ sender: Any){
        self.removeFromSuperview()
    }
    
    @IBAction func confirmPressed(_ sender: Any){
        if lbNewPwd.text == lbConfirmNewPwd.text && lbCurrentPwd.text != lbNewPwd.text{
            let completion = {(status: Int?,error: String?) -> Void in
                if status == 1 {
                    self.removeFromSuperview()
                    self.delegate?.changePwd(isSuccess: true)
                } else {
                    self.delegate?.changePwd(isSuccess: false)
                }
            }
                    ApiManager.changePassword(oldPwd: lbCurrentPwd.text!, newPwd: lbNewPwd.text!, completion: completion)
        } else {
            self.delegate?.newPwdNotMatch()
        }

    }
}
extension ChangePassword: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
