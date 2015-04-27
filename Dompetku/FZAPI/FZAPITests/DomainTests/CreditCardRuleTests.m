//
//  CreditCardRuleTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "CreditCardRule.h"

@interface CreditCardRuleTests : XCTestCase

@end

@implementation CreditCardRuleTests

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

- (void)testCreditCardRuleWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getregisteredcardsTakenAmount" withClass:[NSDictionary dictionary]];
    
    NSMutableArray *creditCardsList = [[NSMutableArray alloc] init];
    
    NSArray *creditCardsListTemp = [aDictionary objectForKey:@"creditcards"];
    
    for(int i = 0; i < creditCardsListTemp.count; i++ ) {
        
        //CreditCardRule *creditCard = [CreditCardRule creditCardRuleWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] error:error];
        
        [CreditCardRule creditCardRuleWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] successBlock:^(id object) {

            [creditCardsList addObject:creditCard];
            
            XCTAssertNotNil([creditCard pan], @"CreditCard : pan is nil");
            
            XCTAssertGreaterThanOrEqual([creditCard takenAmount], 0.0, @"CreditCard : takenAmount < 0");
            
            //Owner can be nil
            //XCTAssertNotNil([creditCard owner], @"CreditCard : owner is nil");
            XCTAssertNotNil([creditCard expirationDate], @"CreditCard : expirationDate is nil");
            
        } failureBlock:^(Error *error) {
            XCTFail(@"CreditCard : can't instantiate object");
        }];
    }
}

@end