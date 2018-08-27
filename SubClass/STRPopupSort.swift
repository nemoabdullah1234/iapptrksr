import UIKit

class STRPopupSort: UIView,UITableViewDelegate,UITableViewDataSource {
    var sortData = ["ETD","case NO","Hospital","Doctor","Surgery Type","Surgery Date"]
    var sortDataCountry = [AnyObject]()
    
    var closure :((String)->())?
   var closureTable :((AnyObject)->())?
    var isCountryTable : Bool?
    @IBOutlet var tblViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        tblPopup.layer.cornerRadius = 5;
        tblPopup.layer.shadowOpacity = 0.8;
        tblPopup.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    }
    
    
    @IBOutlet var tblPopup: UITableView!
    func setUpPopup(type:Int) {
        isCountryTable = false
        switch type {
        case 1:
            sortData = ["ETD","Case NO","Hospital","Doctor","Surgery Type","Surgery Date"]
            self.tblPopup.reloadData()
            self.tblViewHeight.constant=self.tblPopup.contentSize.height
            tblPopup.scrollEnabled = false
            break;
        case 2:

            sortData = ["Edit Profile","Sign Out"]

            self.tblPopup.reloadData()
            tblPopup.scrollEnabled = false
            self.tblViewHeight.constant=self.tblPopup.contentSize.height
            break;
        case 3:
            
            sortData = ["Ascending","Descending"]
            
            self.tblPopup.reloadData()
            tblPopup.scrollEnabled = false
            self.tblViewHeight.constant=self.tblPopup.contentSize.height
            break;
            
        case 4:
            let bounds = UIScreen.mainScreen().bounds
            let width = bounds.size.width
            let height = bounds.size.height
            
            tblPopup.frame = CGRectMake(20, 70, width - 40, height - 140)
          
            isCountryTable = true
            self.tblPopup.reloadData()
            break;
            
        default:
            break
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCountryTable == true {
            return sortDataCountry.count
        }
        return sortData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        if isCountryTable == true {
        let infoDictionary = sortDataCountry[indexPath.row] as? [String : AnyObject]
            print(infoDictionary)
            cell!.textLabel?.text = infoDictionary!["countryName"] as? String
            cell?.imageView?.image=UIImage(named: "rbunselected")
            cell?.imageView?.frame=CGRectMake(4, 4, 36, 36)
            cell?.imageView?.contentMode=UIViewContentMode.ScaleAspectFit
            return cell!
       }
        let move = sortData[indexPath.row]
        
            cell!.textLabel!.text = move
               cell?.imageView?.image=UIImage(named: "rbunselected")
               cell?.imageView?.frame=CGRectMake(4, 4, 36, 36)
               cell?.imageView?.contentMode=UIViewContentMode.ScaleAspectFit
                return cell!
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isCountryTable == true {
            self.closureTable!((sortDataCountry[indexPath.row] as? [String : AnyObject])!)
        }else{
        self.closure!(sortData[indexPath.row])
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self .removeFromSuperview()
    }
    
    
}
