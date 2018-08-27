import UIKit
import PhoneNumberKit


class EditViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,  UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate{
    
    @IBOutlet var vwSave: UIView!
    @IBOutlet var bottomLayout: NSLayoutConstraint!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet var lastnameText: B68UIFloatLabelTextField!
    
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var countryCodeText: UITextField!
    
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet var pickerView : UIPickerView?
    let phoneNumberKit = PhoneNumberKit()
     var currentView : UITextField?
    
    let imagePicker = UIImagePickerController()
  
    var removeLocally : Bool! = false
    var selectedImage : UIImage?
    var dataArrayObj : NSArray?
    var dataSortValue : NSArray?
    var sortCountryCode : String?
    var responseData : ((Dictionary<String,AnyObject>)->())?
    var countryArray : NSArray?
    var isImageChanged : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
         isImageChanged = false
        self.title = "Edit Profile"
        customizeNavigationforAll(self)
        self.navigationController?.navigationBar.translucent = false
        imagePicker.delegate = self
    
        getUSerProfile()
        getCountries()
        setUpFont()
        addKeyboardNotifications()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UPDATEPROFILENOTIFICATION", object: nil))
    }
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0, animations: { () -> Void in
                self.bottomLayout.constant = keyboardFrame.size.height
        }) { (completed: Bool) -> Void in
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0, animations: { () -> Void in
             self.bottomLayout.constant = 0.0
        }) { (completed: Bool) -> Void in
            
        }
    }
    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func setUpFont()
    {
        self.vwSave.layer.cornerRadius = 5.0
        nameLabel.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
        btnSave.titleLabel?.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        passwordText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        confirmText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        emailText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        nameText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        lastnameText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        countryCodeText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        phoneText.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 14.0)! // Note the !
        ]
        passwordText.attributedPlaceholder = NSAttributedString(string: "NEW PASSWORD", attributes:attributes)
        confirmText.attributedPlaceholder = NSAttributedString(string: "CONFIRM PASSWORD", attributes:attributes)
        emailText.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes:attributes)
        nameText.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes:attributes)
        lastnameText.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes:attributes)

        countryCodeText.attributedPlaceholder = NSAttributedString(string: "PHONE", attributes:attributes)
        phoneText.attributedPlaceholder = NSAttributedString(string: "", attributes:attributes)
    }
   
    override func viewDidLayoutSubviews() {
        scrollView.scrollEnabled = true
        // Do any additional setup after loading the view
        scrollView.contentSize = CGSizeMake(view.frame.width,  view.frame.height + 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToDashbaord(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }

    
    @IBAction func onClickSaveButton(sender: AnyObject) {
        if removeLocally == true {
            deleteImage()
        }
        
        if isValidate() {
            updateUserProfileApi()
        }
        
    }
    
    func updateUserProfileApi() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        responseData = {(dict) in
            if(dict["status"]?.integerValue != 1)
            {
                dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(dict["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue, view:self)
                    return
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.getUSerProfile()
                 utility.createAlert(TextMessage.alert.rawValue, alertMessage: "Profile Updated", alertCancelTitle: TextMessage.Ok.rawValue, view:self)
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UPDATEPROFILENOTIFICATION", object: nil))
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
        
        self.UploadRequest()
        
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if dataArrayObj == nil {
            return 0
        }
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataArrayObj!.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        let aStr = String(format: "%@", (dataArrayObj![row]["countryName"] as? String)!)
        
        return aStr;
        
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }



    @IBAction func onImageClick(sender: AnyObject) {
        
        let actionSheetTitle = ""; 
        let remove       = "Remove"
        let imageClicked = "Take Picture";
        let ImageGallery = "Choose Photo";
        let  cancelTitle = "Cancel";
        let actionSheet = UIActionSheet(title: actionSheetTitle, delegate: self, cancelButtonTitle: cancelTitle, destructiveButtonTitle: nil, otherButtonTitles:remove,imageClicked , ImageGallery)
        actionSheet.showInView(self.view)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            
            isImageChanged = true
            selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            
            selectedImage = selectedImage?.resizeWithV(640)
            profileImage .setBackgroundImage(selectedImage, forState: UIControlState.Normal)
            profileImage!.layer.borderWidth = 1
            profileImage!.layer.masksToBounds = false
            profileImage!.layer.borderColor = UIColor.clearColor().CGColor
            profileImage!.layer.cornerRadius = profileImage!.frame.height/2
            profileImage!.clipsToBounds = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1)
        {
            removeLocally  = true
            self.profileImage .setBackgroundImage(UIImage(named: "default_profile" ), forState:
                UIControlState.Normal)
        }
        else if(buttonIndex == 2)
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .Camera
            self.performSelector(#selector(present), withObject: nil, afterDelay: 0)
            
        }
        else if(buttonIndex == 3)
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            self.performSelector(#selector(present), withObject: nil, afterDelay: 0)
        }
    }
    
    func present(){
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let aStr = String(format: "%@(+%@)", (dataArrayObj![row]["shortCode"] as? String)!, (dataArrayObj![row]["dialCode"] as? String)! )
        countryCodeText.text = aStr
        self.sortCountryCode = dataArrayObj![row]["shortCode"] as? String
    }

    
    func getUSerProfile()->(){
        let generalApiobj = GeneralAPI()
        
        let someDict:[String:String] = ["":""]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiGetUSerProfile, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                guard let data = response["data"] as? [String:AnyObject],readerGetProfileResponse = data["readerGetProfileResponse"] as? [String:AnyObject] else{
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                
                self.setUserDetail(readerGetProfileResponse)
            }
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                NSLog(" %@", err)
            }
        }
        
    }
    
    func setUserDetail(data: Dictionary<String,AnyObject>) -> () {
        self.nameText!.text = "\(data["firstName"]!)"
        self.lastnameText!.text =  "\(data["lastName"]!)"
        self.nameLabel!.text = "\(data["firstName"]!) \(data["lastName"]!)"
        self.phoneText!.text = "\(data["mobile"]!)"
        let aStr = String(format: "%@(+%@)", "\(data["countryCode"]!)", "\(data["countryDialCode"]!)" )
        self.countryCodeText!.text = aStr
        self.emailText!.text = "\(data["email"]!)"
        let url = NSURL(string: "\(data["profileImage"]!)")
        
        
        utility.setUserFirstName(data["firstName"]! as! String)
        utility.setUserLastName(data["lastName"]! as! String)
        utility.setCountryDialCode((data["countryDialCode"] as? String)!)
        utility.setCountryCode((data["countryCode"] as? String)!)

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            if data == nil {return}
            dispatch_async(dispatch_get_main_queue(), {
                
                self.selectedImage = UIImage(data: data!)
                self.profileImage .setBackgroundImage(self.selectedImage, forState:
                    UIControlState.Normal)
                
                self.profileImage!.layer.borderWidth = 1
                self.profileImage!.layer.masksToBounds = false
                self.profileImage!.layer.borderColor = UIColor.whiteColor().CGColor
                self.profileImage!.layer.cornerRadius = self.profileImage!.frame.height/2
                self.profileImage!.clipsToBounds = true
            });
            
        }
    }
    
    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }
    
    func isValidate() -> Bool {
        if nameText.text == "" {
            createAlert(TextMessage.fillFirstName.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
        if lastnameText.text == "" {
            createAlert(TextMessage.fillLastName.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
        
                if phoneText.text == "" {
            
            
            
            createAlert(TextMessage.fillPhone.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
                else{
                    let aStr = String(format: "%@", phoneText.text!)
                    let istrue: Bool =  parseNumber(aStr)
                    if istrue == false {
                        return false
                    }
        }

        if countryCodeText.text == "" {
            createAlert(TextMessage.fillCity.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
               if confirmText.text != passwordText.text {
            createAlert(TextMessage.confirmpassword.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
             return true
    }
    
    func createPicker() {
        
        pickerView = UIPickerView(frame: CGRectMake(0, 250, view.frame.width, 250))
        pickerView!.clipsToBounds = true
        pickerView!.layer.borderWidth = 1
        pickerView!.layer.borderColor = UIColor.lightGrayColor().CGColor
        pickerView!.layer.cornerRadius = 5;
        pickerView!.layer.shadowOpacity = 0.8;
        pickerView!.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        pickerView!.dataSource = self
        pickerView!.delegate = self
        pickerView!.backgroundColor = UIColor.whiteColor()
    }
    
    func getCountries()  {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiGetCountries, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                
                self.dataArrayObj = dataDictionary!["readerGetCountriesResponse"]  as! [AnyObject]
                var names = [String]()
                var countries = [String]()
                for blog in self.dataArrayObj! {
                    if let name = blog["countryName"] as? String {
                        names.append(name)
                    }
                    if let name = blog["dialCode"] as? String {
                        countries.append(name)
                    }
                }
                
                
                self.createPicker()
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }
    
    
    func parseNumber(number: String) -> Bool {
        
        var istrue: Bool?
        
        do {
            let phoneNumber = try PhoneNumber(rawNumber: number)
            print(String(phoneNumber.countryCode))
            if let regionCode = phoneNumberKit.mainCountryForCode(phoneNumber.countryCode) {
                let country = NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: regionCode)
                print(country)
                istrue = true
            }
        }
        catch {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            createAlert(TextMessage.notValidNumber.rawValue, alertMessage: "", alertCancelTitle: "OK")
            istrue = false
            print("Something went wrong")
        }
        return istrue!
    }
    
    func UploadRequest()
    {
        let url = NSURL(string: String(format: "%@%@", Kbase_url, "/reader/updateProfile" ))
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
    
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(utility.getDevice(), forHTTPHeaderField:"deviceId")
        request.setValue("traquer", forHTTPHeaderField:"AppType")
        request.setValue(utility.getUserToken(), forHTTPHeaderField:"sid")
        
        
        
        let body = NSMutableData()
        
        let fname = "test.png"
        let mimetype = "image/png"
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"firstName\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(nameText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"lastName\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(lastnameText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"mobile\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(phoneText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        if(sortCountryCode != nil)
        {
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"countryCode\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(sortCountryCode!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"organization\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Organization\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

        if(passwordText.text != "")
        {
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"password\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(passwordText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        if isImageChanged == true{
            if(selectedImage == nil)
            {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                return
            }
            
            let image_data = UIImageJPEGRepresentation(selectedImage!, 0.0)
            
            if(image_data == nil)
                
            {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                return
                
            }

            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"profileImage\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(image_data!)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves);
            
            self.responseData!(dict as! Dictionary<String, AnyObject>)
        }
        
        task.resume()
        
        
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }

    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == countryCodeText {
            resignText()
            textField.inputView = pickerView
            textField.inputAccessoryView = toolBar()
        }
    }
    func resignText() {
        nameText.resignFirstResponder()
        
        phoneText.resignFirstResponder()
       
        passwordText.resignFirstResponder()
        confirmText.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        currentView = textField
        textField.inputAccessoryView = self.toolBar()
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == phoneText
        {
            let aStr = String(format: "%@", phoneText.text!)
            parseNumber(aStr)
        }
        
    }

    
    func toolBar()-> UIToolbar {
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(STREditProfileVC.nextMove)),
            UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(STREditProfileVC.previousMove)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(STREditProfileVC.done))]
        numberToolbar.sizeToFit()
        return numberToolbar
    }
    
    func  nextMove(){
        if(currentView?.tag<106)
        {
            let vw = self.view.viewWithTag((currentView?.tag)!+1) as? UITextField
            vw?.becomeFirstResponder()
        }
    }
    func previousMove(){
        if(currentView?.tag>101)
        {
            let vw = self.view.viewWithTag((currentView?.tag)!-1) as? UITextField
            vw?.becomeFirstResponder()
        }
        
    }
    func done(){
        
        currentView?.resignFirstResponder()
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        if up == false {
            self.view.frame = CGRectOffset(self.view.frame, 0, +150)
        }else{
            self.view.frame = CGRectOffset(self.view.frame, 0,  -150)
        }
        
        UIView.commitAnimations()
    }
    func deleteImage(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["deleteProfileImage":"1"], serviceType: .STRApiDeleteUserProfile, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UPDATEPROFILENOTIFICATION", object: nil))
                self.profileImage .setBackgroundImage(UIImage(named: "editprofile_default" ), forState:
                    UIControlState.Normal)
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
