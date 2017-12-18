//
//  SignInViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import SVProgressHUD
class SignInViewController: BaseViewController {
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnFBLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewSignIn: UIView!
    
    var viewForgotPassword: ForgotPasswordView!
    var viewModel:SignInViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignInViewModel(self)
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setupView(){
        if DataManager.isLogged() {
          slideMenuController()?.changeMainViewController(UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController"), close: true)
        }
        viewCenter.alpha = 0
        viewSignIn.alpha = 1
        viewSignIn.backgroundColor = UIColor.clear
        tfPhoneNumber.returnKeyType = .next
        tfPhoneNumber.tag = 0
        tfPhoneNumber.delegate = self
        tfPassword.returnKeyType = .done
        tfPassword.tag = 1
        tfPassword.delegate = self
    }
    @IBAction func signInPressed(_ sender: Any) {
        if tfPhoneNumber.hasText && tfPassword.hasText {
            SVProgressHUD.show()
            viewModel.login(tfPhoneNumber.text!, tfPassword.text!)
        }
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
        btnForgotPassword.isHidden = true
        viewCenter.alpha = 1
    }
    
}
extension SignInViewController: ForgotPasswordViewDelegate {
    func backPressed() {
        viewForgotPassword.viewPhoneNumberPrompt.leftToRightAnimation()
        viewSignIn.alpha = 1
        viewCenter.alpha = 0
        btnForgotPassword.isHidden = false
    }
    
    func confirmPressed() {
        
    }
    
    func missingParameter(_ title: String) {
        alert(title: "Lỗi", message: title)
    }
}
extension SignInViewController: SignInViewModelDelegate, AlertPresenting {
    func loginFailed() {
        SVProgressHUD.dismiss()
        showWrongPwd(self.view)
    }
    func loginSuccess() {
        SVProgressHUD.dismiss()
        print("Success")
    }
}
extension SignInViewController: UITextFieldDelegate {
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
