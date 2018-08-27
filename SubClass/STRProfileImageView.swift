import UIKit

class STRProfileImageView: UIImageView {

    var dict:String?
    
    func setUpImage(data:String){
        dict = data
        let url = NSURL(string: dict!)
        self.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_profile"))
    }
    
}
