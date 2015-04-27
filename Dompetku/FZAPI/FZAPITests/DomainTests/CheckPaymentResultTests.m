//
//  CheckPaymentResultTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "CheckPaymentResult.h"

@interface CheckPaymentResultTests : XCTestCase

@end

@implementation CheckPaymentResultTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCheckPaymentResultWithDictionnary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"checkPaymentSuccess" withClass:[NSDictionary dictionary]];
    
    //CheckPaymentResult *checkPayment = [CheckPaymentResult checkPaymentResultWithDictionary:aDictionary error:nil];
    
    [CheckPaymentResult checkPaymentResultWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil(checkPayment, @"CheckPayment : can't instantiate object");
        XCTAssertNotNil([checkPayment currency], @"CheckPayment : currency == nil");
        XCTAssertNotNil([checkPayment username], @"CheckPayment : username == nil");
        XCTAssertEqual([checkPayment balance], 12, @"CheckPayment : balance !=");
    } failureBlock:^(Error *error) {
        XCTAssertNotNil(nil, @"CheckPayment : can't instantiate object");
    }];
}

@end
