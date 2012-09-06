//
//  ITViewController.h
//  ImageToolsSample
//
//  Created by pramati on 9/3/12.
//
//

#import <UIKit/UIKit.h>
#import <ITools/ITFilterListController.h>

@interface ITViewController : UIViewController<ITFilterSelectionDelegate, ITFilterEditorDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end
