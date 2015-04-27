//
//  InvoiceCorrectedParametersTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "InvoiceCorrectedParameters.h"
#import "Invoice.h"

@interface InvoiceCorrectedParametersTests : XCTestCase

@end

@implementation InvoiceCorrectedParametersTests

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
 + (InvoiceCorrectedParameters *)initWithInvoice:(Invoice *)invoice;
 */
- (void)testInitWithInvoice {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getinvoice" withClass:[NSDictionary dictionary]];
    
    //Invoice *invoice = [Invoice invoiceWithDictionary:aDictionary error:error];
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        InvoiceCorrectedParameters *correctedInvoice;
        
        correctedInvoice = [InvoiceCorrectedParameters initWithInvoice:invoice];
        
        XCTAssertEqual([invoice withRefill], [correctedInvoice newWithRefill], @"InvoiceCorrectedParameters : != newWithRefill");
        XCTAssertEqual([invoice amount], [correctedInvoice correctedInvoiceAmount], @"InvoiceCorrectedParameters : != correctedInvoiceAmount");
        
        XCTAssertEqual([invoice balance], [correctedInvoice newBalanceWithRefill], @"InvoiceCorrectedParameters : != newBalanceWithRefill");
        
        XCTAssertEqual([invoice numberOfRefill], [correctedInvoice nbOfRefill], @"InvoiceCorrectedParameters : != nbOfRefill");
        
        XCTAssertEqual(([invoice numberOfRefill]*[invoice takenAmount]), [correctedInvoice amountOfRefill], @"InvoiceCorrectedParameters : != amountOfRefill");
        
        XCTAssertEqual(0, [correctedInvoice discount], @"InvoiceCorrectedParameters : != discount");
        
        XCTAssertEqual([invoice hasLoyaltyCard], [correctedInvoice hasLoyaltyCard], @"InvoiceCorrectedParameters : != hasLoyaltyCard");
    } failureBlock:^(Error *error) {
        XCTFail(@"Invoice : can't instantiate object");
    }];
}

@end