import UIKit

class STRPopup: UIView {
    
    @IBOutlet var ascDescButton  : UIButton?
    @IBOutlet var ascDesclabel  : UILabel?
    @IBOutlet var innerView  : UIView?
    var selectedString : String?
    var SelectSortingOrder : String?
    var closure :((String)->())?
    var seletedIndexx :Int = 0
    
    override func awakeFromNib() {
        innerView!.layer.cornerRadius = 5;
        innerView!.layer.shadowOpacity = 0.8;
        selectedString = utility.getselectedSortBy()
        SelectSortingOrder = utility.getselectedSortOrder()
        innerView!.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        if SelectSortingOrder == "asc" {
            ascDesclabel?.text  = "Ascending"
            ascDescButton! .setBackgroundImage(UIImage.init(named: "rbselected"), forState: UIControlState.Normal)
        }else{
            ascDescButton! .setBackgroundImage(UIImage.init(named: "rbunselected"), forState: UIControlState.Normal)
            ascDesclabel?.text  = "Descending"
        }
        seletedIndexx = sortDataFromApi.indexOf(selectedString!)!
    }
    
    
    @IBAction func doneButtonClicked(sender : UIButton)
    {
        
        print( selectedString)
        print( SelectSortingOrder)
        utility.setselectedSortOrder(SelectSortingOrder!)
        utility.setselectedSortBy(selectedString!)
        self.closure!("1")
        self .removeFromSuperview()
        
        
    }
    
    @IBAction func ascDescButtonClicked(sender : UIButton)
    {
        if SelectSortingOrder == "desc" {
            ascDesclabel?.text  = "Ascending"
            self.ascDescButton! .setBackgroundImage(UIImage.init(named: "rbselected"), forState: UIControlState.Normal)
            SelectSortingOrder = "asc"
        }else{
            ascDesclabel?.text  = "Descending"
            self.ascDescButton!.setBackgroundImage(UIImage.init(named: "rbunselected"), forState: UIControlState.Normal)
            SelectSortingOrder = "desc"
        }
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortDataPopUp.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        let move = sortDataPopUp[indexPath.row]
        
        if  seletedIndexx == indexPath.row {
            cell?.imageView?.image=UIImage(named: "rbselected")
        }else{
            cell?.imageView?.image=UIImage(named: "rbunselected")
        }
        cell!.textLabel!.text = move
        cell?.imageView?.frame=CGRectMake(4, 4, 36, 36)
        cell?.imageView?.contentMode=UIViewContentMode.ScaleAspectFit
        cell!.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell!
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selcetedIndex  = indexPath.row
        seletedIndexx  = selcetedIndex
        let move = sortDataFromApi[indexPath.row]        
        selectedString  = move

        
        tableView .reloadData()
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self .removeFromSuperview()
    }
}

extension STRPopup {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}

