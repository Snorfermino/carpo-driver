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
    func loginFailed()
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
                    self.delegate?.loginFailed()
                } else {
                    Global.user = user
                    self.delegate?.loginSuccess()
                }
            } else {
                self.delegate?.loginFailed()
            }
        }
        ApiManager.login(phone: phone, password: password, completion: completion)
    }
}
