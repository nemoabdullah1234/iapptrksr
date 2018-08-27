import UIKit

class STRCaseHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    var flag: Bool?
    var arrayOfExpandedIndex : Array<NSIndexPath>?
    var caseNo = ""
    var caseDetails: Dictionary<String,AnyObject>?
    var items  : [Dictionary<String,AnyObject>]?
    var isEditable: Bool?
    @IBOutlet var tblView: UITableView!
    
    
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var caseDateLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var phoneNUmberBtn: UIButton!
    @IBOutlet weak var faxNUmberBtn: UIButton!
    @IBOutlet var headerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        flag=false
        arrayOfExpandedIndex=[];
        customNavigationforBack(self)
        self.title = TitleName.CaseHistoryDetail.rawValue
        self.navigationController?.navigationBar.translucent=false
        isEditable=false
        // Do any additional setup after loading the view.
        self.dataFeeding()
        
        setUpFont()
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSave(sender: AnyObject) {
        
        
        self.saveItemStatus(true);
        
    }
    
    @IBAction func btnDraft(sender: AnyObject) {
        self.saveItemStatusDraft(false)
    }

    //MARK: TableviewMethods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0)
        {
            self.headerView.frame=CGRectMake(0, 0, self.tblView.frame.size.width, 127)
        return self.headerView
        }
        else{
            return nil
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 127
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if(section==0)
        {
            return 0
        }
        if((items) != nil)
        {
       return (items?.count)!
        }
        else{
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCellWithIdentifier("STRCaseHistoryTableViewCell")
        if(cell == nil){
            cell =  NSBundle.mainBundle().loadNibNamed("STRCaseHistoryTableViewCell", owner: self, options: nil)! .first as! STRCaseHistoryTableViewCell
        }
        cell?.selectionStyle=UITableViewCellSelectionStyle.None
        (cell as! STRCaseHistoryTableViewCell).heightComment.constant = 0
        (cell as! STRCaseHistoryTableViewCell).indexPath = indexPath
        (cell as! STRCaseHistoryTableViewCell).closure = {(indexPath) in
            if (self.arrayOfExpandedIndex?.indexOf(indexPath)) != nil            {
               self.arrayOfExpandedIndex?.removeAtIndex((self.arrayOfExpandedIndex?.indexOf(indexPath))!)
                tableView.beginUpdates()
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! STRCaseHistoryTableViewCell
                  cell.heightComment.constant = 0
                tableView.endUpdates()
            }
            else{
                self.arrayOfExpandedIndex?.append(indexPath)
                tableView.beginUpdates()
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! STRCaseHistoryTableViewCell
                 cell.heightComment.constant = cell.txtComment.contentSize.height
                tableView.endUpdates()
            }
            
        }
        
        
        (cell as! STRCaseHistoryTableViewCell).closureSwitch = {(indexPath,on) in
        
            if(on)
            {
               self.items![indexPath.row].updateValue("2", forKey: "l5")
            }
            else{
                 self.items![indexPath.row].updateValue("1", forKey: "l5")
            }
        
        }
         (cell as! STRCaseHistoryTableViewCell).txtComment.delegate=self
         (cell as! STRCaseHistoryTableViewCell).txtComment.tag=indexPath.row
        (cell as! STRCaseHistoryTableViewCell).txtComment.text="Comment Here"
        
        
        
        if (self.arrayOfExpandedIndex?.indexOf(indexPath)) != nil  {
            (cell as! STRCaseHistoryTableViewCell).heightComment.constant = (cell as! STRCaseHistoryTableViewCell).txtComment.contentSize.height
        }
        else{
            (cell as! STRCaseHistoryTableViewCell).heightComment.constant = 0
        }
        
        (cell as! STRCaseHistoryTableViewCell).setUpdata(items![indexPath.row], editable: isEditable!)
        cell?.contentView.layer.borderWidth=1
        cell?.contentView.layer.cornerRadius=2
        cell!.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: data processing
    
    func dataFeeding(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["caseNo":self.caseNo], serviceType: .STRApiCaseHistoryDetail, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],readerGetCaseHistoryDetailsResponse = data["readerGetCaseHistoryDetailsResponse"] as? [String:AnyObject] ,caseDetails = readerGetCaseHistoryDetailsResponse["caseDetails"] as? [String:AnyObject],items = readerGetCaseHistoryDetailsResponse["items"] as? [[String:AnyObject]]  else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.caseDetails = caseDetails
                self.items = items
                if(self.caseDetails!["isSubmitted"]?.integerValue==0)
                {
                    self.isEditable=true
                    
                }
                self.setUPDetails()
                self.tblView.reloadData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
        }

    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        
        if textView.text == "Comment Here" {
            textView.text = ""
        }
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(STRCaseHistoryViewController.cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(STRCaseHistoryViewController.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        textView.inputAccessoryView = numberToolbar
        
        return isEditable!
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "Comment Here"  || textView.text == ""{
            textView.text = "Comment Here"
        }
         self.items![textView.tag].updateValue(textView.text, forKey: "l3")
    }
    
    func cancelNumberPad(){
    }
    func doneWithNumberPad(){
        self.view.endEditing(true)
       
    }
    func poptoPreviousScreen() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    func setUpFont(){
    }
    func setUPDetails(){
         self.doctorNameLbl.text = self.caseDetails!["l1"] as? String
         self.caseDateLbl.text = self.caseDetails!["l2"] as? String
         self.venueLbl.text = self.caseDetails!["l3"] as? String
        let strDate =   String(format: "Due Back Date : %@",(self.caseDetails!["l6"] as? String)! )
         self.dueDateLbl.text = strDate
        
        let str =   String(format: "PH : %@",(self.caseDetails!["l4"] as? String)! )
        phoneNUmberBtn .setTitle(str, forState: UIControlState.Normal)
        let strFax =   String(format: "FAX : %@",(self.caseDetails!["l5"] as? String)! )
        faxNUmberBtn .setTitle(strFax, forState: UIControlState.Normal)
    }
    
    func saveItemStatus(flag:Bool){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["caseNo":self.caseNo,"items":self.items!,"isSubmitted":flag], serviceType: .STRApiItemStatusUpdate, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],_ = data["ReaderSetItemUsedStatusResponse"] as? [String:AnyObject]  else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.isEditable = false
                self.tblView.reloadData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
        }

    }
    func saveItemStatusDraft(flag:Bool){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["caseNo":self.caseNo,"items":self.items!,"isSubmitted":flag], serviceType: .STRApiItemStatusUpdate, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],_ = data["ReaderSetItemUsedStatusResponse"] as? [String:AnyObject]  else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.isEditable = true
                self.tblView.reloadData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
        }
        
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
