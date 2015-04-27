//
//  CorrectedInvoiceTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "CorrectedInvoice.h"
#import "Invoice.h"

@interface CorrectedInvoiceTests : XCTestCase

@end

@implementation CorrectedInvoiceTests

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
+(id)correctedInvoiceWithInvoice:(Invoice *)invoice;
 */
- (void)testCorrectedInvoiceWithInvoice {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getinvoice" withClass:[NSDictionary dictionary]];
    
    //Invoice *invoice = [Invoice invoiceWithDictionary:aDictionary error:error];
    
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        CorrectedInvoice *correctedInvoice;

        correctedInvoice = [CorrectedInvoice correctedInvoiceWithInvoice:invoice];
        
        XCTAssertEqual([invoice withRefill], [correctedInvoice withRefill], @"CorrectedInvoice : != withRefill");
        XCTAssertEqual([invoice amount], [correctedInvoice amount], @"CorrectedInvoice : != amount");
        
        XCTAssertEqual([invoice balance], [correctedInvoice balance], @"CorrectedInvoice : != balance");
        
        XCTAssertEqual([invoice numberOfRefill], [correctedInvoice numberOfRefill], @"CorrectedInvoice : != numberOfRefill");
        
        XCTAssertEqual(([invoice numberOfRefill]*[invoice takenAmount]), [correctedInvoice amountOfRefill], @"CorrectedInvoice : != amountOfRefill");
        
        XCTAssertEqual(0, [correctedInvoice discount], @"CorrectedInvoice : != discount");
        
        XCTAssertEqual([invoice hasLoyaltyCard], [correctedInvoice hasLoyaltyCard], @"CorrectedInvoice : != hasLoyaltyCard");
        
        
        XCTAssertEqual([invoice amount], [correctedInvoice amount], @"CorrectedInvoice : amount < 0");
        XCTAssertEqual([invoice newBalanceWithRefill], [correctedInvoice newBalanceWithRefill], @"CorrectedInvoice : newBalanceWithRefill < 0");
        XCTAssertEqual([invoice newBalanceWithoutRefill], [correctedInvoice newBalanceWithoutRefill], @"CorrectedInvoice : newBalanceWithoutRefill < 0");
        XCTAssertEqual([invoice takenAmount], [correctedInvoice takenAmount], @"CorrectedInvoice : takenAmount < 0");
        XCTAssertEqual([invoice permanentPercentageDiscount], [correctedInvoice permanentPercentageDiscount], @"CorrectedInvoice : permanentPercentageDiscount < 0");
        XCTAssertEqual([invoice correctedInvoiceAmountWithPercentage], [correctedInvoice correctedInvoiceAmountWithPercentage], @"CorrectedInvoice : correctedInvoiceAmountWithPercentage < 0");
        XCTAssertEqual([invoice balance], [correctedInvoice balance], @"CorrectedInvoice : balance < 0");
        
        XCTAssertEqual([invoice invoiceId],[correctedInvoice invoiceId], @"CorrectedInvoice : no invoiceId");
        
        XCTAssertEqual([invoice otherName],[correctedInvoice otherName], @"CorrectedInvoice : no otherName");
        
        XCTAssertEqual([invoice otherMail],[correctedInvoice otherMail], @"CorrectedInvoice : no otherMail");
        
        XCTAssertEqual([invoice comment],[correctedInvoice comment], @"CorrectedInvoice : no comment");
        
    } failureBlock:^(Error *error) {
        XCTAssertNotNil(nil, @"Invoice : can't instantiate object");
    }];
}

@end