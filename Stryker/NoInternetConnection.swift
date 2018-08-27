import UIKit
import NBLOG
class NoInternetConnection: NSObject {
    
    func checkReachablity() {
        AFNetworkReachabilityManager.sharedManager()
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock({(status) in
            
            if status == .NotReachable {
                print("No Internet Connection")
                self.showAlertAction("No Internet Connection")
                NBApplicationState.sharedHandler.setRole = role
                NBApplicationState.sharedHandler.setWIFIAvailable("0")
                
            }
            else{
                
                print("Internet Connection")
                NBApplicationState.sharedHandler.setRole = role
                NBApplicationState.sharedHandler.setWIFIAvailable("1")

            }
        })
    }
    
    func showAlertAction(alertMessage : String) {
        let alertController: UIAlertController = UIAlertController()
        
        alertController.message = alertMessage
        
        
        alertController.title = ApplicationName.appName.rawValue
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(cancelAction)
        
        let topController = topMostController()
        alertController.popoverPresentationController?.sourceView = topController.view
        
        topController.presentViewController(alertController, animated:true, completion:nil)
        
        
    }
    func topMostController()->UIViewController
    {
        var topController = UIApplication.sharedApplication().keyWindow!.rootViewController;
        
        while (topController!.presentedViewController != nil)
        {
            topController = topController!.presentedViewController;
        }
        
        return topController!;
    }
    
}


