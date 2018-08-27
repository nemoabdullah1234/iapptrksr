import UIKit
import AirshipKit
class STRCaseHistoryTableViewCell: UITableViewCell {
    var indexPath: NSIndexPath?
    var closure: ((NSIndexPath)->())?
    var closureSwitch: ((NSIndexPath,Bool)->())?
    private var data : Dictionary<String,AnyObject>?
    @IBOutlet var heightComment: NSLayoutConstraint!
    @IBOutlet var txtComment: UITextView!
    @IBOutlet var lblUsed: UILabel!
    @IBOutlet var btnSwitch: UISwitch!
    
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl1: UILabel!
    override func awakeFromNib() {
               super.awakeFromNib()
        // Initialization code
        setUpFont()
    }
    func setUpFont(){
    }
    @IBAction func btnClicked(sender: UISwitch) {
        if(sender.on)
        {
             self.lblUsed.text = TextMessage.used.rawValue
        }
        else{
             self.lblUsed.text = TextMessage.unused.rawValue
        }
        closureSwitch!(indexPath!,sender.on)
        
    }
   
    // Configure the view for the selected state
    
    
    func setUpdata(data: Dictionary<String,AnyObject>,editable:Bool) -> Void {
        self.data = data
        self.lbl1.text = data["l1"] as! String
        self.lbl2.text = data["l2"] as! String
        self.txtComment.text = data["l3"] as! String
        if(data["l5"]?.integerValue == 1)
        {
            self.btnSwitch.setOn(false, animated: true)
            self.lblUsed.text = TextMessage.unused.rawValue
        }
        else{
            self.btnSwitch.setOn(true, animated: true)
            self.lblUsed.text = TextMessage.used.rawValue

        }
        self.btnSwitch.userInteractionEnabled=editable
    }
    @IBAction func btnExpand(sender: AnyObject) {
        if(closure != nil)
        {
        self.closure!(self.indexPath!)
        }
        
    }

    
}
