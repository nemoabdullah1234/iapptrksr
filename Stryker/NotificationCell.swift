import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var imgIcon: UIImageView!

    @IBOutlet var lbl1: UILabel!
    
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpFont()
        lbl2.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }

    func setUpFont(){
       lbl1.font = UIFont(name: "SourceSansPro-Regular", size: 18.0);
       lbl2.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
       lbl3.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
    }

    func setUpData(dict:Dictionary<String,AnyObject>){
         lbl1.text = dict["title"] as? String
         lbl2.text = dict["message"] as? String
         lbl3.text = dict["notificationDateTime"] as? String
        
        switch dict["notificationType"] as! NSInteger {
        case 4,5,7,8,2,10,12,11:
            
            imgIcon.image = UIImage.init(named: "iconreport")
            break
        case 6:
            imgIcon.image = UIImage.init(named: "inoti")
            break
            
        case 1,3,9,13,15,16,14,17,18:
            imgIcon.image = UIImage.init(named: "bell")
            break
        default:
            imgIcon.image = UIImage.init(named: "bell")
            break
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
