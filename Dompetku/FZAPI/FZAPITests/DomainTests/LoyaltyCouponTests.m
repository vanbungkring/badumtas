//
//  LoyaltyCouponTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 11/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "LoyaltyCoupon.h"

@interface LoyaltyCouponTests : XCTestCase

@end

@implementation LoyaltyCouponTests

#pragma mark - Init

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Samples
/*
 - (void)testExample {
 // This is an example of a functional test case.
 XCTAssert(NO, @"TODO");
 }
 
 - (void)testPerformanceExample {
 // This is an example of a performance test case.
 [self measureBlock:^{
 // Put the code you want to measure the time of here.
 }];
 }
 */

#pragma mark - Tests

- (void)testLoyaltyCouponWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getinvoice" withClass:[NSDictionary dictionary]];
    
    NSArray *array = [aDictionary valueForKey:@"couponList"];
    NSUInteger length = array.count;
    
    for(int i = 0; i < length; i++){
        
        //LoyaltyCoupon *aLoyaltyCoupon = [LoyaltyCoupon loyaltyCouponWithDictionary:[array objectAtIndex:i] error:nil];
        [LoyaltyCoupon loyaltyCouponWithDictionary:[array objectAtIndex:i] successBlock:^(id object) {
            XCTAssertNotNil(aLoyaltyCoupon, @"LoyaltyCoupon testLoyaltyCouponWithDictionary failure");
            
            XCTAssertGreaterThanOrEqual([aLoyaltyCoupon amount], 0.0, @"LoyaltyCoupon : amount < 0");
            XCTAssertNotNil([aLoyaltyCoupon currency], @"No currency");
            XCTAssertNotNil([aLoyaltyCoupon couponId], @"No couponId");
            NSString *couponType = [NSString stringWithFormat:@"%u",[aLoyaltyCoupon couponType]];
            XCTAssertNotNil(couponType, @"");
            XCTAssertNotNil([aLoyaltyCoupon fidelitizId], @"No fidelitizId");
            XCTAssertNotNil([aLoyaltyCoupon loyaltyCardId], @"No loyaltyCardId");
            XCTAssertNotNil([aLoyaltyCoupon loyaltyProgramId], @"No loyaltyProgramId");
            XCTAssertNotNil([aLoyaltyCoupon validityEndDate], @"No validityEndDate");
        } failureBlock:^(Error *error) {
            XCTFail(@"LoyaltyProgram : can't instantiate object");
        }];
    }
}

@end