//
//  PaymentSummaryTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "PaymentSummary.h"

@interface PaymentSummaryTests : XCTestCase

@end

@implementation PaymentSummaryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPaymentSummaryWithDictionaryWithCoupons {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"payinvoiceCorrectedInvoiceAmountWithCoupons" withClass:[NSDictionary dictionary]];
    
    //PaymentSummary *paymentSummary = [PaymentSummary paymentSummaryWithDictionary:aDictionary error:error];
    [PaymentSummary paymentSummaryWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil([paymentSummary currency], @"PaymentSummary : no currency");
        XCTAssertNotNil([paymentSummary couponType], @"PaymentSummary : no couponType");
        
        XCTAssertGreaterThanOrEqual([paymentSummary newBalance], 0.0, @"PaymentSummary : newBalance < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbCouponsGenerated], 0.0, @"PaymentSummary : nbCouponsGenerated < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary couponAmount], 0.0, @"PaymentSummary : couponAmount < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbGeneratedPoints], 0.0, @"PaymentSummary : nbGeneratedPoints < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbPointsToGetACoupon], 0.0, @"PaymentSummary : nbPointsToGetACoupon < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbPointsOnLoyaltyCard], 0.0, @"PaymentSummary : nbPointsOnLoyaltyCard < 0");
    } failureBlock:^(Error *error) {
        XCTFail(@"PaymentSummary : can't instantiate object");
    }];
}

- (void)testPaymentSummaryWithDictionaryWithoutCoupons {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"payinvoiceCorrectedInvoiceAmount" withClass:[NSDictionary dictionary]];
    
    //PaymentSummary *paymentSummary = [PaymentSummary paymentSummaryWithDictionary:aDictionary error:error];
    [PaymentSummary paymentSummaryWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil([paymentSummary currency], @"PaymentSummary : no currency");
        XCTAssertNotNil([paymentSummary couponType], @"PaymentSummary : no couponType");
        
        XCTAssertGreaterThanOrEqual([paymentSummary newBalance], 0.0, @"PaymentSummary : newBalance < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbCouponsGenerated], 0.0, @"PaymentSummary : nbCouponsGenerated < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary couponAmount], 0.0, @"PaymentSummary : couponAmount < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbGeneratedPoints], 0.0, @"PaymentSummary : nbGeneratedPoints < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbPointsToGetACoupon], 0.0, @"PaymentSummary : nbPointsToGetACoupon < 0");
        XCTAssertGreaterThanOrEqual([paymentSummary nbPointsOnLoyaltyCard], 0.0, @"PaymentSummary : nbPointsOnLoyaltyCard < 0");
    } failureBlock:^(Error *error) {
        XCTFail(@"PaymentSummary : can't instantiate object");
    }];
}

@end