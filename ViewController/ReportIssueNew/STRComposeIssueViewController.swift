import UIKit

class STRComposeIssueViewController: UIViewController ,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate {
    
    
    @IBOutlet var vwSave: UIView!
    
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var tblItems: UITableView!
    @IBOutlet var fileSlider: CSFileSlideView!
    @IBOutlet var tvComment: UITextView!
    @IBOutlet var botmLayout: NSLayoutConstraint!
    @IBOutlet var lblPlaceHolder: UILabel!
    
    var reportType:STRTypeOfReport?
    var trackingID: String!
    var itemsArray: [Dictionary<String,AnyObject>]?
    var dataPath: String?
    var imagePicker = UIImagePickerController()
    var selectedImage : UIImage?
    var selectedSku : [String]?
    var caseNo:String?
    var shippingNo:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TitleName.ReportIssue.rawValue
        selectedSku = [String]()
        customizeNavigationforAll(self)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        self.createDirectory()
        self.addKeyboardNotifications()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "STRItemsTableViewCell", bundle: nil)
        tblItems.registerNib(nib, forCellReuseIdentifier: "STRItemsTableViewCell_")
        if(reportType == .STRReportCase)
        {
            let vw = STRNavigationTitle.setTitle("Notes", subheading: "\(self.trackingID!)")
            vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
            self.navigationItem.titleView = vw

        }
        else{
            let vw = STRNavigationTitle.setTitle("Notes", subheading: "\(self.trackingID!)")
            vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
            self.navigationItem.titleView = vw
            self.lbl2.hidden = true
            self.tblItems.hidden = true
            self.tblItems.dataSource = nil
            self.tblItems.delegate =  nil
        }

       
        // Do any additional setup after loading the view.
        setUpFont()
    
    }
        func backToDashbaord(back:UIButton){
            self.deleteDirectory()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func setUpFont(){
        self.vwSave.layer.cornerRadius = 5.0
        self.tvComment.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
        self.lbl2.font =  UIFont(name: "SourceSansPro-Regular", size: 14.0);
        self.lblPlaceHolder.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    @IBAction func btnCam(sender: AnyObject) {
        self.view.endEditing(true)
        self.performSelector(#selector(STRComposeIssueViewController.openCam), withObject: nil, afterDelay: 0.1);
    }
    func openCam(){
        let actionSheetTitle = "Images"; 
        let imageClicked = "Take Picture";
        let ImageGallery = "Choose Photo";
        let  cancelTitle = "Cancel";
        let actionSheet = UIActionSheet(title: actionSheetTitle, delegate: self, cancelButtonTitle: cancelTitle, destructiveButtonTitle: nil, otherButtonTitles:imageClicked , ImageGallery)
        actionSheet.showInView(self.view)

    }
    @IBAction func btnSend(sender: AnyObject) {
        if(self.validate())
        {
            if(reportType == .STRReportCase)
            {
                 self.uploadIssue()
            }
            else{
                 self.uploadIssue2()
            }
           
        }
    }
    func toolBar()-> UIToolbar {
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(STRComposeIssueViewController.done))]
        numberToolbar.sizeToFit()
        return numberToolbar
    }
    func done(){
        self.tvComment?.resignFirstResponder()
    }
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STRComposeIssueViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STRComposeIssueViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.inputAccessoryView = self.toolBar()
        lblPlaceHolder.hidden = true
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            if(self.reportType == .STRReportCase)
            {
                  self.botmLayout.constant = keyboardFrame.size.height - 100
            }
            else{
                
                  self.botmLayout.constant = keyboardFrame.size.height - 50
            }

          
            
        }) { (completed: Bool) -> Void in
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.botmLayout.constant = 0.0
        }) { (completed: Bool) -> Void in

        }
        if(tvComment.text == "")
        {
            self.lblPlaceHolder.hidden = false
        }

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
        func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1)
        {
            imagePicker.sourceType = .Camera
            self.performSelector(#selector(present), withObject: nil, afterDelay: 0)
        }
        else if(buttonIndex == 2)
        {
            imagePicker.sourceType = .PhotoLibrary
            self.performSelector(#selector(present), withObject: nil, afterDelay: 0)
        }
    }
    
    func present(){
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dispatch_async(dispatch_queue_create("directory_write", nil), {
            self.selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
           let compressedImage = compressImage(self.selectedImage!)
           self.selectedImage = UIImage(data:compressedImage,scale:1.0)!
            let  timeStamp = NSDate().timeIntervalSince1970 * 1000.0
            let time = "\(timeStamp)".stringByReplacingOccurrencesOfString(".", withString: "")
            var fileName = ""
            fileName = fileName.stringByAppendingString("PIC_\(time).png")
            let localFilePath = self.dataPath?.stringByAppendingString("/\(fileName)")
            compressedImage.writeToFile(localFilePath!, atomically: true)
            dispatch_async(dispatch_get_main_queue(), {
                 self.fileSlider.addAssetURL(localFilePath)
                });
        });
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.Up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if(reportType == .STRReportCase)
                {
        return self.itemsArray!.count
                }
                else{
               return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: STRItemsTableViewCell = self.tblItems.dequeueReusableCellWithIdentifier("STRItemsTableViewCell_") as! STRItemsTableViewCell
        cell.lbl1.text = self.itemsArray![indexPath.row]["l1"] as? String
        cell.lbl2.text = self.itemsArray![indexPath.row]["l2"] as? String
          if(self.itemsArray![indexPath.row]["sel"] as? NSInteger == 0 || self.itemsArray![indexPath.row]["sel"] == nil)
          {
            cell.btnCheck.setImage(UIImage.init(imageLiteral: "rbunselected") , forState: UIControlState.Normal)
         }
                else
         {
         cell.btnCheck.setImage(UIImage.init(imageLiteral: "rbselected"), forState: UIControlState.Normal)
         }
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.itemsArray![indexPath.row]["sel"] as? NSInteger == 0 || self.itemsArray![indexPath.row]["sel"] == nil)
        {
            self.itemsArray![indexPath.row]["sel"] = 1
            
         self.selectedSku?.append((self.itemsArray![indexPath.row]["skuId"] as? String)!)
        }
        else{
           self.itemsArray![indexPath.row]["sel"] = 0
            
            self.selectedSku?.removeAtIndex((self.selectedSku?.indexOf((self.itemsArray![indexPath.row]["skuId"] as? String)!))! )
        }
        
        self.tblItems.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    //MARK: validation
    func validate()->Bool{
        if(tvComment.text == "")
        {
            utility.createAlert("", alertMessage: "Please enter a comment", alertCancelTitle:"Ok", view: self)
            return false
        }
        
        return true
    }
    func uploadIssue(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"

        let uploadObj = CSUploadMultipleFileApi()
        uploadObj.hitFileUploadAPIWithDictionaryPath(dataPath, actionName: "", idValue: ["caseNo":self.caseNo!,"shippingNo":self.shippingNo!,"comment":self.tvComment.text,"skuIds":self.selectedSku!.joinWithSeparator(",")], successBlock: { (response) in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            loadingNotification = nil

            do {
                let responsed = try NSJSONSerialization.JSONObjectWithData((response as? NSData)!, options:[])
                if(responsed["status"]?!.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(responsed["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                else{
                    self.deleteDirectory()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            catch {
                print("Error: \(error)")
            }
            
        }) { (error) in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            loadingNotification = nil
            print(error)
        }
    }
    
    func uploadIssue2(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        let uploadObj = CSUploadMultipleFileApi()
        uploadObj.hitFileUploadAPIWithDictionaryPath2(dataPath, actionName: "", idValue: ["caseNo":self.caseNo!,"skuId":self.shippingNo!,"comment":self.tvComment.text], successBlock: { (response) in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            loadingNotification = nil
            do {
                let responsed = try NSJSONSerialization.JSONObjectWithData((response as? NSData)!, options:[])
                if(responsed["status"]?!.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                     loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(responsed["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                else{
                     self.deleteDirectory()
                    self.navigationController?.popViewControllerAnimated(true)
                }

            }
            catch {
                print("Error: \(error)")
            }
        }) { (error) in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            loadingNotification = nil
            print(error)
        }
    }

    
}
