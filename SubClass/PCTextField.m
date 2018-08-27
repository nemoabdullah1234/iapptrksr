#import "PCTextField.h"

@implementation PCTextField



- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x =+ self.leftMargin;
     return bounds;
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x =+ _leftMargin;
    return bounds;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    bounds.origin.x =+ _leftMargin;
    bounds.origin.y =+_topMargin;
    
    return bounds;
}

@end
