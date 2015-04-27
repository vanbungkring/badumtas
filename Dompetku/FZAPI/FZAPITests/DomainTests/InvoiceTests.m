//
//  InvoiceTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "Invoice.h"
#import "LoyaltyCoupon.h"

@interface InvoiceTests : XCTestCase

@end

@implementation InvoiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvoiceWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getinvoice" withClass:[NSDictionary dictionary]];
    
    //Invoice *invoice = [Invoice invoiceWithDictionary:aDictionary error:error];
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertGreaterThanOrEqual([invoice amount], 0.0, @"Invoice : amount < 0");
        XCTAssertGreaterThanOrEqual([invoice newBalanceWithRefill], 0.0, @"Invoice : newBalanceWithRefill < 0");
        XCTAssertGreaterThanOrEqual([invoice newBalanceWithoutRefill], 0.0, @"Invoice : newBalanceWithoutRefill < 0");
        XCTAssertGreaterThanOrEqual([invoice numberOfRefill], 0.0, @"Invoice : numberOfRefill < 0");
        XCTAssertGreaterThanOrEqual([invoice takenAmount], 0.0, @"Invoice : takenAmount < 0");
        XCTAssertGreaterThanOrEqual([invoice permanentPercentageDiscount], 0.0, @"Invoice : permanentPercentageDiscount < 0");
        XCTAssertGreaterThanOrEqual([invoice correctedInvoiceAmountWithPercentage], 0.0, @"Invoice : correctedInvoiceAmountWithPercentage < 0");
        XCTAssertGreaterThanOrEqual([invoice balance], 0.0, @"Invoice : balance < 0");
        XCTAssertNotNil([invoice invoiceId], @"Invoice : no invoiceId");
        XCTAssertNotNil([invoice otherName], @"Invoice : no otherName");
        XCTAssertNotNil([invoice otherMail], @"Invoice : no otherMail");
        XCTAssertNotNil([invoice comment], @"Invoice : no comment");
        
        // Can be null
        //XCTAssertNotNil([invoice fidelitizId], @"Invoice : no fidelitizId");
        XCTAssertNotNil([invoice currency], @"Invoice : no currency");
        
        //Now test subdomains
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
        
        array = [[aDictionary valueForKey:@"currentLoyaltyProgram"]valueForKey:@"coupons"];
        length = array.count;
        
        for(int j = 0; j < length; j++){
            
            //LoyaltyCoupon *aLoyaltyCoupon = [LoyaltyCoupon loyaltyCouponWithDictionary:[array objectAtIndex:j] error:nil];
            [LoyaltyCoupon loyaltyCouponWithDictionary:[array objectAtIndex:j] successBlock:^(id object) {
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
    } failureBlock:^(Error *error) {
        XCTFail(@"Invoice : can't instantiate object");
    }];
}

@end