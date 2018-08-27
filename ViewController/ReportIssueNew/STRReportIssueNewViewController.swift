import UIKit
enum STRTypeOfReport:Int{
    case STRReportCase = 0
    case STRReportDueback
}

class STRReportIssueNewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var vwAddButton: UIView!
    var readonly:Bool?
    var caseNo:String?
    var issueID:String?
    var shippingNo:String?
    var caseDetails: Dictionary<String,AnyObject>?
    var comments:[Dictionary<String,AnyObject>]?
    var items:[Dictionary<String,AnyObject>]?
    var reportType: STRTypeOfReport?
    var fromImageExpand:Bool?
    var trackingID:String?
    @IBOutlet var vwSave: UIView!
    
    
    
    @IBOutlet var heightAddComment: NSLayoutConstraint!
    @IBOutlet var lblAddComment: UILabel!
    @IBOutlet var lblTrackingID: UILabel!
    @IBOutlet var tblReportIssue: UITableView!
    @IBAction func btnAddComment(sender: AnyObject) {
        if self.trackingID != ""{
        let vw = STRComposeIssueViewController(nibName: "STRComposeIssueViewController", bundle: nil)
            vw.trackingID = self.trackingID
            vw.itemsArray = self.items
            vw.shippingNo = self.shippingNo
            vw.caseNo     = self.caseNo
            vw.reportType = reportType
           self.navigationController?.pushViewController(vw, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.reportType == .STRReportDueback)
        {
             self.title = TitleName.ItemComment.rawValue
        }
        else
        {
        self.title = TitleName.ReportIssue.rawValue
        }
        customizeNavigationforAll(self)
        // Do any additional setup after loading the view.
        self.revealViewController().panGestureRecognizer().enabled = false
        let nib = UINib(nibName: "STRIssueDetailTableViewCell", bundle: nil)
        tblReportIssue.registerNib(nib, forCellReuseIdentifier: "STRIssueDetailTableViewCell")
        tblReportIssue.rowHeight = UITableViewAutomaticDimension
        tblReportIssue.tableFooterView = UIView()
        self.tblReportIssue.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblReportIssue.estimatedRowHeight = 140
        setUpFont()
        if(readonly == true)
        {
            self.heightAddComment.constant = 0
            self.vwAddButton.hidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if(self.fromImageExpand == true)
        {
            self.fromImageExpand = false
            return
        }
        
        if(reportType == .STRReportCase)
        {
            dataFeeding()
        }
        else{
            dataFeedingGetComment()
        }
         self.navigationController?.navigationBar.hidden = false
    }
    
    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func setUpFont(){
        self.vwSave.layer.cornerRadius = 5.0
        self.lblAddComment.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backToDashbaord(back:UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.comments ==  nil || self.comments?.count == 0)
        {
           
            return 0

        }
        for view in self.view.subviews{
            if(view.tag == 10002)
            {
                view.removeFromSuperview()
            }
            self.view.viewWithTag(10002)?.removeFromSuperview()
        }
        return self.comments!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.comments == nil)
        {
            return 0
        }
        let dict  =  self.comments![section] as? Dictionary<String,AnyObject>
        if(reportType == .STRReportCase)
        {
        let arr = dict!["issueComments"] as? [Dictionary<String,AnyObject>]
        return arr!.count
        }
        else{
            let arr = dict!["itemComments"] as? [Dictionary<String,AnyObject>]
            return arr!.count

        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: STRIssueDetailTableViewCell = (self.tblReportIssue.dequeueReusableCellWithIdentifier("STRIssueDetailTableViewCell") as? STRIssueDetailTableViewCell)!
        let dict  =  self.comments![indexPath.section]
        if(reportType == .STRReportCase)
        {
            let arr = dict["issueComments"] as? [Dictionary<String,AnyObject>]
            cell.setUpData(arr![indexPath.row],index: indexPath.row)

        }
        else{
            let arr = dict["itemComments"] as? [Dictionary<String,AnyObject>]
            cell.setUpData2(arr![indexPath.row],index: indexPath.row)
        }
        cell.imageUrl = {(URL) in
            self.presentWithImageURL(URL)
        }
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        cell.layoutSubviews()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict = self.comments![section]
        let vw = STRReportIssueSectionHeader.sectionView((dict["commentDate"] as? String)!)
        vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 30)
        return vw
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //MARK: get data from API
    func dataFeeding(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
         generalApiobj.hitApiwith(["caseNo":self.caseNo!,"shippingNo":self.shippingNo!,"issueId":self.issueID == nil ? "": self.issueID!], serviceType: .STRApiGetUserCommentsForIssue, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                     self.addNodata()
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],readerGetIssueCommentsResponse = data["readerGetIssueCommentsResponse"] as? Dictionary< String,AnyObject>,caseDetails = readerGetIssueCommentsResponse["caseDetails"] as? Dictionary<String,AnyObject>,comments = readerGetIssueCommentsResponse["comments"] as? [Dictionary<String,AnyObject>],items = readerGetIssueCommentsResponse["items"] as? [Dictionary<String,AnyObject>] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                     self.addNodata()
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.caseDetails = caseDetails
                self.comments = comments
                self.items = items
                self.setUpData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.addNodata()
                self.tblReportIssue.reloadData()
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                 self.addNodata()
                NSLog(" %@", err)
            }
        }

    }
    func dataFeedingGetComment(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["caseNo":self.caseNo!,"skuId":self.shippingNo!], serviceType: .STRApiGetCaseItemComments, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                     self.addNodata()
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],readerGetCaseItemCommentsResponse = data["readerGetCaseItemCommentsResponse"] as? Dictionary< String,AnyObject>,caseDetails = readerGetCaseItemCommentsResponse["itemDetails"] as? Dictionary<String,AnyObject>,comments = readerGetCaseItemCommentsResponse["comments"] as? [Dictionary<String,AnyObject>] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                     self.addNodata()
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.caseDetails = caseDetails
                self.comments = comments
                self.setUpData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                self.addNodata()
                self.tblReportIssue.reloadData()
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                 self.addNodata()
                NSLog(" %@", err)
            }
        }
        
    }
    
    func setUpData(){

        if(self.navigationController == nil)
        {
            return
        }

        if(reportType == .STRReportCase)
        {
            
            self.trackingID = self.caseDetails!["l1"] as? String
            let vw = STRNavigationTitle.setTitle("Notes", subheading: "\(self.trackingID!)")
            vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
            self.navigationItem.titleView = vw

        }
        else{
            self.trackingID = "\(self.caseDetails!["l2"]!)"
            let vw = STRNavigationTitle.setTitle("Notes", subheading: (self.caseDetails!["l2"] as? String)!)
            vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
            self.navigationItem.titleView = vw

        }
            }
    
    func presentWithImageURL(url:String?){
        self.fromImageExpand = true;
        let vw = STRImageViewController(nibName: "STRImageViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: vw)
        vw.imageURL = url
        self.navigationController?.presentViewController(nav, animated: true, completion: nil)
    }
    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        self.view.addSubview(noData)
        noData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(120)-[noData]-(0)-[vwAddButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData,"vwAddButton":self.vwAddButton]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
        
    }

}
