//
//  ITFilterAttributeCell.h
//  ImageTools
//
//  Created by pramati on 9/6/12.
//
//

#import <UIKit/UIKit.h>
#import "ITFilterInputAttribute.h"

typedef void (^ITSliderActionBlock) (id sender);

@interface ITFilterAttributeCell : UITableViewCell

@property (nonatomic, strong) ITFilterInputAttribute* attribute;

@property (nonatomic, copy) ITSliderActionBlock sliderActionBlock;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier filterAttribute:(ITFilterInputAttribute*) inputAttr;

+(void) configureCell:(ITFilterAttributeCell*) cell indexPath:(NSIndexPath*) indexPath;

@end
