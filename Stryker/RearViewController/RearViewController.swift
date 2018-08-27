 import UIKit

class RearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIDocumentInteractionControllerDelegate{

    @IBOutlet var tableView: UITableView!
    var tableData: [String]!
    
    @IBOutlet var profileImage: UIImageView?
    @IBOutlet var profileName: UILabel?
    var selectedRow = 0
    var activityVC: UIActivityViewController?
    @IBAction func btnEditProfile(sender: AnyObject) {
        let vw = EditViewController(nibName: "EditViewController", bundle: nil)
        self.revealViewController().revealToggleAnimated(true)
        let leftSideNav = UINavigationController(rootViewController: vw)
        self.revealViewController().setFrontViewController(leftSideNav, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.navigationBarHidden = true
        
        profileImage!.layer.borderWidth = 2
        profileImage!.layer.masksToBounds = false
        profileImage!.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage!.layer.cornerRadius = profileImage!.frame.height/2
        profileImage!.clipsToBounds = true
        
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
        
        
        
       
        
        switch appType {
        case .salesRep:
            tableData = [RearSlider.completeCase.rawValue,RearSlider.inventory.rawValue,RearSlider.notification.rawValue,RearSlider.settings.rawValue, RearSlider.help.rawValue, RearSlider.about.rawValue,RearSlider.sendDiagnostic.rawValue,RearSlider.logout.rawValue]
            print("It's for Sales Rep")
        case .warehouseOwner:
             tableData = [RearSlider.inventory.rawValue, RearSlider.help.rawValue, RearSlider.about.rawValue,RearSlider.sendDiagnostic.rawValue,RearSlider.logout.rawValue]
            print("It's for wareHouse Owner")
        }

        
        
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "SideBarTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "sideBarCell")
        tableView.tableFooterView = UIView()
        if(utility.getUserToken() != nil && utility.getUserToken() != " ")
        {
            self.getUSerProfile()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateProfile), name: "UPDATEPROFILENOTIFICATION", object: nil)
        setUpFont()
    }
    
    func updateProfile(){
        self.getUSerProfile()
    }
    override func viewWillAppear(animated: Bool) {
         self.navigationController?.navigationBarHidden = true
        if(utility.getUserFirstName() != nil && utility.getUserFirstName() != " ")
        {
            self.profileName!.text = "\(utility.getUserFirstName()!) \(utility.getUserLastName()!)"
            
        }

    }
    override func viewDidAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SideBarTableCell = self.tableView.dequeueReusableCellWithIdentifier("sideBarCell") as! SideBarTableCell
        cell.setupCell(indexPath, selectedvalue: false, titleString:tableData[indexPath.row])
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        switch tableData[indexPath.row] {
        case RearSlider.case_history.rawValue:
            self.revealViewController().revealToggleAnimated(true)
            let strNotification = STRCaseHistoryVC.init(nibName: "STRCaseHistoryVC", bundle: nil)
            strNotification.titleName = RearSlider.case_history.rawValue
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
        case RearSlider.item_locator.rawValue:
            break
        case RearSlider.notification.rawValue:
            self.revealViewController().revealToggleAnimated(true)

            let strNotification = STRNotificationVC.init(nibName: "STRNotificationVC", bundle: nil)
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
        case  RearSlider.settings.rawValue:
            self.revealViewController().revealToggleAnimated(true)

            let strNotification = STRSettingViewController.init(nibName: "STRSettingViewController", bundle: nil)
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
        case  RearSlider.help.rawValue:
            self.revealViewController().revealToggleAnimated(true)

            let strNotification = STRHelpViewController.init(nibName: "STRHelpViewController", bundle: nil)
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
            
        case RearSlider.about.rawValue:
            self.revealViewController().revealToggleAnimated(true)

            let strNotification = STRAboutViewController.init(nibName: "STRAboutViewController", bundle: nil)
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
            
         
        case RearSlider.completeCase.rawValue:
            self.revealViewController().revealToggleAnimated(true)
            let strNotification = STRCaseHistoryVC.init(nibName: "STRCaseHistoryVC", bundle: nil)
            strNotification.titleName = RearSlider.completeCase.rawValue
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
        case RearSlider.inventory.rawValue:
            self.revealViewController().revealToggleAnimated(true)
            let strNotification = STRInventorViewController.init(nibName: "STRInventorViewController", bundle: nil)
            let leftSideNav = UINavigationController(rootViewController: strNotification)
            self.revealViewController().setFrontViewController(leftSideNav, animated: true)
            break
        case RearSlider.logout.rawValue:
             logOut()
            break
        case RearSlider.sendDiagnostic.rawValue:
            sendMail()
            break
        default:
            break
        }
        tableView.reloadData()
        
    }
    @IBAction func editButtonClicked(sender: AnyObject) {
        
        
    }
    

    //MARK: get user profile from api
    
    func getUSerProfile()->(){
            let generalApiobj = GeneralAPI()
            let someDict:[String:String] = ["":""]
            generalApiobj.hitApiwith(someDict, serviceType: .STRApiGetUSerProfile, success: { (response) in
                dispatch_async(dispatch_get_main_queue()) {
                    print(response)
                    guard let data = response["data"] as? [String:AnyObject],let readerGetProfileResponse = data["readerGetProfileResponse"] as? [String:AnyObject] else{
                        utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                        return
                    }
                    
                    self.setUserDetail(readerGetProfileResponse)
                }
            }) { (err) in
                dispatch_async(dispatch_get_main_queue()) {
                      utility.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    NSLog(" %@", err)
                }
            }
            
        }
    
    func setUserDetail(data: Dictionary<String,AnyObject>) -> () {
        self.profileName!.text = "\(data["firstName"]!) \(data["lastName"]!)"
        let url = NSURL(string: "\(data["profileImage"]!)")
        
        self.profileImage?.sd_setImageWithURL(url,placeholderImage:UIImage(named: "editprofile_default" ))
        
        utility.setUserFirstName(data["firstName"]! as! String)
        utility.setUserLastName(data["lastName"]! as! String)
        utility.setCountryDialCode((data["countryDialCode"] as? String)!)
        utility.setCountryCode((data["countryCode"] as? String)!)

    }
    func logOut() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith([:], serviceType: .STRApiSignOut, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                applicationEnvironment.ApplicationCurrentType = applicationType.salesRep
                utility.setUserToken(" ")
                self.presentLogin()
                print(response["data"])
                
                let dataDictionary = response["message"] as? String
                
                if dataDictionary == "Ok" {
                    
                }
                
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                applicationEnvironment.ApplicationCurrentType = applicationType.salesRep
                utility.setUserToken(" ")
                self.presentLogin()
                NSLog(" %@", err)
            }
        }
    }
    
    func presentLogin() -> () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }
    func setUpFont(){
        self.profileName?.font = UIFont(name: "SourceSansPro-Regular", size: 18.0);
        
    }
    func sendMail()->(){
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/"+role+"_log.csv")
        let fileData = NSURL(fileURLWithPath: documentsPath)
        let objectsToShare = [fileData]
        self.activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
   
        let model = UIDevice.currentDevice().model
        print("device type=\(model)")
        if model == "iPad" {
            print("device type inside ipad =\(model)")
            if let wPPC = activityVC!.popoverPresentationController {
                wPPC.sourceView = activityVC!.view
            }
            presentViewController( activityVC!, animated: true, completion: nil)
        }else{
            self.presentViewController(activityVC!, animated: true, completion: nil)
        }
    }
}
