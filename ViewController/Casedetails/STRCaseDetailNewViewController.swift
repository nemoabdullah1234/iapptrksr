import UIKit

class STRCaseDetailNewViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UIWebViewDelegate{
    var readonly:Bool?
    @IBOutlet var tblCaseDetail: UITableView!
    @IBOutlet var webView: UIWebView!
    var caseNo:String?
    var index:NSInteger!
    var headerDict:Dictionary<String,AnyObject>?
    var shipment:Dictionary<String,AnyObject>?
    var selectedView:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(self.readonly == false )
        {
        let nib = UINib(nibName: "STRCaseDetailNewTableViewCell", bundle: nil)
        tblCaseDetail.registerNib(nib, forCellReuseIdentifier: "STRCaseDetailNewTableViewCell")
        }
        else{
            let nib = UINib(nibName: "STRCompletedCaseTableViewCell", bundle: nil)
            tblCaseDetail.registerNib(nib, forCellReuseIdentifier: "STRCompletedCaseTableViewCell")

        }
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeView), name: "CHANGEVIEWNOTIFICATION", object: nil)
        
        tblCaseDetail.rowHeight = UITableViewAutomaticDimension
        tblCaseDetail.estimatedRowHeight = 60

        setUpData()
        self.webView.delegate = self
    }
    func changeView(dict:NSNotification){
      changeViewIndex( (dict.object!["view"] as? String)!)
    }
    func changeViewIndex(type:String)
    {
        if(type == "1")
        {
            self.view .bringSubviewToFront(self.webView)
            self.webView.hidden = false
            self.view.sendSubviewToBack(self.tblCaseDetail)
        }
        else
        {
            self.view .bringSubviewToFront(self.tblCaseDetail)
            self.webView.hidden = true
            self.view.sendSubviewToBack(self.webView)
        }

    }
    override func viewDidAppear(animated: Bool) {
         NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SCROLLTOINDEX", object: ["index":self.index]))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if (self.shipment == nil)
       {
        return 0
       }
      let items = self.shipment!["items"] as! [Dictionary<String,AnyObject>]
      return items.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let items = self.shipment!["items"] as! [Dictionary<String,AnyObject>]
        if(self.readonly ==  false)
        {
        let cell: STRCaseDetailNewTableViewCell = self.tblCaseDetail.dequeueReusableCellWithIdentifier("STRCaseDetailNewTableViewCell") as! STRCaseDetailNewTableViewCell
             cell.setUpData(items[indexPath.row],IndexPath: indexPath.row)
            cell.selectionStyle =  UITableViewCellSelectionStyle.None

            return cell
        }
        else
        {
            
          let cell: STRCompletedCaseTableViewCell = self.tblCaseDetail.dequeueReusableCellWithIdentifier("STRCompletedCaseTableViewCell") as! STRCompletedCaseTableViewCell
             cell.setUpData(items[indexPath.row],IndexPath: indexPath.row)
            cell.blockCommentBtn = {(index) in
                 let items = self.shipment!["items"] as! [Dictionary<String,AnyObject>]
                
                let shipmentSpecific = items[index]
                let strReportIssue = STRReportIssueNewViewController.init(nibName: "STRReportIssueNewViewController", bundle: nil)
                strReportIssue.caseNo =  self.caseNo
                strReportIssue.reportType = .STRReportDueback
                strReportIssue.readonly = true
                strReportIssue.shippingNo = shipmentSpecific["skuId"] as? String
                self.navigationController?.pushViewController(strReportIssue, animated: true)
            }
            cell.selectionStyle =  UITableViewCellSelectionStyle.None

            return cell
        }
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let items = self.shipment!["items"] as! [Dictionary<String,AnyObject>]
        let data  = items[indexPath.row]
        let vw = STRInventoryListViewController(nibName: "STRInventoryListViewController", bundle: nil) as! STRInventoryListViewController
        vw.skuId =  "\(data["skuId"]!)" 
        var str = shipment!["l1"] as? String
        if(str != nil)
        {
            str = str?.stringByReplacingOccurrencesOfString("\n", withString: "")
            str = str?.stringByReplacingOccurrencesOfString("\r", withString: "")
        }

        vw.locationName = str
        vw.titleString =  self.caseNo
        vw.sourceScreen = .STRItemDetailFromCaseDetail
        self.navigationController?.pushViewController(vw, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 325
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = STRHeaderViewCaseDetail.headerViewForDict(self.headerDict!)
        vw.frame =  CGRectMake(0, 0, tableView.frame.size.width, 325)
        return vw
    }
    func setUpData(){
        let mapData = shipment!["map"] as? Dictionary<String,String>
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string:mapData!["url"]!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!));//
        if(self.selectedView == true)
        {
            changeViewIndex("1");
        }
    
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.stringByEvaluatingJavaScriptFromString("window.alert=null;")
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {

    }

}
