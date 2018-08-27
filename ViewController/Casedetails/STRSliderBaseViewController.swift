import UIKit
enum STRSLIDERTYPE: Int{
    case STRSLIDERTYPEREADONLY = 0
}

class STRSliderBaseViewController: UIViewController,UIPageViewControllerDataSource {
    var readonly:Bool?
    var pageController:UIPageViewController?
    var currentIndex = 0
    var selectedViewMap: Bool?
    
    
    @IBOutlet var btnReport: UIButton!
    @IBOutlet var btnMap: UIButton!
    
    
    @IBOutlet var lblReport: UILabel!
    @IBOutlet var imgReport: UIImageView!
    @IBAction func btnReport(sender: AnyObject) {
        
        let isAssigned = self.caseDetails!["isAssigned"] as? NSInteger
        if(isAssigned == 0)
        {
            utility.createAlert("", alertMessage: "Case is not assigned to you.", alertCancelTitle: "Ok", view: self)
            return
        }
        if(self.shipments == nil)
        {
            return
        }
        let shipmentSpecific = self.shipments![currentIndex]
        let strReportIssue = STRReportIssueNewViewController.init(nibName: "STRReportIssueNewViewController", bundle: nil)
        strReportIssue.caseNo =  self.caseNo
        if(shipmentSpecific["issueId"] != nil)
        {
        strReportIssue.issueID = "\(shipmentSpecific["issueId"] as! NSInteger)"
        }
        strReportIssue.readonly = self.readonly
        strReportIssue.reportType = .STRReportCase
        strReportIssue.shippingNo = shipmentSpecific["shipmentNo"] as? String
        self.navigationController?.pushViewController(strReportIssue, animated: true)
    }
    @IBOutlet var lblMap: UILabel!
    @IBOutlet var imgMap: UIImageView!
    @IBAction func btnMap(sender: UIButton) {
        if(sender.tag == 0)
        {
         sender.tag = 1
         lblMap.text = "List"
         imgMap.image = UIImage(imageLiteral: "list")
             NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CHANGEVIEWNOTIFICATION", object: ["view":"1"]))
         selectedViewMap = true
        }
        else
        {
         sender.tag = 0
         lblMap.text = "Map"
         imgMap.image = UIImage(imageLiteral: "map")
             NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CHANGEVIEWNOTIFICATION", object: ["view":"2"]))
            selectedViewMap = false
        }
        
    }
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblLocation: MarqueeLabel!
    var caseDetails: Dictionary<String,AnyObject>?
    var shipments : [Dictionary<String,AnyObject>]?
    var caseNo:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationforBack(self)
        let vw = STRNavigationTitle.setTitle("\(self.caseNo!)", subheading: "")

        vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
        
