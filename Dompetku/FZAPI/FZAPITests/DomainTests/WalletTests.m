//
//  WalletTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "Wallet.h"

@interface WalletTests : XCTestCase

@end

@implementation WalletTests

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

- (void)testWalletWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"createwebwallet" withClass:[NSDictionary dictionary]];
    
    if([[aDictionary objectForKey:@"trData"] length] > 0){ //register credit card with Braintree (USD AUD)
        XCTFail("Wallet - attempt Wallet object, not Braintree");
    } else { //register credit card with PayLine (EUR)
        //Wallet *wallet = [Wallet walletWithDictionary:aDictionary error:error];
        [Wallet walletWithDictionary:aDictionary successBlock:^(id object) {
            XCTAssertNotNil([(Wallet *)object redirectUrl], @"Wallet : coupons is redirectUrl");
            XCTAssertNotNil([(Wallet *)object creditCardId], @"Wallet : coupons is creditCardId");
        } failureBlock:^(Error *error) {
            XCTFail(@"Wallet : can't instantiate object");
        }];
    }
}

@end