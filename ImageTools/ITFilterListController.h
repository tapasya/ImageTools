//
//  PGImageEffectsController.h
//  PhotoGrid
//
//  Created by pramati on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITFilterEditorController.h"

@protocol ITFilterSelectionDelegate;

@interface ITFilterListController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (unsafe_unretained) id <ITFilterSelectionDelegate> delegate;
- (id)initWithFilters:(NSArray*) filtersArray;
@end

@protocol ITFilterSelectionDelegate
-(void) filterSelected:(ITFilter*) filter;
@end
