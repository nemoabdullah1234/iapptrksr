//
//  CustomAlertViewController.swift
//  Stryker
//
//  Created by Nitin Singh on 29/11/16.
//  Copyright © 2016 OSSCube. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    var onCancel : (() -> Void)?
    var onConfirm : ((AnyObject?) -> Void)?
    
    var objectToDelete : AnyObject?

    var titleLabel: UILabel!
    
    
    func cancelButtonPressed() {
        // defered to ensure it is performed no matter what code path is taken
        defer {
            dismissViewControllerAnimated(false, completion: nil)
        }
        
        let onCancel = self.onCancel
        // deliberately set to nil just in case there is a self reference
        self.onCancel = nil
        guard let block = onCancel else { return }
        block()
    }
    
    func confirmationButtonPresssed() {
        // defered to ensure it is performed no matter what code path is taken
        defer {
            dismissViewControllerAnimated(false, completion: nil)
        }
        let onConfirm = self.onConfirm
        // deliberately set to nil just in case there is a self reference
        self.onConfirm = nil
        guard let block = onConfirm else { return }
        block(self.objectToDelete)
    }
   
    
        override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
            
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    func initwithCustomAlertView(viewController : UIViewController, titleMessage : String, buttonTitle : String) {
//        <#function body#>
//    }
    
    
    /*
     let confirm = ConfirmViewController()
     confirm.objectToDelete = NSObject()
     confirm.onCancel = {
     // perform some action here
     }
     confirm.onConfirm = { objectToDelete in
     // delete your object here
     }
    */

}
