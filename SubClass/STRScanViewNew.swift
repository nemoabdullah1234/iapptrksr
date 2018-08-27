import UIKit
import CoreBluetooth
class STRScanViewNew: UIView,CBPeripheralManagerDelegate {
    var imgBaseView: UIImageView?
    var imgFrontView: UIImageView?
    var btnScan: UIButton?
    var manager  = CBCentralManager()
    var bluetoothPeripheralManager: CBPeripheralManager?
    var scanBlock:((Int)->())?
    override func awakeFromNib() {
        
        
    setUpView()
    let delegate =  UIApplication.sharedApplication().delegate as? AppDelegate
        delegate?.managerState = {(peripheral)in
            if(peripheral.state.rawValue == 5)
            {
                self.imgBaseView?.image = UIImage(named: "bleactivebase")
                self.imgFrontView?.image = UIImage(named: "bleactivefront")
                self.btnScan?.userInteractionEnabled = true
 
            }
            else
            
            {
                self.imgBaseView?.image = UIImage(named: "bleinactivebase")
                self.imgFrontView?.image = UIImage(named: "bleinactivefront")
                self.btnScan?.userInteractionEnabled = false
                self.btnScan!.tag = 0
                self.stopAnimation()
            }
        }
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        self.bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)

    }
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        if(peripheral.state.rawValue == 5 )
        {
            imgBaseView?.image = UIImage(named: "bleactivebase")
            imgFrontView?.image = UIImage(named: "bleactivefront")
            btnScan?.userInteractionEnabled = true
        }
        else{
            imgBaseView?.image = UIImage(named: "bleinactivebase")
            imgFrontView?.image = UIImage(named: "bleinactivefront")
            btnScan?.userInteractionEnabled = false
        }
        
    }

    func setUpView(){
        imgBaseView = nil
        imgBaseView = UIImageView()
        imgBaseView?.contentMode = UIViewContentMode.ScaleAspectFit
        imgBaseView!.translatesAutoresizingMaskIntoConstraints=false
        imgFrontView = nil
        imgFrontView = UIImageView()
        imgFrontView?.contentMode = UIViewContentMode.ScaleAspectFit
        imgFrontView!.translatesAutoresizingMaskIntoConstraints = false
               btnScan = nil
        btnScan = UIButton()
        btnScan?.addTarget(self, action:  #selector(STRScanViewNew.pressed(_:)), forControlEvents: .TouchUpInside)
        btnScan!.translatesAutoresizingMaskIntoConstraints = false
        manager  = CBCentralManager()
        if(manager.state.rawValue == 5)
        {
            imgBaseView?.image = UIImage(named: "bleactivebase")
            imgFrontView?.image = UIImage(named: "bleactivefront")
            btnScan?.userInteractionEnabled = true
        }
        else{
            imgBaseView?.image = UIImage(named: "bleinactivebase")
            imgFrontView?.image = UIImage(named: "bleinactivefront")
            btnScan?.userInteractionEnabled = false
        }

        self .addSubview(imgBaseView!)
        self .addSubview(imgFrontView!)
        self .addSubview(btnScan!)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
         //Add constrints
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[imgBaseView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imgBaseView" : imgBaseView!]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[imgBaseView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imgBaseView" : imgBaseView!]))
        
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[imgFrontView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imgFrontView" : imgFrontView!]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[imgFrontView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imgFrontView" : imgFrontView!]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[btnScan]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["btnScan" : btnScan!]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[btnScan]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["btnScan" : btnScan!]))

    }
    func pressed(sender:UIButton){
        if(self.scanBlock != nil)
        {
            self.scanBlock!((btnScan?.tag)!)
        }
        if(self.btnScan!.tag == 1)
        {
            self.btnScan!.tag = 0
            self.stopAnimation()
        }
        else{
           self.btnScan!.tag = 1
            self.startAnimation()

        }

    }
    func startAnimation(){
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 0.70
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        imgFrontView!.layer.addAnimation(pulseAnimation, forKey: "animateOpacity")
    }
    func stopAnimation(){
        imgFrontView!.layer.removeAllAnimations()
    }
    func resetState(){
        stopAnimation()
        self.btnScan!.tag = 0
    }

}
