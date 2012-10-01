//==============================================================================
//
//  ITImagePickerController.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^ ITImageSelectionBlock) (ALAsset* asset);

@interface ITImagePickerController : UITableViewController

@property (nonatomic, assign) ALAssetsGroup *assetGroup;

@property (nonatomic, copy) ITImageSelectionBlock selectionBlock;

@end

