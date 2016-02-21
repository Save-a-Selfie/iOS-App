//
//  SASAppCacheTest.m
//  Save a Selfie
//
//  Created by Stephen Fox on 21/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SASAppCache.h"

@interface SASAppCacheTest : XCTestCase

@property (strong, nonatomic) SASAppCache *appCache;

@end

@implementation SASAppCacheTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void) testSharedInstance {
  self.appCache = [SASAppCache sharedInstance];
  XCTAssertNotNil(self.appCache);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
