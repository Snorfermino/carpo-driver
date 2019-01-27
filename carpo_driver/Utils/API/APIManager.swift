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
class CarpoMoyaProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    public init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
//    override func request(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping ((BaseModel?, String?) -> Void)) -> Cancellable {
//        return super.request(target, completion: { (result) in
//            switch result {
//            case .success(let response):
//                print(response)
//                if(response.statusCode == 200) {
//                    do {
//                        let userResponse = try response.mapObject(BaseModel.self)
//                        if ((userResponse.error) != nil) {
//
//                        }
//                        completion(userResponse, nil)
//                    } catch {
//                        completion(nil, nil)
//                    }
//                } else {
//                    completion(nil, "Error")
//                }
//            case .failure(let error):
//                print(error)
//                completion(nil, error.errorDescription)
//            }
//        })
//    }
    
}

//let requestClosure = { (endpoint: Endpoint<MyAPI>, done: (URLRequest) -> Void) in
//    // This is the request Moya generates
//    do {
//        let request = try endpoint.urlRequest()
//
//        done(.success(request))
//    } catch {
//        done(.failure(MoyaError.underlying(error)))
//    }
//
//}

let closure = {(endpoint: Endpoint<MyAPI>, closure: MoyaProvider<MyAPI>.RequestClosure) -> Void in
    let request = try! endpoint.urlRequest()
}
let provider = MoyaProvider<MyAPI>(plugins: [NetworkLoggerPlugin(verbose: true),MyPlugin()])



class ApiManager {
    
    
    
    static func login(phone: String, password: String, completion: @escaping ((User?, String?) -> Void)) {
        provider.request(.login(phone: phone, password: password)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let userResponse = try response.mapObject(User.self)
                        completion(userResponse, nil)
                    } catch {
                        completion(nil, self.parseError(response: response))
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func getOTP(_ phone: String, completion: @escaping ((OTP?,String?) -> Void)) {
        provider.request(.getOTP(phone: phone)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let otp = try response.mapObject(OTP.self)
                        completion(otp, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func createNewPassword(_ phone: String, _ newPassword: String, _ otp: Int, completion: @escaping ((Int?,String?) -> Void)) {
        provider.request(.createNewPassword(phone: phone, newPassword: newPassword, otp: otp)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(BaseModel.self)
                        completion(result.status, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func changePassword(oldPwd: String, newPwd: String, completion: @escaping ((Int?, String?) -> Void)) {
        provider.request(.changePassword(oldPwd: oldPwd, newPwd: newPwd)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(BaseModel.self)
                        completion(result.status, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    
    static func getGroup(_ leaderID: String, completion: @escaping ((GroupResult?, String?) -> Void)) {
        provider.request(.group(id: leaderID)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(GroupResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func getInfoHomeScreen(_ userID: String, completion: @escaping ((GetInfoForHomeScreenResult?, String?) -> Void)){
        provider.request(.getInfoForHomeScreen(userID: userID)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(GetInfoForHomeScreenResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func submitReport(_ message: String, image: UIImage, completion: @escaping ((BaseModel?, String?) -> Void)){
        provider.request(.support(message: message, image: image)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(BaseModel.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func getInfoForManageGroupScreen(_ leaderID: String, completion: @escaping ((GetInfoForHomeScreenResult?, String?) -> Void)){
        provider.request(.getInfoForManageGroupScreen(leaderID: leaderID)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(GetInfoForHomeScreenResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func getInfoForGroupMemberDetailScreen(_ leaderID: String, completion: @escaping ((GetInfoForGroupMemberDetailScreenResult?, String?) -> Void)){
        provider.request(.getInfoForGroupMemberDetailScreen(leaderID: leaderID)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(GetInfoForGroupMemberDetailScreenResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func getInfoMemberByUserID(_ userID: String, completion: @escaping ((User?, String?) -> Void)){
        provider.request(.getInfoMemberByUserID(userID: userID)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(User.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func getUserInfo(_ userID: String, completion: @escaping ((String?,String?) -> Void)) {
        provider.request(.getInfo(id: userID)) { (result) in
            switch result {
                
            case .success(let response):
                print(response)
                completion(response.description, nil)
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
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    
    static func getHistory(_ userID: String, _ date: String, completion: @escaping ((HistoryResult?,String?) -> Void)) {
        provider.request(.getHistory(id: userID, date: date)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(HistoryResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    
    static func checkFBCode(_ authorCode: String, completion: @escaping ((BaseModel?,String?) -> Void)) {
        provider.request(.checkOTP(otp: authorCode)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(BaseModel.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
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
    
    static func uploadLocation(_ user: User, _ location: CGLocation) {
        provider.request(.trackLocation(param: user, location: location)) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func changeAvatar(_ avatar: UIImage, completion: @escaping ((ChangeAvatarResult?, String?) -> Void)) {
        provider.request(.changeAvatar(avatar: avatar)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        
                        let result = try response.mapObject(ChangeAvatarResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }
    }
    static func uploadProof(_ avatar: UIImage, completion: @escaping ((ChangeAvatarResult?, String?) -> Void)) {
        provider.request(.imageProof(image: avatar)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        
                        let result = try response.mapObject(ChangeAvatarResult.self)
                        completion(result, nil)
                    } catch {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, self.parseError(response: response))
                }
            case .failure(let error):
                print(error)
                completion(nil, error.errorDescription)
            }
        }    }
    
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

