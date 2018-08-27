import UIKit

class STRHeaderViewCaseDetail: UIView {
    
    @IBOutlet var layoutCallHeight: NSLayoutConstraint!
    @IBOutlet var lblStart: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblDelivered: UILabel!
    @IBOutlet var lblDeliveredDate: UILabel!
    
    @IBOutlet var imgIntransitTruck: UIImageView!
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
    
    static func headerViewForDict(dataDict:Dictionary<String,AnyObject>)->STRHeaderViewCaseDetail{
        let vw = NSBundle.mainBundle().loadNibNamed("STRHeaderViewCaseDetail", owner: nil, options: nil)!.last as! STRHeaderViewCaseDetail
        vw.setUpDataOfHeader(dataDict)
        return vw
    }
    func setUpDataOfHeader(dict:Dictionary<String,AnyObject>){
        
        switch dict["shipStatus"] as! NSInteger{
        case 0:
            lblStart.text =  "Order Received"
            lblDelivered.text = "Surgery Date"
            imgIntransitTruck.image = UIImage.init(named: "")
            
            break
        case 10:
            lblStart.text =  "Order Received"
            lblDelivered.text = "Estimated Delivery"
            imgIntransitTruck.image = UIImage.init(named: "iconnewtruck")

            break
        case 20:
            lblStart.text =  "Scheduled"
            lblDelivered.text = "ETD"
            imgIntransitTruck.image = UIImage.init(named: "iconscheduletruck")
            
            break
        case 30:
            lblStart.text =  "Order Soft Shipped"
            lblDelivered.text = "ETD"
            imgIntransitTruck.image = UIImage.init(named: "intransittruck")
            
            break
        case 40:
            lblStart.text =  "Order Shipped"
            lblDelivered.text = "Estimated Delivery"
            imgIntransitTruck.image = UIImage.init(named: "intransittruck")

            break
            
        case 50:
            lblStart.text =  "Order Shipped"
            lblDelivered.text = "Delivered"
            imgIntransitTruck.image = UIImage.init(named: "icondeliveredtruck")
            
            break
        case 60:
            lblStart.text =  "Order Shipped"
            lblDelivered.text = "Delivered"
            imgIntransitTruck.image = UIImage.init(named: "icondeliveredtruck")

            break

        default:
            break
        }
        lblStartDate.text = dict["sl5"] as? String
        lblDeliveredDate.text = dict["sl4"] as? String
        lblDocName.text = dict["l1"] as? String
        lbl2.text = "\(dict["l2"] as! String)  |  \(dict["l7"] as! String)"
        lbl3.text = dict["l3"] as? String
        lblFax.text = "Fax: \(dict["l5"] as! String)"
        lblPhoneNo.text = "\(dict["l4"] as! String)"
        
        if(lblPhoneNo == "" && dict["l5"] as! String == "" )
        {
            layoutCallHeight.constant = 0
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
        lblStart.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblStartDate.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblDelivered.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblDeliveredDate.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblDocName.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        lbl2.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lbl3.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblFax.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblPhoneNo.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
        vwBasePhone.layer.cornerRadius = 15
        vwBasePhone.backgroundColor = UIColor(red: 250.0/255.0, green: 180.0/255.0, blue: 0.0, alpha: 1.0)

    }
}
