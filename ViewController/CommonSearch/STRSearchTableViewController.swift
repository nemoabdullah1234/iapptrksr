import UIKit

class STRSearchTableViewController: UITableViewController,ZBarReaderDelegate {
        let searchController = UISearchController(searchResultsController: nil)
    var option = 0
    var dataList = [[String:AnyObject]]()
    var tblDataSource = [[String:AnyObject]]()
    
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden=false
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
       
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true;
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Cases", "Notifications", "Items", "📷"]
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView  = UIView()
        self.extendedLayoutIncludesOpaqueBars = true
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchController.active = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tblDataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("globalSearch")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "globalSearch")
        }
        cell!.textLabel!.text = self.tblDataSource[indexPath.row]["l1"] as? String
        cell!.detailTextLabel!.text = self.tblDataSource[indexPath.row]["l2"] as? String
        cell!.detailTextLabel?.textColor = UIColor.darkGrayColor()
        cell!.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell!
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict = self.dataList[indexPath.row]
        switch dict["type"] as! NSInteger{
        case 0:
            let notification =  dict["params"]
            let caseNumberObj1  = notification!["caseId"] as! String
            let caseDetailObj =     STRCaseDetailVC.init(nibName: "STRCaseDetailVC", bundle: nil)
            caseDetailObj.titleName = "Case Details"
            caseDetailObj.caseNo = caseNumberObj1
            self.navigationController!.pushViewController(caseDetailObj, animated: true)
            break
        case 1:
            let notification =  dict["params"]
            let caseNumberObj1  = notification!["caseId"] as! String
            let caseDetailObj =      STRCaseDetailVC.init(nibName: "STRCaseDetailVC", bundle: nil)
            caseDetailObj.titleName = "Case Details"
            caseDetailObj.caseNo = caseNumberObj1
            self.navigationController!.pushViewController(caseDetailObj, animated: true)
            break;
        case 2:
            
            let notification =  dict["params"]
            switch notification!["notificationType"] as! String {
            case "1","2","3":
                let caseNumberObj1  = notification!["caseId"] as! String
                let caseDetailObj =    STRCaseDetailVC.init(nibName: "STRCaseDetailVC", bundle: nil)
                caseDetailObj.titleName = "Case Details"
                caseDetailObj.caseNo = caseNumberObj1
                self.navigationController!.pushViewController(caseDetailObj, animated: true)
                break
            case "6","4","5":
                break
            default:
                
                break
            }
        break;
        default:
            
            break;
        }
    }
    
    func dataFeeding() -> () {
        let api = GeneralAPI()
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        api.hitApiwith(["query":self.searchController.searchBar.text!], serviceType: .STRApiGlobalSearch, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingNotification = nil
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],readerSearchCasesResponse = data["readerSearchCasesResponse"] as? [[String:AnyObject]] else{
                    
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
                self.view.viewWithTag(101)?.removeFromSuperview()
                if self.tblDataSource.count == 0{
                    self.addNoData()
                }
                
                    self.tableView.reloadData()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }) { (error) in
            
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
                    self.tableView.reloadData()
                    self.searchController.searchBar.text = "\(symbl.data)"
                    self.dataFeeding()
        })
    }
    
    func addNoData(){
      let lbl = UILabel(frame: CGRectMake(0,80, self.tableView.frame.size.width, 44))
      lbl.tag=101
        
      lbl.text="No Data"
        
      lbl.textAlignment = NSTextAlignment.Center
        
       self.view.addSubview(lbl)
    }
    
    
}
extension STRSearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if(selectedScope == 3)
        {
            let codeReader = ZBarReaderViewController()
                      let infoBtn = codeReader.view.subviews[2].subviews[0].subviews[3]
            infoBtn.hidden=true
            codeReader.readerDelegate=self;
            let scanner = codeReader.scanner;
            scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
            self.navigationController?.presentViewController(codeReader, animated: true, completion: { 
                            })
        }
        if(selectedScope == 0)
        {
            option = 0

            self.tblDataSource.removeAll()
            for dict in dataList{
                if dict["type"]!.integerValue == 0{
                    self.tblDataSource.append(dict)
                }
            }
         self.tableView.reloadData()
        }
        if(selectedScope == 1)
        {
            option = 2
             self.tblDataSource.removeAll()
            for dict in dataList{
                if dict["type"]!.integerValue == 2{
                    self.tblDataSource.append(dict)
                }
            }
            self.tableView.reloadData()

        }

        if(selectedScope == 2)
        {
            option = 1

             self.tblDataSource.removeAll()
            for dict in dataList{
                if dict["type"]!.integerValue == 1{
                    self.tblDataSource.append(dict)
                }
            }
            self.tableView.reloadData()

        }
        self.view.viewWithTag(101)?.removeFromSuperview()
        if self.tblDataSource.count == 0{
            self.addNoData()
        }
        
    }

    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
         UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
       self.dataFeeding()
    }
}



extension STRSearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    }
}
