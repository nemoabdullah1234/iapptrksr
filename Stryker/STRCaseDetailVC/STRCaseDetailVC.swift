protocol STRCaseDetailDelegate{
    func checkWhenComesFromCaseDetais(controller:STRCaseDetailVC,isController:Bool)
}
import UIKit
class STRCaseDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {
    var caseDetails: Dictionary<String,AnyObject>?
    var shipments: Array<AnyObject>?
    var caseNo : String?
    var arrayIndexExpanded: Array<Int>?
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var caseDateLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var phoneNUmberBtn: UIButton!
    @IBOutlet weak var faxNUmberBtn: UIButton!
    @IBOutlet var tblCase: UITableView!
    @IBOutlet var headerView: UIView!
    var refreshControl: UIRefreshControl!
    var delegate:STRCaseDetailDelegate! = nil
    var titleName: String!
    var isfromCompleteCases: String?
     var mapData: Dictionary<String,AnyObject>?
    @IBOutlet var webViewMap: UIWebView!
    @IBOutlet var segementControlObj: ADVSegmentedControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        let aStr = String(format: "%@", titleName!)
       customNavigationforBack(self)
        self.title =  aStr
        
        self.webViewMap.loadRequest(NSURLRequest(URL: NSURL(string: mapUrl + caseNo!)!));
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Arial", size: 14)!]

        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let segmentValue:[String] = [CaseDetailStringValue.list.rawValue, CaseDetailStringValue.map.rawValue]
        customSegmentControl(segmentValue, ref: self)
        dataFeeding()
        arrayIndexExpanded = Array<Int>()
        self.arrayIndexExpanded?.append(0)
        
