import UIKit


enum STRDashboardCellEnum: Int {
    case STRDashboardCellWithFav = 0
    case STRDashboardCellWithoutFave
    case STRDashBoardCellWithSR
}
class DashBoardTableViewCell: UITableViewCell {
    @IBOutlet var imgVehcile: UIImageView!
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var lblDoc: UILabel!
    @IBOutlet var lblProcedure: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblLocation: MarqueeLabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imgFav: UIImageView!
    @IBOutlet var ibLocation: UIImageView!
    @IBOutlet var imgExclamation: UIImageView!
    @IBOutlet var btnSR: UIView!
    @IBOutlet var btnSRBTN: UIButton!
    @IBOutlet var btnFav: UIButton!
    @IBAction func btnSTRBTN(sender: AnyObject) {
        if(self.blockSR != nil)
        {
            self.blockSR!(indexPath!.row)
        }
    }
    
    
    var buttonTypeDash:STRDashboardCellEnum?
    var blockFav:((NSInteger)->())?
    var blockSR:((NSInteger)->())?
    var indexPath:NSIndexPath?
    var dictData : Dictionary<String,AnyObject>?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpFont()
    }
    
    func setUpFont(){
       lblCode.font = UIFont(name: "SourceSansPro-Regular", size:14)
       lblDoc.font = UIFont(name: "SourceSansPro-Semibold", size:18)
       lblProcedure.font = UIFont(name: "SourceSansPro-Regular", size:14)
       lblLocation.font = UIFont(name: "SourceSansPro-Regular", size:14)
        lblStatus.font = UIFont(name: "SourceSansPro-Semibold", size:12)
        lblDate.font = UIFont(name: "SourceSansPro-Semibold", size:12)
        self.btnSR.layer.cornerRadius=4.0
        self.btnSRBTN.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 10.0);
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpCell(dict:Dictionary<String,AnyObject>? ,indexPath:NSIndexPath){
        switch self.buttonTypeDash! {
        case .STRDashboardCellWithFav:
            self.btnSR.hidden = true
            self.imgFav.hidden = false
            self.btnFav.enabled = true
            break
        case .STRDashboardCellWithoutFave:
             self.imgFav.hidden = true
             self.btnFav.enabled = false
             self.btnSR.hidden = true
            break
        case .STRDashBoardCellWithSR:
            self.imgFav.hidden = true
            self.btnFav.enabled = false
            self.btnSR.hidden = false
            break
        }
        
        self.indexPath = indexPath
        lblCode.text = dict!["caseId"] as? String
        lblDoc.text = dict!["h1"] as? String
        lblProcedure.text = "\(dict!["l1"] as! String)  |  \(dict!["h3"] as! String)"
        lblLocation.text = dict!["l3"] as? String
        lblStatus.text = dict!["l4"] as? String
        lblDate.text = dict!["h2"] as? String
        if(dict!["isWatched"] as? NSInteger == 1)
         {
            imgFav.image = UIImage(named: "fav")
         }
         else
         {
             imgFav.image = UIImage(named: "favsel")
          }
        
        if(dict!["isReported"] as? NSInteger == 1)
           {
            imgExclamation.hidden = false
          }
        else
          {
             imgExclamation.hidden = true
          }
        
        let status  = dict!["caseStatus"] as! NSNumber
        switch status{
        case 1:
             imgVehcile.image = UIImage(named: "iconnew")
            break
        case 2:
             imgVehcile.image = UIImage(named: "iconintransit")
            break
        case 3:
            imgVehcile.image = UIImage(named: "paritalstatus")
            break
        case 4:
            imgVehcile.image = UIImage(named: "deliveredicon")

            break
        case 5:
            imgVehcile.image = UIImage(named: "iconcompleted")

            break
        case 6:
            imgVehcile.image = UIImage(named: "submittedicon")
            
            break
        default:
            break
            
        }
    }
    
    
    @IBAction func btnFavClicked(sender: AnyObject) {
        if(self.blockFav != nil)
        {
        self.blockFav!(indexPath!.row)
        }
    }
    
    
}




