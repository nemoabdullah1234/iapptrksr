import UIKit

class STRSuggestedTableViewCell: UITableViewCell {

    @IBOutlet var lblSuggestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUpCell(text:String){
        self.lblSuggestion.text = text
        lblSuggestion.font =  UIFont(name: "SourceSansPro-Regular", size: 14.0)
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
