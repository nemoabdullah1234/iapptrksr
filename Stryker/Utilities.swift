import Foundation
import UserNotifications

var selectedIndex = 1





class MyCustomLabel : UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = UIColor.blueColor()
    }
}


class Point
{
    private var _x : Double = 0
    var x : Double {
        set { _x = 2 * newValue }
        get { return _x / 2 }
    }
}


func customizeNavigation(ref : UIViewController) {
    
    ref.navigationController!.navigationBar.barTintColor = UIColor(colorLiteralRed: 22.0/255.0, green: 25.0/255.0, blue: 31.0/255.0, alpha: 1)
    ref.navigationController?.navigationBar.translucent = false
    let button: UIButton = UIButton.init()
    
    button.setImage(UIImage(named: "sidemenu"), forState: UIControlState.Normal)
    button.addTarget(ref, action: #selector(HomeViewController.toggleSideMenu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    button.frame = CGRectMake(0, 0, 25, 25)
    
    let barButton = UIBarButtonItem(customView: button)
    ref.navigationItem.leftBarButtonItem = barButton
    
    
    let buttonSearch: UIButton = UIButton.init()
    
    buttonSearch.setImage(UIImage(named: "filter"), forState: UIControlState.Normal)
    //add function for button
    buttonSearch.addTarget(ref, action: #selector(HomeViewController.barButtonItemClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    //set frame
    buttonSearch.frame = CGRectMake(0, 0, 25, 25)
    
    let buttonSort: UIButton = UIButton.init()
    
    buttonSort.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
    //add function for button
    buttonSort.addTarget(ref, action: #selector(HomeViewController.sortButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    buttonSort.frame = CGRectMake(0, 0, 25, 25)
    
     let barButtonSort = UIBarButtonItem(customView: buttonSort)
    //assign button to navigationbar
    ref.navigationItem.rightBarButtonItems = [ barButtonSort]
    ref.navigationController?.navigationBar.titleTextAttributes =
        [NSForegroundColorAttributeName: UIColor.whiteColor(),
         NSFontAttributeName: UIFont(name: "Roboto-Light", size: 22)!]
    
}

func customNavigationforBack(ref : UIViewController) {
    ref.navigationController!.navigationBar.barTintColor = UIColor(colorLiteralRed: 22.0/255.0, green: 25.0/255.0, blue: 31.0/255.0, alpha: 1)
    ref.navigationController?.navigationBar.translucent = false
    
    
    let button: UIButton = UIButton.init()
    button.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
    button.addTarget(ref, action: #selector(STRSearchVC.poptoPreviousScreen), forControlEvents: UIControlEvents.TouchUpInside)
    button.frame = CGRectMake(0, 0, 25, 25)
    let spacing : CGFloat = 50;
    button.titleEdgeInsets = UIEdgeInsetsMake(-spacing, 0.0, 0.0, 0.0)
    let barButton = UIBarButtonItem(customView: button)
    ref.navigationItem.leftBarButtonItem = barButton
    
    
    
    
    let buttonSort: UIButton = UIButton.init()
    buttonSort.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
    //add function for button
    buttonSort.addTarget(ref, action: #selector(HomeViewController.sortButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    buttonSort.frame = CGRectMake(0, 0, 25, 25)
    let barButtonSort = UIBarButtonItem(customView: buttonSort)
    ref.navigationItem.rightBarButtonItems = [barButtonSort]
    
    ref.navigationController?.navigationBar.titleTextAttributes =
        [NSForegroundColorAttributeName: UIColor.whiteColor(),
         NSFontAttributeName: UIFont(name: "Roboto-Light", size: 22)!]
}



func customizeNavigationforAll(ref : UIViewController) {
    
     let button: UIButton = UIButton.init()
    ref.navigationController!.navigationBar.barTintColor = UIColor(colorLiteralRed: 22.0/255.0, green: 25.0/255.0, blue: 31.0/255.0, alpha: 1)
    ref.navigationController?.navigationBar.translucent = false
    
    button.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
    //add function for button
    button.addTarget(ref, action: #selector(STRNotificationVC.backToDashbaord), forControlEvents: UIControlEvents.TouchUpInside)
    //set frame
    button.frame = CGRectMake(0, 0, 25, 25)
    
    let barButton = UIBarButtonItem(customView: button)
    //assign button to navigationbar
    ref.navigationItem.leftBarButtonItem = barButton
    
    
    let buttonSort: UIButton = UIButton.init()
    buttonSort.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
    //add function for button
    buttonSort.addTarget(ref, action: #selector(HomeViewController.sortButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    buttonSort.frame = CGRectMake(0, 0, 25, 25)
    let barButtonSort = UIBarButtonItem(customView: buttonSort)
    ref.navigationItem.rightBarButtonItems = [barButtonSort]

    
    ref.navigationController?.navigationBar.titleTextAttributes =
        [NSForegroundColorAttributeName: UIColor.whiteColor(),
         NSFontAttributeName: UIFont(name: "Roboto-Light", size: 22)!]
    
}

func customizeNavigationWithDeleteAll(ref : UIViewController) {
    
    let button: UIButton = UIButton.init()
    ref.navigationController!.navigationBar.barTintColor = UIColor(colorLiteralRed: 22.0/255.0, green: 25.0/255.0, blue: 31.0/255.0, alpha: 1)
    ref.navigationController?.navigationBar.translucent = false
    
    button.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
    //add function for button
    button.addTarget(ref, action: #selector(STRNotificationVC.backToDashbaord), forControlEvents: UIControlEvents.TouchUpInside)
    //set frame
    button.frame = CGRectMake(0, 0, 25, 25)
    
    let barButton = UIBarButtonItem(customView: button)
    //assign button to navigationbar
    ref.navigationItem.leftBarButtonItem = barButton
    
    
    let buttonSort: UIButton = UIButton.init()
    buttonSort.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
    //add function for button
    buttonSort.addTarget(ref, action: #selector(HomeViewController.sortButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    buttonSort.frame = CGRectMake(0, 0, 25, 25)
    let barButtonSort = UIBarButtonItem(customView: buttonSort)
    
    let buttonDeleteAll: UIButton = UIButton.init()
    buttonDeleteAll.setImage(UIImage(named: "delete"), forState: UIControlState.Normal)
    //add function for button
    buttonDeleteAll.addTarget(ref, action: #selector(STRNotificationVC.deleteButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    buttonDeleteAll.frame = CGRectMake(0, 0, 25, 25)
    let barButtonDelete = UIBarButtonItem(customView: buttonDeleteAll)
    
    
    
    ref.navigationItem.rightBarButtonItems = [barButtonSort, barButtonDelete]
    
    
    ref.navigationController?.navigationBar.titleTextAttributes =
        [NSForegroundColorAttributeName: UIColor.whiteColor(),
         NSFontAttributeName: UIFont(name: "Roboto-Light", size: 22)!]
    
}


class utility:NSObject{
    
    class func isEmail(email: String)->(Bool){
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
        
    }
    
    
    class func getselectedIndexDashBoard()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("SelectedIndexDashboard") as? String
    }
    class func setselectedIndexDashBoard(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "SelectedIndexDashboard")
    }
    
    class func getselectedLocation()->(AnyObject){
        let val = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocation")
        if(val == nil)
        {
        return ""
        }
        else{
           return val!
        }
    }
    class func setselectedLocation(location: [String:AnyObject])->(){
        NSUserDefaults.standardUserDefaults().setObject(location, forKey: "selectedLocation")
    }
    class func getflagSession()->(Bool){
    let flag =    NSUserDefaults.standardUserDefaults().boolForKey("flagSession")
        return flag
           }
    class func setflagSession(flag: Bool)->(){
        NSUserDefaults.standardUserDefaults().setBool(flag, forKey: "flagSession")
    }

    
    class func getselectedSortBy()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("DashbordSortedBY") as? String
    }
    class func setselectedSortBy(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "DashbordSortedBY")
    }
    class func getChannelId()->(String?){
        let str = NSUserDefaults.standardUserDefaults().valueForKey("ChannelId") as? String
        if( str == nil)
        {
            return " "
        }
        else
        {
            return str
        }
    }
    class func getBaseUrl()->(String!){
       return Kbase_url
    }

    class func setChannelId(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "ChannelId")
    }
    
    class func getselectedSortOrder()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("DashbordSortedOrder") as? String
    }
    class func setselectedSortOrder(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "DashbordSortedOrder")
    }
    class func getNotificationAlert()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("NotificationAlert") as? String
    }
    class func setNotificationAlert(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "NotificationAlert")
    }
    class func getNotificationVibration()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("NotificationVibration") as? String
    }
    class func setNotificationVibration(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "NotificationVibration")
    }
    class func getNotificationBadge()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("NotificationBadge") as? String
    }
    class func setNotificationBadge(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "NotificationBadge")
    }
    class func getSilentFrom()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("SilentFrom") as? String
    }
    class func setSilentFrom(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "SilentFrom")
    }
    class func getSilentTo()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("SilentTo") as? String
    }
    class func setSilentTo(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "SilentTo")
    }
    class func getNotification()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("Notification") as? String
    }
    class func setNotification(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "Notification")
    }
    
    
    class func getBeaconServices()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("BeaconServices") as? String
    }
    class func setBeaconServices(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "BeaconServices")
    }
    
    class func setUserRole(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "UserRole")
    }
    
    class func getUserRole()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("UserRole") as? String
    }
    
    
    
    class func setUserEmail(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "UserEmail")
    }
    
    class func getUserEmail()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("UserEmail") as? String
    }
    
    class func setDevice(deviceID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(deviceID, forKey: "DEVICEID")
    }
    
    class func getDevice()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("DEVICEID") as? String
    }

