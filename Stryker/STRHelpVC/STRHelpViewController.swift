import UIKit

class STRHelpViewController: UIViewController , UIWebViewDelegate{

    @IBOutlet var myWebView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = TitleName.Help.rawValue
       customizeNavigationforAll(self)
        self.navigationController?.navigationBar.translucent = false
        let url = NSURL (string: Kbase_url_front+"/default/content?type=faq");
        let requestObj = NSURLRequest(URL: url!);
        myWebView!.delegate = self;
        myWebView!.loadRequest(requestObj);
        self.revealViewController().panGestureRecognizer().enabled = false
        // Do any additional setup after loading the view.
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        webView.frame.size = webView.sizeThatFits(CGSizeZero)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }
    func backToDashbaord(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }

    

}
