//
//  ChangePasswordTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ChangePassword.h"

@interface ChangePasswordTests : XCTestCase

@end

@implementation ChangePasswordTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSecretQuestionWithDictionnary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"changePassword" withClass:[NSDictionary dictionary]];
    
    //ChangePassword *cP = [ChangePassword changePasswordWithDictionary:aDictionary error:nil];
    
    [ChangePassword changePasswordWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil((ChangePassword *)object, @"ChangePassword : can't instantiate object");
        XCTAssertNotNil([(ChangePassword *) email], @"ChangePassword : no email");
    } failureBlock:^(Error *error) {
        XCTAssertNotNil(nil, @"Account : can't instantiate object");
    }];
}

@end
