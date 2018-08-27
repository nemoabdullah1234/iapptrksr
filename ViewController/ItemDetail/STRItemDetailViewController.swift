import UIKit

class STRItemDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataFeeding(){
        let web = GeneralAPI()
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        web.hitApiwith(["caseNo":"","skuId":""], serviceType: .STRApiGetItemDetail, success: { (response) in
            print(response)
            dispatch_async(dispatch_get_main_queue()) {
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue, view:self)
                    return
                }
                
                guard let data = response["data"] as? [String:AnyObject],readerGetIssueCommentsResponse = data["readerGetIssueCommentsResponse"] as? [String:AnyObject],caseDetails = readerGetIssueCommentsResponse["caseDetails"] as? [String:AnyObject],comments = readerGetIssueCommentsResponse["comments"] as? [[String:AnyObject]]  else{
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue , view:self)
                    return
                }
                print(data)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }) { (err) in
            
            dispatch_async(dispatch_get_main_queue()) {
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue , view:self)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
            
        }
        
    }
   
}
