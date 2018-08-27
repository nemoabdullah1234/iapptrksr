import UIKit

class ViewController: UIViewController {

   @IBOutlet var signInButton :UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func barButtonItemClicked(){
        
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
       
        self.revealViewController().revealToggleAnimated(true)
        
    }
    
}

