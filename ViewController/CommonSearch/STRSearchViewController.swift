import UIKit

class STRSearchViewController: UIViewController,ZBarReaderDelegate {
    @IBAction func btnBarCode(sender: AnyObject) {
        let codeReader = ZBarReaderViewController()
        codeReader.readerDelegate=self;
        let scanner = codeReader.scanner;
        scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        self.navigationController?.presentViewController(codeReader, animated: true, completion: {
        })

    }
    @IBOutlet var btnBarCode: UIButton!
    @IBAction func btnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var vwWhiteBase: UIView!
     @IBOutlet var vwSegment: STRSearchSegment!
     @IBOutlet var tblSearch: UITableView!
    var option = 0
    var dataList = [[String:AnyObject]]()
    var tblDataSource = [[String:AnyObject]]()
    var suggestedArray = [String]()
    @IBOutlet var tblSuggestion: UITableView!
    
    var index:NSInteger?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let  arr = NSUserDefaults.standardUserDefaults().objectForKey("STRSEARCHSUGGESTION") as? [String]
        if (arr != nil)
        {
        for (_,str) in (arr?.enumerate())!{
            self.suggestedArray.append(str)
        }
        }
        
        self.vwSegment.blockSegmentButtonClicked = {(segment) in
        self.changeDataSource(segment)
        }
        let nib = UINib(nibName: "STRItemSearchCellTableViewCell", bundle: nil)
        tblSearch.registerNib(nib, forCellReuseIdentifier: "STRItemSearchCellTableViewCell")
        let nib2 = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        tblSearch.registerNib(nib2, forCellReuseIdentifier: "dashBoardTableViewCell")
        tblSearch.rowHeight = UITableViewAutomaticDimension
         let nib3 = UINib(nibName: "STRSuggestedTableViewCell", bundle: nil)
        tblSearch.estimatedRowHeight = 60
        tblSuggestion.registerNib(nib3, forCellReuseIdentifier: "STRSuggestedTableViewCell")
        tblSearch.rowHeight = UITableViewAutomaticDimension
        tblSearch.estimatedRowHeight = 40
        self.vwWhiteBase.layer.cornerRadius = 4.0
        self.vwSegment.setSegment(0)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(self.suggestedArray, forKey: "STRSEARCHSUGGESTION")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView ==  self.tblSearch)
        {
            if((self.tblDataSource.count == 0 && self.suggestedArray.count==0))
            {
                addNodata()
                return 0
            }
            
            for view in self.view.subviews{
                if(view.tag == 10002)
                {
                    view.removeFromSuperview()
                }
                self.view.viewWithTag(10002)?.removeFromSuperview()
            }
            
            return self.tblDataSource.count
        }
        else
        {
            if((self.tblDataSource.count == 0 && self.suggestedArray.count==0))
            {
                
                addNodata()
                return 0
                
            }
            for view in self.view.subviews{
                if(view.tag == 10002)
                {
                    view.removeFromSuperview()
                }
                self.view.viewWithTag(10002)?.removeFromSuperview()
            }
            
            
            return suggestedArray.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(tableView == self.tblSuggestion)
        {
            return 44
        }
        
        if(self.option == 1)
        {
            return 137
            
        }
        return 110
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.tblSuggestion)
        {
            let cell: STRSuggestedTableViewCell = self.tblSuggestion.dequeueReusableCellWithIdentifier("STRSuggestedTableViewCell") as! STRSuggestedTableViewCell
            cell.setUpCell(self.suggestedArray[indexPath.row])
            cell.selectionStyle =  UITableViewCellSelectionStyle.None

            return cell
        }
        if(self.option == 1)
        {
        let cell: STRItemSearchCellTableViewCell = self.tblSearch.dequeueReusableCellWithIdentifier("STRItemSearchCellTableViewCell") as! STRItemSearchCellTableViewCell
        cell.setUpCellData(self.tblDataSource[indexPath.row], indexPath: indexPath)
            cell.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell
        }
        else
        {
            let cell: DashBoardTableViewCell = self.tblSearch.dequeueReusableCellWithIdentifier("dashBoardTableViewCell") as! DashBoardTableViewCell
            cell.buttonTypeDash = .STRDashboardCellWithoutFave
            cell.setUpCell(self.tblDataSource[indexPath.row] as? [String : AnyObject],indexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
         return cell
        }
    }
    func watchCaseApi(caseNumberObj : String, watchStrObj : String) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        var watchStr:String?
        if watchStrObj == "0" {
            watchStr = "1"
        }else{
            watchStr = "0"
        }
        
        let someDict:[String:String] = ["caseNo":caseNumberObj, "isWatch":watchStr!, "isException":"0"]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiWatchCase, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response["data"])
                let dataDictionary = response["message"] as? String
                if dataDictionary == "Ok" {
                    if watchStr == "0" {
                       self.tblDataSource[self.index!]["isWatched"] = 0
                    }else{
                         self.tblDataSource[self.index!]["isWatched"] = 1
                    }
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tblSuggestion)
        {
            self.txtSearch.text = self.suggestedArray[indexPath.row];
            self.dataFeeding()
            self.view.endEditing(true)
        }
        else
        {
            if(self.option == 1)
            {
                let items = self.tblDataSource[indexPath.row] as? [String : AnyObject]
                let data  = items!["params"]
                let vw = STRInventoryListViewController(nibName: "STRInventoryListViewController", bundle: nil)
                vw.skuId =  "\(data!["skuId"] as! NSNumber)"
                vw.locationName = ""
                vw.titleString = "\(data!["caseId"] as! String)"
                vw.sourceScreen =   .STRItemDetailFromSearch
                self.navigationController?.pushViewController(vw, animated: true)

            }
            else
            {
            let infoDictionary = self.tblDataSource[indexPath.row] as? [String : AnyObject]
            let status = infoDictionary!["status"] as? String
            
            if(status == "Completed")
            {
                let caseNumberObj1  = infoDictionary!["caseId"] as! String
                let obj =  STRSliderBaseViewController.init(nibName: "STRSliderBaseViewController", bundle: nil)
                obj.caseNo = caseNumberObj1
                obj.readonly = true
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else
            {
                let caseNumberObj1  = infoDictionary!["caseId"] as! String
                let obj =  STRSliderBaseViewController.init(nibName: "STRSliderBaseViewController", bundle: nil)
                obj.caseNo = caseNumberObj1
                obj.readonly = false
                self.navigationController!.pushViewController(obj, animated: true)
            }
            }
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        let str  = txtSearch.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if(str?.characters.count != 0)
        {
        dataFeeding()
        }
        return true
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == self.tblSuggestion)
        {
            let vw = STRReportIssueSectionHeader.sectionView("Recent")
            vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 30)
            vw.backgroundColor = UIColor(colorLiteralRed: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1.0)
            return vw
        }
        else{
            let vw = UIView(frame:CGRectZero)
            return vw
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(tableView == self.tblSuggestion)
        {
                       return 44
        }
        
        else{
            return 0
        }

    }
    
    //MARK: search api calls
    func dataFeeding() -> () {
        addString(self.txtSearch.text!)
        let api = GeneralAPI()
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        api.hitApiwith(["query":self.txtSearch.text!], serviceType: .STRApiGlobalSearch, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],let readerSearchCasesResponse = data["readerSearchCasesResponse"] as? [[String:AnyObject]] else{
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                self.dataList = readerSearchCasesResponse
                self.tblDataSource.removeAll()
                for dict in readerSearchCasesResponse{
                    if dict["type"]!.integerValue == self.option{
                        self.tblDataSource.append(dict)
                    }
                }
                for view in self.view.subviews{
                    if view.tag == 10002 {
                        view.removeFromSuperview()
                    }
                }
                if self.tblDataSource.count == 0{
                }
                self.hideSuggestedTable()
                self.tblSearch.reloadData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }) { (error) in
            
        }
        
    }

    func changeDataSource(type:NSInteger)
    {
        if(type == 0)
        {
            option = 0
            
            self.tblDataSource.removeAll()
            for dict in dataList{
                if dict["type"]!.integerValue == 0{
                    self.tblDataSource.append(dict)
                }
            }
            self.tblSearch.reloadData()
        }
        if(type == 1)
        {
            option = 1
            self.tblDataSource.removeAll()
            for dict in dataList{
                if dict["type"]!.integerValue == 1{
                    self.tblDataSource.append(dict)
                }
            }
            self.tblSearch.reloadData()
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let results: ZBarSymbolSet = info[ZBarReaderControllerResults] as! ZBarSymbolSet
        var symbl=ZBarSymbol()
        for symbol in results{
            symbl = symbol as! ZBarSymbol
            break
        }
        print(symbl.data)
        
        picker.dismissViewControllerAnimated(true, completion: {
            self.tblDataSource.removeAll()
            self.tblSearch.reloadData()
            self.txtSearch.text = "\(symbl.data)"
            self.dataFeeding()
        })
    }
    
    func addString(text:String){
        if(suggestedArray.contains(text) || suggestedArray.count == 10)
        {
            return
        }
        else{
            self.suggestedArray.append(text)
        }
    }
    func showSuggestedTable(){
        self.tblSuggestion.hidden = false
    }
    func hideSuggestedTable(){
        self.tblSuggestion.hidden = true
    }
    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        self.view.addSubview(noData)
        noData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[vwSegment]-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData,"vwSegment":self.vwSegment]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
    }

}
extension ZBarSymbolSet: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}