        self.navigationItem.titleView = vw
        self.setUpFont()
         dataFeeding()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeView), name: "SCROLLTOINDEX", object: nil)

            }
    func poptoPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
    }
       func changeView(dict:NSNotification){
        let index = dict.object!["index"] as! NSInteger
        let shipmentSpecific = self.shipments![index]
        self.currentIndex = index
       let vw = STRNavigationTitle.setTitle("\(self.caseNo!)", subheading: shipmentSpecific["l1"] as! String)
        vw.frame = CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, (self.navigationController?.navigationBar.frame.size.height)!)
        
        self.navigationItem.titleView = vw

        setDataForIndex(index)
    }

    func setUpPageController(){
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageController?.view.backgroundColor=UIColor(red:240.0/255.0 , green:240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.setupViewLayout()
        let vw = self.viewControllerAtIndex(0)
        self.pageController?.setViewControllers([vw], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.pageController!.dataSource = self;

    }
    func setupViewLayout(){
        self.addChildViewController(self.pageController!)
        self.pageController?.view.frame = CGRectMake(0, 70,self.view.bounds.width, self.view.bounds.height-70)
        self.view.addSubview((self.pageController?.view)!)
        self.pageController?.didMoveToParentViewController(self)
    }
    func setUpFont(){
        lblReport.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
        lblMap.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
        lblTitle.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        lblLocation.font = UIFont(name: "SourceSansPro-Regular", size: 16.0);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func viewControllerAtIndex(index:NSInteger)-> STRCaseDetailNewViewController{
      let obj =  STRCaseDetailNewViewController.init(nibName: "STRCaseDetailNewViewController", bundle: nil)
      obj.index = index
      obj.headerDict = self.getHeaderDetail(index)
      obj.readonly = self.readonly
      obj.shipment = self.getShipmentForIndex(index)
      obj.caseNo = self.caseNo
      obj.selectedView = self.selectedViewMap
      return obj
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var  index = (viewController as! STRCaseDetailNewViewController).index
        if(index == 0)
        {
            return nil
        }
        index = index! - 1
        return self.viewControllerAtIndex(index!)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
         var  index = (viewController as! STRCaseDetailNewViewController).index
        index = index! + 1
        if(index == self.shipments?.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index!)
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        if(self.shipments != nil)
        {
            return (self.shipments?.count)!
        }
        return 0
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
       
        return 0
    }
    
    //MARK: DataMethods
    func getShipmentForIndex(index:NSInteger)->Dictionary<String,AnyObject>{
        let dict = self.shipments![index]
        return dict
    }
    func getHeaderDetail(index: NSInteger)->Dictionary<String,AnyObject>{
        let shipmentSpecific = self.shipments![index]
        
        return ["l1":caseDetails!["l1"]!,"l2":caseDetails!["l2"]!,"l3":caseDetails!["l3"]!,"l4":caseDetails!["l4"]!,"l5":caseDetails!["l5"]!,"l7":caseDetails!["l7"]!,"shipStatus":shipmentSpecific["shipStatus"]!,"sl4":shipmentSpecific["l4"]!,"sl5":shipmentSpecific["l5"]!]
    }
    func setBarButtonStatus(index: NSInteger){
         let shipmentSpecific = self.shipments![index]
         let status = shipmentSpecific["shipStatus"] as! NSInteger
        if(status == 0)
        {
            self.imgMap.alpha = 0.5
            self.imgReport.alpha = 0.5
            self.btnReport.userInteractionEnabled = false
            self.btnMap.userInteractionEnabled = false
        }
        else{
            self.imgMap.alpha = 1
            self.imgReport.alpha = 1
            self.btnReport.userInteractionEnabled = true
            self.btnMap.userInteractionEnabled = true
        }
    }
    
    
    
    func setDataForIndex(index: NSInteger){
     let shipmentSpecific = self.shipments![index]
         lblTitle.text = shipmentSpecific["l2"] as? String
        var str = shipmentSpecific["l3"] as? String
        if(str != nil)
        {
            str = str?.stringByReplacingOccurrencesOfString("\n", withString: "")
            str = str?.stringByReplacingOccurrencesOfString("\r", withString: "")
            lblLocation.text = str
        }
        let status = shipmentSpecific["shipStatus"] as! NSInteger
        if(status == 0)
        {
            self.imgMap.alpha = 0.5
            self.imgReport.alpha = 0.5
            self.lblMap.alpha = 0.5
            self.lblReport.alpha = 0.5
            self.btnReport.userInteractionEnabled = false
            self.btnMap.userInteractionEnabled = false
        }
        else{
            self.imgMap.alpha = 1
            self.imgReport.alpha = 1
            self.lblMap.alpha = 1
            self.lblReport.alpha = 1
            self.btnReport.userInteractionEnabled = true
            self.btnMap.userInteractionEnabled = true
        }


    }
    //MARK: API
    
     func dataFeeding() -> () {
        let api = GeneralAPI()
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let caseNoString  = self.caseNo!
        let escapedString = caseNoString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        self.caseNo! = self.caseNo!.stringByRemovingPercentEncoding!
         api.hitApiwith(["caseNo":self.caseNo!], serviceType: .STRApiGetCaseDetail, success: { (response) in
         dispatch_async(dispatch_get_main_queue()) {
            
            if(response["status"]?.integerValue != 1)
            {
                MBProgressHUD.hideAllHUDsForView(self.navigationController!.view, animated: true)
                loadingNotification = nil
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                return
            }//caseDetails
            // shipments
            guard let data = response["data"] as? [String:AnyObject],readerGetCaseDetailsResponse = data["readerGetCaseDetailsResponse"] as? [String:AnyObject], caseDetails = readerGetCaseDetailsResponse ["caseDetails"] as? [String:AnyObject],shipments =  readerGetCaseDetailsResponse["shipments"] as? [Dictionary<String,AnyObject>] else{
                MBProgressHUD.hideAllHUDsForView(self.navigationController!.view, animated: true)
                utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                return
            }
            self.caseDetails = caseDetails
            self.shipments = shipments
            self.pageController?.reloadInputViews()
            MBProgressHUD.hideAllHUDsForView(self.navigationController!.view, animated: true)
             self.setUpPageController()
                   }
        }) { (error) in
             MBProgressHUD.hideAllHUDsForView(self.navigationController!.view, animated: true)
        }
    }

}
