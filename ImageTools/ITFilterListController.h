//
//  PGImageEffectsController.h
//  PhotoGrid
//
//  Created by pramati on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITFilterEditorController.h"

typedef void (^ITFilterSelectionBlock)( ITFilterEditorController* filter);

@interface ITFilterListController : UIViewController<UITableViewDelegate, UITableViewDataSource>


- (id)initWithFilters:(NSArray*) filtersArray filterSelectionBlock:(ITFilterSelectionBlock) callbackBlock filterEditingBlock:(ITFilterEditingBlock) editingCallbackBlock;

@end
