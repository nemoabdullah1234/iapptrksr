import UIKit

class STRImageDisplay: UIView {
    var hideClouser : (()->())?
    @IBOutlet var imgChat: UIImageView!
    @IBAction func btnHide(sender: AnyObject) {
        
        if(self.hideClouser != nil)
        {
            self.hideClouser!()
        }
        
    }
    func setUpImage(image: String){
        self.imgChat.sd_setImageWithURL(NSURL(string: image))
        
    }
}
