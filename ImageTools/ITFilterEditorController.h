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

@protocol ITFilterEditorDelegate;

@interface ITFilterEditorController : UIViewController<UITableViewDelegate, UITableViewDataSource, InfColorPickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ITImageSelectionDelegte>
-(id)initWithFilter:(ITFilter *)filter;
@property (unsafe_unretained) id<ITFilterEditorDelegate> delegate;
@property (nonatomic, assign) CGSize inputImageSize;
@end

@protocol ITFilterEditorDelegate
-(void) filterValueChanged:(ITFilter*) pgFilter forKey:(NSString*) key;
-(void) discardFilter;
-(void) applyFilter;
@end
