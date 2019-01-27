//
//  ForgotPasswordView.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

protocol ForgotPasswordViewDelegate {
    func backPressed()
    func confirmPressed(phoneNumber: String)
    func missingParameter(_ title:String)
    func newPwdConfirmPressed(newPWd: String, otp: Int)
}
class ForgotPasswordView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewPdPrompt: UIView!
    @IBOutlet weak var viewPhoneNumberPrompt: UIView!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmNewPassword: UITextField!
    @IBOutlet weak var tfVerificationCode: UITextField!
    var delegate: ForgotPasswordViewDelegate?
    var isPhoneNumberExist: Bool = true
    var isPromtingPhoneNumber: Bool = true
    var otp:Int = 0
    var phoneNumber:String = ""
    @IBAction func backPressed(_ sender: Any){
        delegate?.backPressed()
    }
    @IBAction func confirmPressed(_ sender: UIButton){
        
//        if sender.tag == 0 {
//            if tfPhoneNumber.text != nil || tfPhoneNumber.text != "" {
//                moveToNewPassword()
//            } else {
//                self.delegate?.missingParameter("Không tìm thấy số điện thoại")
//            }
//        } else {
//            delegate?.confirmPressed()
//        }
        
        if isPromtingPhoneNumber {
            if tfPhoneNumber.text != nil && tfPhoneNumber.text != "" &&  9...11 ~= (tfPhoneNumber.text?.count)! {
                delegate?.confirmPressed(phoneNumber: tfPhoneNumber.text!)
                phoneNumber = tfPhoneNumber.text!
                moveToNewPassword()
            } else {
                
                self.delegate?.missingParameter("Số điện thoại không hợp lệ")
            }
        } else {
            if !(tfNewPassword.text?.isEmpty)! &&  tfNewPassword.text! == tfConfirmNewPassword.text! && Int(tfVerificationCode.text!)! == otp {
                delegate?.newPwdConfirmPressed(newPWd: tfNewPassword.text!, otp: otp)
                
            } else {
                self.delegate?.missingParameter("Nhập lại mật khẩu mới")
            }
            
        }
    }
    @IBAction func resendVeriCodePressed(_ sender: Any){
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ForgotPasswordView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = UIColor.clear
        contentView.bringSubview(toFront: viewPhoneNumberPrompt)
        viewPhoneNumberPrompt.backgroundColor = UIColor.clear
        viewPdPrompt.backgroundColor = UIColor.clear
        viewPdPrompt.alpha = 0
    }
    
    func moveToNewPassword() {
//        
//        let completion = {(otp: OTP?, error: String?) -> Void in
//            if let OTP = otp {
//                if ((OTP.rangeOfCharacter(from: CharacterSet.alphanumerics)) != nil) {
//                    print("OTP: \(otp)")
//                    self.viewPhoneNumberPrompt.leftToRightAnimation(duration: 0.5, completionDelegate: self)
//                }
//            } else {
//                self.delegate?.missingParameter("Không tìm thấy số điện thoại")
//            }
//        }
//        ApiManager.getOTP(tfPhoneNumber.text! , completion: completion)
        isPromtingPhoneNumber = false
        viewPhoneNumberPrompt.leftToRightAnimation(duration: 0.5, completionDelegate: self)
    }
    
    func backToPasswordPrompt(){
        
    }
    
    func displayPhoneNumberPrompt(){
        self.contentView.bringSubview(toFront: viewPhoneNumberPrompt)
        viewPhoneNumberPrompt.alpha = 1
        
    }
    
    func displayNewPasswordPrompt(){
        
        self.contentView.bringSubview(toFront: viewPdPrompt)
        viewPdPrompt.alpha = 1
        
    }
}

extension UIView {
    func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: CAAnimationDelegate? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        leftToRightTransition.delegate = completionDelegate
        
        leftToRightTransition.type = kCATransitionPush
        leftToRightTransition.subtype = kCATransitionFromRight
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
    
    func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: CAAnimationDelegate? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        leftToRightTransition.delegate = completionDelegate
        
        leftToRightTransition.type = kCATransitionPush
        leftToRightTransition.subtype = kCATransitionFromLeft
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "rightToLeftTransition")
    }
}
extension ForgotPasswordView: CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        if isPhoneNumberExist {
            viewPhoneNumberPrompt.alpha = 0
        }
        
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isPhoneNumberExist {
            displayNewPasswordPrompt()
        }
    }
}
