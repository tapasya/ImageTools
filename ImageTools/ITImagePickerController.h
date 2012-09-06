//
//  ITImagePickerController.h
//  ImageTools
//
//  Created by pramati on 9/4/12.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ITImageSelectionDelegte;

@interface ITImagePickerController : UITableViewController
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, assign) id<ITImageSelectionDelegte> delegate;
@end

@protocol ITImageSelectionDelegte
-(void) assetSelected:(ALAsset*) asset;
@end
