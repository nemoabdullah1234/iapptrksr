//
//  STRIssueHistoryVC.swift
//  Stryker
//
//  Created by Nitin Singh on 14/06/16.
//  Copyright © 2016 OSSCube. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
class STRIssueHistoryVC: UIViewController,ZBarReaderDelegate {
    var codeReader: STRBarCodeReaderViewController?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var tableViewSearch: UITableView?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var tblViewHeight: NSLayoutConstraint!
    var dataArrayObj = [AnyObject]()
    var searchItemData = [AnyObject]()
    
    
    @IBAction func actionCamera(sender: AnyObject) {
        
        let codeReader = STRBarCodeReaderViewController()
      
        codeReader.closureBar = {(value) in
        self.searchTextField.text = "\(value)"
        }
        let nav = UINavigationController(rootViewController: codeReader)
        self.navigationController?.presentViewController(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelbuttonClicked(sender: AnyObject) {
        
        searchTextField.text = ""
        searchTextField .resignFirstResponder()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = TitleName.ItemLocator.rawValue
        customizeNavigationforAll(self)
         self.navigationController?.navigationBar.translucent = false
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "ITemLocatorCell", bundle: nil)
        tableView!.registerNib(nib, forCellReuseIdentifier: "iTemLocatorCell")
        tableView!.tableFooterView = UIView()
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.revealViewController().panGestureRecognizer().enabled = false
      
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    func sortButtonClicked(sender : AnyObject){
        
        //tableView.tableHeaderView = searchController.searchBar
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func toggleSideMenu(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        
    }
    func backToDashbaord(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenu()
    }

    // Data Feeding
    func getData(searchText: String) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
         let someDict:[String:String] = ["Search":searchText]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiGetItem, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                
                
                if dataDictionary?.count <= 0 {
                    self.tableViewSearch?.hidden = true
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return
                }
                self.dataArrayObj = dataDictionary!["readerGetItemsResponse"]  as! [AnyObject]
                
                self.tableViewSearch?.hidden = false
                self.tblViewHeight.constant=self.tableViewSearch!.contentSize.height
                self.tableViewSearch!.reloadData()
                
           
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }

    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        if newLength > 3 {
            getData(textField.text!)
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewSearch {
            return dataArrayObj.count
        }
        return searchItemData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableViewSearch {
        return 44
        }
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView  == tableViewSearch {
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            if(cell == nil){
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            }
            let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
            
            cell!.textLabel!.text = infoDictionary!["itemName"] as? String
            cell!.textLabel?.font = UIFont(name: "Arial", size: 10)
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            
            return cell!
        }
        
        
        let cell: ITemLocatorCell = self.tableView!.dequeueReusableCellWithIdentifier("iTemLocatorCell") as! ITemLocatorCell
        
        let infoDictionary = self.searchItemData[indexPath.row] as? [String : AnyObject]
        
       
        
        cell.sideTitlelabel?.text = infoDictionary!["l2"] as? String
        cell.sideSubTitleLabel?.text = String(format: "Surgery Date %@",(infoDictionary!["l4"] as? String)! )
        cell.caseNumber?.text = String(format: "Case # %@",(infoDictionary!["l1"] as? String)! )
        cell.headerlabel?.text = infoDictionary!["l5"] as? String
        cell.addressLabel?.text = infoDictionary!["l2"] as? String
        cell.dateLabel?.text = String(format: "Due Back Date: %@",(infoDictionary!["l6"] as? String)! )
        cell.addressLabel?.text = infoDictionary!["l7"] as? String
        cell.subtitlelabel?.text = infoDictionary!["l3"] as? String
        
        cell.selectionStyle =  UITableViewCellSelectionStyle.None

        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView  == tableViewSearch {
         let infoDictionary = self.dataArrayObj[indexPath.row] as? [String : AnyObject]
        let aStr = String(format: "%d",(infoDictionary!["itemId"] as? Int)! )
         getDataSearchItems(aStr)
        self.tableViewSearch?.hidden = true
        searchTextField .resignFirstResponder()
        }
    }
    
    // Data Feeding
    func getDataSearchItems(searchText: String) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        let someDict:[String:String] = ["Search":searchText]
        generalApiobj.hitApiwith(someDict, serviceType: .STRApiSearchItems, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                
                
                if dataDictionary?.count <= 0 {
                    self.tableViewSearch?.hidden = true
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return
                }
                self.searchItemData = dataDictionary!["readerSearchItemsResponse"]  as! [AnyObject]
              
                self.tableView!.reloadData()
                
                
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
            }
        }
    }
    

}
