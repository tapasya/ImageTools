
//==============================================================================
//  ITAssetView.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================


#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ITAssetView : UIButton {
}

@property (nonatomic, strong) ALAsset *asset;
-(id)initWithAsset:(ALAsset*)_asset;
@end
