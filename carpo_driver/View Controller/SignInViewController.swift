//
//  SignInViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnFBLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewSignIn: UIView!
    var viewForgotPassword: ForgotPasswordView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupView(){
        viewCenter.alpha = 0
        viewSignIn.alpha = 1
        viewSignIn.backgroundColor = UIColor.clear
    }
    @IBAction func signInPressed(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any){
        phoneNumberPromptDisplay()
        
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
    }
    func phoneNumberPromptDisplay(){
        viewSignIn.alpha = 0
        if viewForgotPassword == nil {
            viewForgotPassword = ForgotPasswordView()
            viewForgotPassword.frame = viewCenter.bounds
            viewForgotPassword.delegate = self
            viewCenter.addSubview(viewForgotPassword)
            
        }
        viewCenter.alpha = 1
    }
    
}
extension SignInViewController: ForgotPasswordViewDelegate {
    func backPressed() {
        viewForgotPassword.viewPhoneNumberPrompt.leftToRightAnimation()
        viewSignIn.alpha = 1
        viewCenter.alpha = 0
    }
    
    func confirmPressed() {
        
    }
}
