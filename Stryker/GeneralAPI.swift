// the class has been prepared using almofire sourcecode so if you are using framework then use  Almofire.request instead of request

import UIKit


enum STRApiType: Int{
    case STRApiLogin = 0
    case STRApiSession
    case STRApiCase
    case STRApiRequestForgetPassword
    case STRApiValidateForgetPassword
    case STRApiResetForgetPassword
    case STRApiGetUSerProfile
    case STRApiWatchCase
    case STRApiGetCaseDetail
    case STRApiGetSettingDetails
    case STRApiUpdateSettingDetails
    case STRApiGETComments
    case STRPostComment
    case STRApiSearchCase
    case STRApiSignOut
    case STRApiCaseHistory
    case STRApiGetItemDetail
    case STRApiGetCountries
    case STRApiUpdateProfile
    case STRApiGetItem
    case STRApiSearchItems
    case STRApiCaseHistoryDetail
    case STRApiItemStatusUpdate
    case STRApiNotificationApi
    case STRApiGlobalSearch
    case STRApiCompletedCase
    case STRAPiGetCaseItemComment
    case STRAPiPostCaseItemComment
    case STRApiDeleteUserProfile
    case STRApiGetUserCommentsForIssue
    case STRApiGetCaseItemComments
    case STRApiGetLocationData
    case STRApiGetInventory
    case STRApiUpdateItemInventory
    case STRApiGetCaseItemDetails
    case STRApiUpdateCaseItemInventory
    case STRValidateSurgeryReport
    case STRDeviceInformation
    case STRUpdatScanInformation
    case STRDeleteNotification
    case STRUpdateTimeZone
}
class GeneralAPI: NSObject {
    var successCallBack: ((Dictionary<String,AnyObject>)->())?
    var errorCallBack: ((NSError)->())?
    //save param and service type to hit silently
    var prevData: Dictionary<String,AnyObject>?
    var prevrequest:STRApiType?
    func hitApiwith(parameters: Dictionary<String,AnyObject> ,serviceType:STRApiType,success:((Dictionary<String,AnyObject>)->()),failure:((NSError)->())){
        successCallBack = success
        errorCallBack = failure
        prevData=parameters
        prevrequest=serviceType
        switch serviceType {
        case .STRApiLogin:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/signIn")
            hitPOSTApiNSURLLogin(parameters, path: aStr)
            break
            
        case .STRApiSession:
          self.prevData=nil
          let aStr = String(format: "%@%@", Kbase_url, "/reader/generateSession")
           hitPOSTApiNSURLSession(parameters, path: aStr)
          break
            
        case .STRApiCase:
            let getStr = String(format: "sortBy=%@&sortOrder=%@", utility.getselectedSortBy() != nil ?  utility.getselectedSortBy()! : "Doctor",utility.getselectedSortOrder() != nil ? utility.getselectedSortOrder()! : "asc")
            let aStr = String(format: "%@%@?%@", Kbase_url, "/reader/getCases", getStr)
            hitGETApiNSURL(parameters, path: aStr)
            break
        case .STRApiRequestForgetPassword:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/requestForgotPassword")
            hitPOSTApiNSURLLogin(parameters, path: aStr)
            break
        case .STRApiValidateForgetPassword:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/validateForgotToken")
            hitPOSTApiNSURLLogin(parameters, path: aStr)

            break
        case .STRApiResetForgetPassword:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/resetPassword")
            hitPOSTApiNSURLLogin(parameters, path: aStr)
            break
            
        case .STRApiGetUSerProfile:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/getProfile")
            hitGETApiNSURL(parameters, path: aStr)
            break

            
        case .STRApiWatchCase:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateCaseFlag")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
            

        case .STRApiGetCaseDetail:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getCaseDetails")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"] as? String)
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
        case .STRApiGetSettingDetails:
        let aStr = String(format: "%@%@", Kbase_url, "/reader/getSettings")
        hitGETApiNSURL(parameters, path: aStr)
            
            break
            
        case .STRApiUpdateSettingDetails:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateSettings")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
            
        case .STRApiGETComments:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getIssueComments")!
            let str  = parameters["ShipmentNumber"]! as? String
            urlComponents.queryItems = [
                NSURLQueryItem(name: "issueId", value:parameters["issueId"]! as? String),
                NSURLQueryItem(name: "shippingNo", value:str!.stringByRemovingPercentEncoding),
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String)
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
            
        case .STRPostComment:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/reportShippingIssue")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break;
        case .STRApiSearchCase:
            let tempDict: String = parameters["Search"] as! String
            let aStr = String(format: "%@%@%@", Kbase_url, "/reader/searchCases?query=",tempDict )
            hitGETApiNSURL(parameters, path: aStr)
            
            break

        case .STRApiSignOut:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/signOut" )
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            
            break
        case .STRApiCaseHistory:
           
