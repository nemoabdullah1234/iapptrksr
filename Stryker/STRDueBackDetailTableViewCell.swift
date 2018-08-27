import UIKit

class STRDueBackDetailTableViewCell: UITableViewCell {
    @IBOutlet var bseviewComment: UIView!
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var lblItem: UILabel!
    @IBOutlet var btnSwitch: SevenSwitch!
    @IBOutlet var imgComment: UIImageView!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var imgStatus: UIImageView!
    @IBAction func btnComment(sender: AnyObject) {
        self.blockCommentBtn!(self.index!)
    }
    var blockDueBackCell: ((NSInteger,Bool)->())?
    var blockCommentBtn :((NSInteger)->())?
    var index :NSInteger?
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpFont()
        
    }
    @IBAction func btnSwitch(sender: AnyObject) {
        self.blockDueBackCell!(self.index!,sender.on)
    }
    func setUpFont(){
        lblCode.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblItem.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
         self.bseviewComment.layer.cornerRadius=4.0
        self.btnComment.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 13.0);
    }
    
    func setUpData(dict:Dictionary<String,AnyObject> ,IndexPath index:NSInteger){
        self.index = index
        lblCode.text = (dict["l1"] as? String)?.uppercaseString
        lblItem.text = dict["l2"] as? String
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
