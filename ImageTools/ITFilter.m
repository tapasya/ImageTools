//==============================================================================
//
//  ITFilter.m
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "ITFilter.h"
#import "ITFilterInputAttribute.h"

@implementation ITFilter
@synthesize editableProperties=_editableProperties, displayName=_displayName, className=_className;
@synthesize ciFilter=_ciFilter;

-(id) initWithFilter:(NSString *)className
{
    self = [super init];
    if(self)
    {
        self.className = className;
        self.editableProperties = [[NSMutableDictionary alloc] init];
        NSArray* inputKeys = [self.ciFilter inputKeys];
        NSDictionary* attr = [self.ciFilter attributes];
        self.displayName = [attr objectForKey:kCIAttributeFilterDisplayName];
        for(NSString* key in inputKeys)
        {
            NSDictionary* inputAttr = [attr objectForKey:key];
            ITFilterInputAttribute* inputAttribute = [ITFilterInputAttribute fromDictionary:inputAttr key:key];
            //NSLog(@"%@ Attribute of %@ is of type %@ and of class %@", key, self.displayName, inputAttribute.type,inputAttribute.className);
            if(![inputAttribute.key isEqualToString:kCIInputImageKey])
            {
                [self.ciFilter setValue:inputAttribute.value forKey:inputAttribute.key];
                [self.editableProperties setObject:inputAttribute forKey:inputAttribute.key];
            }            
        }
    }
    return self;;
}

-(CIFilter*) ciFilter
{
    if(!_ciFilter)
    {
      _ciFilter = [CIFilter filterWithName:self.className];        
    }
    return  _ciFilter;
}

-(void) updateAttributeValue:(ITFilterInputAttribute *)attribute
{
    if(self.ciFilter)
    {
        [self.ciFilter setValue:attribute.value forKey:attribute.key];
    }
}
@end
