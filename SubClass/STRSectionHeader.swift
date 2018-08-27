import UIKit

class STRSectionHeader: UIView {
    var index: NSInteger?
    var closure: ((NSInteger)->())?
    var closureReportIssue: ((NSInteger)->())?
    @IBOutlet var imgSectionHeader: UIImageView!
    @IBOutlet var lblTRID: UILabel!
    @IBOutlet var lblTRCooment: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBAction func btnHeader(sender: AnyObject) {
        
        if((closure) != nil)
        {
            closure!(index!)
        }
        
    }

    @IBAction func btnReportIssue(sender: AnyObject) {
        if((closureReportIssue) != nil)
        {
            closureReportIssue!(index!)
        }

        
    }
    override func awakeFromNib() {
        self.layer.borderWidth=1
        self.layer.borderColor=UIColor.blackColor().CGColor
        setUpFont()
    }
    func setUpFont(){
    }
  
}
