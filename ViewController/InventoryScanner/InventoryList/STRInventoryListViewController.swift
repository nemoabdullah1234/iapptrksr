import UIKit
enum STRItemDetail: Int{
    case  STRItemDetailFromSearch = 0
    case  STRItemDetailFromItemScan
    case  STRItemDetailFromCaseDetail
}
class STRInventoryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet var IconWidth: NSLayoutConstraint!
    @IBOutlet var btnImage: UIButton!
    @IBOutlet var vwEditButton: UIView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var tblviewBottomLayout: NSLayoutConstraint!
    @IBOutlet var imgEdit: UIImageView!
    @IBOutlet var btnEdit: UIButton!
    @IBAction func btnImage(sender: AnyObject) {
        if(imageUrl != nil)
        {
            self.presentWithImageURL(imageUrl)
        }
    }

    @IBAction func btnEdit(sender: AnyObject) {
         self.view.endEditing(true)
        if(btnEdit.tag == 0)
        {
        self.editMode = true
        self.tblList.reloadData()
        btnEdit.tag = 1
            self.imgEdit.image = UIImage(imageLiteral: "iconsaveitem");
        }
        else{
            if(validate())
            {
            btnEdit.tag = 0
                self.imgEdit.image = UIImage(imageLiteral: "iconedititem");

            dataSave()
            }
            else{
                return
            }
        }
    }
    var imageUrl: String?
    var locationName: String?
    var titleString: String?
    var skuId: String?
    var sourceScreen: STRItemDetail?
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var tblList: UITableView!
    var editMode: Bool?
    var productDetails = Dictionary<String,AnyObject>()
    var itemList =  [Dictionary<String,AnyObject>]()
    var editedData = [Dictionary<String,AnyObject>]()
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeNavigationforAll(self)
        setUpFont()
        self.editMode = false
        let nib = UINib(nibName: "STRInventoryDetailTableViewCell", bundle: nil)
        self.tblList.registerNib(nib, forCellReuseIdentifier: "STRInventoryDetailTableViewCell")
        
        switch sourceScreen! {
        case .STRItemDetailFromSearch:
            self.vwEditButton.hidden = true
            self.dataFeeding()
            break
        case .STRItemDetailFromItemScan:
            self.vwEditButton.hidden = false
            self.dataFeeding()

            break
        case .STRItemDetailFromCaseDetail:
            self.vwEditButton.hidden = true
            self.dataFeeding2()
            break
        }
        
            addKeyboardNotifications()
        let vw = STRNavigationTitle.setTitle(self.titleString!, subheading: self.locationName!)
        
        vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
        
        self.navigationItem.titleView = vw
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }

    
    
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.tblviewBottomLayout.constant = keyboardFrame.size.height
        }) { (completed: Bool) -> Void in
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.tblviewBottomLayout.constant = 0.0
        }) { (completed: Bool) -> Void in
            
        }
    }

    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func backToDashbaord(sender: AnyObject) {
       self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: STRInventoryDetailTableViewCell = self.tblList.dequeueReusableCellWithIdentifier("STRInventoryDetailTableViewCell") as! STRInventoryDetailTableViewCell
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        
       cell.setUpCellData(self.itemList[indexPath.row], indexPath: indexPath, editMode: self.editMode!)
        cell.blockTextFeild = {(indexPath) in
            self.tblList.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true);
        }
        cell.blockTextFeildData = { (data,index) in
        var dict = self.itemList[index.row]
            self.editedData.append(["quantity":data,"productId":dict["productId"] as! NSInteger,"skuId":dict["skuId"] as! NSInteger])
        dict["newQuantity"] = data
        self.itemList[index.row] = dict
        }
        return cell
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71
    }
    func dataFeeding(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["skuId": self.skuId!], serviceType: .STRApiGetInventory, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],let readerGetItemInventoryResponse = data["readerGetItemInventoryResponse"] as? Dictionary<String,AnyObject>,let productDetails = readerGetItemInventoryResponse["productDetails"] as? Dictionary<String,AnyObject>, let items = readerGetItemInventoryResponse["items"] as? [Dictionary<String,AnyObject>] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.productDetails.removeAll()
                self.itemList.removeAll()
                self.productDetails =  productDetails
                self.itemList.appendContentsOf(items)
                self.setUpData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
            
        }
    }
    func dataFeeding2(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["skuId": self.skuId!,"caseNo": self.titleString!], serviceType: .STRApiGetCaseItemDetails, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],let readerGetCaseItemQuantityResponse = data["readerGetCaseItemQuantityResponse"] as? Dictionary<String,AnyObject>,let productDetails = readerGetCaseItemQuantityResponse["productDetails"] as? Dictionary<String,AnyObject>, let items = readerGetCaseItemQuantityResponse["items"] as? [Dictionary<String,AnyObject>] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.productDetails.removeAll()
                self.itemList.removeAll()
                self.productDetails =  productDetails
                self.itemList.appendContentsOf(items)
                self.setUpData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
            
        }
    }

    func dataSave(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["items":self.editedData], serviceType: .STRApiUpdateItemInventory, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],let _ = data["ReaderUpdateItemInventoryResponse"] as? Dictionary<String,AnyObject> else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                self.editMode = false
                self.btnEdit.tag = 0
                self.editedData.removeAll()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.dataFeeding()
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                NSLog(" %@", err)
            }
            
        }
    }

    func setUpData(){
        self.tblList.reloadData()
        self.lbl1.text =  self.productDetails["code"] as? String
        self.lbl2.text = self.productDetails["name"] as? String
        self.lbl3.text = self.productDetails["category"] as? String
        let arr = self.productDetails["images"] as? [AnyObject]
        if(arr != nil && arr?.count > 0)
        {
        let dict = arr!.first as? Dictionary<String,String>
        if(dict != nil)
        {
         let img = dict!["thumb"]
         self.imageUrl = dict!["full"]
        let url = NSURL(string: img!)
         self.imgProfile.sd_setImageWithURL(url)
        }
        }
        let child = self.productDetails["haveChild"] as? Int
        if(child == 0)
        {
            self.imgEdit.image = UIImage(named: "editdisabled")
            self.btnEdit.userInteractionEnabled = false
        }

        self.tblList.reloadData()
    }
    
    func setUpFont(){
       self.lbl2.font =  UIFont.init(name: "SourceSansPro-Regular", size: 16.0)
        self.lbl1.font = UIFont.init(name: "SourceSansPro-Semibold", size: 18.0)
        self.lbl3.font = UIFont.init(name: "SourceSansPro-Regular", size: 16.0)
        self.imgProfile.layer.cornerRadius = 3
    }
    
    func validate()->(Bool){
        if(editedData.count == 0)
        {
           utility.createAlert("", alertMessage: "Nothing to save", alertCancelTitle: "OK", view: self)
           return false
        }
        return true
    }
    func presentWithImageURL(url:String?){
        let vw = STRImageViewController(nibName: "STRImageViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: vw)
        vw.imageURL = url
        self.navigationController?.presentViewController(nav, animated: true, completion: nil)
    }

}
