//
//  TBRMutableDictionary.m
//  TBRMutableDictionary
//
//  Created by Luciano Marisi on 06/08/2015.
//  Copyright (c) 2015 TechBrewers LTD. All rights reserved.
//

#import "TBRMutableDictionary.h"
#import "TBRMutableCollectionMacros.h"

#define SYNC(block) dispatch_sync(self.synchronousQueue, ^{block;});
#define RETURN_SYNC(returnType, block) dispatch_sync_with_return_type(returnType, self.synchronousQueue, ^returnType(void){return block;});

@interface TBRMutableDictionary ()
@property (nonatomic, strong) NSMutableDictionary *mutableDictionary;
@property (nonatomic, strong) dispatch_queue_t synchronousQueue;
@end

@implementation TBRMutableDictionary

#pragma mark - Method synchronization

- (id)objectForKeyedSubscript:(id)key
{
  RETURN_SYNC(id, [self.mutableDictionary objectForKeyedSubscript:key]);
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
  SYNC([self.mutableDictionary setObject:obj forKeyedSubscript:key]);
}

- (void)removeAllObjects
{
  SYNC([self.mutableDictionary removeAllObjects]);
}

- (NSUInteger)count
{
  RETURN_SYNC(NSUInteger, [self.mutableDictionary count]);
}

#pragma mark - Object lifecycle

- (instancetype)init
{
  self = [super init];
  if (self) {
    _mutableDictionary = [NSMutableDictionary new];
    _synchronousQueue = dispatch_queue_create("TBRMutableDictionary_synchronous_queue", DISPATCH_QUEUE_SERIAL);
  }
  return self;
}

#pragma mark - Description

- (NSString *)description
{
  RETURN_SYNC(NSString *, self.mutableDictionary.description);
}

@end