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
    case register(phone: String,password: String)
    case changePassword(oldPwd: String, newPwd: String)
    case changeAvatar(avatar: UIImage)
    case trackLocation(param: User)
    case support(message: String, image: UIImage)
    case getInfo(id:String)
    case getOTP(phone:String)
    case group(id:String)
    case getHistory(date:String)
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
            
        default:
            return APIConfiguration.myServerAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
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
        case .changePassword:
            return "change-password-user"
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
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,.changePassword, .trackLocation, .support, .changeAvatar:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(let phone, let pwd):
            return ["username":phone,"password":pwd]
        case .group(let leaderID):
            return ["leader_id":leaderID]
        case .getInfo(let userID):
            return ["user_id":userID]
        case .getHistory(let date):
            return ["date":date,"user_id":Global.user?.data.id! ?? ""]
        case .getCarInfoBy(let userID):
            return ["user_id": userID]
        case .getOTP(let phone):
            return ["phone":phone]
        case .changePassword(let oldPwd, let newPwd):
            return ["user_id":Global.user?.data.id! ?? "",
                    "old_password":oldPwd,
                    "new_password":newPwd]
        case .trackLocation(let param):
            return param.toJSON()
        case .getInfoForHomeScreen(let userID):
            return ["user_id": userID]
        case .getInfoForManageGroupScreen(let leaderID):
            return ["leader_id":leaderID]
        case .getInfoForGroupMemberDetailScreen(let leaderID):
            return ["leader_id":leaderID]
        case .getInfoMemberByUserID(let userID):
            return ["user_id": userID]
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
        default:
            return .requestParameters(parameters: self.parameters!, encoding: encoding)
        }
    }
}






