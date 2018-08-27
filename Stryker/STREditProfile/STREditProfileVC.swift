import UIKit
import PhoneNumberKit

class STREditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,  UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate{

    var currentView : UITextField?
    let phoneNumberKit = PhoneNumberKit()
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var countryCodeText: UITextField!
    @IBOutlet weak var phoneText: PhoneNumberTextField!
    @IBOutlet weak var lastnameText: UITextField!
    @IBOutlet weak var firstnameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet var scrollViewBottom: NSLayoutConstraint!
    var selectedImage : UIImage?
    var dataArrayObj : NSArray?
    var dataSortValue : NSArray?
    var sortCountryCode : String?
    var responseData : ((Dictionary<String,AnyObject>)->())?
    var countryArray : NSArray?
    var isImageChanged : Bool?
    var localTimeZoneAbbreviation: String { return NSTimeZone.localTimeZone().name ?? "UTC" }

    @IBOutlet var scrollView: UIScrollView!
    let imagePicker = UIImagePickerController()
    @IBOutlet var pickerView : UIPickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        isImageChanged = false
        self.title = "Update Profile"
        customizeNavigationforAll(self)
        self.navigationController?.navigationBar.translucent = false
        imagePicker.delegate = self
        scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height + 200)
    
        getUSerProfile()
        self.revealViewController().panGestureRecognizer().enabled = false
        getCountries()
       
    }
    override func viewDidLayoutSubviews() {
        scrollView.scrollEnabled = true
        // Do any additional setup after loading the view
        scrollView.contentSize = CGSizeMake(view.frame.width,  view.frame.height + 200)
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
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
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
    @IBAction func btnDeleteProfile(sender: AnyObject) {
        
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
                self.profileImage .setBackgroundImage(UIImage(named: "default_profile" ), forState:
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let aStr = String(format: "%@(+%@)", (dataArrayObj![row]["shortCode"] as? String)!, (dataArrayObj![row]["dialCode"] as? String)! )
        countryCodeText.text = aStr
        
        self.sortCountryCode = dataArrayObj![row]["shortCode"] as? String
       
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backToDashbaord(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
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
        self.firstnameText!.text = "\(data["firstName"]!)"
        self.lastnameText!.text = "\(data["lastName"]!)"
        self.phoneText!.text = "\(data["mobile"]!)"
        self.cityText!.text = "\(data["city"]!)"
        self.sortCountryCode = "\(data["countryCode"]!)"
        
        let aStr = String(format: "%@(+%@)", "\(data["countryCode"]!)", "\(data["countryDialCode"]!)" )
        self.countryCodeText!.text = aStr
        self.emailText!.text = "\(data["email"]!)"
        let url = NSURL(string: "\(data["profileImage"]!)")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
             if data == nil {return}
            dispatch_async(dispatch_get_main_queue(), {
               
                self.selectedImage = UIImage(data: data!)
                self.profileImage .setBackgroundImage(self.selectedImage, forState:
                    UIControlState.Normal)
                self.profileImage!.layer.borderWidth = 1
                self.profileImage!.layer.masksToBounds = false
                self.profileImage!.layer.borderColor = UIColor.clearColor().CGColor
                self.profileImage!.layer.cornerRadius = self.profileImage!.frame.height/2
                self.profileImage!.clipsToBounds = true
            });
            
        }
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        
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
            
           NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UPDATEPROFILENOTIFICATION", object: nil))
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }
        }
        
        self.UploadRequest()
        
    }
    
    @IBAction func selectimageClicked(sender: AnyObject) {
       
        
        let actionSheetTitle = "Images"; 
        let imageClicked = "Take Photo";
        let ImageGallery = "Select Photo";
        let  cancelTitle = "Cancel";
        let actionSheet = UIActionSheet(title: actionSheetTitle, delegate: self, cancelButtonTitle: cancelTitle, destructiveButtonTitle: nil, otherButtonTitles:imageClicked , ImageGallery)
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
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .Camera
            
            self.performSelector(#selector(present), withObject: nil, afterDelay: 0)
            
        }
        else if(buttonIndex == 2)
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
             self.performSelector(#selector(present), withObject: nil, afterDelay: 0)
        }
    }
    
    func present(){
         self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == countryCodeText {
            resignText()
            textField.inputView = pickerView
            textField.inputAccessoryView = toolBar()
        }
        if textField == cityText {
        }
        if textField == newPasswordText {
            animateViewMoving(true, moveValue: 100)
        }
        if textField == confirmPasswordText {
            animateViewMoving(true, moveValue: 100)
        }
    }
    func resignText() {
        firstnameText.resignFirstResponder()
        lastnameText.resignFirstResponder()
        phoneText.resignFirstResponder()
        cityText.resignFirstResponder()
        newPasswordText.resignFirstResponder()
        confirmPasswordText.resignFirstResponder()
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
        
        if textField == cityText {
        }
        if textField == newPasswordText {
            animateViewMoving(false, moveValue: 100)
        }
        if textField == confirmPasswordText {
            animateViewMoving(false, moveValue: 100)
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneText {
            guard let text = textField.text else { return true }
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= 10
        }
        return true
        
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
    
    
    func addpopup(dataArray : NSArray){
        let popup =  NSBundle.mainBundle().loadNibNamed("STRPopupSort", owner: self, options: nil)! .first as! STRPopupSort
        popup.tag=10001
        popup.sortDataCountry = dataArray as [AnyObject]
        popup.frame=(self.navigationController?.view.frame)!;
        popup.layoutIfNeeded()
        
        self.navigationController?.view.addSubview(popup)
        
        popup.layoutSubviews()
        
        popup.closureTable = {(sortString)in
            
            print(sortString)
            self.sortCountryCode = sortString["shortCode"] as? String
             self.navigationController?.view.viewWithTag(10001)?.removeFromSuperview()
        }
        popup.setUpPopup(4)
        
    }
    
    
    
    
    func isValidate() -> Bool {
        if firstnameText.text == "" {
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
        }else{
            let aStr = String(format: "%@", phoneText.text!)
            let istrue: Bool =  parseNumber(aStr)
            if istrue == false {
                return false
            }
            
        }
        if cityText.text == "" {
            createAlert(TextMessage.fillCity.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
        if firstnameText.text == "" {
            createAlert(TextMessage.fillCountry.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
       
        if confirmPasswordText.text != newPasswordText.text {
            createAlert(TextMessage.confirmpassword.rawValue, alertMessage: "", alertCancelTitle: "OK")
            return false
        }
        return true
    }
    
    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
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
        
        
        let body = NSMutableData()
        
        let fname = "test.png"
        let mimetype = "image/png"
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"firstName\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(firstnameText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"lastName\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(lastnameText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"mobile\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(phoneText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\" \"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(sortCountryCode!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"organization\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Organization\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"timezone\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(localTimeZoneAbbreviation)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"password\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(newPasswordText.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        if isImageChanged == true{
        
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
        if(currentView?.tag<107)
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
    
}

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithV(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
   
    
    
}

