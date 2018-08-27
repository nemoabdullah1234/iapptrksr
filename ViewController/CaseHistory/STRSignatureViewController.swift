import UIKit
import SwiftSignatureView


struct AppUtility {
    
    static func lockOrientation(orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.currentDevice().setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

class STRSignatureViewController: UIViewController{

    @IBOutlet weak var signatureView: SwiftSignatureView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    var blockGetImage:((UIImage)->())?
    var fullName:String?
    var phoneSTr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signatureView.delegate = self
        fullNameLabel.text = fullName
        phoneNumberLabel.text = phoneSTr
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapClear() {
        signatureView.clear()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeLeft
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //AppUtility.lockOrientation(.LandscapeLeft)
        // Or to rotate and lock
        AppUtility.lockOrientation(.Portrait, andRotateTo: .LandscapeLeft)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.All)
    }
    @IBAction func saveButtonPress(sender: UIButton) {
        if let signatureImage = self.signatureView.signature {
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
            
            if(self.blockGetImage != nil)
            {
                self.blockGetImage!(signatureImage)
            }
            
            
            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            
            
            //On signature save pop the view controller
                self.dismissViewControllerAnimated(true) { () -> Void in
                    UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
                }
            
        }
    }
    @IBAction func backButtonPress(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
        }
    }
    
    func canRotate() -> Void {}
}
extension STRSignatureViewController : SwiftSignatureViewDelegate
{
    internal func swiftSignatureViewDidTapInside(view: SwiftSignatureView) {
        print("Did tap inside")
    }
    
    internal func swiftSignatureViewDidPanInside(view: SwiftSignatureView) {
        print("Did pan inside")
    }
}
