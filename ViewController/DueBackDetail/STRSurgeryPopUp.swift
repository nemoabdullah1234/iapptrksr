import UIKit
import PhoneNumberKit

class STRSurgeryPopUp: UIView,UITextFieldDelegate {
    
    @IBOutlet var vwSave: UIView!
    @IBOutlet var vwPopUp: UIView!
    @IBOutlet var txtFirstName: B68UIFloatLabelTextField!
    @IBOutlet var txtLastName: B68UIFloatLabelTextField!
    @IBOutlet var lblSave: UILabel!
    
    var dataPath: String?
    var navController : UINavigationController!
    @IBOutlet var txtPhone: B68UIFloatLabelTextField!
    
    @IBOutlet var txtCountryCode: B68UIFloatLabelTextField!
    
    var  signatureImage : UIImage!
    
    @IBOutlet var bottomSpace: NSLayoutConstraint!
    
    @IBOutlet var centerAlignment: NSLayoutConstraint!
    
    @IBAction func btnSave(sender: AnyObject) {
        if(validate())
        {
            self.updateData()
        }
    }
    @IBOutlet var btnSave: UIButton!
    @IBAction func btnSignature(sender: AnyObject) {
        
        let strSignature = STRSignatureViewController.init(nibName: "STRSignatureViewController", bundle: nil)
        strSignature.fullName =  txtFirstName.text
        strSignature.phoneSTr =  txtPhone.text
        
        strSignature.blockGetImage = {(image) in
            self.signatureImage   = image
            print(self.signatureImage)
        }
        navController.presentViewController(strSignature, animated: true, completion:nil)
        
    }
    @IBOutlet weak var btnSignature: UIButton!
    var codeBlock: ((Dictionary<String,String>)->())?
    var caseNo:String?
    var phoneNumber:String?
    let phoneNumberKit = PhoneNumberKit()
    override func awakeFromNib() {
        setUpFont()
    }
    @IBAction func btnCancel(sender: AnyObject) {
          self.removeFromSuperview()
    }
    
