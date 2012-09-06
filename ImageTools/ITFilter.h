//
//  PGFilter.h
//  PhotoGrid
//
//  Created by pramati on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import "ITFilterInputAttribute.h"

@interface ITFilter : NSObject
-(id) initWithFilter:(NSString*) classname;
@property (nonatomic, strong) NSMutableDictionary* editableProperties;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) CIFilter* ciFilter;
-(void) updateAttributeValue:(ITFilterInputAttribute*)attribute;
@end
