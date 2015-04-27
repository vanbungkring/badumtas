//
//  WalletBraintreeTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "WalletBraintree.h"

@interface WalletBraintreeTests : XCTestCase

@end

@implementation WalletBraintreeTests

#pragma mark - Init

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests

- (void)testWalletBraintreeWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"createwebwalletBrainTree" withClass:[NSDictionary dictionary]];
    
    if([[aDictionary objectForKey:@"trData"] length] > 0){ //register credit card with Braintree (USD AUD)
        
        //WalletBraintree *wallet = [WalletBraintree walletBraintreeWithDictionary:aDictionary error:error];
        [WalletBraintree walletBraintreeWithDictionary:aDictionary successBlock:^(id object) {
            XCTAssertNotNil([(WalletBraintree *)object trData], @"Wallet : coupons is redirectUrl");
            XCTAssertNotNil([(WalletBraintree *)objec actionFormUrl], @"Wallet : coupons is creditCardId");

        } failureBlock:^(Error *error) {
            XCTFail(@"Wallet : can't instantiate object");
        }];
    } else { //register credit card with PayLine (EUR)
        XCTFail("Wallet - attempt Braintree object, not EU Wallet");
    }
}

@end