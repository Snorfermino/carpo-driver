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
    func confirmPressed()
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
    @IBAction func backPressed(_ sender: Any){
        delegate?.backPressed()
    }
    @IBAction func confirmPressed(_ sender: Any){
        delegate?.confirmPressed()
        moveToNewPassword()
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
        viewPhoneNumberPrompt.leftToRightAnimation(duration: 0.5, completionDelegate: self)
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
