//
//  Plugins.swift
//  carpo_driver
//
//  Created by Tien Dat on 8/7/18.
//  Copyright © 2018 Tien Dat. All rights reserved.
//

import Foundation
import Result
import Moya
import UIKit

final class MyPlugin: PluginType {

    init() {}
    
    public func willSend(_ request: RequestType, target: TargetType) {
        
    }


    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):

            print("In Plugin")
             print(response)
            do {
                let userResponse = try response.mapObject(BaseModel.self)
                if userResponse.error != nil {
                    if userResponse.error.errorCode == "702" {
                        print("need to do something")
                        let currentVC = UIApplication.topViewController()
                        DataManager.loggedOut()
                        let viewController = UINavigationController(rootViewController: UIStoryboard.main.viewController(SignInViewController.self))
                        currentVC?.slideMenuController()?.changeMainViewController(viewController, close: false)
                        
                    }
                    print("there is error")
                }
            } catch {

            }
            print("In Plugin")
        case .failure(let error):
            print(error)

        }

    }
    

}
