//
//  MyAPI.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//
//
//  MyServerAPI.swift
//  WongYiuNam-User
//
//  Created by Admin on 9/18/17.
//  Copyright © 2017 RTH. All rights reserved.
//

import Moya

enum MyAPI {
    case login(phone: String,password: String)
    case refreshToken(token: String)
    case register(phone: String,password: String)
    case changePassword(oldPwd: String, newPwd: String)
    case createNewPassword(phone: String, newPassword: String, otp: Int)
    case changeAvatar(avatar: UIImage)
    case trackLocation(param: User, location: CGLocation)
    case support(message: String, image: UIImage)
    case getInfo(id:String)
    case imageProof( image: UIImage)
    case getOTP(phone:String)
    case checkOTP(otp: String)
    case group(id:String)
    case getHistory(id: String, date:String)
    case getCarInfoBy(userID: String)
    
    //Info for Screen UIs
    case getInfoForHomeScreen(userID: String)
    case getInfoForManageGroupScreen(leaderID: String)
    case getInfoForGroupMemberDetailScreen(leaderID: String)
    case getInfoMemberByUserID(userID: String)
}

extension MyAPI: TargetType {
    
    var headers: [String : String]? {
        var h = [String:String]()
        guard let accessToken = Global.user?.data.token else {
            return h
        }
        
        switch self {
        case .login:
            break
        default:
            h["Authorization"] = accessToken
        }
        return h
    }
    
    var baseURL: URL {
        switch self {
        case .login:
            return APIConfiguration.qAPIURL
        default:
            return APIConfiguration.myServerAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .refreshToken:
            return "refresh-Token"
        case .group:
            return "get-group-member-by-leader-id"
        case .getInfo:
            return "get-info-user-by-user-id"
        case .getHistory:
            return "get-group-member-history-by-date"
        case .getCarInfoBy:
            return "getInfoCarByUserId"
        case .getOTP:
            return "get-otp-by-phone"
        case .checkOTP:
            return "check-otp-by-authorization-code"
        case .changePassword:
            return "change-password-user"
        case .createNewPassword:
            return "created-new-password-user"
        case .trackLocation:
            return "insert-tracking"
        case .support:
            return "insert-report"
        case .changeAvatar:
            return "change-avata-user"
        case .getInfoForHomeScreen:
            return "get-info-home-driver"
        case .getInfoForManageGroupScreen:
            return "get-info-screen-manager-group"
        case .getInfoForGroupMemberDetailScreen:
            return "get-info-group-member-in-month"
        case .getInfoMemberByUserID:
            return "get-info-member-by-user-id"
        case .imageProof:
            return "upload-photo-car-status"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,.changePassword, .trackLocation, .support, .changeAvatar,.refreshToken, .createNewPassword, .imageProof:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(let phone, let pwd):
            return ["username":phone,"password":pwd,"app_type":0]
        case .refreshToken(let token):
            return ["AuthorizationRefresh":token]
        case .group(let leaderID):
            return ["leader_id":leaderID]
        case .getInfo(let userID):
            return ["user_id":userID]
        case .getHistory(let id, let date):
            return ["date":date,"user_id":id]
        case .getCarInfoBy(let userID):
            return ["user_id": userID]
        case .getOTP(let phone):
            return ["phone":phone]
        case .changePassword(let oldPwd, let newPwd):
            return ["user_id":Global.user?.data.id! ?? "",
                    "old_password":oldPwd,
                    "new_password":newPwd]
        case .createNewPassword(let phone, let newPwd, let otp):
            return ["phone":phone,"newPassword":newPwd,"otp":otp]
        case .trackLocation(let param, let location):
            return ["car_id":param.data.carId!,
                    "campaign_id":param.data.campaignId!,
                    "location_lat":location.latitude,
                    "location_long":location.longitude,
                    "type":0]
        case .getInfoForHomeScreen(let userID):
            return ["user_id": userID]
        case .getInfoForManageGroupScreen(let leaderID):
            return ["leader_id":leaderID]
        case .getInfoForGroupMemberDetailScreen(let leaderID):
            return ["leader_id":leaderID]
        case .getInfoMemberByUserID(let userID):
            return ["user_id": userID]
        case .checkOTP(let otp):
            return ["authorizationCode":otp]
        default:
            return nil
        }
    }
    var task: Task {
        let encoding = URLEncoding.methodDependent
        switch self {
        case .support(let message, let image):
            guard let data = UIImageJPEGRepresentation(image ,0.5) else {
                return .requestPlain
            }
            let str64 = data.base64EncodedString()
            return .requestParameters(parameters: ["user_id": Global.user?.data.id ?? "","image":str64,"message":message], encoding: encoding)
        case .changeAvatar(let avatar):
            guard let data = UIImageJPEGRepresentation(avatar ,0.5) else {
                return .requestPlain
            }
            let str64 = data.base64EncodedString()
            return .requestParameters(parameters: ["user_id": Global.user?.data.id ?? "","image":str64], encoding: encoding)
        case .imageProof(let image):

            guard let data = UIImageJPEGRepresentation(image ,0.2) else {
                return Task.requestPlain
            }
            var multipartdata:[MultipartFormData] = []
            multipartdata.append(MultipartFormData(provider: .data(data), name: "file", fileName: "avatar.jpg", mimeType: "image/jpg"))
            return .uploadCompositeMultipart(multipartdata, urlParameters: ["user_id":  Global.user?.data.id ?? ""])
        default:
            return .requestParameters(parameters: self.parameters!, encoding: encoding)
        }
    }
}






