import UIKit

class STRImageViewController: UIViewController ,UIScrollViewDelegate{
    var imageURL:String?
    @IBAction func btnDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet var lblDone: UILabel!
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        self.navigationController?.navigationBar.hidden = true
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        self.imgView.sd_setImageWithURL(NSURL(string: self.imageURL!)) { (img, error, id, url) in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    func setupFont(){
        self.lblDone.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
