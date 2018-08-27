import UIKit
import CoreData
import RealmSwift
import CoreLocation
import AirshipKit
import CoreBluetooth
import Fabric
import Crashlytics
import DeviceKit
import NBLOG
import NBSync
import NBTrack
import AKProximity
let realm = try! Realm()
let role = "salesrep"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,CBPeripheralManagerDelegate, UARegistrationDelegate {
    let pushHandler = PushHandler()
    let simulatorWarningDisabledKey = "ua-simulator-warning-disabled"
    var window: UIWindow?
    var viewController: UIViewController?
    var navController: UINavigationController?
    var rearViewController : RearViewController?
    let nointernet = NoInternetConnection()
    var beaconHandler: BeaconHandler?
    var locationHandler: NBLocationUpdateHandler?
    var locationTracker: LocationTracker?
    var locationUpdateTimer: NSTimer?
    var orientationLock = UIInterfaceOrientationMask.All
    var bluetoothPeripheralManager: CBPeripheralManager?
    var isfirstTime:Bool?
    let appType:applicationType = .salesRep
    let log:NBApplicationState = NBApplicationState.sharedHandler
    var managerState: ((CBPeripheralManager)->())?
    let locationHandlerObj:NBLocationUpdateHandler = NBLocationUpdateHandler.sharedHandler
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let device = UIDevice.currentDevice();
        let currentDeviceId = device.identifierForVendor!.UUIDString;
        utility.setDevice(currentDeviceId)
        getUSerProfile()
        postDeviceData()
        log.setRole = role
        //Start playing blank audio file.
        //You can run NSTimer() or whatever you need and it will continue executing in the background.
        //  backgroundTask.startBackgroundTask()
        return true
    }
    

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor(colorLiteralRed: 206.0/255.0, green: 203.0/255.0, blue: 198.0/255.0, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = UIColor(colorLiteralRed: 66.0/255.0, green: 68.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        pageControl.backgroundColor = UIColor(colorLiteralRed: 240.0/255.0, green: 240.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        application.applicationIconBadgeNumber = 0
        registerForPushNotifications(application)
        if ((launchOptions != nil) && (launchOptions![UIApplicationLaunchOptionsLocationKey]) != nil)
        {
            utility.showNotification("launched", message: "Location option key")
            print("UIApplicationLaunchOptionsLocationKey")
            
        }
        if(UIApplication.instancesRespondToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Alert , .Badge ,.Sound], categories: nil))
        }
        UINavigationBar.appearance().barTintColor = UIColor.darkGrayColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        locationHandlerObj.setBaseUrl(Kbase_url)
         locationHandlerObj.setRole(role)
        nointernet.checkReachablity()
        
        if (utility.getUserRole() ==  "Warehouse") {
            applicationEnvironment.ApplicationCurrentType = applicationType.warehouseOwner
        }else{
            applicationEnvironment.ApplicationCurrentType = applicationType.salesRep
        }
        
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
        
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        switch appType {
        case .salesRep:
           viewController = HomeViewController.init(nibName:"HomeViewController", bundle: nil)
            print("It's for Sales Rep")
        case .warehouseOwner:
            viewController = STRInventorViewController.init(nibName:"STRInventorViewController", bundle: nil)
            print("It's for wareHouse Owner")
        }
       
        navController = UINavigationController.init(rootViewController: viewController!)
        
        
       
       urbanRegister()
        
        
        rearViewController = RearViewController(nibName : "RearViewController" , bundle : nil);
        let nav=UINavigationController.init(rootViewController: rearViewController!);
        let reveler=SWRevealViewController.init(rearViewController: nav, frontViewController: navController)
        window?.rootViewController=reveler
       
        
        window?.makeKeyAndVisible()
        //On viewDidLoad/didFinishLaunchingWithOptions
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        getIntervals()
        Fabric.with([Crashlytics.self])
        logUser()
        
        
        /*new code for location tracking*/
        beaconHandler = BeaconHandler.sharedHandler
        beaconHandler?.initiateResponseBlocks({
            //stop
               NBApplicationState.sharedHandler.setRecordTime("\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))")
               NBApplicationState.sharedHandler.logEvent()
               NBApplicationState.sharedHandler.setRecordTime("")
            }, authenticationChanged: {
                //auth change
                NBLocationUpdateHandler.sharedHandler.nbScannerstate()
            }, updateBeaconInformation: { (beacon, PKSyncObj, coordinate) in
                //realm update
                 dispatch_async(dispatch_queue_create("background_update", nil), {
                 self.updateSyncBeaconData(beacon,primaryKey: PKSyncObj,coordinate: coordinate)
                   })
        })
        
        self.locationTracker = LocationTracker()
        self.locationTracker?.startLocationTracking({ (speed, altitude) in
            NBApplicationState.sharedHandler.setSpeed(speed)
            NBApplicationState.sharedHandler.setAltitude(altitude)
            
            }, location: { (location, accuracy) in
                NBApplicationState.sharedHandler.setAccuracy(accuracy)
                BeaconHandler.sharedHandler.stopBeconOperation()
                BeaconHandler.sharedHandler.dummy(location)
                // print(accuracy)
                
            }, andHeading: { (heading) in
                NBApplicationState.sharedHandler.setDirection(heading)
                // print(heading)
        })
        
        
        
        
        //Send the best location to server every 60 seconds
        // May adjust the time interval depends on the need of your app.
        let time:NSTimeInterval = 60.0;
        self.locationUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector:#selector(NBLocationUpdateHandler.updateLocation), userInfo: nil, repeats: true)
       
        
        return true
    }
    
    func urbanRegister()   {
        
        if(UIApplication.instancesRespondToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Alert , .Badge ,.Sound], categories: nil))
        }

        
        let config = UAConfig.defaultConfig()
        config.messageCenterStyleConfig = "UAMessageCenterDefaultStyle"
        UAirship.takeOff(config)
        print("Config:\n \(config)")
        UAirship.push()?.resetBadge()
        
        
        UAirship.push().pushNotificationDelegate = pushHandler
        UAirship.push().registrationDelegate = self
        
