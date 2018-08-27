import UIKit

class ITemLocatorCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var sideSubTitleLabel: UILabel!
    @IBOutlet weak var sideTitlelabel: UILabel!
    @IBOutlet weak var subtitlelabel: UILabel!
    @IBOutlet weak var caseNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      setUpFont()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpFont(){
    }
}