        self.revealViewController().panGestureRecognizer().enabled = false
        tblCase.tableFooterView = UIView()
       self.webViewMap.hidden = true
       setUpFont()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tblCase.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        dataFeeding()
    }
    
    func setUpFont(){
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func poptoPreviousScreen() {
        
        if(delegate != nil)
        {
        delegate!.checkWhenComesFromCaseDetais(self, isController: true)
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    func customSegmentControl(nameArray: Array<String> , ref : UIViewController) {
        segementControlObj!.items = nameArray
        segementControlObj!.font = UIFont(name: "Avenir-Black", size: 12)
        segementControlObj!.borderColor = UIColor.clearColor()
        segementControlObj!.selectedIndex = 0
        segementControlObj!.addTarget(self, action: #selector(STRCaseDetailVC.segmentValueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func segmentValueChanged(sender: AnyObject?){
        if segementControlObj!.selectedIndex == 0 {
            self.view .bringSubviewToFront(self.tblCase)
            self.webViewMap.hidden = true
            self.view.sendSubviewToBack(self.webViewMap)
        }else if segementControlObj!.selectedIndex == 1{
            self.webViewMap.hidden = false
            self.view.bringSubviewToFront(self.webViewMap)
             self.view.sendSubviewToBack(self.tblCase)
        }else{
            
        }
        
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }
    //MARK: TableviewMethods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 0
        }
        if(self.shipments == nil)
        {
            return 0
        }
        if(self.arrayIndexExpanded?.contains(section-1) == false)
        {
            return 0
        }
        return self.shipments![section-1]["items"]!!.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.shipments == nil)
        {
            return 1
        }
        return ((self.shipments?.count)!+1)
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        cell!.textLabel!.text = self.shipments![indexPath.section-1]["items"]!![indexPath.row]["l1"] as? String
         cell!.detailTextLabel!.text = self.shipments![indexPath.section-1]["items"]!![indexPath.row]["l2"] as? String
         cell!.detailTextLabel?.textColor = UIColor.darkGrayColor()
        
        if isfromCompleteCases == "2" {
            var label = UILabel(frame: CGRectMake(0, 0, 100, 20))
            label.center = CGPointMake(160, 284)
            label.textAlignment = NSTextAlignment.Right
            if  self.shipments![indexPath.section-1]["items"]!![indexPath.row]["l5"] as? String == "1"{
                label.text = "Unused"
                
            }else
            {
                label.text = "Used"
            }
            
            
            cell!.accessoryView = label as UIView
        }
        cell!.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (self.caseDetails!["isAssigned"]!.integerValue) == 1 {
           addReport(indexPath.section - 1, andRow:indexPath.row)
        }else
        {
            utility.createAlert(TextMessage.casenotAssigned.rawValue, alertMessage: "", alertCancelTitle: TextMessage.Ok.rawValue, view: self)
        }

    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0 )
        {
            return 127
        }
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if section == 0 {
            return self.headerView
        }
        
        let header =  NSBundle.mainBundle().loadNibNamed("STRSectionHeader", owner: self, options: nil)! .first as! STRSectionHeader
        header.lblTRID.text = self.shipments![section-1]["l1"] as? String
        header.lblStatus.text = self.shipments![section-1]["l2"] as? String
        header.lblDate.text = self.shipments![section-1]["l4"] as? String
        header.lblTRCooment.text = self.shipments![section-1]["l3"] as? String
        header.lblStatus.textColor =  colorWithHexString((self.shipments![section-1]["color"] as? String)!)
        if self.shipments![section-1]["isReported"]?!.integerValue == 1 {
            header.imgSectionHeader!.image = UIImage(named: "reportedstatus")
        }else
        {
            header.imgSectionHeader!.image = UIImage(named: "")
        }
       
        
        
        header.index = section-1
        header.closure={(index) in
            
            if(self.arrayIndexExpanded?.contains(section - 1 ) == true)
            {
                self.arrayIndexExpanded?.removeAtIndex((self.arrayIndexExpanded?.indexOf(section - 1))!)
                self.deleteTable(section - 1)
            }
            else{
                self.arrayIndexExpanded?.append(section - 1)
                self.insertTable(section - 1)
            }
        }
        
        header.closureReportIssue={(index)in
            
            if (self.caseDetails!["isAssigned"]!.integerValue) == 1 {
                
                  self.addReport(index, andRow:10000)
            }
            else
            {
                utility.createAlert(TextMessage.casenotAssigned.rawValue, alertMessage: "", alertCancelTitle: TextMessage.Ok.rawValue, view: self)
            }
        }
        return header
        }
    
    //MARK:  hit api
    
    func dataFeeding() -> () {
        let api = GeneralAPI()
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"

      api.hitApiwith(["caseNo":self.caseNo!], serviceType: .STRApiGetCaseDetail, success: { (response) in
        print(response)
        dispatch_async(dispatch_get_main_queue()) {
            
             self.refreshControl.endRefreshing()
            if(response["status"]?.integerValue != 1)
            {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                loadingNotification = nil
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                return
            }//caseDetails
            // shipments
            guard let data = response["data"] as? [String:AnyObject],readerGetCaseDetailsResponse = data["readerGetCaseDetailsResponse"] as? [String:AnyObject] ,caseDetails = readerGetCaseDetailsResponse["caseDetails"] as? [String:AnyObject],shipments = readerGetCaseDetailsResponse["shipments"] as? [[String:AnyObject]]  else{
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                return
            }
            print(data)
            self.caseDetails=caseDetails
            self.setUpValues(self.caseDetails!)
            self.shipments=shipments
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.tblCase.reloadData()
            guard let mapData = readerGetCaseDetailsResponse["map"] as? [String:AnyObject] else{
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                return
            }
            self.mapData = mapData
            self.setUpData()
        }
        }) { (error) in
            
        }
        
    }
    func setUpData(){
        self.webViewMap.loadRequest(NSURLRequest(URL: NSURL(string:mapData!["url"] as! String)!));//
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        let path = NSBundle.mainBundle().pathForResource("index", ofType:"html" , inDirectory: "HTML")
        let html = try! String(contentsOfFile: path!, encoding:NSUTF8StringEncoding)
        
        self.webViewMap.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
        self.webViewMap.delegate = nil
    }


    func insertTable(section: Int){
        if(self.shipments![section]["items"]!!.count == 0)
        {
            return
        }
        var indexPaths = [NSIndexPath]()
        for i in 0...self.shipments![section]["items"]!!.count-1
        {
            indexPaths.append(NSIndexPath.init(forRow: i, inSection: section+1))
        }
        self.tblCase.beginUpdates()
        self.tblCase.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
         self.tblCase.endUpdates()
    }
    func deleteTable(section: Int){
        if(self.shipments![section]["items"]!!.count == 0)
        {
            return
        }
        var indexPaths = [NSIndexPath]()
        for i in 0...self.shipments![section]["items"]!!.count-1
        {
            indexPaths.append(NSIndexPath.init(forRow: i, inSection: section+1))
        }
        self.tblCase.beginUpdates()
       self.tblCase.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.tblCase.endUpdates()
    }

    
    func addpopup(){
         let popup =  NSBundle.mainBundle().loadNibNamed("STRPopupSort", owner: self, options: nil)! .first as! STRPopupSort
        self.view.addSubview(popup)
        self.view.translatesAutoresizingMaskIntoConstraints=false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[popup]-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["popup":popup]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[popup]-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["popup":popup]))
        popup.closure = {(sortString)in
            

        }
        popup.setUpPopup(1)
        
    }
    
    func setUpValues(dataDic : NSDictionary) {
        doctorNameLbl.text = dataDic["l1"] as? String
        caseDateLbl.text = dataDic["l2"] as? String
        venueLbl.text = dataDic["l3"] as? String
       let str =   String(format: "PH : %@",(dataDic["l4"] as? String)! )
        phoneNUmberBtn .setTitle(str, forState: UIControlState.Normal)
        let strFax =   String(format: "FAX : %@",(dataDic["l5"] as? String)! )
        faxNUmberBtn .setTitle(strFax, forState: UIControlState.Normal)
        dueDateLbl.text = dataDic["l6"] as? String
    }
    
    
    func addReport(index:Int, andRow: Int){
  
    }
    @IBAction func phoneNumberClicked(sender: AnyObject) {
       let str =   String(format: "tel://%@",(self.caseDetails!["l4"] as? String)! )
        print(str)
        let url:NSURL = NSURL(string: str)!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction func faxNumberClicked(sender: AnyObject) {
    }
    
}
