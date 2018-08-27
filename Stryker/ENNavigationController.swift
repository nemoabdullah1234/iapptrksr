//
//  ENNavigationController.swift
//  Stryker
//
//  Created by Nitin Singh on 10/06/16.
//  Copyright © 2016 OSSCube. All rights reserved.
//

import UIKit

class ENNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: RearViewController(), menuPosition:.Left)
        sideMenu?.menuWidth = 180.0
        view.bringSubviewToFront(navigationBar)
        // Do any additional setup after loading the view.
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
