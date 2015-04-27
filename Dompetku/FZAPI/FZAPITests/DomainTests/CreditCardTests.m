//
//  CreditCardTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "CreditCard.h"

@interface CreditCardTests : XCTestCase

@end

@implementation CreditCardTests

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

- (void)testCreditCardWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getregisteredcards" withClass:[NSDictionary dictionary]];
    
    NSMutableArray *creditCardsList = [[NSMutableArray alloc] init];
    
    NSArray *creditCardsListTemp = [aDictionary objectForKey:@"creditcards"];
    
    for(int i = 0; i < creditCardsListTemp.count; i++ ) {
        
        //CreditCard *creditCard = [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] error:error];
        [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] successBlock:^(id object) {
            [creditCardsList addObject:creditCard];
            
            XCTAssertNotNil([creditCard pan], @"CreditCard : pan is nil");
            
            XCTAssertNotNil([creditCard creditCardId], @"CreditCard : creditCardId is nil");
            
            //Owner can be nil
            //XCTAssertNotNil([creditCard owner], @"CreditCard : owner is nil");
            XCTAssertNotNil([creditCard expirationDate], @"CreditCard : expirationDate is nil");
            
            XCTAssertNotNil([creditCard comment], @"CreditCard : comment is nil");
        } failureBlock:^(Error *error) {
            XCTFail(@"CreditCard : can't instantiate object");
        }];
    }
}

- (void)testIsExpired {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getregisteredcards" withClass:[NSDictionary dictionary]];
    
    NSArray *creditCardsListTemp = [aDictionary objectForKey:@"creditcards"];
    
    for(int i = 0; i < creditCardsListTemp.count; i++ ) {
        
        //CreditCard *creditCard = [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] error:error];
        
        CreditCard *creditCard = [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] successBlock:^(id object) {

            if(([(NSNumber*)[creditCard creditCardId]floatValue])==2514){
                //Expired card
                XCTAssertTrue([creditCard isExpired], @"CreditCard : Expired card - bad management");
            }else{
                //Valid card
                XCTAssertFalse([creditCard isExpired], @"CreditCard : Valid card - bad management");
            }
        } failureBlock:^(Error *error) {
            XCTFail(@"CreditCard : can't instantiate object");
        }];
    }
}

- (void)testMonth {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getregisteredcards" withClass:[NSDictionary dictionary]];
    
    NSArray *creditCardsListTemp = [aDictionary objectForKey:@"creditcards"];
    
    NSDateComponents *components = nil;
    NSString *month = nil;
    
    for(int i = 0; i < creditCardsListTemp.count; i++ ) {
        
        //CreditCard *creditCard = [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] error:error];
        [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] successBlock:^(id object) {
            components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[creditCard expirationDate]];
            
            if([components month]<10) {
                month = [NSString stringWithFormat:@"0%ld",(long)[components month]];
            }
            else {
                month = [NSString stringWithFormat:@"%ld",(long)[components month]];
            }
            
            XCTAssertTrue([month isEqualToString:[creditCard month]], @"CreditCard : not good month");
        } failureBlock:^(Error *error) {
            XCTFail(@"CreditCard : can't instantiate object");
        }];
    }
}

- (void)testYear {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getregisteredcards" withClass:[NSDictionary dictionary]];
    
    NSArray *creditCardsListTemp = [aDictionary objectForKey:@"creditcards"];
    
    NSDateComponents *components = nil;
    NSString *year = nil;
    
    for(int i = 0; i < creditCardsListTemp.count; i++ ) {
        
        //CreditCard *creditCard = [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] error:error];
        [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] successBlock:^(id object) {
            components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[creditCard expirationDate]];
            
            year = [NSString stringWithFormat:@"%ld",(long)[components year]];
            
            XCTAssertTrue([year isEqualToString:[creditCard year]], @"CreditCard : not good year");
        } failureBlock:^(Error *error) {
            XCTFail(@"CreditCard : can't instantiate object");
        }];
    }
}

@end