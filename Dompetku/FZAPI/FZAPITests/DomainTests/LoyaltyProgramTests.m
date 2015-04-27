//
//  LoyaltyProgramTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 11/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "LoyaltyProgram.h"

@interface LoyaltyProgramTests : XCTestCase

@end

@implementation LoyaltyProgramTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
 + (LoyaltyProgram *)loyaltyProgramWithDictionary:(NSDictionary *)program error:(Error *)error
 */
- (void)testLoyaltyProgramWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"fidelitizProgramGetwithLogoTrue" withClass:[NSDictionary dictionary]];
    
    //LoyaltyProgram *aLoyaltyProgram = [LoyaltyProgram loyaltyProgramWithDictionary:[aDictionary valueForKey:@"loyaltyProgram"] error:nil];
    [LoyaltyProgram loyaltyProgramWithDictionary:[aDictionary valueForKey:@"loyaltyProgram"] successBlock:^(id object) {
        XCTAssertNotNil(aLoyaltyProgram, @"LoyaltyCoupon testLoyaltyCouponWithDictionary failure");
        
        XCTAssertNotNil([aLoyaltyProgram affiliationId], @"No affiliationId");
        XCTAssertNotNil([aLoyaltyProgram backgroundColor], @"No backgroundColor");
        XCTAssertNotNil([aLoyaltyProgram borderColor], @"No borderColor");
        XCTAssertGreaterThanOrEqual([aLoyaltyProgram discountAmount], 0.0, @"LoyaltyProgram : discountAmount < 0");
        XCTAssertNotNil([aLoyaltyProgram currency], @"No currency");
        
        //TODO : NSDate test are disabled for the moment (need change on server)
        //XCTAssertNotNil([aLoyaltyProgram endDate], @"No endDate");
        XCTAssertNotNil([aLoyaltyProgram expenseType], @"No expenseType");
        XCTAssertNotNil([aLoyaltyProgram fidelitizId], @"No fidelitizId");
        XCTAssertTrue([aLoyaltyProgram hasLoyaltyCard] || ![aLoyaltyProgram hasLoyaltyCard], @"No hasLoyaltyCard");
        
        //Can be null (Optionnal values)
        //XCTAssertNotNil([aLoyaltyProgram individualId], @"No individualId");
        
        XCTAssertTrue([aLoyaltyProgram isPrivate] || ![aLoyaltyProgram isPrivate], @"No isPrivate");
        XCTAssertNotNil([aLoyaltyProgram label], @"No label");
        XCTAssertNotNil([aLoyaltyProgram logo], @"No logo");
        XCTAssertNotNil([aLoyaltyProgram loyaltyProgramId], @"No loyaltyProgramId");
        XCTAssertNotNil([aLoyaltyProgram loyaltyProgramOwnerBrand], @"No loyaltyProgramOwnerBrand");
        
        ////Can be null (Optionnal values)
        //XCTAssertNotNil([aLoyaltyProgram loyaltyProgramOwnerCompanyName], @"No loyaltyProgramOwnerCompanyName");
        
        XCTAssertNotNil([aLoyaltyProgram loyaltyProgramOwnerEmail], @"No loyaltyProgramOwnerEmail");
        XCTAssertNotNil([aLoyaltyProgram loyaltyProgramOwnerId], @"No loyaltyProgramOwnerId");
        XCTAssertNotNil([aLoyaltyProgram loyaltyProgramType], @"No loyaltyProgramType");
        XCTAssertGreaterThanOrEqual([aLoyaltyProgram monthNumberValidity], 0.0, @"LoyaltyProgram : monthNumberValidity < 0");
        XCTAssertGreaterThanOrEqual([aLoyaltyProgram permanentPercentageDiscount], 0.0, @"LoyaltyProgram : permanentPercentageDiscount < 0");
        XCTAssertGreaterThanOrEqual([aLoyaltyProgram pointAmountForCoupon], 0.0, @"LoyaltyProgram : pointAmountForCoupon < 0");
        XCTAssertGreaterThanOrEqual([aLoyaltyProgram pointPerExpense], 0.0, @"LoyaltyProgram : pointPerExpense < 0");
        XCTAssertNotNil([aLoyaltyProgram rewardType], @"No rewardType");
        
        //TODO : NSDate test are disabled for the moment (need change on server)
        //XCTAssertNotNil([aLoyaltyProgram startDate], @"No startDate");
    } failureBlock:^(Error *error) {
        XCTFail(@"LoyaltyProgram : can't instantiate object");
    }];
}

@end