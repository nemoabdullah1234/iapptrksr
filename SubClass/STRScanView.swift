import UIKit

class STRScanView: UIView {
    
    func startAnimation(){
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.90
        pulseAnimation.toValue = 1.10
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        self.layer.addAnimation(pulseAnimation, forKey: "animateOpacity")
    }
    func stopAnimation(){
        self.layer.removeAllAnimations()
    }
}
