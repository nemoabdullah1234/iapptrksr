import UIKit

class STRItemSearchCellTableViewCell: UITableViewCell {
    @IBOutlet var lbl1: UILabel!

    @IBOutlet var viewPhoneBase: UIView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var lbl5: UILabel!
    @IBOutlet var lbl4: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var heightOfBottomView: NSLayoutConstraint!
    @IBAction func btnCall(sender: AnyObject) {
        
        var ph = lbl5.text?.stringByReplacingOccurrencesOfString("(", withString: "")
        ph = ph?.stringByReplacingOccurrencesOfString(")", withString: "")
        ph = ph?.stringByReplacingOccurrencesOfString("-", withString: "")
        ph = ph?.stringByReplacingOccurrencesOfString(" ", withString: "")
        if(utility.isPhoneNumber(ph!)){
            let url = NSURL(string: "tel://\(ph!)")
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }

    var indexPath:NSIndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpFont()
    }
    
    func setUpFont(){
        lbl1.font = UIFont(name: "SourceSansPro-Regular", size:14)
        lbl2.font = UIFont(name: "SourceSansPro-Semibold", size:18)
        lbl3.font = UIFont(name: "SourceSansPro-Regular", size:14)
        lbl4.font = UIFont(name: "SourceSansPro-Semibold", size:16)
        lbl5.font = UIFont(name: "SourceSansPro-Regular", size:16)
        self.viewPhoneBase.layer.cornerRadius = self.viewPhoneBase.bounds.height/2
    }
    
    func setUpCellData(dict:Dictionary<String,AnyObject>,indexPath:NSIndexPath)
    {
        lbl1.text = dict["h1"] as? String
        lbl2.text = dict["h2"] as? String
        lbl3.text = dict["l3"] as? String
        if(dict["isCaseAssociated"] as? NSInteger == 1)
        {
        heightOfBottomView.constant = 50;
        lbl4.text = dict["l1"] as? String
        lbl5.text = dict["l2"] as? String
        img1.hidden = true
        }
        else
        {
        heightOfBottomView.constant = 0;
        img1.hidden = true
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
