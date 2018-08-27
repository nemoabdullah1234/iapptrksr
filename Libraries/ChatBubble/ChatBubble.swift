import UIKit

class ChatBubble: UIView {

    
    // Properties
    var imageViewChat: UIImageView?
    var imageViewBG: UIImageView?
    var text: String?
    var labelChatText: UILabel?
    var labelName:UILabel?
    var labelTime: UILabel?
    var closure:((String)->())?
    var data: ChatBubbleData?
    
    
    /**
    Initializes a chat bubble view
    
    - parameter data:   ChatBubble Data
    - parameter startY: origin.y of the chat bubble frame in parent view
    
    - returns: Chat Bubble
    */
    init(data: ChatBubbleData, startY: CGFloat){
        self.data = data
        // 1. Initializing parent view with calculated frame
        super.init(frame: ChatBubble.framePrimary(data.type, startY:startY))
        
        // Making Background transparent
        self.backgroundColor = UIColor.clearColor()
        
        // adding gesture
      
        let tap = UITapGestureRecognizer.init(target: self, action:#selector(self.tap))
        tap.numberOfTapsRequired=1
        self.addGestureRecognizer(tap)
        
        let padding: CGFloat = 10.0
        let startX = padding
        var startY:CGFloat = 5.0

        
        
        labelName = UILabel(frame: CGRectMake(startX, startY, CGRectGetWidth(self.frame) - 2 * startX , 5))
        labelName?.textAlignment = data.type == .Mine ? .Left : .Left
        labelName?.numberOfLines = 0 // Making it multiline
        labelName?.text = data.name
        labelName?.sizeToFit() // Getting fullsize of it
        self.addSubview(labelName!)

        
        
        
        // 2. Drawing image if any
        if data.imagePath != nil {
            
            let width: CGFloat = min(100, CGRectGetWidth(self.frame) - 2 * padding)
            let height: CGFloat = 100 * (width / 100)
            imageViewChat = UIImageView(frame: CGRectMake(padding, CGRectGetMaxY(labelName!.frame), width, height))
            imageViewChat?.layer.cornerRadius = 5.0
            imageViewChat?.layer.masksToBounds = true
            self.addSubview(imageViewChat!)
        }
        
        // 3. Going to add Text if any
        if data.text != nil {
            if imageViewChat != nil {
                startY += CGRectGetMaxY(imageViewChat!.frame)
            }
            else{
                startY += CGRectGetMaxY(labelName!.frame)
            }
            
            
            labelChatText = UILabel(frame: CGRectMake(startX, startY, CGRectGetWidth(self.frame) - 2 * startX , 5))
            labelChatText?.textAlignment = data.type == .Mine ? .Right : .Left
            labelChatText?.numberOfLines = 0 // Making it multiline
            labelChatText?.text = data.text
            labelChatText?.sizeToFit() // Getting fullsize of it
            self.addSubview(labelChatText!)
        }
        
        labelTime = UILabel(frame: CGRectMake(CGRectGetMaxX(labelChatText!.frame)-15,  CGRectGetMaxY(labelChatText!.frame), CGRectGetWidth(self.frame) - 2 * startX , 5))
        labelTime?.textAlignment = data.type == .Mine ? .Right : .Right
        labelTime?.numberOfLines = 0 // Making it multiline
        labelTime?.text = data.date
        labelTime?.sizeToFit() // Getting fullsize of it
        
        if imageViewChat != nil{
        labelTime?.frame = CGRectMake(startX, CGRectGetMaxY(labelChatText!.frame),max(labelChatText!.frame.size.width, (labelTime?.frame.size.width)!,imageViewChat!.frame.size.width,labelName!.frame.size.width), (labelTime?.frame.size.height)!)
        }
        else{
           labelTime?.frame = CGRectMake(startX, CGRectGetMaxY(labelChatText!.frame),max(labelChatText!.frame.size.width, (labelTime?.frame.size.width)!,labelName!.frame.size.width), (labelTime?.frame.size.height)!)
        }
        self.addSubview(labelTime!)
        
        
        
        
        
        
        
        // 4. Calculation of new width and height of the chat bubble view
        var viewHeight: CGFloat = 0.0
        var viewWidth: CGFloat = 0.0
        if imageViewChat != nil {
            // Height calculation of the parent view depending upon the image view and text label
            viewWidth = max(CGRectGetMaxX(imageViewChat!.frame), CGRectGetMaxX(labelChatText!.frame),CGRectGetMaxX(labelName!.frame),CGRectGetMaxX(labelTime!.frame)) + padding
            viewHeight = max(CGRectGetMaxY(imageViewChat!.frame), CGRectGetMaxY(labelChatText!.frame)) + padding + (labelTime?.frame.size.height)! + (labelName?.frame.size.height)!
            
        } else {
            viewHeight = CGRectGetMaxY(labelChatText!.frame) + padding/2 + (labelTime?.frame.size.height)! + (labelName?.frame.size.height)!
            viewWidth = max(CGRectGetWidth(labelChatText!.frame),CGRectGetMaxX(labelName!.frame),CGRectGetMaxX(labelTime!.frame)) + CGRectGetMinX(labelChatText!.frame) + padding
        }
        
        // 5. Adding new width and height of the chat bubble frame
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), viewWidth, viewHeight)
        
