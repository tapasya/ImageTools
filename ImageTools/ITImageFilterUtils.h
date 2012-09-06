//
//  PGImageFilterUtils.h
//  PhotoGrid
//
//  Created by pramati on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITImageFilterUtils : NSObject
+ (NSArray *) FilterDictionaryForFilters: (NSArray *)names;
+ (NSDictionary *) attributesForFilter: (NSString *)name;
@end
