//==============================================================================
//
//  ITFilterAttributeCell.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>
#import "ITFilterInputAttribute.h"

typedef void (^ITSliderActionBlock) (id sender);

@interface ITFilterAttributeCell : UITableViewCell

@property (nonatomic, strong) ITFilterInputAttribute* attribute;

@property (nonatomic, copy) ITSliderActionBlock sliderActionBlock;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier filterAttribute:(ITFilterInputAttribute*) inputAttr;

+(void) configureCell:(ITFilterAttributeCell*) cell indexPath:(NSIndexPath*) indexPath;

@end
