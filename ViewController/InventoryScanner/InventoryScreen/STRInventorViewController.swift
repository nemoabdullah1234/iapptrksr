import UIKit
import CoreLocation
enum STRFromScreen: Int{
    case STRFromSearchScreen = 0
    case STRFromItemDetail
    case STRFromSearchLocation
    case STRFromFirstLoad
}
import AKProximity
class STRInventorViewController: UIViewController,UITabBarDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate {
    var appearInformation: STRFromScreen! = .STRFromFirstLoad
    var locationManager : CLLocationManager!
    var currentID :NSInteger?
    @IBOutlet var btnScan: UIButton!
    @IBOutlet var lblMissing: UILabel!
    @IBOutlet var lblFound: UILabel!
    @IBOutlet var lblAll: UILabel!

    var beacon : CLBeaconRegion!
    var startTime: String?
    var endTime: String?
    @IBAction func btnSearchLocation(sender: AnyObject) {
             appearInformation = .STRFromSearchLocation
        utility.setflagSession(false)
        resetState()
        let vw  = STRChangeLocationViewController(nibName: "STRChangeLocationViewController", bundle: nil)
        let arrnr = self.location["near"] as? [Dictionary<String,AnyObject>]
        let arrOtr = self.location["other"] as? [Dictionary<String,AnyObject>]
        if(arrOtr == nil && arrnr == nil)
        {
            return
        }
        vw.arrNear = arrnr
        vw.arrayOther = arrOtr
        vw.idCurrent = currentID
        let nav = UINavigationController(rootViewController: vw)
        self.presentViewController(nav, animated: true, completion: {
            
        })
    }
    @IBOutlet var vwScan: STRScanViewNew!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var tblInventory: UITableView!
    var location = [String:AnyObject]()
    var zone_obj = [[String:AnyObject]]()
    var flagScanDisabled: Bool = false
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewScanCall()
        self.title = TitleName.LocationInventory.rawValue
        
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
        
        
        switch appType {
        case .salesRep:
            customizeNavigationforAll(self)
            print("It's for Sales Rep")
        case .warehouseOwner:
            customizeNavigation(self)
            print("It's for wareHouse Owner")
        }
        
        
        setFont()
        let nib = UINib(nibName: "STRInventoryTableViewCell", bundle: nil)
        self.tblInventory.registerNib(nib, forCellReuseIdentifier: "STRInventoryTableViewCell")
        tblInventory.rowHeight = UITableViewAutomaticDimension
        tblInventory.estimatedRowHeight = 70
        appearInformation = .STRFromFirstLoad
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tblInventory.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    func viewScanCall(){
        self.vwScan.scanBlock = {(tag) in
            if(tag == 1)
            {
                self.endTime = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
                self.locationManager.stopRangingBeaconsInRegion(self.beacon)
                self.markeRemainingUndetected()
                self.makeUpdateData()
                dispatch_async(dispatch_queue_create("background_update", nil), {
                    self.setCount()
                })
            }
            else{
                utility.showAlertSheet("", message: "Scan for minimum five minutes", viewController: self)
                self.startTime = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
                self.locationManager = CLLocationManager()
                let uuid:NSUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
                self.beacon = CLBeaconRegion(proximityUUID: uuid, identifier:"")
                self.locationManager.requestAlwaysAuthorization()
                self.beacon.notifyOnEntry=true
                self.beacon.notifyOnExit=true
                self.beacon.notifyEntryStateOnDisplay=true
                CLLocationManager.locationServicesEnabled()
                self.locationManager.startMonitoringForRegion(self.beacon)
                self.locationManager.startRangingBeaconsInRegion(self.beacon)
                self.locationManager.delegate = self
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.vwScan.btnScan!.tag = 0
        self.vwScan.stopAnimation()
        dataFeeding()
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }
    
    func sortButtonClicked(sender : AnyObject){
        appearInformation = .STRFromSearchScreen
        resetState()
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
      
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
        
        
        switch appType {
        case .salesRep:
           
            print("It's for Sales Rep")
        case .warehouseOwner:
          
            if(utility.getUserToken() == nil || utility.getUserToken() == " ")
            {
                self.presentLogin()
                utility.setflagSession(true)//setting flag to show alert scan
                
            }else{
                
            }
            
            print("It's for wareHouse Owner")
        }
        
        
        
        
        switch appearInformation! {
        case .STRFromSearchScreen:
            dataFeeding()
            break
            
        case .STRFromItemDetail:
            
            break
        case .STRFromSearchLocation:
            let loc = utility.getselectedLocation() as? Dictionary<String,AnyObject>
            let dict = self.location["current"] as! [Dictionary<String,AnyObject>]
            if(loc != nil)
            {
            dataFeeding()
            }
            else{
                if(dict.count ==  0)
                {
                self.lblAddress.text = "No location found"
                }
            }
            break
        case .STRFromFirstLoad:
            dataFeeding()
            break
        }
        
    }
    
    func presentLogin() -> () {
        let login = STRLoginViewController(nibName: "STRLoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: login)
        self.navigationController?.presentViewController(nav, animated: false, completion: {
            
        })
        
    }
    
    func backToDashbaord(sender: AnyObject) {
          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          appDelegate.initSideBarMenu()
    }

    func dataFeeding(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        var dict = ["":""]
        let loc = utility.getselectedLocation() as? Dictionary<String,AnyObject>
        var lat: String
        var long: String
        if(BeaconHandler.sharedHandler.coordinate != nil)
        {
            long = "\(BeaconHandler.sharedHandler.coordinate!.longitude)"
            lat = "\(BeaconHandler.sharedHandler.coordinate!.latitude)"
        }
        else{
            long = " "
            lat = " "
 
        }
        
        if(loc != nil)
        {
            dict["latitude"] = lat
            dict["longitude"] = long
            dict["locationId"] = "\(loc!["locationId"]!)"
        }
        else{
            dict["latitude"] = lat
            dict["longitude"] = long
            dict["locationId"] = "0"
        }
        
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(dict, serviceType: .STRApiGetLocationData, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                     self.addNodata()
                    return
                }
                
                guard let data = response["data"] as? [String:AnyObject],let readerSearchNearLocationsResponse = data["readerSearchNearLocationsResponse"] as? Dictionary<String,AnyObject>,let location = readerSearchNearLocationsResponse["location"] as? [String:AnyObject],let zones = readerSearchNearLocationsResponse["zones"] as? [Dictionary<String,AnyObject>]else{
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.location = location
                self.zone_obj.removeAll()
                self.zone_obj.appendContentsOf(zones)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.setUData()
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
                 self.addNodata()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
        }
    }
    func setCount(){
        var allCount = 0
        var found  = 0
        var notFound = 0
        for (_,z) in self.zone_obj.enumerate(){
       let product = z["products"] as? [Dictionary<String,AnyObject>]

        for (_, dic) in product!.enumerate() {
            if (dic["status"] as! NSInteger == STRInventoryStatus.STRInventoryStatusFound.rawValue) {
                found = found + 1
                
            }
             allCount = allCount + 1
        }
        for (_, dic) in product!.enumerate() {
            if (dic["status"] as! NSInteger == STRInventoryStatus.STRInventoryStatusNotFound.rawValue) {
                notFound = notFound + 1
            }
        }
    }
       dispatch_async(dispatch_get_main_queue(),{
        self.lblFound.text = "Nearby : \(found)"
        self.lblAll.text = "All : \(allCount)"
        })
    
    }
    func setFont(){
          lblAddress.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
          lblMissing.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
          lblFound.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
          lblAll.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.zone_obj.count == 0 {
            return 0
        }
        for view in self.view.subviews{
            if view.tag == 10002 {
                view.removeFromSuperview()
            }
        }

        return zone_obj.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let z = self.zone_obj[section]
        if(z["is_expanded"] as? Bool == false){
            return 0
        }
        let product = z["products"] as? [Dictionary<String,AnyObject>]
        if product != nil && product!.count == 0 {
            return 0
        }
        for view in self.view.subviews{
            if view.tag == 10002 {
                view.removeFromSuperview()
            }
        }

        return product!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: STRInventoryTableViewCell = self.tblInventory.dequeueReusableCellWithIdentifier("STRInventoryTableViewCell") as! STRInventoryTableViewCell
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        let z = self.zone_obj[indexPath.section]
        let product = z["products"] as? [Dictionary<String,AnyObject>]
        let data = product![indexPath.row]
        cell.setCellData(data, indexPath: indexPath)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        appearInformation = .STRFromItemDetail
        resetState()
        let vw = STRInventoryListViewController(nibName: "STRInventoryListViewController", bundle: nil)
        let z = self.zone_obj[indexPath.section]
        let product = z["products"] as? [Dictionary<String,AnyObject>]
         let data = product![indexPath.row]
        vw.skuId =  "\(data["skuId"] as! NSInteger)"
        vw.locationName = self.lblAddress.text
        
        vw.titleString =  TitleName.LocationInventoryDetails.rawValue
        vw.sourceScreen = .STRItemDetailFromItemScan
        self.navigationController?.pushViewController(vw, animated: true)
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict = self.zone_obj[section]
        let vw = STRInventorySectionHeaderView.sectionView(dict,section: section) 
        vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 60)
        vw.block_sectionClicked = { section in
         self.expandCollapse(section)
        }
        return vw
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func expandCollapse(section:Int)
    {
        let z = self.zone_obj[section]
        if( z["is_expanded"] as? Bool == false){
            self.expand(section)
        }
        else{
            self.collapse(section)
        }
    }
    func expand(section: Int){
        var z = self.zone_obj[section]
        z["is_expanded"] =  true
        let product = z["products"] as? [Dictionary<String,AnyObject>]
        var row = [NSIndexPath]()
        for (idx,_) in product!.enumerate(){
            row.append(NSIndexPath(forRow: idx, inSection: section))
        }
        self.zone_obj[section] = z
        self.tblInventory.beginUpdates()
        self.tblInventory.insertRowsAtIndexPaths(row, withRowAnimation: UITableViewRowAnimation.Bottom)
        self.tblInventory.endUpdates()

    }
    func collapse(section: Int){
        var z = self.zone_obj[section]
        z["is_expanded"] =  false
        let product = z["products"] as? [Dictionary<String,AnyObject>]
        var row = [NSIndexPath]()
        for (idx,_) in product!.enumerate(){
            row.append(NSIndexPath(forRow: idx, inSection: section))
        }
        self.zone_obj[section] = z
        self.tblInventory.beginUpdates()
        self.tblInventory.deleteRowsAtIndexPaths(row, withRowAnimation: UITableViewRowAnimation.Top)
        self.tblInventory.endUpdates()
    }
    
    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        self.view.addSubview(noData)
        noData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(48)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
    }
    func setUData(){
        var count = 0
        for (indx,z) in self.zone_obj.enumerate(){
        var product = z["products"] as? [Dictionary<String,AnyObject>]
            
        for index in 0..<product!.count{
          var sensor = product![index]["sensor"] as? Dictionary<String,AnyObject>
            if((sensor!["type"] as? String)!.uppercaseString == "BEACON")
            {
                var dict = product![index]
                dict["status"] = STRInventoryStatus.STRInventoryStatusInitial.rawValue
                product![index] = dict
                print(dict["status"])
            }
            else{
                var dict = product![index]
                dict["status"] = STRInventoryStatus.STRInventoryStatusNotBeacon.rawValue
                product![index] = dict
                print(dict["status"])

            }
            count = count + 1
        }
            var dict = self.zone_obj[indx]
            dict["products"] = product
            dict["is_expanded"] = false
            self.zone_obj[indx] = dict
        }
        self.lblAll.text = "All : \(count)"
        self.lblFound.text = "Nearby : 0"
        let loc = utility.getselectedLocation() as? Dictionary<String,AnyObject>
        let arr = self.location["near"] as? [Dictionary<String,AnyObject>]
        if(arr == nil || arr?.count == 0)
        {
             self.flagScanDisabled = true
        }
        if(loc != nil)
        {
            
            for (_,dic) in arr!.enumerate(){
                if( loc!["locationId"] as! NSInteger == (dic["locationId"] as! NSInteger))
                {
                    self.flagScanDisabled = false
                }
                else{
                    self.flagScanDisabled = true
                }
            }
        }
        let flagSession = utility.getflagSession()
        if( arr?.count > 0 &&  self.flagScanDisabled == true && flagSession == true && appearInformation != .STRFromSearchLocation)
        {
            utility.setflagSession(false)
            //show alert
            let str = "We have detected your location as \(arr!.first!["address"]). Do you want to switch?"
            let alert = UIAlertView(title: "", message: str, delegate:self, cancelButtonTitle: "No Thanks", otherButtonTitles: "Switch")
            alert.show()
        }
        let dict = self.location["current"] as! [Dictionary<String,AnyObject>]
        if(dict.count > 0)
        {
        self.lblAddress.text = dict.first!["address"] as! String
        self.currentID = dict.first!["locationId"] as! NSInteger
        self.tblInventory.reloadData()
            if(self.zone_obj.count == 0){
                self.addNodata()
            }
         }
        else{
            //show search :D
            appearInformation = .STRFromSearchLocation
            let vw  = STRChangeLocationViewController(nibName: "STRChangeLocationViewController", bundle: nil)
            vw.arrNear =  self.location["near"] as? [Dictionary<String,AnyObject>]
            vw.arrayOther = self.location["other"] as? [Dictionary<String,AnyObject>]
            let nav = UINavigationController(rootViewController: vw)
            self.presentViewController(nav, animated: true, completion: {
                
            })
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex == 1)
        {
         let near =   self.location["near"] as? [Dictionary<String,AnyObject>]
         utility.setselectedLocation((near?.first)!)
         self.dataFeeding()
        }
    }

    
    func resetState(){
        self.vwScan.resetState()
        if(self.locationManager != nil)
        {
        self.locationManager.stopRangingBeaconsInRegion(self.beacon)
        }

    }
    func updateStatus(beacons:[CLBeacon]?)
    {
        for (_,data) in beacons!.enumerate(){
        for (indx,z) in self.zone_obj.enumerate(){
        var product = z["products"] as? [Dictionary<String,AnyObject>]
        for (idx, dic) in product!.enumerate() {
            let sensor = dic["sensor"]! as? Dictionary<String,AnyObject>
            if ((sensor!["major"] as? NSInteger) == data.major && (sensor!["minor"] as? NSInteger) == data.minor && dic["status"] as! NSInteger != STRInventoryStatus.STRInventoryStatusFound.rawValue) {
                var dict = product![idx]
                dict["status"] = STRInventoryStatus.STRInventoryStatusFound.rawValue
                product![idx] = dict
            }
        }
            
            var dict = self.zone_obj[indx]
            dict["products"] = product
            self.zone_obj[indx] = dict
      }
    }
        self.tblInventory.reloadData()
    }
    
    func markeRemainingUndetected(){
        for (indx,z) in self.zone_obj.enumerate(){
        var product = z["products"] as? [Dictionary<String,AnyObject>]
        for (idx, dic) in product!.enumerate() {
            let status = dic["status"]!
            if ((status as! NSInteger) == STRInventoryStatus.STRInventoryStatusInitial.rawValue ) {
                var dict = product![idx]
                dict["status"] = STRInventoryStatus.STRInventoryStatusNotFound.rawValue
                product![idx] = dict
            }
        }
            var dict = self.zone_obj[indx]
            dict["products"] = product
            self.zone_obj[indx] = dict
    }
        self.tblInventory.reloadData()
    }
    func makeUpdateData(){
        var items = [Dictionary<String,AnyObject>]()
        for (_,z) in self.zone_obj.enumerate(){
            var dictData = Dictionary<String,AnyObject>()
            dictData["zoneId"] = z["zoneId"]
            var product = z["products"] as? [Dictionary<String,AnyObject>]
            for index in 0..<product!.count{
                var pro = product![index]
                dictData["productId"] = pro["productId"]
                dictData["skuId"] = pro["skuId"]
                var sensor = product![index]["sensor"] as? Dictionary<String,AnyObject>
                dictData["sensorId"] = sensor!["sensorId"]
                var dict = product![index]
                if(dict["status"] as! NSInteger == STRInventoryStatus.STRInventoryStatusFound.rawValue)
                {
                    dictData["found"] = "1"

                }
                else{
                    dictData["found"] = "0"
                }
                 items.append(dictData)
            }
        }
        postScanData(items)
    }
    
    func postScanData(array:[Dictionary<String,AnyObject>]){
        
        var locationId =  self.currentID
        var lat: String
        var long: String
        if(BeaconHandler.sharedHandler.coordinate != nil)
        {
            long = "\(BeaconHandler.sharedHandler.coordinate!.longitude)"
            lat = "\(BeaconHandler.sharedHandler.coordinate!.latitude)"
        }
        else{
            long = " "
            lat = " "
            
        }
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["items":array,"locationId":locationId!,"currentLatitude":lat,"currentLongitude":long,"isPresentOnLocation": self.flagScanDisabled,"scanStartTime": self.startTime!,"scanEndTime":self.endTime!], serviceType: .STRUpdatScanInformation, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                
                utility.showAlertSheet(TextMessage.alert.rawValue, message: "\(response["message"] as! String)", viewController: self)
                    return
            }
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
        }
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
