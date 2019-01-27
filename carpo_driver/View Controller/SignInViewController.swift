//
//  SignInViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import SVProgressHUD
import AccountKit
class SignInViewController: BaseViewController {
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnFBLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewSignIn: UIView!
    
    var accountkit:AKFAccountKit?
    var pendingLoginViewController:AKFViewController?
    
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
        print("In Setup View")
        
        SVProgressHUD.dismiss()
        if accountkit == nil {
            accountkit = AKFAccountKit(responseType: .authorizationCode)
        }
        pendingLoginViewController = accountkit!.viewControllerForLoginResume()
        
        if DataManager.isLogged() {
            slideMenuController()?.changeMainViewController(UIStoryboard.main.viewController(HomeViewController.self), close: true)
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
    
    func firstNotRepeatingCharacter(s: String) -> Character {
        var dictionary = [Character:Int]()
        var charArray = Array(s.characters);
        for char in charArray {
            if !(dictionary.keys.contains(char)) {
                dictionary[char] = 1
            } else {
                dictionary[char]! = dictionary[char]! + 1
            }
        }
        let result = dictionary.filter { $0.value == 1 }
        return ((result.isEmpty) ? "_" : (result.first!.key))
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
    
    func APPPTheme() -> AKFTheme {
        let theme = AKFTheme.outlineTheme(withPrimaryColor: UIColor(hexString: "2192D8"),
                                          primaryTextColor: UIColor.white,
                                          secondaryTextColor: UIColor.black,
                                          statusBarStyle: .lightContent)
        return theme
    }
    
    
   
    @IBAction func loginWithFBPressed(_ sender: Any){
        alert(title: "Chức năng đang được cập nhập", message: "")
//        loginWithFacebook()
    }
    private func generateState() -> String {
        let uuid = NSUUID().uuidString
        
        let indexOfDash = uuid.range(of: "-")!.lowerBound
        
        return uuid.substring(to: indexOfDash)
    }
    func loginWithFacebook(){
        let preFillPhoneNumber = AKFPhoneNumber(countryCode: "", phoneNumber: "")

        let vc:AKFViewController = accountkit!.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: generateState()) as AKFViewController
                vc.delegate = self
        vc.enableSendToFacebook = true
        vc.setAdvancedUIManager(nil)
        

        vc.setTheme(APPPTheme())
//                hideButtonBackInView(vc.)
        present(vc as! UIViewController, animated: true)

    }
    
    func hideButtonBackInView(_ view: UIView) {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                if button.title(for: .normal) == "Back" { button.isHidden = true }
                break
            }
            hideButtonBackInView(subview)
        }
    }
}
extension SignInViewController : AKFViewControllerDelegate {
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("did complete login with AuthCode \(code) state \(state)")
        SVProgressHUD.show()
        let completion = {(result: BaseModel?, error: String?) -> Void in
            SVProgressHUD.dismiss()
            if result?.status == 1 {
                self.viewSignIn.alpha = 0
                if self.viewForgotPassword == nil {
                    self.viewForgotPassword = ForgotPasswordView()
                    self.viewForgotPassword.frame = self.viewCenter.bounds
                    self.viewForgotPassword.delegate = self
                    self.viewCenter.addSubview(self.viewForgotPassword)
                    
                }
                self.btnForgotPassword.isHidden = true
                self.viewCenter.alpha = 1
            } else {
                self.alert(title: "Lỗi", message: "Không tìm thấy tài khoản")
            }
        }
        ApiManager.checkFBCode(code, completion: completion)
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        print("canceled")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        print(error)
    }
}

extension SignInViewController: ForgotPasswordViewDelegate {
    func confirmPressed(phoneNumber: String) {
        viewModel.getOTP(phoneNumber)
    }
    
    func newPwdConfirmPressed(newPWd: String, otp: Int) {
        viewModel.createNewPassword(viewForgotPassword.phoneNumber,newPWd,otp)
    }
    
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

    func createNewPwdSuccess() {
        SVProgressHUD.dismiss()
        alert(title: "Xác Nhận", message: "Đổi mật khẩu thành công")
        backPressed()
    }
    
    func createNewPwdFailed() {
        SVProgressHUD.dismiss()
        alert(title: "Lỗi", message: "Không thể đổi mật khẩu")
    }
    
    func getOTPSuccess(otp: Int) {
        SVProgressHUD.dismiss()
        alert(title: "Mã xác nhận", message: otp.description)
        self.viewForgotPassword.otp = otp
    }
    
    func getOTPFailed() {
        SVProgressHUD.dismiss()
        alert(title: "Lỗi", message: "Không tìm thấy mã xác nhận")
    }
    
    func loginFailed(msg: String) {
        SVProgressHUD.dismiss()
        showWrongPwd(self.view, msg)
    }
    func loginSuccess() {
        SVProgressHUD.dismiss()
        print("Success")
        
//        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
//        if DataManager.isLogged() {
//            let viewController = UINavigationController(rootViewController: UIStoryboard.main.viewController(HomeViewController.self))
//            slideMenuController()?.changeMainViewController(viewController, close: true)
//        }
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
