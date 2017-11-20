//
//  APIManager.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import FacebookCore

let provider = MoyaProvider<MyAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])

class ApiManager {
    

    
    static func login(email: String, password: String, completion: @escaping ((User?, String?) -> Void)) {
//        provider.request(.login(email: email, password: password)) { (result) in
//            switch result {
//            case .success(let response):
//                print(response)
//                if(response.statusCode == 200) {
//                    do {
//                        let userResponse = try response.mapObject(User.self)
//                        completion(userResponse, nil)
//                    } catch {
//                        completion(nil, nil)
//                    }
//                } else {
//                    completion(nil, self.parseError(response: response))
//                }
//            case .failure(let error):
//                print(error)
//                completion(nil, error.errorDescription)
//            }
//        }
    }
    

    static func logout() {
//        provider.request(.logout) { (result) in
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

    static func register(user: User, completion: @escaping ((User?, String?) -> Void)) {
//        provider.request(.register(user: user)) { (result) in
//            switch result {
//            case .success(let response):
//                print(response)
//                if(response.statusCode == 200) {
//                    do {
//                        let userResponse = try response.mapObject(User.self)
//                        completion(userResponse, nil)
//                    } catch {
//                        //
//                    }
//                } else {
//                    completion(nil, self.parseError(response: response))
//                }
//                completion(nil, nil)
//            case .failure(let error):
//                print(error)
//                completion(nil, error.errorDescription)
//            }
//        }
    }
    
    static func changePassword(oldPassword: String, newPassword: String, completion: @escaping ((String, String?) -> Void)) {

    }
    
    static func parseError(response: Response) -> String? {
        do {
            let errorResponse = try response.mapObject(ErrorResponse.self)
            if let message = errorResponse.message {
                return message
            } else {
                return errorResponse.invalidFields
            }
        } catch {
            return "Failure."
        }
    }
}