            let getStr = String(format: "sortBy=%@&sortOrder=%@", utility.getselectedSortBy() != nil ?  utility.getselectedSortBy()! : "Doctor",utility.getselectedSortOrder() != nil ? utility.getselectedSortOrder()! : "asc")
            let aStr = String(format: "%@%@?%@", Kbase_url, "/reader/getCasesHistory", getStr)
            hitGETApiNSURL(parameters, path: aStr)
            

        case .STRApiGetItemDetail:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getItemDetails")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String),
                NSURLQueryItem(name: "skuId", value:parameters["skuId"]! as? String)
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
        case .STRApiGetCountries:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/getCountries")
            hitGETApiNSURL(parameters, path: aStr)
            
            break
        case .STRApiUpdateProfile:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateProfile" )
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            
            break
            
        case .STRApiGetItem:
            let tempDict: String = parameters["Search"] as! String
            let aStr = String(format: "%@%@%@", Kbase_url, "/reader/getItems?query=",tempDict )
            hitGETApiNSURL(parameters, path: aStr)
            
            break
        case .STRApiSearchItems:
            let tempDict: String = parameters["Search"] as! String
            let aStr = String(format: "%@%@%@", Kbase_url, "/reader/searchItems?itemId=",tempDict )
            hitGETApiNSURL(parameters, path: aStr)
            
            break
          
            
        case .STRApiCaseHistoryDetail:
            
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getCaseHistoryDetails")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String),
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
            
        case .STRApiItemStatusUpdate:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/setItemUsedStatus" )
            hitPOSTApiWithAlaomfire(parameters, path: aStr)

            break
        case .STRApiNotificationApi:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/getNotifications")
            hitGETApiNSURL(parameters, path: aStr)
            break
            
            
        case .STRApiGlobalSearch:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/searchCases")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "query", value:parameters["query"]! as? String),
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
        case .STRApiCompletedCase:
            
             let aStr = String(format: "%@%@", Kbase_url, "/reader/getCompletedCases")
            hitGETApiNSURL(parameters, path: aStr)
            break
        
        case .STRAPiGetCaseItemComment:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getCaseItemComments")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String),
                NSURLQueryItem(name: "skuId", value:parameters["skuId"]! as? String)
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            
            break
        case .STRAPiPostCaseItemComment:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/postCaseItemComment")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
            
