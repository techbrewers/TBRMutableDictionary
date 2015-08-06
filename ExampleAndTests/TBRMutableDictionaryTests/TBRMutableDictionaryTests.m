//
//  TBRMutableDictionaryTests.m
//  TBRMutableDictionaryTests
//
//  Created by Luciano Marisi on 06/08/2015.
//  Copyright (c) 2015 TechBrewers LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TBRMutableDictionary.h"

static size_t numberOfConcurrentIterations = 100;

@interface TBRMutableDictionaryTests : XCTestCase
@end

@implementation TBRMutableDictionaryTests

- (void)testThreadSafety
{
  TBRMutableDictionary *tbrMutableDictionary = [TBRMutableDictionary new];
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(numberOfConcurrentIterations);
  dispatch_apply(numberOfConcurrentIterations, DISPATCH_QUEUE_PRIORITY_DEFAULT, ^(size_t i) {
    NSString *key = [@(i) stringValue];
    tbrMutableDictionary[key] = @(i);
    XCTAssertEqualObjects(tbrMutableDictionary[key], @(i));
    dispatch_semaphore_signal(semaphore);
  });
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
  dispatch_apply(numberOfConcurrentIterations, DISPATCH_QUEUE_PRIORITY_DEFAULT, ^(size_t i) {
    XCTAssertEqual([tbrMutableDictionary count], numberOfConcurrentIterations);
  });
}

- (void)testRemoveAllObjectsThreadSafety
{
  TBRMutableDictionary *tbrMutableDictionary = [TBRMutableDictionary new];
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(numberOfConcurrentIterations);
  dispatch_apply(numberOfConcurrentIterations, DISPATCH_QUEUE_PRIORITY_DEFAULT, ^(size_t i) {
    NSString *key = [@(i) stringValue];
    tbrMutableDictionary[key] = @(i);
    [tbrMutableDictionary removeAllObjects];
    dispatch_semaphore_signal(semaphore);
  });
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  XCTAssertEqual([tbrMutableDictionary count], 0);
}

@end
