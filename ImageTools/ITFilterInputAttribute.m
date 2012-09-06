//
//  PGFilterInputAttribute.m
//  PhotoGrid
//
//  Created by pramati on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ITFilterInputAttribute.h"
#import <CoreImage/CoreImage.h>

@implementation ITFilterInputAttribute
@synthesize key,maxSliderValue,minSliderValue,defalultValue, type, className, displayName, components, value;
@synthesize minValue=_minValue, maxValue=_maxValue;

+(ITFilterInputAttribute*) fromDictionary:(NSDictionary *)dict key:(NSString *)key
{
    ITFilterInputAttribute* attr = [[ITFilterInputAttribute alloc] init];
    attr.key = key;
    NSString* displayName = [dict objectForKey:kCIAttributeDisplayName];
    if(!displayName)
    {
        attr.displayName = attr.key;
    }
    attr.className = [dict objectForKey:kCIAttributeClass];
    attr.type = [dict objectForKey:kCIAttributeType];
    attr.maxSliderValue = [dict objectForKey:kCIAttributeSliderMax];
    attr.minSliderValue = [dict objectForKey:kCIAttributeSliderMin];
    attr.minValue = [dict objectForKey:kCIAttributeMin];
    attr.maxValue = [dict objectForKey:kCIAttributeMax];
    attr.defalultValue = [dict objectForKey:kCIAttributeDefault];
    attr.value = attr.defalultValue;
    if([attr.type isEqualToString:kCIAttributeTypePosition] || [attr.type isEqualToString:kCIAttributeTypeOffset])
    {
        attr.components = 2;
    }
    else
    {
        attr.components = 1;
    }
    return attr;
}

-(void) updatePositionValue:(CGFloat )toValue forComponent:(NSString *)component
{
    if([self.type isEqualToString:kCIAttributeTypePosition]  || [self.type isEqualToString:kCIAttributeTypeOffset])
    {
        CIVector* position = self.value;
        if([component isEqualToString:kXPositionTag])
        {
            CIVector* tempValue = [[CIVector alloc] initWithX:toValue Y:position.Y];
            self.value = tempValue;
        }
        else if( [component isEqualToString:kYPositionTag])
        {
            CIVector* tempValue = [[CIVector alloc] initWithX:position.X Y:toValue];
            self.value = tempValue;
        }
    }
    else
    {
        NSLog(@"Invalid call of position update for attribute type : %@", self.type);
    }
}
@end
