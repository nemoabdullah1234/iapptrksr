import UIKit

class STRAboutViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var lblVersion: UILabel!
    @IBOutlet var myWebView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.title = TitleName.About.rawValue
        customizeNavigationforAll(self)
        self.navigationController?.navigationBar.translucent = false
        let url = NSURL (string: Kbase_url_front+"/default/content?type=aboutus");
        let requestObj = NSURLRequest(URL: url!);
        myWebView!.delegate = self;
        myWebView!.loadRequest(requestObj);
        self.revealViewController().panGestureRecognizer().enabled = false
        // Do any additional setup after loading the view.
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        // Do any additional setup after loading the view.
        var buildType = "P"
        if(Kbase_url.containsString("ossclients"))
        {
            buildType = "Q"
        }
        
        self.lblVersion.text = "V" + version + buildType
        setFont()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }

    func backToDashbaord(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }
    func setFont(){
        self.lblVersion.font = UIFont(name: "SourceSansPro-Regular", size: 12.0);
    }

}
