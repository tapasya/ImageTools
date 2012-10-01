//==============================================================================
//
//  ITFilterSlider.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>
#import "ITFilter.h"

@interface ITFilterSlider : UISlider
@property (nonatomic, strong) NSString* attributeInputKey;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* componentKey;
@end
