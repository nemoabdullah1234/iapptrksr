import UIKit

class SettingWithSwitchCell: UITableViewCell {

    @IBOutlet var labelName : UILabel?
    @IBOutlet var switchControl : SevenSwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         switchControl!.transform = CGAffineTransformMakeScale(0.75, 0.75);
        labelName!.font =  UIFont(name: "SourceSansPro-Semibold", size: 15.0);
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
