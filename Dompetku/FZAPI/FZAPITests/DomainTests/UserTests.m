//
//  UserTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "User.h"

@interface UserTests : XCTestCase

@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserWithDictionnary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getuserinfos" withClass:[NSDictionary dictionary]];
    
    //User *user = [User userWithDictionary:aDictionary];
    [User userWithDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil([user lastName], @"User : no lastName");
        XCTAssertNotNil([user firstName], @"User : no firstName");
        XCTAssertNotNil([user currency], @"User : no currency");
        XCTAssertNotNil([user username], @"User : no username");
        XCTAssertNotNil([user email], @"User : no email");
        XCTAssertNotNil([user phoneNumber], @"User : no phoneNumber");
        XCTAssertNotNil([user fidelitizId], @"User : no fidelitizId");
    } failureBlock:^(Error *error) {
        XCTFail(@"User : can't instantiate object");
    }];
}

- (void)testUserWithInformationDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getuserinfos" withClass:[NSDictionary dictionary]];
    
    //User *user = [User userWithInformationDictionary:aDictionary];
    [User userWithInformationDictionary:aDictionary successBlock:^(id object) {
        XCTAssertNotNil([user lastName], @"User : no lastName");
        XCTAssertNotNil([user firstName], @"User : no firstName");
        XCTAssertNotNil([user currency], @"User : no currency");
        XCTAssertNotNil([user username], @"User : no username");
        XCTAssertNotNil([user email], @"User : no email");
        XCTAssertNotNil([user phoneNumber], @"User : no phoneNumber");
        XCTAssertNotNil([user fidelitizId], @"User : no fidelitizId");
        //Can be nil
        //XCTAssertNotNil([user nationality], @"User : no fidelitizId");
        XCTAssertNotNil([user cityCode], @"User : no cityCode");
        XCTAssertNotNil([user cityName], @"User : no cityName");
        XCTAssertNotNil([user country], @"User : no country");
        XCTAssertNotNil([user sex], @"User : no sex");
        XCTAssertNotNil([user birthday], @"User : no birthday");
        XCTAssertNotNil([user address1], @"User : no address1");
        //Can be nil
        //XCTAssertNotNil([user address2], @"User : no birthday");
    } failureBlock:^(Error *error) {
        XCTFail(@"User : can't instantiate object");
    }];
}

- (void)testUserFillBlank {
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getuserinfos" withClass:[NSDictionary dictionary]];
    
    //User *user = [User userWithInformationDictionary:aDictionary];
    [User userWithInformationDictionary:aDictionary successBlock:^(id object) {
        User *user = (User *)object;
        
        [user setPin:nil];
        [user setCaptcha:nil];
        
        [User fillBlank:user];
        
        XCTAssertNotNil([user pin], @"User : no blank pin");
        XCTAssertNotNil([user captcha], @"User : no blank pin");
    } failureBlock:^(Error *error) {
        XCTFail(@"User : can't instantiate object");
    }];
}

- (void)testUserIsTextBlankOrWhitespace {
    
    XCTAssertTrue([User isTextBlankOrWhitespace:@" "], @"User isTextBlankOrWhitespace doesn't work as expected");
    XCTAssertTrue([User isTextBlankOrWhitespace:@""], @"User isTextBlankOrWhitespace doesn't work as expected");
    
    XCTAssertFalse([User isTextBlankOrWhitespace:@"sdfsdf dfdf"], @"User isTextBlankOrWhitespace doesn't work as expected");
    
    XCTAssertFalse([User isTextBlankOrWhitespace:@"sdfsdfdfdf"], @"User isTextBlankOrWhitespace doesn't work as expected");
}

- (void)testUserCopyWithZone {
    
    NSString *testCopyValue = @"132Test";
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getuserinfos" withClass:[NSDictionary dictionary]];
    
    //User *user = [User userWithInformationDictionary:aDictionary];
    [User userWithInformationDictionary:aDictionary successBlock:^(id object) {
        User *user = (User *)object;
        
        [user setUsername:testCopyValue];
        [user setFirstName:testCopyValue];
        [user setLastName:testCopyValue];
        [user setNationality:testCopyValue];
        [user setPassword:testCopyValue];
        
        User *newUser = [user copy];
        
        XCTAssertEqual([newUser username], testCopyValue, @"User : bad mutable copy");
        XCTAssertEqual([newUser firstName], testCopyValue, @"User : bad mutable copy");
        XCTAssertEqual([newUser lastName], testCopyValue, @"User : bad mutable copy");
        XCTAssertEqual([newUser nationality], testCopyValue, @"User : bad mutable copy");
        XCTAssertEqual([newUser password], testCopyValue, @"User : bad mutable copy");
    } failureBlock:^(Error *error) {
        XCTFail(@"User : can't instantiate object");
    }];
}

- (void)testUserIsTrial {
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getuserinfos" withClass:[NSDictionary dictionary]];
    
    //User *user = [User userWithInformationDictionary:aDictionary];
    [User userWithInformationDictionary:aDictionary successBlock:^(id object) {
        User *user = (User *)object;
        
        [user setIsUserUpgraded:YES];
        [user setIsMailValidated:YES];
        
        /*
         if([self isUserUpgraded] && [self isMailValidated]){
         return NO;
         } else {
         return YES;
         }
         */
        
        XCTAssertFalse([user isTrial], @"User is not trial");
        
        [user setIsUserUpgraded:NO];
        
        XCTAssertTrue([user isTrial], @"User is trial");
        
        [user setIsUserUpgraded:YES];
        [user setIsMailValidated:NO];
        
        XCTAssertTrue([user isTrial], @"User is trial");
        
        [user setIsUserUpgraded:NO];
        [user setIsMailValidated:NO];
    } failureBlock:^(Error *error) {
        XCTFail(@"User : can't instantiate object");
    }];
}

@end
