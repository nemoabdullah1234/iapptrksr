import UIKit

class STRCaseDetailNewTableViewCell: UITableViewCell {
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var lblItem: UILabel!
    @IBOutlet var imgMissing: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         setUpFont()
        
    }
  
    func setUpFont(){
         lblCode.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
         lblItem.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
           }
    
    func setUpData(dict:Dictionary<String,AnyObject>,IndexPath index:NSInteger){
        lblCode.text = (dict["l1"] as? String)?.uppercaseString 
        lblItem.text =  dict["l2"] as? String
        let isMissing = dict["isMissing"] as? Int
        if(isMissing == 0)
        {
            self.imgMissing.hidden = true
        }
        else if(isMissing != nil){
            self.imgMissing.hidden =  false
            self.imgMissing.image = UIImage(named: "iconitemnotverified")
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
