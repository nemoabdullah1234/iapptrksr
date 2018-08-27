import UIKit

 var  iswatching : String = "watch"

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, STRCaseDetailDelegate,STRNoDataFoundDelegate{

    @IBOutlet var vwSegment: STRHomeSegment!
    @IBOutlet var tableView: UITableView!
    var dataArrayObj = [AnyObject]()
    var allArrayObj = [AnyObject]()
    
    var caseNumber : String?
    var reportStr :String?
    var watchStr : String?
    
    var sortOrderBool: Bool?
    var isFirstLoad: Bool?  
    var isBackFromCaseDetail: Bool?
    var searchString : String?
    
    var refreshControl: UIRefreshControl!
    var selectIndex:Int?
     var caseDetailObj : STRCaseDetailVC?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFirstLoad = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
       
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.frame = CGRectMake(0, 64, self.searchController.searchBar.frame.size.width, 44.0);
        
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = true
        } else {
           
        }
     

         tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        iswatching = " "
        self.title = TitleName.Dashboard.rawValue
        customizeNavigation(self)
        
             let nib = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "dashBoardTableViewCell")
        tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

      
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        isBackFromCaseDetail = false
        self.view .addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.vwSegment.blockSegmentButtonClicked = {(segment) in
            if segment == 0 {
                self.dataArrayObj  = self.allArrayObj
                
            }else if segment == 1{
                var watchArrayObj = [AnyObject]()
                self.dataArrayObj  = self.allArrayObj
                for dataObj in self.dataArrayObj {
                    print(dataObj)
                    
                    if dataObj["isWatched"]?!.integerValue == 1
                    {
                        watchArrayObj .append(dataObj)
                        
                    }
                    
                }
                self.dataArrayObj = watchArrayObj
            }else{
                var reportedArrayObj = [AnyObject]()
                self.dataArrayObj  = self.allArrayObj
                for dataObj in self.dataArrayObj {
                    
                    if dataObj["isReported"]?!.integerValue == 1
                    {
                        reportedArrayObj .append(dataObj)
                        
                    }
                    
                }
                self.dataArrayObj = reportedArrayObj
            }
            
            self.tableView .reloadData()

        
        }
      
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        getData()
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.searchController.searchBar.frame = CGRectMake(0, 0, self.searchController.searchBar.frame.size.width, 44.0);
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        getData()
        tableView.tableHeaderView = nil
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {

        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        let someDict:[String:String] = ["Search":searchText]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiSearchCase, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
        
        
        
    }
    
    // Data Feeding
    func getData() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiCase, success: { (response) in
             dispatch_async(dispatch_get_main_queue()) {

            print(response)
            
            let dataDictionary = response["data"] as? [String : AnyObject]
        
                self.isFirstLoad = true
                
                
                self.refreshControl.endRefreshing()
                if dataDictionary?.count <= 0 {
                     MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.addNodata()
                    return
                }
            self.dataArrayObj = dataDictionary!["readerGetCasesResponse"]  as! [AnyObject]
            self.allArrayObj = self.dataArrayObj
                
                if self.vwSegment!.selectedSegment == 0 {
                    self.dataArrayObj = self.allArrayObj
                }else if self.vwSegment!.selectedSegment == 1 {
                    self.dataArrayObj = self.iswatchedData() as [AnyObject]
                }else{
                    self.dataArrayObj = self.isReportedData() as [AnyObject]
                }
                
         self.view.viewWithTag(10002)?.removeFromSuperview()
         self.tableView .reloadData()
            
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
    
    override func viewDidAppear(animated: Bool) {
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.navigationBar.hidden = false
       
      self.revealViewController().panGestureRecognizer().enabled = true
       if(utility.getUserToken() == nil || utility.getUserToken() == " ")
        {
           self.presentLogin()
            utility.setflagSession(true)//setting flag to show alert scan

        }else{
        if isBackFromCaseDetail == false {
            getData()
            if(utility.getselectedIndexDashBoard() != nil)
            {
            selectIndex = Int(utility.getselectedIndexDashBoard()!)!
            self.vwSegment.setSegment(selectIndex!)
            }
            else{
                self.vwSegment.setSegment(0)
            }
         }
        

        }

    }
    func checkWhenComesFromCaseDetais(controller:STRCaseDetailVC,isController:Bool)
    {
        isBackFromCaseDetail = isController
        print(isController)
    }
    
    
    func iswatchedData() -> NSArray {
        var watchArrayObj = [AnyObject]()
        dataArrayObj  = allArrayObj
        for dataObj in self.dataArrayObj {
            print(dataObj)
            
            if dataObj["isWatched"]?!.integerValue == 1
            {
                watchArrayObj .append(dataObj)
                
            }
            
        }
        return watchArrayObj
    }
    
    func isReportedData() -> NSArray {
        var reportedArrayObj = [AnyObject]()
        dataArrayObj  = allArrayObj
        for dataObj in self.dataArrayObj {
            
            if dataObj["isReported"]?!.integerValue == 1
            {
                reportedArrayObj .append(dataObj)
                
            }
            
        }
        return reportedArrayObj
    }
    
    func barButtonItemClicked(sender : AnyObject){
        self.navigationController?.view.viewWithTag(10001)?.removeFromSuperview()
        addpopup()
    }
    
    func sortButtonClicked(sender : AnyObject){
     
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
       
    }
    
   
    
    
    
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFirstLoad == false {
            return 0
        }
        
        if self.dataArrayObj.count == 0 {
             self.addNodata()
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
       
        let cell: DashBoardTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("dashBoardTableViewCell") as! DashBoardTableViewCell
        cell.buttonTypeDash = .STRDashboardCellWithFav
        cell.setUpCell(self.dataArrayObj[indexPath.row] as? [String : AnyObject],indexPath:indexPath)
        cell.blockFav = {(indexPath) in
        
            let infoDictionary = self.dataArrayObj[indexPath] as? [String : AnyObject]
            print(infoDictionary!["caseId"] as! String)
            
            self.caseNumber =  infoDictionary!["caseId"] as? String
            self.watchStr = String(format: "%d", (infoDictionary!["isWatched"]?.integerValue)!)
            var iswatcting : String
            if self.watchStr == "0" {
                iswatcting  = "Favorite"
                
            }else{
                iswatcting  = "Favorited"
                
            }
            self.watchCaseApi(self.caseNumber!, watchStrObj: self.watchStr!)
        
        
        
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
      }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if self.dataArrayObj.count == 0 {
            
            
        }else {
        
        let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
        let caseNumberObj1  = infoDictionary!["caseId"] as! String
      let obj =  STRSliderBaseViewController.init(nibName: "STRSliderBaseViewController", bundle: nil)
            obj.caseNo = caseNumberObj1
            obj.readonly = false
       self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    func attributedString(stringValue : NSString)-> NSString {
        let fullString = NSMutableAttributedString(string: stringValue as String)
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "flight_takeoff")
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        image1Attachment.image = UIImage(CGImage: image1Attachment.image!.CGImage!, scale: 6, orientation: .Up)
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.appendAttributedString(image1String)
       // fullString.appendAttributedString(NSAttributedString(string: stringValue as String))
        let stringVal = fullString.string
        return stringVal
    }
    
    func presentLogin() -> () {
        let login = STRLoginViewController(nibName: "STRLoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: login)
        self.navigationController?.presentViewController(nav, animated: false, completion: {
            
        })
       
    }
    
    // Need To call  and set Is watch from Edit Table Cell
    func watchCaseApi(caseNumberObj : String, watchStrObj : String) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        if watchStrObj == "0" {
            watchStr = "1"
        }else{
             watchStr = "0"
        }
        
        let someDict:[String:String] = ["caseNo":caseNumberObj, "isWatch":watchStr!, "isException":"0"]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiWatchCase, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["message"] as? String
                
                if dataDictionary == "Ok" {
               
                    self.getData()
                    if self.watchStr == "0" {
                        iswatching  = "Favorite"
                    }else{
                        iswatching  = "Favorited"
                    }
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
    
    
    
    func addpopup(){
        let popup =  NSBundle.mainBundle().loadNibNamed("STRPopUp", owner: self, options: nil)! .first as? STRPopup
        
        
        popup!.tag=10001
        popup!.frame=(self.navigationController?.view.frame)!;
        popup!.layoutIfNeeded()
        
       
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlDown, animations: {
            popup!.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                //Once the label is completely invisible, set the text and fade it back in
                 self.navigationController?.view.addSubview(popup!)
                
                // Fade in
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlDown, animations: {
                    popup!.alpha = 1.0
                    }, completion: nil)
        })
       
       
        
        popup!.layoutSubviews()
        
        popup!.closure = {(sortString)in
            
           self.getData()
            
            var defaultView : String?
            
            if utility.getselectedIndexDashBoard()! == "0"
            {
                defaultView = "All"
            }
            if utility.getselectedIndexDashBoard()! == "1"
            {
                defaultView = "Watched"
            }
            if utility.getselectedIndexDashBoard()! == "2"
            {
                defaultView = "Exceptions"
            }
            self.updateSettingDetailApi(defaultView!, sortedbyObj:  utility.getselectedSortBy()!, sortedOrderObj:  utility.getselectedSortOrder()!, notificationObj: utility.getNotification()!, soundObj: utility.getNotificationAlert()!, silentFromObj: utility.getSilentFrom()!, silentToObj: utility.getSilentTo()!, vibrationObj:utility.getNotificationVibration()!, ledObj: utility.getNotificationBadge()!)
            
            
            
        }
      
        
    }
    
    
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
       
        let length = searchController.searchBar.text!.characters.count
        if length > 2 {
       //searchString
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        print(searchPredicate)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        let someDict:[String:String] = ["Search":searchController.searchBar.text!]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiSearchCase, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                
                
                
                self.dataArrayObj = dataDictionary!["readerSearchCasesResponse"]  as! [AnyObject]
                
                if self.dataArrayObj.count  > 0  {
                    self.allArrayObj = self.dataArrayObj
                    
                    if self.vwSegment!.selectedSegment == 0 {
                        self.dataArrayObj = self.allArrayObj
                    }else if self.vwSegment!.selectedSegment == 1 {
                        self.dataArrayObj = self.iswatchedData() as [AnyObject]
                    }else{
                        self.dataArrayObj = self.isReportedData() as [AnyObject]
                    }
                    
                    
                    
                    
                }else{
                    
                }
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
    }
    
    
    func updateSettingDetailApi(defaultViewObj : String, sortedbyObj : String,sortedOrderObj : String, notificationObj : String, soundObj : String, silentFromObj : String, silentToObj : String, vibrationObj : String, ledObj : String) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        let someDict:[String:String] = ["dashboardDefaultView":defaultViewObj, "dashboardSortBy":sortedbyObj,"dashboardSortOrder":sortedOrderObj, "notifications":notificationObj,"sound":soundObj,"silentHrsFrom":silentFromObj,"silentHrsTo":silentToObj, "vibration":vibrationObj, "led":ledObj]
        
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiUpdateSettingDetails, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["message"] as? String
                
                if dataDictionary == "Ok" {
                    
                    
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
    
    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        noData.showViewRetry()
        noData.delegate = self
        
      self.view.addSubview(noData)
         noData.translatesAutoresizingMaskIntoConstraints = false
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(48)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
    }
    
    func retryPressed() {
        getData()
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}






