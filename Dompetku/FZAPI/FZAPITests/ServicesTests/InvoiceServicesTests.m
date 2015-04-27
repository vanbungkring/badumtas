//
//  InvoiceServicesTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 11/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigForTests.h"
#import "ConnectionServices.h"
#import "Invoice.h"

//Tested
#import "InvoiceServices.h"

@interface InvoiceServicesTests : XCTestCase

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userkey;

@end

@implementation InvoiceServicesTests

#pragma mark - Init

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    _email = [ConfigForTests emailUsed];
    _password = [ConfigForTests passwordUsed];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"Connection succeeded"];
    
    XCTAssertNotNil(_email, @"No email");
    XCTAssertNotNil(_password, @"No password");
    
    [ConnectionServices connect:_email password:_password firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"No userkey");
        
        [self setUserkey:context];
        
        [connectionSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"ConnectionServices testConnectPasswordFirstTimeWithDevice has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
        NSLog(@"Setup passed");
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Samples

/*
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(NO, @"TODO");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/

#pragma mark - Tests
/*
+ (void)getTransactionsHistory:(NSString *)userKey
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testGetTransactionsHistory {
    
    XCTestExpectation *getTransactionsHistorySucceeded = [self expectationWithDescription:@"Get Transactions History succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    [InvoiceServices getTransactionsHistory:_userkey successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Get Transactions History failure");
        
        [getTransactionsHistorySucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testGetTransactionsHistory has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)getTransactionsHistory:(NSString *)userKey
                          from:(NSString *)from
                            to:(NSString *)to
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testGetTransactionsHistoryFromTo {
    
    XCTestExpectation *getTransactionsHistoryFromToSucceeded = [self expectationWithDescription:@"Get Transactions History FromTo succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    [InvoiceServices getTransactionsHistory:_userkey from:nil to:nil successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Get Transactions History FromTo failure");
        
        [getTransactionsHistoryFromToSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testGetTransactionsHistoryFromTo has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)readInvoice:(NSString *)invoiceId
            userKey:(NSString *)userKey
       successBlock:(NetworkSuccessBlock)successBlock
       failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testReadInvoice {
    
    XCTestExpectation *readInvoiceSucceeded = [self expectationWithDescription:@"Read invoice succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    NSString *invoiceId = [ConfigForTests invoiceUsed];
    
    XCTAssertNotNil(invoiceId, @"No invoiceId");
    
    [InvoiceServices readInvoice:invoiceId userKey:_userkey successBlock:^(id context) {
        
        NSLog(@"%f",[(Invoice *)context amount]);
        
        XCTAssertNotNil(context, @"Read invoice failure");
        
        [readInvoiceSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testReadInvoice has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)payInvoice:(NSString *)invoiceId
           userKey:(NSString *)userKey
    hasLoyaltyCard:(BOOL)hasLoyaltyCard
correctedInvoiceAmount:(double)correctedInvoiceAmount
         nbCoupons:(NSInteger)nbCoupons
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testPayInvoiceInvoice {
    
    XCTestExpectation *payInvoiceSucceeded = [self expectationWithDescription:@"Pay invoice succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    NSString *invoiceId = [ConfigForTests invoiceUsed];
    
    XCTAssertNotNil(invoiceId, @"No invoiceId");
    
    [InvoiceServices payInvoice:invoiceId userKey:_userkey hasLoyaltyCard:YES correctedInvoiceAmount:4.25 nbCoupons:0 successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Pay invoice failure");
        
        [payInvoiceSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testPayInvoiceInvoice has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)createInvoice:(NSString *)userKey
               amount:(NSString *)amount
         successBlock:(NetworkSuccessBlock)successBlock
         failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testCreateInvoiceAmount {
    
    XCTestExpectation *createInvoiceSucceeded = [self expectationWithDescription:@"Create invoice succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    [InvoiceServices createInvoice:_userkey amount:@"1.00" successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Create invoice failure");
        
        [createInvoiceSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testCreateInvoiceAmount has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)cancelInvoice:(NSString *)invoiceId
              userKey:(NSString *)userKey
         successBlock:(NetworkSuccessBlock)successBlock
         failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testCancelInvoiceUserkey {
    
    XCTestExpectation *cancelInvoiceUserkeySucceeded = [self expectationWithDescription:@"Cancel invoice succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    [InvoiceServices createInvoice:_userkey amount:@"1.00" successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Create invoice failure");
        
        NSString *invoiceId = [context lastPathComponent];
        
        [InvoiceServices cancelInvoice:invoiceId userKey:_userkey successBlock:^(id context) {
            
            XCTAssertNotNil(context, @"Cancel invoice failure");
            
            [cancelInvoiceUserkeySucceeded fulfill];
        } failureBlock:^(Error *error) {
            XCTFail(@"InvoiceServices testCancelInvoiceUserkey has failed");
        }];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testCreateInvoiceAmount has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)createCredit:(NSString *)userKey
              amount:(NSString *)amount
        successBlock:(NetworkSuccessBlock)successBlock
        failureBlock:(NetworkFailureBlock)failureBlock;
 */
#warning Cannot be tested with a client, need a merchant
- (void)testCreateCreditAmount {
    
    XCTestExpectation *createCreditAmountSucceeded = [self expectationWithDescription:@"Create credit succeeded"];
    
    NSString *merchantEmail = [ConfigForTests merchantEmailUsed];
    NSString *merchantPassword = [ConfigForTests merchantPasswordUsed];
    
    XCTAssertNotNil(merchantEmail, @"No email");
    XCTAssertNotNil(merchantPassword, @"No password");
    
    [ConnectionServices connect:merchantEmail password:merchantPassword firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"No userkey");
        
        [InvoiceServices createCredit:context amount:@"1.00" successBlock:^(id context) {
            
            XCTAssertNotNil(context, @"Create credit failure");
            
            [createCreditAmountSucceeded fulfill];
            
        } failureBlock:^(Error *error) {
            XCTFail(@"InvoiceServices testCreateCreditAmount has failed");
        }];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"ConnectionServices testConnectPasswordFirstTimeWithDevice has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)checkPayment:(NSString *)invoiceId
          forUserKey:(NSString *)userKey
        successBlock:(NetworkSuccessBlock)successBlock
        failureBlock:(NetworkFailureBlock)failureBlock;
 */
#warning need to create an invoice, pay it and after call checkPayment
- (void)testCheckPaymentForUserKey {
    
    XCTestExpectation *checkPaymentSucceeded = [self expectationWithDescription:@"Check payment succeeded"];
    
    XCTAssertNotNil(_userkey, @"No userkey");
    
    //TODO: create an invoice and pay it
    NSString *invoiceId = [ConfigForTests invoiceUsed];
    
    [InvoiceServices checkPayment:invoiceId forUserKey:_userkey successBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Check payment failure");
        
        [checkPaymentSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testCheckPaymentForUserKey has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

/*
+ (void)urlListSuccessBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testUrlList {
    
    XCTestExpectation *urlListSucceeded = [self expectationWithDescription:@"Url list succeeded"];
    
    [InvoiceServices urlListSuccessBlock:^(id context) {
        
        XCTAssertNotNil(context, @"Url list failure");
        
        [urlListSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        XCTFail(@"InvoiceServices testCreateCreditAmount has failed");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

#pragma mark - MM

-(void)dealloc {
    [super dealloc];
    [_email release], _email = nil;
    [_password release], _password = nil;
    [_userkey release], _userkey = nil;
}

@end
