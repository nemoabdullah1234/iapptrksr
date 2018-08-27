#import <UIKit/UIKit.h>

@interface CSFileSlideView :  UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *fileGallery;
@property(nonatomic,copy)void(^cellSelect)(NSIndexPath*);
@property(nonatomic,copy)void(^fileDelete)(NSIndexPath*);
@property(nonatomic,copy)BOOL(^removeFile)(NSIndexPath*);
-(NSInteger)addAssetURL:(NSString*)filePathURL;
-(void)replicateAwakeFromNib;
-(void)removeAllImages;
-(BOOL)validate;
@end
