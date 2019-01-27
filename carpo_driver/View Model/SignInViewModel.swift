//
//  SignInViewModel.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/24/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation

protocol SignInViewModelDelegate{
    func loginSuccess()
    func loginFailed(msg: String)
    func getOTPSuccess(otp:Int)
    func getOTPFailed()
    func createNewPwdSuccess()
    func createNewPwdFailed()
}
class SignInViewModel {
    
    var delegate: SignInViewModelDelegate?

    init(_ delegate: SignInViewModelDelegate) {
        self.delegate = delegate
    }
    
    func login(_ phone: String, _ password: String){
        let completion = {(user: User?, error: String?) -> Void in
            if let user = user {
                if user.status == 0 {
                    self.delegate?.loginFailed(msg: (user.error.message ?? "Phát hiện lỗi")!)
                } else {
                    Global.user = user
                    self.delegate?.loginSuccess()
                }
            } else {
                self.delegate?.loginFailed(msg: "Không có kết quả")
            }
        }
        ApiManager.login(phone: phone, password: password, completion: completion)
    }
    
    func getOTP(_ phone: String){
        let completion = {(otp: OTP?, error: String?) -> Void in
            
            if let otp = otp {
                if otp.status == 0 {
                    self.delegate?.getOTPFailed()
                } else {
                    self.delegate?.getOTPSuccess(otp: otp.data!)
                }
            } else {
                self.delegate?.getOTPFailed()
            }
        }
        ApiManager.getOTP(phone, completion: completion)
    }
    func createNewPassword(_ phone: String, _ newPassword: String, _ otp: Int){
        let completion = {(status: Int?, error: String?) -> Void in
            if status == 0 {
                
                self.delegate?.createNewPwdFailed()
            } else {
                self.delegate?.createNewPwdSuccess()
            }
        }
        ApiManager.createNewPassword(phone, newPassword, otp, completion: completion)
    }
}