        case .STRApiDeleteUserProfile:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateProfile")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        case .STRApiGetUserCommentsForIssue:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getIssueComments")!
            let str  = parameters["shippingNo"]! as? String

            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String),
                NSURLQueryItem(name: "shippingNo", value:str!.stringByRemovingPercentEncoding),
                NSURLQueryItem(name: "issueId", value:parameters["issueId"]! as? String)
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
            
        case .STRApiGetCaseItemComments:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getCaseItemComments")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String),
                NSURLQueryItem(name: "skuId", value:parameters["skuId"]! as? String),
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
            
        case .STRApiGetLocationData:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/searchNearLocations")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "latitude", value:parameters["latitude"]! as? String),
                NSURLQueryItem(name: "longitude", value:parameters["longitude"]! as? String),
                NSURLQueryItem(name: "locationId", value:parameters["locationId"]! as? String)
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
            
        case .STRApiGetInventory:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getItemInventory")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "skuId", value:parameters["skuId"]! as? String),
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break
        case .STRApiUpdateItemInventory:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateItemInventory")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break;
         
        case .STRApiGetCaseItemDetails:
            let urlComponents = NSURLComponents(string: Kbase_url+"/reader/getCaseItemQuantity")!
            urlComponents.queryItems = [
                NSURLQueryItem(name: "caseNo", value:parameters["caseNo"]! as? String),
                NSURLQueryItem(name: "skuId", value:parameters["skuId"]! as? String),
            ]
            hitGETApiNSURL(parameters, path: (urlComponents.URL?.absoluteString)!)
            break;
        case .STRApiUpdateCaseItemInventory:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateCaseItemQuantity")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        case .STRValidateSurgeryReport:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/submitSurgeryReport")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        case .STRDeviceInformation:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/saveDeviceInformation")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        case .STRUpdatScanInformation:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateInventoryScanData")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        case .STRDeleteNotification:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/removeNotifications")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        case .STRUpdateTimeZone:
            let aStr = String(format: "%@%@", Kbase_url, "/reader/updateProfile")
            hitPOSTApiWithAlaomfire(parameters, path: aStr)
            break
        }
    }
    
    
    // Use for Case Api And all
    private func hitPOSTApiWithAlaomfire(params: Dictionary<String,AnyObject>,path:String)->Void{
        let request = NSMutableURLRequest(URL: NSURL(string:path)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(utility.getDevice(), forHTTPHeaderField:"deviceId")
        request.setValue("traquer", forHTTPHeaderField:"AppType")
        request.setValue(utility.getUserToken(), forHTTPHeaderField:"sid")
        request.setValue("salesrep", forHTTPHeaderField:"role")

        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: []);
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental
                print("error=\(error)")
                self.errorCallBack!(error!)
                return
            }
            
            let test = response as? NSHTTPURLResponse
            print(test!.statusCode)
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode > 299 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                let err = NSError(domain:"API_Nicbit" , code: 500, userInfo: ["description":"Status code not 200"])
                self.errorCallBack!(err)
                return
            }
            else
            {
            let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves);
                if(dict["code"]!!.integerValue == 209)
                {
                    utility.setUserToken(" ")
                     dispatch_async(dispatch_get_main_queue()) {
                    self.hitPOSTApiNSURLSession(Dictionary<String,String>(), path:String(format: "%@%@", Kbase_url, "/reader/generateSession") )
                    }
                    
                }
                else if (dict["code"]!!.integerValue == 210)
                {
                    utility.setUserToken(" ")
                    dispatch_async(dispatch_get_main_queue()) {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.initSideBarMenu()
                    }
                }
                else{
                    self.prevData = nil
                    self.successCallBack!(dict as! Dictionary<String, AnyObject>)
                }
            }
            
        }
        task.resume()
    }
    
    private func hitGETApiNSURL(params: Dictionary<String,AnyObject>,path:String)->Void{
        let escapedAddress = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let request = NSMutableURLRequest(URL: NSURL(string: escapedAddress!)!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(utility.getDevice(), forHTTPHeaderField:"deviceId")
        request.setValue(utility.getUserToken(), forHTTPHeaderField:"sid")
         request.setValue("traquer", forHTTPHeaderField:"AppType")
        request.setValue("salesrep", forHTTPHeaderField:"role")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            guard error == nil && data != nil else {
                print("error=\(error)")
                self.errorCallBack!(error!)
                return
            }
           let test = response as? NSHTTPURLResponse
             print(test!.statusCode)
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode > 299 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                let err = NSError(domain:"API_Nicbit" , code: 500, userInfo: ["description":"Status code not 200"])
                self.errorCallBack!(err)
                return
            }
            else
            {
            

                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: []);
                print (dict)
                if(dict["code"]!!.integerValue == 209)
                {
                    utility.setUserToken(" ")
                     dispatch_async(dispatch_get_main_queue()) {
                    self.hitPOSTApiNSURLSession(Dictionary<String,String>(), path:String(format: "%@%@", Kbase_url, "/reader/generateSession") )
                    }

                }
                else if (dict["code"]!!.integerValue == 210)
                {
                    utility.setUserToken(" ")
                    dispatch_async(dispatch_get_main_queue()) {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.initSideBarMenu()
                    }
                }
                else{
                     self.prevData = nil
                    self.successCallBack!(dict as! Dictionary<String, AnyObject>)
                }
            }
        }
        task.resume()
    }

    //MARK: session and login methods for post
    private func hitPOSTApiNSURLSession(params: Dictionary<String,AnyObject>,path:String)->Void{
        let request = NSMutableURLRequest(URL: NSURL(string:path)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(utility.getDevice(), forHTTPHeaderField:"deviceId")
        print(utility.getPermToken()!)
        request.setValue(utility.getPermToken()!, forHTTPHeaderField:"sid")
        request.setValue("salesrep", forHTTPHeaderField:"role")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: []);    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                                          print("error=\(error)")
                self.errorCallBack!(error!)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode > 299 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                let err = NSError(domain:"API_Nicbit" , code: 500, userInfo: ["description":"Status code not 200"])
                self.errorCallBack!(err)
                return
            }
            if(self.prevData != nil)
            {
                let dict1 = try! NSJSONSerialization.JSONObjectWithData(data!, options: []);
                guard let dict2 = dict1["data"] as? [String:AnyObject],readerGenerateSessionResponse = dict2["readerGenerateSessionResponse"] as? [String:AnyObject] else{
                    return
                }
                utility.setUserToken((readerGenerateSessionResponse["token"] as? String)!)
                 dispatch_async(dispatch_get_main_queue()) {
                self.hitApiwith(self.prevData!, serviceType: self.prevrequest!, success:self.successCallBack!, failure:self.errorCallBack!)
                }
            }
            else
            {
            let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: []);
            print (dict)
            self.successCallBack!(dict as! Dictionary<String, AnyObject>)
            }
        }
        task.resume()
        
    }
    private func hitPOSTApiNSURLLogin(params: Dictionary<String,AnyObject>,path:String)->Void{
        self.prevData=nil
        let request = NSMutableURLRequest(URL: NSURL(string:path)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(utility.getDevice(), forHTTPHeaderField:"deviceId")
        request.setValue("salesrep", forHTTPHeaderField:"role")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: []);
        
        print(request.allHTTPHeaderFields)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            print(response)
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                self.errorCallBack!(error!)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode > 299 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                let err = NSError(domain:"API_Nicbit" , code: 500, userInfo: ["description":"Status code not 200"])
                self.errorCallBack!(err)
                      return
            }
            print("response = \(response)")
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: []);
                print (dict)
                self.successCallBack!(dict as! Dictionary<String, AnyObject>)
        }
        task.resume()
        
    }
    
    
}

