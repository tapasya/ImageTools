//
//  PGFilterInputAttribute.h
//  PhotoGrid
//
//  Created by pramati on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define kXPositionTag @"xPos"
#define kYPositionTag @"yPos"

@interface ITFilterInputAttribute : NSObject
@property (nonatomic,strong)NSNumber* maxSliderValue;
@property (nonatomic,strong)NSNumber* minSliderValue;
@property (nonatomic, strong) NSNumber* minValue;
@property (nonatomic ,strong) NSNumber* maxValue;
@property (nonatomic,strong)id defalultValue;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, readwrite) int components;
@property (nonatomic, strong) id value;
+(ITFilterInputAttribute*) fromDictionary:(NSDictionary*) dict key:(NSString*) key;
-(void) updatePositionValue:(CGFloat) toValue forComponent: (NSString*) component;
@end