    @IBOutlet var btnCancel: UIButton!
    func setUpFont(){
        self.vwPopUp.layer.cornerRadius = 10.0
        self.vwSave.layer.cornerRadius = 5.0

        lblSave.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        btnCancel.titleLabel?.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        txtLastName.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        txtFirstName.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        txtCountryCode.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        txtPhone.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 14.0)! // Note the !
        ]
        txtLastName.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes:attributes)
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes:attributes)
        txtCountryCode.attributedPlaceholder = NSAttributedString(string: "PHONE", attributes:attributes)
    }
    
    func setUpTitle(title:Dictionary<String,String>){
      self.txtFirstName.text = title["reviewerFirstName"]
      self.txtLastName.text = title["reviewerLastName"]
      self.txtCountryCode.text = title["reviewerCountryCode"]
      self.txtPhone.text = title["reviewerMobile"]
        
    }
    
    func canRotate() -> Void {}
    
    static func sectionView(title:Dictionary<String,String>)->STRSurgeryPopUp{
        let vw = NSBundle.mainBundle().loadNibNamed("STRSurgeryPopUp", owner: nil, options: nil)!.last as! STRSurgeryPopUp
        vw.setUpTitle(title)
        return vw
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {

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
            MBProgressHUD.hideAllHUDsForView(self, animated: true)
            createAlert(TextMessage.notValidNumber.rawValue, alertMessage: "", alertCancelTitle: "OK")
            istrue = false
            print("Something went wrong")
        }
        return istrue!
    }
    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    
    {
        if(textField == self.txtCountryCode)
        {
        let numberOnly = NSCharacterSet(charactersInString: "0123456789+")
        let stringFromTextField = NSCharacterSet(charactersInString: string)
        let strValid = numberOnly.isSupersetOfSet(stringFromTextField)
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
        return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
         return (newLength<=4 && strValid)
        }
        if(textField == self.txtPhone)
        {
            let numberOnly = NSCharacterSet(charactersInString: "0123456789")
            let stringFromTextField = NSCharacterSet(charactersInString: string)
            let strValid = numberOnly.isSupersetOfSet(stringFromTextField)
            return strValid
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
          func validate()->Bool{
        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
        if(txtFirstName.text == "" && txtLastName.text == "" && txtPhone.text == "" && txtCountryCode.text == "")
        {
            utility.createAlert("", alertMessage: "Enter name", alertCancelTitle: "OK", view: rootViewController)
            return false
            
        }
        if(txtFirstName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" )
        {
            utility.createAlert("", alertMessage: "Enter first name", alertCancelTitle: "OK", view: rootViewController)
            return false
            
        }
        if(txtLastName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "")
        {
            utility.createAlert("", alertMessage: "Enter last name", alertCancelTitle: "OK", view: rootViewController)
            return false
            
        }
            if(txtCountryCode.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "")
            {
                utility.createAlert("", alertMessage: "Enter country code", alertCancelTitle: "OK", view: rootViewController)
                return false
                
            }
            if(txtPhone.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "")
            {
                utility.createAlert("", alertMessage: "Enter phone number", alertCancelTitle: "OK", view: rootViewController)
                return false
                
            }
            if(txtCountryCode.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "" && txtPhone.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "" )
            {
                if(txtCountryCode.text?.containsString("+") == true)
                {
                 phoneNumber = txtCountryCode.text! + txtPhone.text!
                }
                else {
                     phoneNumber = "+" + txtCountryCode.text! + txtPhone.text!
                }
                return parseNumber(phoneNumber!)
            }
        return true
    }

    

    func updateData(){
            var loadingNotification = MBProgressHUD.showHUDAddedTo(self.superview, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
        
            loadingNotification.labelText = "Loading"
        
        var infoDict : [String : AnyObject] = ["reviewerFirstName":txtFirstName.text!,"reviewerLastName":txtLastName.text!,"caseNo":self.caseNo!,"reviewerMobile":self.txtPhone.text!,"reviewerCountryCode":(txtCountryCode.text?.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "+")))!]
        
        if(self.signatureImage != nil)
        {
            let signatureData = UIImagePNGRepresentation(self.signatureImage) as NSData?
            infoDict = ["reviewerFirstName":txtFirstName.text!,"reviewerLastName":txtLastName.text!,"caseNo":self.caseNo!,"reviewerMobile":self.txtPhone.text!,"reviewerCountryCode":(txtCountryCode.text?.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "+")))!,"surgerysignature":signatureData!]
        }
        
        let uploadObj = CSUploadMultipleFileApi()
        uploadObj.hitFileUploadAPIWithDictionaryPath3(dataPath, actionName: "", idValue: infoDict, successBlock: { (response) in
            do {
                let responsed = try NSJSONSerialization.JSONObjectWithData((response as? NSData)!, options:[])
                        print(responsed)
                        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
                        if(responsed["status"]?!.integerValue != 1)
                        {
                            MBProgressHUD.hideAllHUDsForView(self.superview, animated: true)
                            loadingNotification = nil
    
                            utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(responsed["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: rootViewController)
                            self.removeFromSuperview()
                            return
                        }
                        guard let data = responsed["data"] as? [String:AnyObject],let readerSubmitSurgeryReportResponse = data["ReaderSubmitSurgeryReportResponse"] as? Dictionary<String,String> else{
                            MBProgressHUD.hideAllHUDsForView(self.superview, animated: true)
                            utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: rootViewController)
                            self.removeFromSuperview()
                            return
                        }
                       self.codeBlock!(readerSubmitSurgeryReportResponse)
                        MBProgressHUD.hideAllHUDsForView(self.superview, animated: true)
                        self.removeFromSuperview()
    
                }
            catch {
                print("Error: \(error)")
            }
            
        }) { (error) in
            MBProgressHUD.hideAllHUDsForView(self.superview, animated: true)
            self.removeFromSuperview()
            NSLog(" %@", error)
        }
        

    }
}
