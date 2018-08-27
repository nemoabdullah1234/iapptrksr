import UIKit
import MessageUI

class STRSettingViewController: UIViewController, SSRadioButtonControllerDelegate ,MFMailComposeViewControllerDelegate,UIPopoverPresentationControllerDelegate,UIDocumentInteractionControllerDelegate{

    var rowArrayExpanded: Array<Int>?
    var sectionArray : NSMutableArray = NSMutableArray()
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var optionMenu : UIAlertController?
    var radioButtonController: SSRadioButtonsController?
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexpath : NSIndexPath?
    var dataArrayObj : NSDictionary?
    
     var switchControlObj : SevenSwitch?
    
    var defaultView : String?
    var defaultSortedby : String?
    var defaultSortedorder : String?
    var notification : String?
    var sound : String?
     var vibration : String?
     var led : String?
     var silentFrom : String?
     var silentTo : String?
     var beaconServiceStatus: String = "Off"
    let tmp4 : NSArray = ["Alerts", "Beacon Services"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TitleName.Settings.rawValue
        customizeNavigationforAll(self)
        let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "settingTableViewCell")
        let nib2 = UINib(nibName: "SettingWithSwitchCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "settingWithSwitchCell")
        tableView.sectionFooterHeight = 0.0;
        dataFeeding()
        
        sectionArray  = [SettingSectionMessage.DashboardDefaultView.rawValue, SettingSectionMessage.DashboardSortedBy.rawValue, SettingSectionMessage.DashboardSortedOrder.rawValue, SettingSectionMessage.Notification.rawValue]
   
        
        let tmp1 : NSArray = [DashboardTitle.All.rawValue , DashboardTitle.Favorites.rawValue , DashboardTitle.alert.rawValue]
        
        var string1 = sectionArray .objectAtIndex(0) as? String
        [sectionContentDict .setValue(tmp1, forKey:string1! )]
        let tmp2 : NSArray = sortDataPopUp
        string1 = sectionArray .objectAtIndex(1) as? String
        [sectionContentDict .setValue(tmp2, forKey:string1! )]
        let tmp3 : NSArray = ["Ascending","Descending"]
        string1 = sectionArray .objectAtIndex(2) as? String
        [sectionContentDict .setValue(tmp3, forKey:string1! )]
        
        string1 = sectionArray .objectAtIndex(3) as? String
        [sectionContentDict .setValue(tmp4, forKey:string1! )]
       
        self.revealViewController().panGestureRecognizer().enabled = false
    }

    
    func dotButtonClicked() {
        
        addpopup()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func backToDashbaord(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }
    func logOut() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiSignOut, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["message"] as? String
                
                if dataDictionary == "Ok" {
                    utility.setUserToken(" ")
                    self.presentLogin()
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
    
    func presentLogin() -> () {
        let login = STRLoginViewController(nibName: "STRLoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: login)
        self.navigationController?.presentViewController(nav, animated: true, completion: {
            
        })
        
    }
    
    func dataFeeding()  {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiGetSettingDetails, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
               
                let dataDictionary = response["data"] as? [String : AnyObject]
                if dataDictionary?.count <= 0 {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return
                }
                let dictResult = dataDictionary as! NSDictionary
                self.dataArrayObj = dictResult["readerGetSettingsResponse"]  as? NSDictionary
                self.setValueInDefaults(self.dataArrayObj!)
                self.tableView .reloadData()
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }

    @IBAction func saveButtonClicked(sender: AnyObject) {
        
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return (self.sectionArray.count)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tps = sectionArray.objectAtIndex(section) as! String
        let count1 = (sectionContentDict.valueForKey(tps)) as! NSArray
        return count1.count
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        selectedIndexpath = indexPath
        if indexPath.section == 0 {
            if indexPath.row == 0
            {
                defaultView = "All"
                
            }
            if indexPath.row == 1
            {
                defaultView = "Watched"
            }
            if indexPath.row == 2
            {
                defaultView = "Exceptions"
            }
            
        }
        
        
        if indexPath.section == 1 {
            if indexPath.row == 0
            {
                defaultSortedby = sortDataFromApi[0]
            }
            if indexPath.row == 1
            {
                defaultSortedby = sortDataFromApi[1]
            }
            if indexPath.row == 2
            {
                defaultSortedby = sortDataFromApi[2]
            }
            if indexPath.row == 3 {
                defaultSortedby = sortDataFromApi[3]
            }
            if indexPath.row == 4 {
                defaultSortedby = sortDataFromApi[4]
            }
            if indexPath.row == 5 {
                defaultSortedby = sortDataFromApi[5]
            }
            
        }
        
        
       
        if indexPath.section == 2 {
            if indexPath.row == 0
            {
                defaultSortedorder = "asc"
            }
            if indexPath.row == 1
            {
                defaultSortedorder = "desc"
            }
        }
        
        
        if indexPath.section == 3 {
            if indexPath.row == 0
            {
               
                let theswitch = self.tableView.viewWithTag(3) as? SevenSwitch
                
                
                if  theswitch!.on{
                    sound = "Off"
                    vibration = "Off"
                    led = "Off"
                }else{
                    sound = "On"
                    vibration = "On"
                    led = "On"
                }
                
                
            }

            if indexPath.row == 1
            {
                
                
                
                let theswitch = self.tableView.viewWithTag(4) as? SevenSwitch
                
                
                if  theswitch!.on{
                    beaconServiceStatus = "Off"
                }else{
                    beaconServiceStatus = "On"
                    
                }
                
                
                
            }
            
        }
        let silentHrFrom : String = "2016-06-10T01:30:00+00:00"
        let silentHrTo : String = "2016-06-10T05:30:00+00:00"
        updateSettingDetailApi(defaultView!, sortedbyObj: defaultSortedby!, sortedOrderObj: defaultSortedorder!, notificationObj: notification!, soundObj: sound!, silentFromObj: silentHrFrom, silentToObj: silentHrTo, vibrationObj: vibration!, ledObj: led!, beaconServiceStatusObj: beaconServiceStatus)
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = NSBundle.mainBundle().loadNibNamed("STRSettingSectionHeader", owner: nil, options: nil)!.last as! STRSettingSectionHeader
        vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 50)
        vw.LblTitle.text = sectionArray.objectAtIndex(section) as? String
        return vw
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 3 {
           let cellSwitch: SettingWithSwitchCell = self.tableView.dequeueReusableCellWithIdentifier("settingWithSwitchCell") as! SettingWithSwitchCell
            let content = sectionContentDict .valueForKey(sectionArray.objectAtIndex(indexPath.section) as! String) as! NSArray
            cellSwitch.labelName!.text = content .objectAtIndex(indexPath.row) as? String
            
            print(indexPath.section + indexPath.row)
            cellSwitch.switchControl?.tag = indexPath.section + indexPath.row
            cellSwitch.switchControl!.setOn(false, animated: true)
            if indexPath.row == 0 && sound == "On"  {
                cellSwitch.switchControl!.setOn(true, animated: true)
            }
            if indexPath.row == 1 && beaconServiceStatus == "On" {
                 cellSwitch.switchControl!.setOn(true, animated: true)
            }
            cellSwitch.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cellSwitch
        }else{
        let cell: SettingTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("settingTableViewCell") as! SettingTableViewCell
           
          
        let content = sectionContentDict .valueForKey(sectionArray.objectAtIndex(indexPath.section) as! String) as! NSArray
        let labelString  = content .objectAtIndex(indexPath.row) as? String
            
            if indexPath.section == 0{
                if dataArrayObj != nil {
                    var apiStringOrder = dataArrayObj!["dashboardDefaultView"] as? String
                    if apiStringOrder == "Watched" {
                        apiStringOrder = "Favorites"
                    }else if apiStringOrder == "Exceptions" { apiStringOrder = "Alerts" }
                    if labelString == apiStringOrder{
                        cell.switchControl?.setImage(UIImage(named: "rbselected"),forState:UIControlState.Normal)
                    }
                    else{
                        cell.switchControl?.setImage(UIImage(named: "rbunselected"),forState:UIControlState.Normal)
                    }
                }
            }
            if indexPath.section == 1{
                if dataArrayObj != nil {
                    var apiStringOrder = dataArrayObj!["dashboardSortBy"] as? String
                    if apiStringOrder == "CaseNo"{
                        apiStringOrder = "Case No"
                    }else if apiStringOrder == "SurgeryType" {   apiStringOrder = "Surgery Type"   }else if apiStringOrder == "SurgeryDate"{
                        apiStringOrder = "Surgery Date"
                    }
                    
                    if labelString == apiStringOrder{
                        cell.switchControl?.setImage(UIImage(named: "rbselected"),forState:UIControlState.Normal)
                    }
                    else{
                        cell.switchControl?.setImage(UIImage(named: "rbunselected"),forState:UIControlState.Normal)
                    }
                }
            }
            
            if indexPath.section == 2{
                if dataArrayObj != nil {
                    var apiStringOrder = dataArrayObj!["dashboardSortOrder"] as? String
                    if apiStringOrder == "desc"{
                        apiStringOrder = "Descending"
                    }else{   apiStringOrder = "Ascending"   }
                    
                    if labelString == apiStringOrder{
                        cell.switchControl?.setImage(UIImage(named: "rbselected"),forState:UIControlState.Normal)
                    }
                    else{
                        cell.switchControl?.setImage(UIImage(named: "rbunselected"),forState:UIControlState.Normal)
                    }
                }
            }
            
          
            
        cell.labelName!.text = labelString
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
       }
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {
        
        
        optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        
        
       
        
        let deleteAction = UIAlertAction(title: "Edit Profile", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
           
            let strNotification = STREditProfileVC.init(nibName: "STREditProfileVC", bundle: nil)
            self.navigationController?.pushViewController(strNotification, animated: true)
            
        })
        let saveAction = UIAlertAction(title: "Sign Out", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
             self.logOut()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu!.addAction(deleteAction)
        optionMenu!.addAction(saveAction)
        optionMenu!.addAction(cancelAction)
        
        optionMenu!.popoverPresentationController?.sourceView = self.view
        optionMenu!.popoverPresentationController?.sourceRect = self.view.bounds
        // this is the center of the screen currently but it can be any point in the view
        
        optionMenu!.modalInPopover = true
        
        let pop = optionMenu!.popoverPresentationController
        pop?.sourceRect=CGRectMake(self.view.frame.size.width, 0, 40, 40)
        pop?.sourceView=self.view
        pop?.delegate = self
        
        self.presentViewController(optionMenu!, animated: true, completion: nil)
    }

   
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    
    func updateSettingDetailApi(defaultViewObj : String, sortedbyObj : String,sortedOrderObj : String, notificationObj : String, soundObj : String, silentFromObj : String, silentToObj : String, vibrationObj : String, ledObj : String, beaconServiceStatusObj : String) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        let someDict:[String:String] = ["dashboardDefaultView":defaultViewObj, "dashboardSortBy":sortedbyObj,"dashboardSortOrder":sortedOrderObj, "notifications":notificationObj,"sound":soundObj,"silentHrsFrom":silentFromObj,"silentHrsTo":silentToObj, "vibration":vibrationObj, "led":ledObj, "beaconServiceStatus" : beaconServiceStatusObj]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiUpdateSettingDetails, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["message"] as? String
                
                if dataDictionary == "Ok" {
                }
                self.dataFeeding()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }

    
    
    func setValueInDefaults(infoDictionary : NSDictionary) {
        self.defaultView = self.dataArrayObj!["dashboardDefaultView"] as? String
        if self.defaultView == "All" {
            utility.setselectedIndexDashBoard("0")
        }else if self.defaultView == "Watched" {
            utility.setselectedIndexDashBoard("1")
        }else if self.defaultView == "Exceptions" {
            utility.setselectedIndexDashBoard("2")
        }
        
        
        self.defaultSortedby = self.dataArrayObj!["dashboardSortBy"] as? String
        
        utility.setselectedSortBy(self.defaultSortedby!)
        
        self.defaultSortedorder = self.dataArrayObj!["dashboardSortOrder"] as? String
        utility.setselectedSortOrder(self.defaultSortedorder!)
        
        self.notification = self.dataArrayObj!["notifications"] as? String
        self.silentFrom = self.dataArrayObj!["silentHrsFrom"] as? String
        self.silentTo = self.dataArrayObj!["silentHrsTo"] as? String
        self.sound = self.dataArrayObj!["sound"] as? String
        utility.setNotificationAlert(self.sound!)
        self.vibration = self.dataArrayObj!["vibration"] as? String
        utility.setNotificationVibration(self.vibration!)
        self.led = self.dataArrayObj!["led"] as? String
        utility.setNotificationBadge(self.led!)
        self.beaconServiceStatus = (self.dataArrayObj!["beaconServiceStatus"] as? String)!
        utility.setBeaconServices(self.beaconServiceStatus)
    }
    
    func addpopup(){
        let popup =  NSBundle.mainBundle().loadNibNamed("STRPopupSort", owner: self, options: nil)! .first as! STRPopupSort
        popup.tag=10003
        popup.frame=(self.navigationController?.view.frame)!;
        popup.layoutIfNeeded()
        
        self.navigationController?.view.addSubview(popup)
        
        popup.layoutSubviews()
        
        popup.closure = {(sortString)in
            
            print(sortString)
            if sortString == "Sign Out" {
               self.logOut()
            }else{
               
                let strNotification = STREditProfileVC.init(nibName: "STREditProfileVC", bundle: nil)
                let leftSideNav = UINavigationController(rootViewController: strNotification)
                self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            }
            
           self.navigationController?.view.viewWithTag(10003)?.removeFromSuperview()
            
        }
        popup.setUpPopup(2)
        
    }
    
   
    func sendMail()->(){
         let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/"+role+"_log.csv")
       
        
        let fileData = NSURL(fileURLWithPath: documentsPath)
        
        let objectsToShare = [fileData]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
        // DONE
    }
    //    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        let mailData = STRLogFileGenerator()
//        mailData.createCSV()
//        let emailController = MFMailComposeViewController()
//        emailController.mailComposeDelegate = self
//        emailController.setSubject("CSV File")
//        emailController.setMessageBody("", isHTML: false)
//        
//        // Attaching the .CSV file to the email.
//        emailController.addAttachmentData(mailData.csv(), mimeType: "text/csv", fileName: "Sample.csv")
//        return emailController
    //   }

    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }

}
