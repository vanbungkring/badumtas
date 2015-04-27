//
//  SecretQuestionTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "SecretQuestion.h"

@interface SecretQuestionTests : XCTestCase

@end

@implementation SecretQuestionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSecretQuestionWithDictionnary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"forgottenPassword" withClass:[NSDictionary dictionary]];
    
    //SecretQuestion *sQ = [SecretQuestion secretQuestionWithDictionary:aDictionary error:nil];
    [SecretQuestion secretQuestionWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil(sQ, @"ChangePassword : can't instantiate object");
        XCTAssertNotNil([sQ secretQuestion], @"ChangePassword : no secretQuestion");
    } failureBlock:^(Error *error) {
        XCTFail(@"ChangePassword : can't instantiate object");
    }];
}

@end