//
//  TransactionTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "Transaction.h"

@interface TransactionTests : XCTestCase

@end

@implementation TransactionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTransactionWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"listtransactions" withClass:[NSDictionary dictionary]];
    
    NSObject *transactions = [aDictionary objectForKey:@"transactions"];
    
    NSEnumerator *enumerator = [(NSArray *)transactions reverseObjectEnumerator];
    
    for(NSDictionary *dic in enumerator){
        
        // FIXME : not good place to parse
        
        NSString *fullName = (NSString *)[dic objectForKey:@"fullName"];
        
        NSString *creditorUsername = (NSString *)[dic objectForKey:@"creditor"];
        NSString *debitorUsername = (NSString *)[dic objectForKey:@"debitor"];
        
        //Transaction *transaction = [Transaction transactionWithDictionary:[dic objectForKey:@"transaction"] error:error];
        [Transaction transactionWithDictionary:[dic objectForKey:@"transaction"] successBlock:^(id object) {
            Transaction *transaction = (Transaction *)object;
            
            [transaction setFullName:fullName];
            
            if(creditorUsername.length > 0) {
                [transaction setCreditorUsername:creditorUsername];
                [transaction setDebitorUsername:nil];
            } else if(debitorUsername.length > 0) {
                [transaction setDebitorUsername:debitorUsername];
                [transaction setCreditorUsername:nil];
            } else {
                [transaction setDebitorUsername:nil];
                [transaction setCreditorUsername:nil];
            }
            
            if(transaction != nil){
                
                // Can be null
                //XCTAssertNotNil([transaction transactionId], @"");
                
                XCTAssertGreaterThanOrEqual([[transaction amount]doubleValue], 0.0, @"Transaction : amount < 0");
                XCTAssertNotNil([transaction currency], @"Transaction : no currency");
                XCTAssertNotNil([transaction comment], @"Transaction : no comment");
                
                // Can be null
                // XCTAssertNotNil([transaction receiverInfo], @"rTransaction : no receiverInfo");
                // Can be null
                // XCTAssertNotNil([transaction executionDate], @"Transaction : no executionDate");
                XCTAssertNotNil([transaction status], @"Transaction : no status");
                XCTAssertNotNil([transaction fullName], @"Transaction : no fullName");
                
                if(creditorUsername.length > 0) {
                    XCTAssertNotNil([transaction creditorUsername], @"Transaction : no creditorUsername");
                }else{
                    XCTAssertNil([transaction creditorUsername], @"Transaction : no debitorUsername");
                }
                
                if(debitorUsername.length > 0) {
                    XCTAssertNotNil([transaction debitorUsername], @"Transaction : no debitorUsername");
                }else{
                    XCTAssertNil([transaction debitorUsername], @"Transaction : no debitorUsername");
                }
                
                // Can be null
                //XCTAssertNotNil([transaction creditor], @"creditor");
                //XCTAssertNotNil([transaction debitor], @"debitor");
                //XCTAssertNotNil([transaction pending], @"pending");
            } else {
                //Fail
                XCTAssertNotNil(transaction, @"Transaction : can't instantiate object");
            }
        } failureBlock:^(Error *error) {
            XCTFail(@"Transaction : can't instantiate object");
        }];
    }
}

@end