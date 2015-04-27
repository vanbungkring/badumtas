//
//  UrlListTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "UrlList.h"

@interface UrlListTests : XCTestCase

@end

@implementation UrlListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlListWithArray {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getURLList" withClass:[NSDictionary dictionary]];
    
    //UrlList *urList = [UrlList urlListWithDictionary:aDictionary];
    [UrlList urlListWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil([urList urls], @"UrlList : no urls");
    } failureBlock:^(Error *error) {
        XCTFail(@"UrlList : can't instantiate object");
    }];
}

@end