        // 6. Adding the resizable image view to give it bubble like shape
        let bubbleImageFileName = data.type == .Mine ? "bubbleMine" : "bubbleSomeone"
        imageViewBG = UIImageView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        if data.type == .Mine {
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImageWithCapInsets(UIEdgeInsetsMake(14, 14, 17, 28))
        } else {
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImageWithCapInsets(UIEdgeInsetsMake(14, 22, 17, 20))
        }
        // Frame recalculation for filling up the bubble with background bubble image
        let repsotionXFactor:CGFloat = data.type == .Mine ? 0.0 : -8.0
        let bgImageNewX = CGRectGetMinX(imageViewBG!.frame) + repsotionXFactor
        let bgImageNewWidth =  CGRectGetWidth(imageViewBG!.frame) + CGFloat(12.0)
        let bgImageNewHeight =  CGRectGetHeight(imageViewBG!.frame) + CGFloat(6.0)
        imageViewBG?.frame = CGRectMake(bgImageNewX, 0.0, bgImageNewWidth, bgImageNewHeight)

        
        // Keepping a minimum distance from the edge of the screen
        var newStartX:CGFloat = 0.0
        if data.type == .Mine {
            // Need to maintain the minimum right side padding from the right edge of the screen
            let extraWidthToConsider = CGRectGetWidth(imageViewBG!.frame)
            newStartX = ScreenSize.SCREEN_WIDTH - extraWidthToConsider
        } else {
            // Need to maintain the minimum left side padding from the left edge of the screen
            newStartX = -CGRectGetMinX(imageViewBG!.frame) + 3.0
        }
        
        self.frame = CGRectMake(newStartX, CGRectGetMinY(self.frame), CGRectGetWidth(frame), CGRectGetHeight(frame))
        self.layer.borderWidth=1
        self.layer.borderColor=UIColor.blackColor().CGColor
        self.layer.cornerRadius=5
        
    }

    // 6. View persistance support
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FRAME CALCULATION
    class func framePrimary(type:BubbleDataType, startY: CGFloat) -> CGRect{
        let paddingFactor: CGFloat = 0.02
        let sidePadding = ScreenSize.SCREEN_WIDTH * paddingFactor
        let maxWidth = ScreenSize.SCREEN_WIDTH * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
        let startX: CGFloat = type == .Mine ? ScreenSize.SCREEN_WIDTH * (CGFloat(1.0) - paddingFactor) - maxWidth : sidePadding
        return CGRectMake(startX, startY, maxWidth, 5) // 5 is the primary height before drawing starts
    }
   
    
    func tap(){
        if((closure) != nil && imageViewChat?.image != nil)
        {
            closure!((self.data?.full)!)
        }

    }
}