class func showNotification(title: String ,message:String){
     /*  var localNotif : UILocalNotification?
     localNotif = UILocalNotification()
     localNotif!.alertBody = message
     if #available(iOS 8.2, *) {
     localNotif!.alertTitle = title
     } else {
     // Fallback on earlier versions
     }
     localNotif?.soundName = UILocalNotificationDefaultSoundName
     UIApplication.sharedApplication().presentLocalNotificationNow(localNotif!)*/

    }
    
class func setPermToken(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "USERID")
    }
    
    
   class func setCountryCode(countryCode: String){
        NSUserDefaults.standardUserDefaults().setObject(countryCode, forKey: "countryCode")
    }
    class func getCountryCode()->(String!){
        return NSUserDefaults.standardUserDefaults().valueForKey("countryCode") as! String
    }

    
    
    class func setCountryDialCode(countryCode: String){
        NSUserDefaults.standardUserDefaults().setObject(countryCode, forKey: "COUNTRYDIALCODE")
    }
    class func getCountryDialCode()->(String!){
        return NSUserDefaults.standardUserDefaults().valueForKey("COUNTRYDIALCODE") as! String
    }

 class func getPermToken()->(String?){
    let pt = NSUserDefaults.standardUserDefaults().valueForKey("USERID") as? String
    if(pt != nil)
    {
        return pt
    }
    else{
        return ""
    }
}
class func setUserToken(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "USERToken")
}
    
