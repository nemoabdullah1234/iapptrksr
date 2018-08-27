import UIKit

class STRSurgeryListInventoryTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var txtQuantity: UITextField!
    
    var blockTextFeild: ((NSIndexPath)->())?
    var blockTextFeildData: ((NSInteger,NSIndexPath)->())?
    var indexPath: NSIndexPath?
    var cellData: Dictionary<String,AnyObject>?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFont()
    }
    func setFont(){
        self.lbl1.font =  UIFont(name: "SourceSansPro-Regular", size: 14.0)
        self.lbl2.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0)
         self.lbl3.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0)
        txtQuantity.delegate = self
    }
    func setUpCellData(dict: Dictionary<String,AnyObject>, indexPath:NSIndexPath, editMode:Bool){
        self.indexPath = indexPath
        self.cellData = dict
        textEditable(true)
        self.lbl1.text = dict["code"] as? String
        self.lbl2.text =  dict["name"] as? String
        self.lbl3.text =  "Quantity: \(dict["quantity"] as! NSInteger)"
        let qunatity = dict["newUsedQuantity"] as? NSInteger
        
        if(qunatity == nil)
        {
            self.txtQuantity.text = "\(dict["usedQuantity"] as! NSInteger)"
        }
        else{
            self.txtQuantity.text = "\(qunatity!)"
            
        }
    }
    func textEditable(editMode: Bool){
        if(editMode)
        {
            txtQuantity.userInteractionEnabled = true
            txtQuantity.borderStyle = UITextBorderStyle.RoundedRect
            txtQuantity.delegate = self
            txtQuantity.borderStyle = UITextBorderStyle.RoundedRect
            self.txtQuantity.layer.borderWidth = 1.0
            self.txtQuantity.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1).CGColor

        }
        else{
            txtQuantity.userInteractionEnabled = false
            txtQuantity.borderStyle = UITextBorderStyle.None
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.blockTextFeild!(self.indexPath!)
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        if(textField.text != nil && textField.text != "")
        {
            let total = self.cellData!["quantity"] as! NSInteger
            let new  = Int(textField.text!)!
            if(new > total)
            {
                let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
                
                utility.createAlert("", alertMessage: "Used Quantity cannot be more then total quantity", alertCancelTitle: "Ok", view: rootViewController)
                let qunatity = self.cellData!["newUsedQuantity"] as? NSInteger
                if(qunatity == nil)
                {
                    self.txtQuantity.text = "\(self.cellData!["usedQuantity"] as! NSInteger)"
                }
                else{
                    self.txtQuantity.text = "\(qunatity!)"
                    
                }
                return
            }
            
                self.blockTextFeildData!(Int(textField.text!)!,self.indexPath!)
        }
        else{
            let qunatity = self.cellData!["newUsedQuantity"] as? NSInteger
            if(qunatity == nil)
            {
                self.txtQuantity.text = "\(self.cellData!["usedQuantity"] as! NSInteger)"
            }
            else{
                self.txtQuantity.text = "\(qunatity!)"
                
            }
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
        
    {
        let numberOnly = NSCharacterSet(charactersInString: "0123456789")
        let stringFromTextField = NSCharacterSet(charactersInString: string)
        let strValid = numberOnly.isSupersetOfSet(stringFromTextField)
        return strValid
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    
}
