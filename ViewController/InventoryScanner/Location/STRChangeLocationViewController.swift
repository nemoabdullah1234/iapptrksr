import UIKit

class STRChangeLocationViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnCross: UIButton!
    @IBOutlet var vwWhiteBase: UIView!
    @IBAction func clearText(sender: AnyObject) {
        removeNodata()
        self.arrNearDS = self.arrNear
        self.arrayOtherDS = self.arrayOther
        self.tblView.reloadData()
        self.txtSearch.text = ""
    }
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoData: UILabel!
    
    @IBOutlet var vwSegemntNew: UIView!
    let arraySectionHeadr = ["Near By","Other Locations"]
    var arrayOther: [Dictionary<String,AnyObject>]?
    var arrNear : [Dictionary<String,AnyObject>]?
    var idCurrent: NSInteger?
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    var arrayOtherDS = [Dictionary<String,AnyObject>]?()
    var arrNearDS = [Dictionary<String,AnyObject>]?()
    override func viewDidLoad() {
        
        
    super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(STRChangeLocationViewController.textChanged(_:)), name: UITextFieldTextDidChangeNotification, object: self.txtSearch)
        let nib = UINib(nibName: "STRLocationTableViewCell", bundle: nil)
        self.tblView.registerNib(nib, forCellReuseIdentifier: "STRLocationTableViewCell")
        tblView.estimatedRowHeight = 55
        self.vwWhiteBase.layer.cornerRadius = 4.0
        self.automaticallyAdjustsScrollViewInsets = false
        setUpDataSource()
    }
    override func viewWillAppear(animated: Bool) {
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func backToDashbaord(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

       //MARK: change text location
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.txtSearch.resignFirstResponder()
       return true
    }
    func textChanged(textFeildNotification: NSNotification)
    {
        let textField = textFeildNotification.object as! UITextField
        
        if (textField.text == "") {
            self.arrNearDS = self.arrNear
            self.arrayOtherDS = self.arrayOther
            removeNodata()
        }
        else    {
            self.txtSearch.text = textField.text;
            self.enumerateArray()
        }
        
        self.tblView.reloadData()

    }
    func enumerateArray(){
        self.arrayOtherDS?.removeAll()
        self.arrNearDS?.removeAll()
        addNodata()
        for (_,data) in (self.arrNear?.enumerate())!{
            let str = data["address"] as? String
            if(str?.containsString(txtSearch.text!) == true)
            {
                self.arrNearDS?.append(data)
                removeNodata()

            }
        }
        
        for (_,data) in (self.arrayOther?.enumerate())!{
            let str = data["address"] as? String
            if(str?.containsString(txtSearch.text!) == true)
            {
                self.arrayOtherDS?.append(data)
                removeNodata()

            }
        }
         self.tblView.reloadData()
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(range.location == 0 && string == " ")
        {
            return false
        }
            return true
    }
    func setUpDataSource(){
        if(self.arrNear?.count >= 0)
        {
            self.arrNearDS = self.arrNear!
        }
        if(self.arrayOther?.count >= 0)
        {
            self.arrayOtherDS = self.arrayOther!
        }
        self.tblView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.arrNear!.count == 0 && self.arrayOther!.count ==  0)
        {
            
            addNodata()
            return 0
        }
        
        if(self.arrNearDS == nil || self.arrNearDS!.count == 0)
        {
        return 1
        }
        else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arrNearDS!.count == 0 && section == 0)
        {
        return self.arrayOtherDS!.count
        }
        else{
              if(section == 0)
              {
                return self.arrNearDS!.count
            }
              else{
                return self.arrayOtherDS!.count
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: STRLocationTableViewCell = self.tblView.dequeueReusableCellWithIdentifier("STRLocationTableViewCell") as! STRLocationTableViewCell
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        
        var dict : Dictionary<String,AnyObject>?
        if(self.arrNearDS!.count == 0 && indexPath.section == 0)
        {
           dict = self.arrayOtherDS![indexPath.row]
        }
        else{
            if(indexPath.section == 0)
            {
                dict = self.arrNearDS![indexPath.row]

            }
            else{
                dict = self.arrayOtherDS![indexPath.row]
            }
        }
        if(dict!["locationId"] as? NSInteger == self.idCurrent)
        {
            cell.imageViewTick.hidden = false
        }
        else{
            cell.imageViewTick.hidden = true
        }
        cell.lblLocationName.text = "\(dict!["locationId"]!)"
        cell.lblLocationAddress.text = dict!["address"] as? String
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dict : Dictionary<String,AnyObject>?
        if(self.arrNearDS!.count == 0 && indexPath.section == 0)
        {
            dict = self.arrayOtherDS![indexPath.row]
        }
        else{
            if(indexPath.section == 0)
            {
                dict = self.arrNearDS![indexPath.row]
                
            }
            else{
                dict = self.arrayOtherDS![indexPath.row]
            }
        }
         utility.setselectedLocation(dict!)
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(self.arrNearDS!.count > 0)
        {
        let   title = self.arraySectionHeadr[section]
        let vw = STRReportIssueSectionHeader.sectionView(title)
        vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 30)
        vw.backgroundColor = UIColor(colorLiteralRed: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1.0)
        return vw
        }
        else{
            return nil
        }

    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.arrNearDS?.count == 0)
        {
        return 0
        }
        else{
          return   30
        }
    }
    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        self.view.addSubview(noData)
        noData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[vwSegemntNew]-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData,"vwSegemntNew":self.vwSegemntNew]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
    }
    func removeNodata(){
        for view in self.view.subviews{
            if(view.tag == 10002)
            {
                view.removeFromSuperview()
            }
            self.view.viewWithTag(10002)?.removeFromSuperview()
        }

    }

   
}
