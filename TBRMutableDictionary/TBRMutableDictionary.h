//
//  TBRMutableDictionary.h
//  TBRMutableDictionary
//
//  Created by Luciano Marisi on 06/08/2015.
//  Copyright (c) 2015 TechBrewers LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Thread safe mutable dictionary, it uses a NSMutableDictionary internally
 *  for storage and forwards some methods through a synchornous queue
 */
@interface TBRMutableDictionary : NSObject
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (void)removeAllObjects;
- (NSUInteger)count;
@end
