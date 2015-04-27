//
//  LoyaltyCardTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "LoyaltyCard.h"

@interface LoyaltyCardTests : XCTestCase

@end

@implementation LoyaltyCardTests

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

/*
 + (LoyaltyCard *)loyaltyProgramWithDictionary:(NSDictionary *)program error:(Error *)error;
 */
- (void)testLoyaltyProgramWithDictionary {
    
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getinvoice" withClass:[NSDictionary dictionary]];
    
    NSArray *loyaltyCards = [aDictionary objectForKey:@"fidelitizCardList"];
    
    for(NSDictionary *dictionaryLoyaltyCard in loyaltyCards) {
        
        //LoyaltyCard *loyaltyCard = [LoyaltyCard loyaltyProgramWithDictionary:dictionaryLoyaltyCard error:error];
        [LoyaltyCard loyaltyProgramWithDictionary:dictionaryLoyaltyCard successBlock:^(id object) {
            XCTAssertGreaterThanOrEqual([loyaltyCard balance], 0.0, @"LoyaltyCard : balance < 0");
            
            XCTAssertNotNil([loyaltyCard coupons], @"LoyaltyCard : coupons is nil");
            
            XCTAssertGreaterThanOrEqual([loyaltyCard discountAmount], 0.0, @"LoyaltyCard : discountAmount < 0");
            
            XCTAssertNotNil([loyaltyCard expenseType], @"LoyaltyCard : expenseType is nil");
            
            XCTAssertNotNil([loyaltyCard fidelitizId], @"LoyaltyCard : fidelitizId is nil");
            
            XCTAssertNotNil([loyaltyCard loyaltyCardId], @"LoyaltyCard : loyaltyCardId is nil");
            
            XCTAssertNotNil([loyaltyCard loyaltyProgramId], @"LoyaltyCard : loyaltyProgramId is nil");
            
            XCTAssertNotNil([loyaltyCard loyaltyProgramLabel], @"LoyaltyCard : loyaltyProgramLabel is nil");
            
            XCTAssertNotNil([loyaltyCard loyaltyProgramType], @"LoyaltyCard : loyaltyProgramType is nil");
            
            XCTAssertNotNil([loyaltyCard ownerBrand], @"LoyaltyCard : ownerBrand is nil");
            
            XCTAssertNotNil([loyaltyCard ownerCompanyName], @"LoyaltyCard : ownerCompanyName is nil");
            
            XCTAssertNotNil([loyaltyCard ownerEmail], @"LoyaltyCard : ownerEmail is nil");
            
            XCTAssertNotNil([loyaltyCard reference], @"LoyaltyCard : reference is nil");
            
            XCTAssertNotNil([loyaltyCard rewardType], @"LoyaltyCard : rewardType is nil");
        } failureBlock:^(Error *error) {
            XCTFail(@"LoyaltyCard : can't instantiate object");
        }];
    }
}

@end
