//
//  APIManager.swift
//  SocketModule

import UIKit
import Alamofire

//MARK: - APIManager
let apiManager:APIManager = APIManager()

class APIManager: NSObject {
    //TODO: - get Api
    func callGetApi(url:String, perameter:[String:Any], header: [String: String]? , dataResponse:@escaping (DataResponse<Any>?, _ error:Error?)->()){
        if !isConnectedToNetwork() {
            let error = NSError(domain: "", code: 505, userInfo: [NSLocalizedDescriptionKey : "connection lost"])
            dataResponse(nil,error)
            return
        }
        let headerss = ["": " " ]
                Alamofire.request(url, method: .get, parameters: perameter, headers: headerss).responseJSON { (response) in
            dataResponse(response,nil)
        }
    }
    //TODO: - Post Api
    func callPostApi(url:String, perameter:[String:Any]? , header: [String: String]? , dataResponse:@escaping (DataResponse<Any>?, _ error:Error?)->()){
        if !isConnectedToNetwork() {
            let error = NSError(domain: "", code: 505, userInfo: [NSLocalizedDescriptionKey : "connection lost"])
            dataResponse(nil,error)
            return
        }
       let he1 = ["": " " ]
        Alamofire.request(url, method: .post, parameters: perameter, headers: he1).responseJSON { (response) in
            dataResponse(response,nil)
        }
    }
    
}
func getTimeStamp(date : Date) -> Double {
    return date.timeIntervalSince1970
}
