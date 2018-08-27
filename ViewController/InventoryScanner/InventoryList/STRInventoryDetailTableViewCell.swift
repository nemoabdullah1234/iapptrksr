import UIKit

class STRInventoryDetailTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var txtQty: UITextField!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl1: UILabel!
    var blockTextFeild: ((NSIndexPath)->())?
    var blockTextFeildData: ((NSInteger,NSIndexPath)->())?
    var indexPath: NSIndexPath?
    var cellData: Dictionary<String,AnyObject>?
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        // Initialization code
    }
    
    func setUpCellData(dict: Dictionary<String,AnyObject>, indexPath:NSIndexPath, editMode:Bool){
        self.indexPath = indexPath
        self.cellData = dict
        textEditable(editMode)
        self.lbl1.text = dict["code"] as? String
        self.lbl2.text =  dict["name"] as? String
        
        let qunatity = dict["newQuantity"] as? NSInteger
        
        if(qunatity == nil)
        {
        self.txtQty.text = "\(dict["quantity"] as! NSInteger)"
        }
        else{
            self.txtQty.text = "\(qunatity!)"

        }
    }
    func setFont(){
        self.lbl1.font =  UIFont(name: "SourceSansPro-Regular", size: 14.0)
        self.lbl2.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0)
        self.txtQty.layer.borderWidth = 1.0
        self.txtQty.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1).CGColor
    }
    func textEditable(editMode: Bool){
        if(editMode)
        {
        txtQty.userInteractionEnabled = true
        txtQty.borderStyle = UITextBorderStyle.RoundedRect
              self.txtQty.layer.borderWidth = 1.0
        self.txtQty.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1).CGColor
        txtQty.delegate = self
        }
        else{
            txtQty.userInteractionEnabled = false
            txtQty.borderStyle = UITextBorderStyle.None
              self.txtQty.layer.borderWidth = 0.0
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.blockTextFeild!(self.indexPath!)
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.text != nil && textField.text != "")
        {
        self.blockTextFeildData!(Int(textField.text!)!,self.indexPath!)
        }
        else{
            let qunatity = self.cellData!["newQuantity"] as? NSInteger
            
            if(qunatity == nil)
            {
                self.txtQty.text = "\(self.cellData!["quantity"] as! NSInteger)"
            }
            else{
                self.txtQty.text = "\(qunatity!)"
                
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
