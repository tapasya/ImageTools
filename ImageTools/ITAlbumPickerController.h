//==============================================================================
//
//  ITAlbumPickerController.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>
#import "ITImagePickerController.h"

@interface ITAlbumPickerController : UITableViewController
@property (nonatomic, copy) ITImageSelectionBlock selectionBlock;
@end
