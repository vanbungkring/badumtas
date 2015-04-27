//
//  AccountTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "Account.h"

@interface AccountTests : XCTestCase

@end

@implementation AccountTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testAccountWithDictionnaryFromUserInfos {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getuserinfos" withClass:[NSDictionary dictionary]];
    
    //Account *account = [Account accountWithDictionary:[aDictionary objectForKey:@"account"]];
    
    [Account accountWithDictionary:[aDictionary objectForKey:@"account"] successBlock:^(id object) {
        
        XCTAssertGreaterThanOrEqual([account accountId], 0.0, @"Account : accountId < 0");
        XCTAssertGreaterThanOrEqual([account balance], 0.0, @"Account : balance < 0");
        XCTAssertNotNil([account desc], @"Account : no description");
        XCTAssertNotNil([account currency], @"Account : no currency");
        
    } failureBlock:^(Error *error) {
        XCTAssertTrue(NO,@"Error :%@",[error messageCode]);
    }];
}

- (void)testAccountWithDictionnaryFromAccount {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getaccount" withClass:[NSDictionary dictionary]];
    
    //Account *account = [Account accountWithDictionary:[aDictionary objectForKey:@"account"]];
    
    [Account accountWithDictionary:[aDictionary objectForKey:@"account"] successBlock:^(id object) {
        XCTAssertGreaterThanOrEqual([account accountId], 0.0, @"Account : accountId < 0");
        XCTAssertGreaterThanOrEqual([account balance], 0.0, @"Account : balance < 0");
        XCTAssertNotNil([account desc], @"Account : no description");
        XCTAssertNotNil([account currency], @"Account : no currency");
    } failureBlock:^(Error *error) {
        XCTAssertTrue(NO,@"Error :%@",[error messageCode]);
    }];
}

@end
