//
//  TBRMutableDictionary.m
//  TBRMutableDictionary
//
//  Created by Luciano Marisi on 06/08/2015.
//  Copyright (c) 2015 TechBrewers LTD. All rights reserved.
//

#import "TBRMutableDictionary.h"

#define SYNC(block) [self executeBlockOnSynchronousQueue:^{block;}];
#define RETURN_OBJECT_SYNC(block) return [self executeObjectReturningBlockOnSynchronousQueue:^{return block;}];
#define RETURN_NSUInteger_SYNC(block) return  [self executeNSUintegerReturningBlockOnSynchronousQueue:^{return block;}];

#define dispatch_sync_with_return_type(type, synchronousQueue, returningBlock) \
  __block type typedVariable;\
  dispatch_sync(synchronousQueue, ^{\
    typedVariable = returningBlock();\
  });\
  return typedVariable;\

#define BASIC_METHOD_INVOCATION \
  NSMethodSignature *signature  = [self methodSignatureForSelector:_cmd];\
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
  [invocation setSelector:_cmd];\

#define ImplementMethod(method) method {\
  BASIC_METHOD_INVOCATION \
  SYNC([invocation invokeWithTarget:self.mutableDictionary]);\
}

#define ImplementReturningMethodWithParameter(method, parameter) method parameter {\
  BASIC_METHOD_INVOCATION \
  [invocation setArgument:&parameter atIndex:2];\
  __block id obj;\
  dispatch_sync(self.synchronousQueue, ^{\
    [invocation invokeWithTarget:self.mutableDictionary];\
    [invocation getReturnValue:&obj];\
  });\
  return obj;\
}

#define ImplementReturningMethod(method, returnType) method {\
  BASIC_METHOD_INVOCATION \
  __block returnType obj;\
  dispatch_sync(self.synchronousQueue, ^{\
    [invocation invokeWithTarget:self.mutableDictionary];\
    [invocation getReturnValue:&obj];\
  });\
  return obj;\
}

@interface TBRMutableDictionary ()
@property (nonatomic, strong) NSMutableDictionary *mutableDictionary;
@property (nonatomic, strong) dispatch_queue_t synchronousQueue;
@end

@implementation TBRMutableDictionary

#pragma mark - Method synchronization

ImplementReturningMethodWithParameter(- (id)objectForKeyedSubscript:(id), key)

//- (id)objectForKeyedSubscript:(id)key
//{
//  RETURN_OBJECT_SYNC([self.mutableDictionary objectForKeyedSubscript:key]);
//}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
  SYNC([self.mutableDictionary setObject:obj forKeyedSubscript:key]);
}

ImplementMethod(- (void)removeAllObjects);

//- (void)removeAllObjects
//{
//  SYNC([self.mutableDictionary removeAllObjects]);
//}

ImplementReturningMethod(- (NSUInteger)count, NSUInteger)

//- (NSUInteger)count
//{
//  RETURN_NSUInteger_SYNC([self.mutableDictionary count]);
//}

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
  __block NSString *description = nil;
  dispatch_sync(self.synchronousQueue, ^{
    description = self.mutableDictionary.description;
  });
  return description;
}

#pragma mark - Synchoronous execution blocks

- (void)executeBlockOnSynchronousQueue:(void(^)(void))block
{
  dispatch_sync(self.synchronousQueue, block);
}

- (id)executeObjectReturningBlockOnSynchronousQueue:(id(^)(void))returningBlock
{
  dispatch_sync_with_return_type(id, self.synchronousQueue, returningBlock);
}

- (NSUInteger)executeNSUintegerReturningBlockOnSynchronousQueue:(NSUInteger(^)(void))returningBlock
{
  dispatch_sync_with_return_type(NSUInteger, self.synchronousQueue, returningBlock);
}

@end