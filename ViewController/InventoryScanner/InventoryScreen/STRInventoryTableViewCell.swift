import UIKit
enum STRInventoryStatus: Int{
    case STRInventoryStatusFound = 0
    case STRInventoryStatusNotFound
    case STRInventoryStatusDispute
    case STRInventoryStatusNotBeacon
    case STRInventoryStatusInitial
}
class STRInventoryTableViewCell: UITableViewCell {

    @IBOutlet var lbl1: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var lbl2: UILabel!
    var indexPath: NSIndexPath?
    func setCellData(dict:Dictionary<String,AnyObject>,indexPath:(NSIndexPath))
    {
        self.indexPath = indexPath
        self.lbl1.text = dict["code"] as? String
        self.lbl2.text = dict["name"] as? String
        let itemStatus =  dict["status"] as! NSInteger
        self.imgStatus.hidden = false
        switch  itemStatus{
        case STRInventoryStatus.STRInventoryStatusFound.rawValue:
            self.imgStatus.image = UIImage(imageLiteral:"iconitemverified")
            break
        case STRInventoryStatus.STRInventoryStatusNotFound.rawValue:
            self.imgStatus.image = UIImage(imageLiteral:"iconitemnotverified")
            break
        case STRInventoryStatus.STRInventoryStatusDispute.rawValue:
            self.imgStatus.backgroundColor = UIColor.orangeColor()
            break
        case STRInventoryStatus.STRInventoryStatusNotBeacon.rawValue:
            self.imgStatus.hidden = true
            break
        case STRInventoryStatus.STRInventoryStatusInitial.rawValue:
            
           self.imgStatus.image = UIImage(imageLiteral:"iconinitial")
            break
        default:
            break
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFont()
    }
    func setFont(){
        
          self.lbl1.font =  UIFont(name: "SourceSansPro-Regular", size: 14.0);
        self.lbl2.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0);
    }
    
    
    
    
}
