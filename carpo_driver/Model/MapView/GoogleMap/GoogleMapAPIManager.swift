//
//  GoogleMapAPIManager.swift
//  carpo_driver
//
//  Created by Tien Dat on 12/14/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
let googleMapProvider = MoyaProvider<GoogleMapAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
class GoogleMapAPIManager {
    
    
    
    static func getRoute(from: CGLocation, to: CGLocation, completion: @escaping ((GetDirectionResult?, String?) -> Void)) {
        googleMapProvider.request(.GetDirection(from: from, to: to)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(GetDirectionResult.self)
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
    
    static func getWaypoints(locations: [CGLocation], completion: @escaping ((GetDirectionResult?, String?) -> Void)) {
        googleMapProvider.request(.GetWaypoint(locations: locations)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if(response.statusCode == 200) {
                    do {
                        let result = try response.mapObject(GetDirectionResult.self)
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