class func getUserToken()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("USERToken") as? String
}
    
    
    class func setUserFirstName(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "FUSERNAME_")
    }
    
    class func getUserFirstName()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("FUSERNAME_") as? String
    }
    
    class func setUserLastName(UserID: String)->(){
        NSUserDefaults.standardUserDefaults().setObject(UserID, forKey: "LUSERNAME_")
    }
    
    class func getUserLastName()->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey("LUSERNAME_") as? String
    }
   
    
    
    class func isPhoneNumber(phone: String)->(Bool){
            let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
            var filtered:NSString!
            let inputString:NSArray = phone.componentsSeparatedByCharactersInSet(charcter)
            filtered = inputString.componentsJoinedByString("")
            return  phone == filtered
    }
    
    
    class func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String, view:UIViewController)
    {        
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: view, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }
    
    class func postNotification(Title:String, body:String){
        var localNotif : UILocalNotification?
        localNotif = UILocalNotification()
        localNotif!.alertBody = Title
        if #available(iOS 8.2, *) {
            localNotif!.alertTitle = body
        } else {
            // Fallback on earlier versions
        }
        localNotif?.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotif!)
    }
    class func showAlertSheet(title:String,message: String,viewController:UIViewController)
    {
        let alertController = UIAlertController()
        alertController.message = message
        alertController.title = NSLocalizedString(ApplicationName.appName.rawValue, tableName: "UAPushUI", comment: "System Push Settings Label")
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = viewController.view
        viewController.presentViewController(alertController, animated:true, completion:nil)
    }
    class func getBlueToothState()->(Int){
        let state = NSUserDefaults.standardUserDefaults().valueForKey("USERDEFAULTBLUETOOTH") as? Int
        if(state == nil)
        {
            return 0
        }
        return state!
    }
    class func setBlueToothState(state:Int)->(){
        NSUserDefaults.standardUserDefaults().setInteger(state, forKey: "USERDEFAULTBLUETOOTH")
    }
    class func getAppVersion()->(String){
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        let version = nsObject as! String
        var buildType = "P"
        if(Kbase_url.containsString("ossclients"))
        {
            buildType = "Q"
        }
        
        return ("V" + version + buildType)
    }

   
}

func compressImage(image:UIImage) -> NSData {
    // Reducing file size to a 10th
    
    var actualHeight : CGFloat = image.size.height
    var actualWidth : CGFloat = image.size.width
    let maxHeight : CGFloat = 600.0
    let maxWidth : CGFloat = 800.0
    var imgRatio : CGFloat = actualWidth/actualHeight
    let maxRatio : CGFloat = maxWidth/maxHeight
    var compressionQuality : CGFloat = 0.5
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
            compressionQuality = 1;
        }
    }
    
    let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    image.drawInRect(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext();
    let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
    UIGraphicsEndImageContext();
    
    return imageData!;
}


func colorWithHexString (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE =  UIDevice.currentDevice().userInterfaceIdiom == .Phone
    static let IS_IPAD =  UIDevice.currentDevice().userInterfaceIdiom == .Pad
}

