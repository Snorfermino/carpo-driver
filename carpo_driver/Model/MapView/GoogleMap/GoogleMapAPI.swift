//
//  GoogleMapAPI.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper
import GoogleMaps
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
//import Alamofire

enum GoogleMapAPI {

    case GetDirection

    
}

extension GoogleMapAPI: TargetType {
    
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
            return APIConfiguration.googleMapURL
        }
    }
    
    var path: String {
        switch self {
        case .GetDirection:
            return "maps/api/directions/json"
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
        let encoding = URLEncoding.default
        var param = [String: String]()
        
        param["key"]            = Config.shareInstance.googleMapAPIKey
        param["language"]       = "us"
        param["query"]          = "some where over the rainbow"
        switch self {
        default:
            return Task.requestParameters(parameters: param, encoding: encoding)
        }
    }
}




//
//
//
//class GoogleMapAPI: BaseAPI {
//
//    let host = "https://maps.googleapis.com/"
//    var type = APIType.None
//    var viewCallApi: UIView? = nil
//
//    enum APIType: String {
//        case None               = ""
//        case GetDirection       = "maps/api/directions/json"
//        case SuggestLocation    = "maps/api/place/autocomplete/json"
//
//        case GetLocation        = "maps/api/geocode/json"
//
//
//        case getCoordinateFromSuggestLocation = "maps/api/place/textsearch/json"
//
//
//    }
//
//    func getApiURL(type: APIType) -> String {
//        return "\(host)\(type.rawValue)"
//    }
//
//
//    func getCoordinateFromSuggestLocation(location: String, language: String = "vi", completeBlock: @escaping CompletionBlock) -> APITask {
//        type = APIType.getCoordinateFromSuggestLocation
//        let url = getApiURL(type: type)
//
//        var param = [String: String]()
//
//        param["key"]            = Config.shareInstance.googleMapAPIKey
//        param["language"]       = language
//        param["query"]          = location
//
//        print(param)
//        do {
//            try Alamofire.request(url.asURL(), method: HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in
//
//                if let JSON = response.result.value {
//                    let objectData = CGGetCoordinateFromSuggestLocation()
//                    _ = Mapper<CGGetCoordinateFromSuggestLocation>().map(JSONObject: JSON, toObject: objectData)
//                    self.task.result = objectData
//                    _ = completeBlock(self.task)
//                }
//
//            })
//        } catch {
//            fatalError("Wrong url")
//        }
//        return task
//
//    }
//
//
//    func getLocation(location: CGLocation, language: String = "vi", completeBlock: @escaping CompletionBlock) -> APITask {
//        type = APIType.GetLocation
//        let url = getApiURL(type: type)
//
//        var param = [String: String]()
//
//        param["key"]            = Config.shareInstance.googleMapAPIKey
//        param["latlng"]       = "\(location.latitude),\(location.longitude)"
//
//
//        do {
//            try Alamofire.request(url.asURL(), method: HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in
//
//
//                if let JSON = response.result.value as? [String : Any]{
//                    var objectData = CGGetLocationResult()
//                    objectData.mapping(map: Map(mappingType: .fromJSON, JSON: JSON))
//                    self.task.result = objectData
//                    _ = completeBlock(self.task)
//                }
//
//            })
//        } catch {
//            fatalError("Wrong url")
//        }
//        return task
//
//    }
//
//
//
//    func getSuggestLocation(location: String, language: String = "vi", completeBlock: @escaping CompletionBlock) -> APITask {
//        type = APIType.SuggestLocation
//        let url = getApiURL(type: type)
//
//        var param = [String: String]()
//        param["types"]          = "geocode"
//        param["key"]            = Config.shareInstance.googleMapAPIKey
//        param["language"]       = language
//        param["input"]          = location
//        param["components"]     = "country:VN"
//        print("===\(param)")
//        do {
//            try Alamofire.request(url.asURL(), method: HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in
//
//                //                print(response.request)  // original URL request
//                //                print(response.response) // HTTP URL response
//                //                print(response.data)     // server data
//                //                print(response.result)   // result of response serialization
//                //
//                if let JSON = response.result.value {
//                    let objectData = SuggestLocationResult()
//                    _ = Mapper<SuggestLocationResult>().map(JSONObject: JSON, toObject: objectData)
//                    self.task.result = objectData
//                    _ = completeBlock(self.task)
//                }
//            })
//        } catch {
//            fatalError("Wrong url")
//        }
//        return task
//    }
//
//    func getRoute(originAddress: CGLocation, destinationAddress: CGLocation, completeBlock: @escaping CompletionBlock) -> APITask {
//
//        type = APIType.GetDirection
//        let url = getApiURL(type: type)
//
//        var param = [String: String]()
//        param["key"]            = Config.shareInstance.googleMapAPIKey
//        param["origin"]         = "\(originAddress.latitude),\(originAddress.longitude)"
//        param["destination"]    = "\(destinationAddress.latitude),\(destinationAddress.longitude)"
//
//        print(param)
//
//        do {
//            try Alamofire.request(url.asURL(), method: HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in
//
//                if let JSON = response.result.value {
//                    let objectData = GetDirectionResult()
//
//                    _ = Mapper<GetDirectionResult>().map(JSONObject: JSON, toObject: objectData)
//
//                    self.task.result = objectData
//                    _ = completeBlock(self.task)
//                }
//            })
//        } catch {
//            fatalError("Wrong url")
//        }
//        return task
//    }
//
//
//
//}

extension CLLocationCoordinate2D {
    func gmsString() -> String {
        return "\(self.latitude), \(self.longitude)"
    }
}

