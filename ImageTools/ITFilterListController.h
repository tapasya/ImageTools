//==============================================================================
//
//  ITImageEffectsController.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>
#import "ITFilterEditorController.h"

typedef void (^ITFilterSelectionBlock)( ITFilterEditorController* filter);

@interface ITFilterListController : UIViewController<UITableViewDelegate, UITableViewDataSource>


- (id)initWithFilters:(NSArray*) filtersArray filterSelectionBlock:(ITFilterSelectionBlock) callbackBlock filterEditingBlock:(ITFilterEditingBlock) editingCallbackBlock;

@end
