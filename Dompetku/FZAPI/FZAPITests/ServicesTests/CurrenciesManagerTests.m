//
//  CurrenciesManagerTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "CurrenciesManager.h"

@interface CurrenciesManagerTests : XCTestCase

@end

@implementation CurrenciesManagerTests

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
 + (CurrenciesManager *)currentManager;
 */
- (void)testCurrentManager {
    XCTAssertNotNil([CurrenciesManager currentManager], @"CurrenciesManager instance can't be nil");
    
    
}

/*
 - (NSString *)formattedAmount:(NSString *) amount currency:(NSString *)currency;
 */
- (void)testFormattedAmount {
    NSString *fAmount =  [[CurrenciesManager currentManager]formattedAmount:@"12" currency:@"EUR"];
    
    // TODO : strange value
    XCTAssertTrue([fAmount isEqualToString:@" 12."], @"CurrenciesManager formattedAmount:currency: result not expected:%@",fAmount);
    
    
    fAmount =  [[CurrenciesManager currentManager]formattedAmount:@"12" currency:@"IDR"];
    
    // TODO : strange value
    XCTAssertTrue([fAmount isEqualToString:@"IDR 12."], @"CurrenciesManager formattedAmount:currency: result not expected:%@",fAmount);
}

/*
 - (NSString *)formattedAmountLight:(NSString *) amount currency:(NSString *)currency;
 */
- (void)testFormattedAmountLight {
    NSString *fAmount =  [[CurrenciesManager currentManager]formattedAmountLight:@"12" currency:@"EUR"];
    
    // TODO : strange value
    XCTAssertTrue([fAmount isEqualToString:@" 12"], @"CurrenciesManager formattedAmountLight: result not expected:%@",fAmount);
    
    fAmount =  [[CurrenciesManager currentManager]formattedAmountLight:@"12" currency:@"IDR"];
    
    // TODO : strange value
    XCTAssertTrue([fAmount isEqualToString:@"IDR 12"], @"CurrenciesManager formattedAmountLight: result not expected:%@",fAmount);
}

/*
 - (NSString *)formattedAmountWithNoCurrency:(NSString*) amount;
 */
- (void)testFormattedAmountWithNoCurrency {
    NSString *fAmount =  [[CurrenciesManager currentManager]formattedAmountWithNoCurrency:@"12"];
    
    XCTAssertTrue([fAmount isEqualToString:@"12"], @"CurrenciesManager formattedAmountWithNoCurrency: result not expected:%@",fAmount);
}

/*
 - (NSString *)formattedPercent:(NSString *)value;
 */
- (void)testFormattedPercent {
    NSString *fAmount =  [[CurrenciesManager currentManager]formattedPercent:@"12"];
    
    XCTAssertTrue([fAmount isEqualToString:@"12%"], @"CurrenciesManager formattedPercent: result not expected:%@",fAmount);
}

/*
 - (NSString *)formattedPercentLight:(NSString *)value;
 */
- (void)testFormattedPercentLight {
    NSString *fAmount =  [[CurrenciesManager currentManager]formattedPercentLight:@"12"];
    
    XCTAssertTrue([fAmount isEqualToString:@"12%"], @"CurrenciesManager formattedPercentLight: result not expected:%@",fAmount);
}

/*
 - (NSArray *)currencySymbols:(NSString *)currency;
 */
- (void)testCurrencySymbols {
    NSArray *currencies =  [[CurrenciesManager currentManager]currencySymbols:@"EUR"];
    
    XCTAssertTrue([[currencies objectAtIndex:0] isEqualToString:@""] && [[currencies objectAtIndex:1] isEqualToString:@"€"], @"CurrenciesManager currencySymbols: result not expected:%@",currencies);
    
    currencies =  [[CurrenciesManager currentManager]currencySymbols:@"IDR"];
    
    XCTAssertTrue([[currencies objectAtIndex:0] isEqualToString:@"IDR"] && [[currencies objectAtIndex:1] isEqualToString:@""], @"CurrenciesManager currencySymbols: result not expected:%@",currencies);
    
    /*
     *can't test, currency unmanaged
     
     currencies =  [[CurrenciesManager currentManager]currencySymbols:@"USD"];
     
     XCTAssertTrue([[currencies objectAtIndex:0] isEqualToString:@"$"] && [[currencies objectAtIndex:1] isEqualToString:@""], @"CurrenciesManager currencySymbols: result not expected:%@",currencies);
     */
}






@end

