import UIKit

class STRSearchSegment: UIView {
@IBOutlet var vwYello1: UIView!
@IBOutlet var vwYello3: UIView!
@IBOutlet var lblAll: UILabel!
@IBOutlet var lblAlert: UILabel!
@IBOutlet var imgAll: UIImageView!
@IBOutlet var imgAlert: UIImageView!
    var selectedSegment: NSInteger?
var blockSegmentButtonClicked: ((NSInteger)->())?
 override func awakeFromNib() {
    setUpFont()
    }
    func setUpFont(){
       lblAll.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
       lblAll.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        lblAlert.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
        lblAlert.textColor = UIColor(colorLiteralRed: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1.0)
       vwYello1.hidden=false
       vwYello3.hidden=true
       imgAll.image = UIImage(named: "iconcaseon")
       imgAlert.image = UIImage(named: "iconitemoff")
    }
    func  setSegment(segement:NSInteger){
        selectedSegment =  segement
        switch segement {
        case 0:
            lblAll.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
            lblAlert.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
            lblAll.textColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1.0)
            lblAlert.textColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0)
            vwYello1.hidden=false
            vwYello3.hidden=true
            imgAll.image = UIImage(named: "iconcaseon")
            imgAlert.image = UIImage(named: "iconitemoff")
            
            break;
        case 2:
            lblAll.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
            lblAlert.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
            lblAll.textColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0)
            lblAlert.textColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0)
            vwYello1.hidden=true
            vwYello3.hidden=true
            imgAll.image = UIImage(named: "iconcaseoff")
            imgAlert.image = UIImage(named: "iconitemoff")
            break;
        case 1:
            lblAll.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
            lblAlert.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
            lblAll.textColor = UIColor(colorLiteralRed: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0)
            lblAlert.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vwYello1.hidden=true
            vwYello3.hidden=false
            imgAll.image = UIImage(named: "iconcaseoff")
            imgAlert.image = UIImage(named: "iconitemon")
            break;
        default:
            break;
        }

    }
    @IBAction func btnSection(sender: UIButton){
        self.setSegment(sender.tag)
        self.blockSegmentButtonClicked!(sender.tag)
    }
}
