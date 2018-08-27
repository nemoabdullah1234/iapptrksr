//
//  STRBarCodeReaderViewController.swift
//  Stryker
//
//  Created by Amarendra on 7/6/16.
//  Copyright © 2016 OSSCube. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

class STRBarCodeReaderViewController: RSCodeReaderViewController {
    var closureBar :((String)->())?
    override func viewDidLoad() {
        var value: String?
        super.viewDidLoad()
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        self.title = "Scan"
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                if(barcode.type.rangeOfString("QR") == nil)
                {
                                            value=barcode.stringValue
                        
                   
                }
            }
             dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion:{
                if(self.closureBar != nil)
                {
           
                self.closureBar!(value!)
                    }
                
            })
            }
            
           
        }
        
//        self.tapHandler = { point in
//              self.dismissViewControllerAnimated(true, completion: nil)
//        }
    setUpNaveBar()
        // Do any additional setup after loading the view.
    }
    func setUpNaveBar(){
        let button: UIButton = UIButton.init()
        
        button.setImage(nil, forState: UIControlState.Normal)
        button.setTitle("Done", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(STRBarCodeReaderViewController.done), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 50, 25)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton

    }
    
    func done(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
