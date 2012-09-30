//
//  ITImagePickerController.h
//  ImageTools
//
//  Created by pramati on 9/4/12.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^ ITImageSelectionBlock) (ALAsset* asset);

@interface ITImagePickerController : UITableViewController

@property (nonatomic, assign) ALAssetsGroup *assetGroup;

@property (nonatomic, copy) ITImageSelectionBlock selectionBlock;

@end

