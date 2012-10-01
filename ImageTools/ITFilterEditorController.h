//==============================================================================
//
//  ITFilterEditorController.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================
#import <UIKit/UIKit.h>
#import "ITFilter.h"
#import "InfColorPickerController.h"
#import "ITImagePickerController.h"
#import "ITFilterAttributeCell.h"

typedef void (^ITFilterEditingBlock) ( UIImage* image) ;

/*
typedef void (^ITFilterDiscardBlock) ();

typedef void (^ITFilterApplyBlock) ();

 */

@interface ITFilterEditorController : UIViewController< UITableViewDelegate,
                                                        UITableViewDataSource,
                                                        InfColorPickerControllerDelegate,
                                                        UIImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate>

-(id)initWithFilter:(ITFilter *)filter editingBlock:(ITFilterEditingBlock) callbackBlock;

@property (nonatomic, copy) ITFilterEditingBlock filterEditingBlock;

@property (nonatomic, assign) CGSize inputImageSize;

@property (nonatomic, copy) UIImage* inputImage;

@end