//        UAirship.push().userNotificationTypes = ([UIUserNotificationType.Alert ,
//                                                  UIUserNotificationType.Badge ,
//                                                  UIUserNotificationType.Sound])
        
        UAirship.push().userPushNotificationsEnabled = true
    }
    
    
    func updateLocation() {
        locationHandlerObj.nbSyncXtimeNew()
    }
    func logUser() {
        
        Crashlytics.sharedInstance().setUserEmail(utility.getUserEmail())
        Crashlytics.sharedInstance().setUserIdentifier(utility.getUserFirstName())
        Crashlytics.sharedInstance().setUserName(utility.getUserFirstName())
    }
    
    
    
    // Data Feeding
    func postDeviceData() {
       
        let generalApiobj = GeneralAPI()
        let systemVersion = UIDevice.currentDevice().name 
        print("iOS\(systemVersion)")
       
        let model = UIDevice.currentDevice().model
        print("device type=\(model)")
        
        let Version = UIDevice.currentDevice().systemVersion
        print("device type=\(Version)")
        
        let systemName = UIDevice.currentDevice().systemName
        print("systemName =\(systemName)")
        
        let identifierForVendor = UIDevice.currentDevice().identifierForVendor
        print("device type=\(identifierForVendor)")
        let uuid = identifierForVendor!.UUIDString
        print(uuid)
        let str :String = "Apple" + " " + Version + " (" + utility.getAppVersion()+")"

        let paramDict:[String:String] = ["deviceId":uuid, "manufacturer":str, "model": model, "os":"ios", "version":Version,"channelId":utility.getChannelId()!]
        
        generalApiobj.hitApiwith(paramDict, serviceType: .STRDeviceInformation, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
               
                NSLog(" %@", err)
            }
        }
    }
    
    
    // Airship
    
    func registrationSucceededForChannelID(channelID: String, deviceToken: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            "channelIDUpdated",
            object: self,
            userInfo:nil)
        
        let channelID = UAirship.push().channelID!
        print("My Application Channel ID: \(channelID)")
        
        utility.setChannelId(channelID)
        postDeviceData()
        
    }
    
    func failIfSimulator() {
        // If it's not a simulator return early
        if (TARGET_OS_SIMULATOR == 0 && TARGET_IPHONE_SIMULATOR == 0) {
            return
        }
        
        if (NSUserDefaults.standardUserDefaults().boolForKey(self.simulatorWarningDisabledKey)) {
            return
        }
        
        let alertController = UIAlertController(title: "Notice", message: "You will not be able to receive push notifications in the simulator.", preferredStyle: .Alert)
        let disableAction = UIAlertAction(title: "Disable Warning", style: UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey:self.simulatorWarningDisabledKey)
        }
        alertController.addAction(disableAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Let the UI finish launching first so it doesn't complain about the lack of a root view controller
        // Delay execution of the block for 1/2 second.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
   
    
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
    
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    
    
    func initSideBarMenu(){
        if (rearViewController == nil) {
           rearViewController = RearViewController.init(nibName: "RearViewController", bundle: nil)
       }
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
         var centerViewController : UIViewController
        switch appType {
        case .salesRep:
            centerViewController = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
            print("It's for Sales Rep")
        case .warehouseOwner:
            centerViewController = STRInventorViewController.init(nibName:"STRInventorViewController", bundle: nil)
            print("It's for wareHouse Owner")
        }
       
        let leftSideNav = UINavigationController(rootViewController: rearViewController!)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
       let sideMenu = SWRevealViewController.init(rearViewController: leftSideNav, frontViewController: centerNav)
        
        window?.rootViewController = sideMenu
    }
    
    
    func initSideBarMenuFromLogin(){
        let appType:applicationType = applicationEnvironment.ApplicationCurrentType
        rearViewController = RearViewController.init(nibName: "RearViewController", bundle: nil)
        var centerViewController : UIViewController
        switch appType {
        case .salesRep:
            centerViewController = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
            print("It's for Sales Rep")
        case .warehouseOwner:
            centerViewController = STRInventorViewController.init(nibName:"STRInventorViewController", bundle: nil)
            print("It's for wareHouse Owner")
        }
       
        let leftSideNav = UINavigationController(rootViewController: rearViewController!)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        let sideMenu = SWRevealViewController.init(rearViewController: leftSideNav, frontViewController: centerNav)
        
        window?.rootViewController = sideMenu
    }
    

    func applicationWillResignActive(application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        // sharedModel?.restartMonitoringLocation()
        // sharedModel?.detectSignificantMovemnt()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        self.getIntervals()
           getUSerProfile()

        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        locationHandlerObj.nbSyncXtimeNew()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // sharedModel?.startMonitoringLocation()
    }

    func applicationWillTerminate(application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       

        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Osscube.Stryker" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Stryker", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        let state = NBApplicationState.sharedHandler
        NBApplicationState.sharedHandler.setRole = role

        if(self.managerState != nil)
        {
            self.managerState!(peripheral)
        }
        var statusMessage = ""
        
        if #available(iOS 10.0, *) {
            switch peripheral.state {
            case CBManagerState.PoweredOn:
                statusMessage = "Bluetooth Status: Turned On"
                utility.setBlueToothState(1)
                NBApplicationState.sharedHandler.setRole = role
                state.setBLEAvailable("1")
                break
            case CBManagerState.PoweredOff,CBManagerState.Resetting,CBManagerState.Unauthorized,CBManagerState.Unsupported:
                
                statusMessage = "Bluetooth Status: Turned Off"
                NBApplicationState.sharedHandler.setRole = role

                state.setBLEAvailable("0")

                utility.setBlueToothState(0)
                break;
            default:
                statusMessage = "Bluetooth Status: Unknown"
                state.setBLEAvailable("0")
                NBApplicationState.sharedHandler.setRole = role

                utility.setBlueToothState(0)
            }
        } else {
            // Fallback on earlier versions
            
            switch peripheral.state.rawValue {
            case 5:
                statusMessage = "Bluetooth Status: Turned On"
                utility.setBlueToothState(1)
                NBApplicationState.sharedHandler.setRole = role
                state.setBLEAvailable("1")
               

                break
            case 4,3,2,1:
                statusMessage = "Bluetooth Status: Turned Off"
                utility.setBlueToothState(0)
                NBApplicationState.sharedHandler.setRole = role

                state.setBLEAvailable("0")

                
            default:
                statusMessage = "Bluetooth Status: Unknown"
                utility.setBlueToothState(0)
                NBApplicationState.sharedHandler.setRole = role
                 state.setBLEAvailable("0")

            }
            
        }
        
        print(statusMessage)
        
        if #available(iOS 10.0, *) {
            if peripheral.state == CBManagerState.PoweredOff {
                //TODO: Update this property in an App Manager class
            }
        } else {
            // Fallback on earlier versions
        }
        
        locationHandlerObj.nbScannerstate()
 
    }

    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }

    
    func getIntervals(){
        
    }
    
    func getUSerProfile()->(){
        if(utility.getUserToken() == nil || utility.getUserToken() == " ")
        {
            return
        }
        
        let generalApiobj = GeneralAPI()
        let someDict:[String:String] = ["":""]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiGetUSerProfile, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                guard let data = response["data"] as? [String:AnyObject],let readerGetProfileResponse = data["readerGetProfileResponse"] as? [String:AnyObject] else{
                    return
                }
                utility.setCountryDialCode((readerGetProfileResponse["countryDialCode"] as? String)!)
                utility.setCountryCode((readerGetProfileResponse["countryCode"] as? String)!)
                utility.setUserFirstName((readerGetProfileResponse["firstName"] as? String)!)
                utility.setUserLastName((readerGetProfileResponse["lastName"] as? String)!)

            }
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
            }
        }
        
    }
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(window?.rootViewController) {
            if (rootViewController.respondsToSelector(Selector("canRotate"))) {
                // Unlock landscape view orientations for this view controller
                return .AllButUpsideDown;
            }
        }
        
        // Only allow portrait (standard behaviour)
        return .Portrait;
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKindOfClass(UITabBarController)) {
            return topViewControllerWithRootViewController((rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKindOfClass(UINavigationController)) {
            return topViewControllerWithRootViewController((rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController.presentedViewController)
        }
        return rootViewController
    }
  func updateSyncBeaconData(beacons: [CLBeacon],primaryKey:String!,coordinate:CLLocationCoordinate2D!){
     
     let realm = try! Realm()
     var syncObj: NBSyncObject?
     syncObj = realm.objectForPrimaryKey(NBSyncObject.self, key: primaryKey!)
     if(syncObj == nil)
     {
     NBApplicationState.sharedHandler.setRole = role
     syncObj = NBSyncObject()
     try! realm.write {
     syncObj!.id = primaryKey!
     syncObj!.synced=false
     syncObj!.lat = String(format:"%.6f",coordinate!.latitude )// "\(coordinate!.latitude)"
     syncObj!.lng = String(format:"%.6f",coordinate!.longitude )// "\(coordinate!.longitude)"
     syncObj!.alt = NBApplicationState.sharedHandler.getAltitude()
     syncObj!.speed = NBApplicationState.sharedHandler.getSpeed()
     syncObj!.accuracy = NBApplicationState.sharedHandler.getAccuracy()
     syncObj!.direction =  NBApplicationState.sharedHandler.getDirection()
     for becn in beacons {
     let state = NBSensorStateModel()
     state.major = "\(becn.major)"
     state.minor = "\(becn.minor)"
     state.proximity = "\(becn.proximity.rawValue)"
     state.longitude = String(format:"%.6f",coordinate!.longitude )
     state.lattitude = String(format:"%.6f",coordinate!.latitude )
     state.UDIDBeacon = becn.proximityUUID.UUIDString
     NBApplicationState.sharedHandler.setRole = role
     NBApplicationState.sharedHandler.setSensorData(state)
     
     
     let beaconInfo = NBBeaconInfo()
     beaconInfo.cid = ""
     beaconInfo.data = ""
     beaconInfo.lat = String(format:"%.6f",coordinate!.latitude )
     beaconInfo.long = String(format:"%.6f",coordinate!.longitude )
     beaconInfo.timestamp = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
     beaconInfo.uuid =  becn.proximityUUID.UUIDString
     beaconInfo.major = "\(becn.major)"
     beaconInfo.minor = "\(becn.minor)"
     beaconInfo.distance = "\(becn.accuracy)"
     beaconInfo.rssi = "\(becn.rssi)"
     beaconInfo.synced = false
     beaconInfo.proximity = "\(becn.proximity.rawValue)"
     beaconInfo.id = "\(becn.major)\(becn.minor)\(syncObj!.id)"
     let sampleBeacon = realm.create(NBBeaconInfo.self, value: beaconInfo, update: true)
     syncObj!.event.append(sampleBeacon)
     realm.add(syncObj!, update: true)
     }
     }
     }
     else{
     NBApplicationState.sharedHandler.setRole = role
     try! realm.write {
     syncObj!.lat = String(format:"%.6f",coordinate!.latitude )//"\(coordinate!.latitude)"
     syncObj!.lng = String(format:"%.6f",coordinate!.longitude )// "\(coordinate!.longitude)"
     syncObj!.alt = NBApplicationState.sharedHandler.getAltitude()
     syncObj!.speed = NBApplicationState.sharedHandler.getSpeed()
     syncObj!.accuracy = NBApplicationState.sharedHandler.getAccuracy()
     syncObj!.direction =  NBApplicationState.sharedHandler.getDirection()
     
     for becn in beacons {
     let state = NBSensorStateModel()
     state.major = "\(becn.major)"
     state.minor = "\(becn.minor)"
     state.proximity = "\(becn.proximity.rawValue)"
     state.longitude = String(format:"%.6f",coordinate!.longitude )
     state.lattitude = String(format:"%.6f",coordinate!.latitude )
     state.UDIDBeacon = becn.proximityUUID.UUIDString
     NBApplicationState.sharedHandler.setSensorData(state)
     let beaconInfo = NBBeaconInfo()
     beaconInfo.cid = ""
     beaconInfo.data = ""
     beaconInfo.lat = String(format:"%.6f",coordinate!.latitude )// "\(coordinate!.latitude)"
     beaconInfo.long = String(format:"%.6f",coordinate!.longitude )// "\(coordinate!.longitude)"
     beaconInfo.timestamp = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
     beaconInfo.uuid =  becn.proximityUUID.UUIDString
     beaconInfo.major = "\(becn.major)"
     beaconInfo.minor = "\(becn.minor)"
     beaconInfo.synced = false
     beaconInfo.distance = "\(becn.accuracy)"
     beaconInfo.rssi = "\(becn.rssi)"
     beaconInfo.proximity = "\(becn.proximity.rawValue)"
     beaconInfo.id = "\(becn.major)\(becn.minor)\(syncObj!.id)"
     if let sampleBeacon = syncObj!.event.filter("id = '\(becn.major)\(becn.minor)\(syncObj!.id)'").first{//realm.create(OSSBeaconInfo.self, value: beaconInfo, update: true)
     sampleBeacon.lat = String(format:"%.6f",coordinate!.latitude )//"\(coordinate!.latitude)"
     sampleBeacon.long = String(format:"%.6f",coordinate!.longitude )//"\(coordinate!.longitude)"
     sampleBeacon.timestamp = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
     //syncObj!.event.append(sampleBeacon)
     }
     else{
     let sampleBeacon=realm.create(NBBeaconInfo.self, value: beaconInfo, update: true)
     syncObj!.event.append(sampleBeacon)
     }
     realm.add(syncObj!, update: true)
     }
     }
     
     }
     
     
     }
}

