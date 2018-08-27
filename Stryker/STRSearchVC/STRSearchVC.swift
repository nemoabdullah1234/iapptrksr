import UIKit

class STRSearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
       customNavigationforBack(self)
        // Do any additional setup after loading the view.
    }

    
    func dataFeeding()  {
        
    }

    func sortButtonClicked(sender : AnyObject){
        
        let VW = STRSearchViewController(nibName: "STRSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(VW, animated: true)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func poptoPreviousScreen() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    

}
