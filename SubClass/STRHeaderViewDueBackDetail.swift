import UIKit

class STRHeaderViewDueBackDetail: UIView {
    @IBOutlet var lblDueBackDate: UILabel!
    
    @IBOutlet var heightCall: NSLayoutConstraint!
    @IBOutlet var lblStart: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblDelivered: UILabel!
    @IBOutlet var lblDeliveredDate: UILabel!
    
    @IBOutlet var lblDocName: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl4: UILabel!
    
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var imgPhoneIcon: UIImageView!
    
    @IBOutlet var vwBasePhone: UIView!
    
    @IBOutlet var lblFax: UILabel!
    
    @IBOutlet var btnCall: UIButton!
    
    @IBAction func btnCall(sender: AnyObject) {
        var ph = lblPhoneNo.text?.stringByReplacingOccurrencesOfString("(", withString: "")
        ph = ph?.stringByReplacingOccurrencesOfString(")", withString: "")
        ph = ph?.stringByReplacingOccurrencesOfString("-", withString: "")
        ph = ph?.stringByReplacingOccurrencesOfString(" ", withString: "")
        if(utility.isPhoneNumber(ph!)){
            let url = NSURL(string: "tel://\(ph!)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    static func headerViewForDict(dataDict:Dictionary<String,AnyObject>)->STRHeaderViewDueBackDetail{
        let vw = NSBundle.mainBundle().loadNibNamed("STRHeaderViewDueBackDetail", owner: nil, options: nil)!.last as! STRHeaderViewDueBackDetail
        vw.setUpDataOfHeader(dataDict)
        return vw
    }
    func setUpDataOfHeader(dict:Dictionary<String,AnyObject>){
        
        lblDocName.text = dict["l1"] as? String
        lbl2.text =  "\(dict["l2"] as! String) | \(dict["l8"] as! String)"
        lbl3.text = dict["l3"] as? String
        lblFax.text = "Fax: \(dict["l5"] as! String)"
        lblPhoneNo.text = "\(dict["l4"] as! String)"
        lblDueBackDate.text = dict["l6"] as? String
        if(lblPhoneNo == "" && dict["l5"] as! String == "" )
        {
            heightCall.constant = 0
        }
        if(lblPhoneNo.text == "")
        {
            vwBasePhone.hidden = true
        }
        if(dict["l5"] as! String == "")
        {
            lblFax.text = ""
        }

    }
    override func awakeFromNib() {
        lblDueBackDate.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        lblDocName.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        lbl2.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lbl3.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblFax.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblPhoneNo.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
        vwBasePhone.layer.cornerRadius = 15
        vwBasePhone.backgroundColor = UIColor(red: 250.0/255.0, green: 180.0/255.0, blue: 0.0, alpha: 1.0)
    }
}
