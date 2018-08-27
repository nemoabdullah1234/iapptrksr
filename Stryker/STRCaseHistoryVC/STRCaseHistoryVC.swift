import UIKit

class STRCaseHistoryVC: UIViewController, STRCaseDetailDelegate,STRNoDataFoundDelegate {
    var titleName: String!
    @IBOutlet var tableView: UITableView!
    var dataArrayObj = [AnyObject]()
    var allArrayObj = [AnyObject]()
     var refreshControl: UIRefreshControl!
    var isFirstLoad : Bool?
    var caseDetailObj : STRCaseDetailVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = titleName
        isFirstLoad = false
        customizeNavigationforAll(self)
        // Do any additional setup after loading the view.
        if titleName == RearSlider.completeCase.rawValue{
            getDataForCompletedCases()
        }else{
            getData()
        }
        
        let nib = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "dashBoardTableViewCell")
        tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
         tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.revealViewController().panGestureRecognizer().enabled = false
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(STRCaseHistoryVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView!.addSubview(refreshControl)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func refresh(sender:AnyObject) {
        
        if titleName == RearSlider.completeCase.rawValue{
            getDataForCompletedCases()
        }else{
            getData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToDashbaord(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }
    func checkWhenComesFromCaseDetais(controller:STRCaseDetailVC,isController:Bool)
    {
      
        print(isController)
    }
    
    
    // Data Feeding
    func getData() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiCaseHistory, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                self.isFirstLoad = true
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                
                self.refreshControl.endRefreshing()
                
                if dataDictionary?.count <= 0 {
                    MBProgressHUD.hideAllHUDsForView(self.navigationController?.view, animated: true)
                     self.addNodata()
                    return
                }
                
                self.dataArrayObj = dataDictionary!["readerGetCasesHistoryResponse"]  as! [AnyObject]
     
                self.allArrayObj = self.dataArrayObj
     
                self.tableView .reloadData()
                
                MBProgressHUD.hideAllHUDsForView(self.navigationController?.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.navigationController?.view, animated: true)
                 self.addNodata()
                NSLog(" %@", err)
            }
        }
    }
    
    // Data Feeding
    func getDataForCompletedCases() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiCompletedCase, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                self.isFirstLoad = true
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                
                self.refreshControl.endRefreshing()
                
                if dataDictionary?.count <= 0 {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                     self.addNodata()
                    return
                }
                
                self.dataArrayObj = dataDictionary!["readerGetCompletedCasesResponse"]  as! [AnyObject]
                
                
                self.allArrayObj = self.dataArrayObj
                
                
                
                
                self.tableView .reloadData()
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                 self.addNodata()
                NSLog(" %@", err)
            }
        }
    }
    


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFirstLoad == false {
           
            return 0
        }

        
        if self.dataArrayObj.count == 0 {
            self.addNodata()
            return 0
        }
        removeNodata()
        return self.dataArrayObj.count
        
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: DashBoardTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("dashBoardTableViewCell") as! DashBoardTableViewCell
        let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
        let iscompleted = infoDictionary!["isCompleted"] as! NSInteger
        if(iscompleted == 0)
        {
        cell.buttonTypeDash = .STRDashBoardCellWithSR
        }
        else{
            cell.buttonTypeDash = .STRDashboardCellWithoutFave
        }
        cell.setUpCell(self.dataArrayObj[indexPath.row] as? [String : AnyObject],indexPath:indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.blockSR = {(index) in
            let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
            let VW = STRDueBackDetailNewViewController(nibName: "STRDueBackDetailNewViewController", bundle: nil)
            VW.caseNo = infoDictionary!["caseId"] as! String
            self.navigationController?.pushViewController(VW, animated: true)
                   }
        cell.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.dataArrayObj.count == 0 {
           
        }else if titleName == RearSlider.completeCase.rawValue
        {
            let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
            let iscompleted = infoDictionary!["isCompleted"] as! NSInteger
            switch iscompleted {
            case 0:
                
                let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
                let caseNumberObj1  = infoDictionary!["caseId"] as! String
                let obj =  STRSliderBaseViewController.init(nibName: "STRSliderBaseViewController", bundle: nil)
                obj.caseNo = caseNumberObj1
                obj.readonly = false
                self.navigationController!.pushViewController(obj, animated: true)

                
                break
            case 1:
                let caseNumberObj1  = infoDictionary!["caseId"] as! String
                let obj =  STRSliderBaseViewController.init(nibName: "STRSliderBaseViewController", bundle: nil)
                obj.caseNo = caseNumberObj1
                obj.readonly = true
                self.navigationController!.pushViewController(obj, animated: true)
                break
            default:
                break;
            }
        }
        else{
        let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
        let VW = STRDueBackDetailNewViewController(nibName: "STRDueBackDetailNewViewController", bundle: nil)
        VW.caseNo = infoDictionary!["caseId"] as! String
        self.navigationController?.pushViewController(VW, animated: true)
        }
    }

    func addNodata(){
        let noData = NSBundle.mainBundle().loadNibNamed("STRNoDataFound", owner: nil, options: nil)!.last as! STRNoDataFound
        noData.tag = 10002
        noData.showViewRetry()
        noData.delegate = self

        self.view.addSubview(noData)
        noData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[noData]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["noData" : noData]))
        
    }
   
    func retryPressed() {
        self.refresh("")
    }

}
