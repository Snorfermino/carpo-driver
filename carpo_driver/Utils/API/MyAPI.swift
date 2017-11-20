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

}

extension MyAPI: TargetType {
    
    var headers: [String : String]? {
        var h = ["X-App-Token": "Ly93b25neWl1bmFtLXBocC5oZXJva3VhcHAuY29tL2FwaS9hdXRoL2xvZ2luIiwiaWF"]
        guard let accessToken = Global.user?.token else {
            return h
        }
        h["X-Access-Token"] = accessToken
        switch self {
        default:
            break
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
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let encoding = URLEncoding.methodDependent
        switch self {
        default:
            return Task.requestPlain
        }
    }
}






