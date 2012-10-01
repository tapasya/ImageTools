//==============================================================================
//
//  ITImageFilterUtils.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <Foundation/Foundation.h>

@interface ITImageFilterUtils : NSObject
+ (NSArray *) FilterDictionaryForFilters: (NSArray *)names;
+ (NSDictionary *) attributesForFilter: (NSString *)name;
@end
