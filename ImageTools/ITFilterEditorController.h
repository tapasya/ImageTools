//
//  PGFilterEditorController.h
//  PhotoGrid
//
//  Created by pramati on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
