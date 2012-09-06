//
//  PGFilterSlider.h
//  PhotoGrid
//
//  Created by pramati on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITFilter.h"

@interface ITFilterSlider : UISlider
@property (nonatomic, strong) NSString* attributeInputKey;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* componentKey;
@end
