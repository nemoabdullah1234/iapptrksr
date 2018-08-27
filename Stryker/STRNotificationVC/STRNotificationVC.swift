import UIKit

class STRNotificationVC: UIViewController, STRCaseDetailDelegate {
    @IBOutlet var tableView: UITableView!
    var dataArrayObj = [AnyObject]()
    var isFirstLoad: Bool?
    
    var isDeleteAll: Int = 0
    var caseDetailObj : STRSliderBaseViewController?
    var deleteArrayObj = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.title = TitleName.Notifications.rawValue
        customizeNavigationWithDeleteAll(self)
        // Do any additional setup after loading the view.
        self.revealViewController().panGestureRecognizer().enabled = false
        isFirstLoad = false
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "notificationCell")
         tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 140
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self ,action: #selector(HomeViewController.refresh(_:)), forControlEvents:UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
               getData()
    }
    func refresh(refreshControl:UIRefreshControl){
        refreshControl.endRefreshing()
        self.getData()
    }
    override func viewWillAppear(animated: Bool) {
        isDeleteAll = 0
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    
    func deleteButtonClicked(sender : AnyObject){
        
      isDeleteAll = 1
        deleteNotification([], deleteValue: isDeleteAll)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }

    func backToDashbaord(sender: AnyObject) {
       let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }
    
    // Data Feeding
    func getData() {
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiNotificationApi, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],readerGetNotificationsResponse = data["readerGetNotificationsResponse"] as? [Dictionary< String,AnyObject>] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.isFirstLoad = true
                self.dataArrayObj = readerGetNotificationsResponse
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.tableView.reloadData()
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFirstLoad == false {
            return 0
        }
        
        if self.dataArrayObj.count == 0 {
            addNodata()
            return 0
        }
        for view in self.view.subviews{
            if view.tag == 10002 {
                view.removeFromSuperview()
            }
        }

        return self.dataArrayObj.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
                let cell: NotificationCell = self.tableView.dequeueReusableCellWithIdentifier("notificationCell") as! NotificationCell
        
        let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
         cell.setUpData(infoDictionary!)
         cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.dataArrayObj.count == 0 {
            
            
        }else {
            
            let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
            
            
            let notificationType = infoDictionary!["notificationType"]?.integerValue
            
            if notificationType == 1  || notificationType == 2 || notificationType == 3 || notificationType == 10 || notificationType == 13 || notificationType == 15 || notificationType == 16 || notificationType == 14{
                let caseNumberObj1  = infoDictionary!["params"]!["caseId"] as! String
                caseDetailObj = STRSliderBaseViewController.init(nibName: "STRSliderBaseViewController", bundle: nil)
                caseDetailObj!.caseNo = caseNumberObj1
                caseDetailObj!.readonly = false
                self.navigationController!.pushViewController(caseDetailObj!, animated: true)
                
            }else if notificationType == 6  || notificationType == 4 || notificationType == 5 || notificationType == 7{
                
                let strReportIssue = STRReportIssueNewViewController.init(nibName: "STRReportIssueNewViewController", bundle: nil)
                strReportIssue.caseNo =  String(infoDictionary!["params"]!["caseId"]! as! String);
                strReportIssue.issueID = String(infoDictionary!["params"]!["issueId"]!  as! String);
                strReportIssue.reportType = .STRReportCase
                strReportIssue.shippingNo = String(infoDictionary!["params"]!["shippingNo"]!  as! String);
                self.navigationController?.pushViewController(strReportIssue, animated: true)
                
            }else if infoDictionary!["notificationType"]?.integerValue == 8   {
                    let url = NSURL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.sharedApplication().openURL(url!)
            }
        }
    }
    
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
        }
    
        internal func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
            {
    
   
                let watch = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
    
                    let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
                    print("watch button tapped \(infoDictionary)")
                    infoDictionary!["notificationType"]?.integerValue
                self.deleteNotificationParameter((infoDictionary!["notificationId"])! as! String)
                    
                }
                watch.backgroundColor = UIColor.redColor()
    
    
    
                return [watch]
            }
    
            func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
                // the cells you would like the actions to appear needs to be editable
                
                if self.dataArrayObj.count == 0 {
                    return false
                }
                return true
            }
    func checkWhenComesFromCaseDetais(controller:STRCaseDetailVC,isController:Bool)
    {
        
        print(isController)
    }
    
    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        self.view.addSubview(noData)
        noData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
        
    }
    
    func deleteNotificationParameter(notificationID : String ) {
        var ar = [Dictionary<String,AnyObject>]()
        ar.append(["notificationId":notificationID])
        deleteNotification(ar, deleteValue: 0)
    }
    
    
    
    // Data Feeding
    func deleteNotification(param : NSArray, deleteValue : Int) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith(["notifications":param, "deleteAll" : deleteValue], serviceType: .STRDeleteNotification, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response)
                
                let dataDictionary = response["status"] as! Int
               
                if dataDictionary == 1{
                   self.getData()
                }
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.addNodata()
                NSLog(" %@", err)
            }
        }
    }

}
