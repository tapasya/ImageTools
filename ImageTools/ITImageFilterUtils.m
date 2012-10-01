//==============================================================================
//
//  ITImageFilterUtils.m
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "ITImageFilterUtils.h"
#import "ITFilter.h"

@implementation ITImageFilterUtils


+ (NSArray *) FilterDictionaryForFilters: (NSArray *)names
{
    NSMutableArray       *temp;
    NSString             *classname;
    int                   i;
    
    temp = [[NSMutableArray alloc] init];
    
    for(i=0 ; i<[names count] ; i++)
    {
        classname = [names objectAtIndex:i];
        ITFilter* filter = [[ITFilter alloc] initWithFilter:classname];
        if(filter && [[filter editableProperties] count] > 0)
            [temp addObject:filter];        
        else
            NSLog(@" No attributes for '%@' filter", classname);
    }
    
    return [NSArray arrayWithArray:temp];
}

+ (NSDictionary *) attributesForFilter: (NSString *)name
{
    NSDictionary         *attr;
    
    CIFilter* filter = [CIFilter filterWithName:name];
    
    if(filter)
    {
        attr = [filter attributes];    
    }    
    else
        NSLog(@" could not create '%@' filter", name);
    
    return  attr;
}

+(NSMutableDictionary*) FilterDictionaryForCategory:(NSString*) categoryName
{
    NSMutableArray  *array;    
    array = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:categoryName]];
    return  nil ;
    
}

@end
