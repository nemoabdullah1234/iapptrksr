//
//  STKGeneralApi.swift
//  Stryker
//
//  Created by Nitin Singh on 13/06/16.
//  Copyright © 2016 OSSCube. All rights reserved.
//

import UIKit



let kbase_Url: String = "http://strykerapi.nicbit.ossclients.com/reader/"

enum STKGeneral {
    case STRLoginApi
    case STRCatagoryApi
    
}


class STKGeneralApi: NSObject {
    var generalApi = STKGeneral.self
    
    func initwithValue() {
      
//        switch generalApi {
//        case .STRLoginApi:
//            NSLog("","Climate is Hot")
//        case .STRCatagoryApi:
//            NSLog("Climate is Cold")
//            
//        default:
//            NSLog("Climate is not predictable")
//        }
        
        
        
//        let urlString: String = "http://www.example.com/myreport"
//        let paramURLEncoding = ParameterEncoding.Custom { (request, params) -> (NSMutableURLRequest, NSError?) in
//            
//            let urlEncoding = Alamofire.ParameterEncoding.URLEncodedInURL
//            let (urlRequest, error) = urlEncoding.encode(request, parameters: params)
//            let mutableRequest = urlRequest.mutableCopy() as! NSMutableURLRequest
//            mutableRequest.URL = NSURL(string: urlString)
//            mutableRequest.HTTPBody = urlRequest.URL?.query?.dataUsingEncoding(NSUTF8StringEncoding)
//            return (mutableRequest, error)
//        }
//        
//        Alamofire.request(.POST, urlString, parameters: params, encoding: paramURLEncoding, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
//            if let reportData = response.result.value {
//                debugPrint(response.request?.URL?.absoluteString.stringByRemovingPercentEncoding)
//            } else {
//                print("Error: \(response.result.error)")
//            }
//        }
        
        
        
    }
    
    
    
    
    
//    func StrykerLogin() {
//        let todosEndpoint: String = kbase_Url as String
//        let newTodo = ["action": "writerSignIn", "email": "", "password": 1, "clientDomain" : ""]
//        Alamofire.request(.POST, todosEndpoint, parameters: newTodo, encoding: .JSON)
//            .responseJSON { response in
//                guard response.result.error == nil else {
//                    // got an error in getting the data, need to handle it
//                    print("error calling POST on /todos/1")
//                    print(response.result.error!)
//                    return
//                }
//                
//                if let value = response.result.value {
//                  //  let todo = JSON(value)
//                    print("The todo is: " + value.description)
//                }
//        }
//
//    }
    
    
}
