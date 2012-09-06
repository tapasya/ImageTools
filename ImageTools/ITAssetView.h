

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ITAssetView : UIButton {
}

@property (nonatomic, strong) ALAsset *asset;
-(id)initWithAsset:(ALAsset*)_asset;
@end
