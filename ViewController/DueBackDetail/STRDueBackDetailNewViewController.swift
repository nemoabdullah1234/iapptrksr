import UIKit

class STRDueBackDetailNewViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    @IBOutlet var vwSave: UIView!
    
    @IBOutlet var height: NSLayoutConstraint!
    @IBOutlet var lblNameUser: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tblCaseDetail: UITableView!
    var dataPath: String?

    @IBOutlet var lblSave: UILabel!
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var lblPhone: UILabel!
    
    @IBOutlet var lblPhoneNumber: UILabel!
    
//    @IBOutlet var lblReport: UILabel!
//    @IBOutlet var imgReport: UIImageView!
//    @IBAction func btnReport(sender: AnyObject) {
//    }
//    @IBOutlet var lblMap: UILabel!
//    @IBOutlet var imgMap: UIImageView!
//    @IBAction func btnMap(sender: UIButton) {
//        if(sender.tag == 0)
//        {
//            sender.tag = 1
//            lblMap.text = "List"
//            imgMap.image = UIImage(imageLiteral: "list")
//            changeView("1")
//        }
//        else
//        {
//            sender.tag = 0
//            lblMap.text = "Map"
//            imgMap.image = UIImage(imageLiteral: "map")
//             changeView("2")
//        }
//        
//    }
    @IBAction func btnSave(sender: AnyObject) {
        //self.saveItemStatusDraft()
        if(self.reviewerDetails != nil)
        {
            self.addValidatePopup()
        }
        
    }
    func canRotate() -> Void {}
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    
    // @IBOutlet var lblTitle: UILabel!
    // @IBOutlet var lblLocation: MarqueeLabel!
     var beacon : CLBeaconRegion!
    @IBOutlet var vwScan: STRScanViewNew!
    
     var caseNo:String?
    var index:NSInteger!
    var headerDict:Dictionary<String,AnyObject>?
    var caseDetails:Dictionary<String,AnyObject>?
    var items:[Dictionary<String,AnyObject>]?
    var reviewerDetails:Dictionary<String,String>?
    var locationManager: CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "STRDueBackDetailTableViewCell", bundle: nil)
        tblCaseDetail.registerNib(nib, forCellReuseIdentifier: "STRDueBackDetailTableViewCell")
        customizeNavigationforAll(self)
        self.title = "\(self.caseNo!)"
        tblCaseDetail.rowHeight = UITableViewAutomaticDimension
        tblCaseDetail.estimatedRowHeight = 60
        
        self.createDirectory()
        //setUpData()
        dataFeeding()
        setUpFont()
        viewScanCall()
    }
    func viewScanCall(){
        self.vwScan.scanBlock = {(tag) in
            
            if(tag == 1)
            {
                self.locationManager!.stopRangingBeaconsInRegion(self.beacon)
                self.markeRemainingUndetected()
            }
            else{
                self.locationManager = CLLocationManager()
                let uuid:NSUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!//"B9407F30-F5F8-466E-AFF9-25556B57FE6D"//B9407F30-F5F8-466E-AFF9-25556B57FE6D
                self.beacon = CLBeaconRegion(proximityUUID: uuid, identifier:"")
               self.locationManager!.requestAlwaysAuthorization()
                self.beacon.notifyOnEntry=true
               self.beacon.notifyOnExit=true
               self.beacon.notifyEntryStateOnDisplay=true
                CLLocationManager.locationServicesEnabled()
                self.locationManager!.startMonitoringForRegion(self.beacon)
                self.locationManager!.startRangingBeaconsInRegion(self.beacon)
               self.locationManager!.delegate = self
            }

            
        }
    }
    func backToDashbaord(sender: AnyObject){
      self.navigationController?.popViewControllerAnimated(true)
    }
    func setUpFont(){
        self.vwSave.layer.cornerRadius = 5.0
        // lblReport.font = UIFont(name: "SourceSansPro-Regular", size: 13.0);
        // lblMap.font = UIFont(name: "SourceSansPro-Regular", size: 13.0);
        //  lblTitle.font = UIFont(name: "SourceSansPro-Semibold", size: 13.0);
        //  lblLocation.font = UIFont(name: "SourceSansPro-Regular", size: 13.0);
        lblName.font = UIFont(name: "SourceSansPro-Regular", size: 15.0);
        lblNameUser.font = UIFont(name: "SourceSansPro-Regular", size: 15.0);
        lblSave.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        lblPhone.font = UIFont(name: "SourceSansPro-Regular", size: 15.0);
        lblPhoneNumber.font = UIFont(name: "SourceSansPro-Regular", size: 15.0);
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        if (self.isMovingFromParentViewController()) {
            UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
        }
    }
    func sortButtonClicked(sender : AnyObject){
        
        //tableView.tableHeaderView = searchController.searchBar
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    
    func createDirectory() {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths.first
        dataPath = documentsDirectory?.stringByAppendingString("/ISSUE")
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath!))
        {
            try! NSFileManager.defaultManager().createDirectoryAtPath(dataPath!, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    func deleteDirectory(){
        try! NSFileManager.defaultManager().removeItemAtPath(dataPath!)
    }
    
    func changeView(dict:String){
       if(dict == "1")
       {
        self.view .bringSubviewToFront(self.webView)
        self.webView.hidden = false
        self.view.sendSubviewToBack(self.tblCaseDetail)
       }
       else
       {
        self.view .bringSubviewToFront(self.tblCaseDetail)
        self.webView.hidden = true
        self.view.sendSubviewToBack(self.webView)
       }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (self.items == nil)
       {
        return 0
       }
      return items!.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: STRDueBackDetailTableViewCell = self.tblCaseDetail.dequeueReusableCellWithIdentifier("STRDueBackDetailTableViewCell") as! STRDueBackDetailTableViewCell
        cell.setUpData(items![indexPath.row],IndexPath:indexPath.row)
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        cell.blockDueBackCell = {(index,on) in
            if(on)
            {
                self.items![index].updateValue("2", forKey: "l5")
            }
            else{
                self.items![index].updateValue("1", forKey: "l5")
            }
        }
        
        cell.blockCommentBtn = {(index) in
            let shipmentSpecific = self.items![index]
            let strReportIssue = STRReportIssueNewViewController.init(nibName: "STRReportIssueNewViewController", bundle: nil)
            strReportIssue.caseNo =  self.caseNo
            strReportIssue.reportType = .STRReportDueback
            strReportIssue.shippingNo = shipmentSpecific["skuId"] as? String
            self.navigationController?.pushViewController(strReportIssue, animated: true)
        }
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data  = self.items![indexPath.row]
        let vw = STRSurgeryItemDetailViewController(nibName: "STRSurgeryItemDetailViewController", bundle: nil)
        vw.skuId =  "\(data["skuId"]!)"
        vw.caseNo = self.caseNo
        vw.flagToShowEdit = false
        self.navigationController?.pushViewController(vw, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 190
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(self.caseDetails != nil)
        {
        let vw = STRHeaderViewDueBackDetail.headerViewForDict(self.caseDetails!)
        vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 161)
        return vw
        }
        return UIView()
    }
    func setUpData(){
        let firstname = self.reviewerDetails!["reviewerFirstName"]
        let lastname = self.reviewerDetails!["reviewerLastName"]
        let  reviewerMobile = self.reviewerDetails!["reviewerMobile"]
        let reviewerCountryCode = self.reviewerDetails!["reviewerCountryCode"]
        if(firstname != "" || lastname != "")
        {
            self.lblName.text = "Name:"
            self.lblNameUser.text = firstname! + " " + lastname!
            self.lblPhone.text = "Phone:"
            self.lblPhoneNumber.text =  reviewerCountryCode! + reviewerMobile!
        }
        else{
            self.height.constant = 0
        }
        /*set up items*/
            for index in 0..<self.items!.count{
                var sensor = self.items![index]["sensor"] as? Dictionary<String,AnyObject>
                if((sensor!["type"] as? String)!.uppercaseString == "BEACON")
                {
                    var dict = self.items![index]
                    dict["status"] = STRInventoryStatus.STRInventoryStatusInitial.rawValue
                    self.items![index] = dict
                    print(dict["status"])
                }
                else{
                    var dict = self.items![index]
                    dict["status"] = STRInventoryStatus.STRInventoryStatusNotBeacon.rawValue
                    self.items![index] = dict
                    print(dict["status"])
                    
                }
            }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        let path = NSBundle.mainBundle().pathForResource("index", ofType:"html" , inDirectory: "HTML")
        let html = try! String(contentsOfFile: path!, encoding:NSUTF8StringEncoding)
        
        self.webView.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
        self.webView.delegate = nil
    }
    //MARK: API
    
    func dataFeeding() -> () {
        let api = GeneralAPI()
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        api.hitApiwith(["caseNo":self.caseNo!], serviceType: .STRApiCaseHistoryDetail, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }//caseDetails
                // shipments
                guard let data = response["data"] as? [String:AnyObject],let readerGetCaseHistoryDetailsResponse = data["readerGetCaseHistoryDetailsResponse"] as? [String:AnyObject], let caseDetails = readerGetCaseHistoryDetailsResponse ["caseDetails"] as? [String:AnyObject],let items =  readerGetCaseHistoryDetailsResponse["items"] as? [Dictionary<String,AnyObject>],let reviewerDetails = readerGetCaseHistoryDetailsResponse["reviewerDetails"] as? Dictionary<String,String> else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.caseDetails = caseDetails
                self.items = items
                self.reviewerDetails = reviewerDetails
                self.setUpData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.tblCaseDetail.reloadData()
            }
        }) { (error) in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    func saveItemStatusDraft(){
        var item = [Dictionary<String,AnyObject>]()
        for dict in self.items! {
            
            item.append(["skuId":dict["skuId"]!,"usedStatus":dict["l5"]!])
        }
        
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["caseNo":self.caseNo!,"items":item], serviceType: .STRApiItemStatusUpdate, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],let _ = data["ReaderSetItemUsedStatusResponse"] as? [String:AnyObject]  else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
        }
        
    }
     func addValidatePopup(){
        let popUp = STRSurgeryPopUp.sectionView(self.reviewerDetails!)
      
        popUp.caseNo = self.caseNo
        popUp.tag = 10002
        popUp.navController = self.navigationController
        popUp.dataPath = self.dataPath
        self.view.addSubview(popUp)
        
        popUp.codeBlock = {(dict) in
            let firstname = dict["reviewerFirstName"]
            let lastname = dict["reviewerLastName"]
            let  reviewerMobile = dict["reviewerMobile"]
            let reviewerCountryCode = dict["reviewerCountryCode"]
            if(firstname != "" || lastname != "")
            {
                self.lblName.text = "Name:"
                self.lblNameUser.text = firstname! + " " + lastname!
                self.lblPhone.text = "Phone:"
                self.lblPhoneNumber.text =  reviewerCountryCode! + reviewerMobile!
                                                              
            }
            else{
                self.height.constant = 0
            }

        
        }
        
        popUp.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-64)-[popUp]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["popUp" : popUp]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[popUp]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["popUp" : popUp]))

    }
    
    /*scaning methods*/
    func resetState(){
        self.vwScan.resetState()
        if(self.locationManager != nil)
        {
            self.locationManager!.stopRangingBeaconsInRegion(self.beacon)
        }
        
    }

    func updateStatus(beacons:[CLBeacon]?)
    {
        for (_,data) in beacons!.enumerate(){
            for (idx, dic) in self.items!.enumerate() {
                let sensor = dic["sensor"]!
                if ((sensor["major"] as? NSInteger) == data.major && (sensor["minor"] as? NSInteger) == data.minor && dic["status"] as! NSInteger != STRInventoryStatus.STRInventoryStatusFound.rawValue) {
                    self.items![idx]["status"] = STRInventoryStatus.STRInventoryStatusFound.rawValue
                    let data = self.items![idx]
                    self.items!.removeAtIndex(idx)
                    self.items!.insert(data, atIndex: idx)
                }
            }
        }
        self.tblCaseDetail.reloadData()
    }
    func markeRemainingUndetected(){
        for (idx, dic) in self.items!.enumerate() {
            let status = dic["status"]!
            if ((status as! NSInteger) == STRInventoryStatus.STRInventoryStatusInitial.rawValue ) {
                self.items![idx]["status"] = STRInventoryStatus.STRInventoryStatusNotFound.rawValue
            }
        }
        self.tblCaseDetail.reloadData()
    }
    //MARK: location manager methods for beacon scanning
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(!CLLocationManager.locationServicesEnabled())
        {
            
        }
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways )
        {
            
        }
    }
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        if (state ==  CLRegionState.Inside)
        {
            
        }
        else
        {
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if(region .isKindOfClass(CLCircularRegion))
        {
            
        }
        else if(region.isKindOfClass(CLBeaconRegion))
        {
            
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if(region .isKindOfClass(CLCircularRegion))
        {
            
        }
        else if(region.isKindOfClass(CLBeaconRegion))
        {
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if( (floor(NSDate().timeIntervalSince1970) % 10) == 0)
        {
            updateStatus(beacons)
        }
    }



}
