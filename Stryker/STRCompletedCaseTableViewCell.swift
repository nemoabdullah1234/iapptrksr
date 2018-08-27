import UIKit

class STRCompletedCaseTableViewCell: UITableViewCell {

    @IBOutlet var vwCommentBase: UIView!
    @IBAction func btnComment(sender: AnyObject) {
          self.blockCommentBtn!(self.index!)
    }
    @IBOutlet var   btnComment: UIButton!
    @IBOutlet var  lblStatus: UILabel!
    @IBOutlet var  lblItem: UILabel!
    @IBOutlet var  lblCode: UILabel!
    var blockCommentBtn :((NSInteger)->())?
    var index :NSInteger?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpFont()
    }
    func setUpFont(){
        lblCode.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblItem.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        self.vwCommentBase.layer.cornerRadius=4.0
         self.btnComment.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 13.0);
    }
    func setUpData(dict:Dictionary<String,AnyObject> ,IndexPath index:NSInteger){
        self.index = index
        lblCode.text = (dict["l1"] as? String)?.uppercaseString
        lblItem.text = dict["l2"] as? String
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
