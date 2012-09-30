//
//  ITAlbumPickerController.h
//  ImageTools
//
//  Created by pramati on 9/4/12.
//
//

#import <UIKit/UIKit.h>
#import "ITImagePickerController.h"

@interface ITAlbumPickerController : UITableViewController
@property (nonatomic, copy) ITImageSelectionBlock selectionBlock;
@end
