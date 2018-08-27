import UIKit

class SideBarTableCell: UITableViewCell {
    @IBOutlet var imgName: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    var img : [String]!
    let imgSel = ["duebacksel","notificationsel","settingssel","helpsel","aboutsel","logoutsel"]
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
        switch appType {
        case .salesRep:
        img = ["dueback","completedcases","notifications","settings","help","about","diagnostic","logout"]
        case .warehouseOwner:
        img = ["completedcases","help","about","diagnostic","logout"]
            print("It's for wareHouse Owner")
        }

        
        
        
        setUpFont()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(indexpath:NSIndexPath, selectedvalue isSelected:Bool, titleString: String)
    {
        if(isSelected)
        {
            self.lblName.text = titleString
            self.lblName.textColor = UIColor(red: CGFloat(252/255.0),green: CGFloat(180/255.0),blue: CGFloat(0/255.0),alpha: CGFloat(1.0))
            self.imgName.image = UIImage(named: imgSel[indexpath.row])
        }
        else{
            self.lblName.text = titleString
            self.lblName.textColor = UIColor(red: CGFloat(192/255.0),green: CGFloat(192/255.0),blue: CGFloat(192/255.0),alpha: CGFloat(1.0))
            self.imgName.image = UIImage(named: img[indexpath.row])
        }
    }
    func setUpFont(){
        lblName.font =  UIFont(name: "SourceSansPro-Regular", size: 16.0);
    }
}
