//==============================================================================
//
//  ITFilter.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

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
