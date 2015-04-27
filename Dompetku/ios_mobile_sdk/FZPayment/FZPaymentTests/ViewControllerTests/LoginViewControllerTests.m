//
//  LoginViewControllerTests.m
//  FZCoreUI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "LoginViewController.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface LoginViewControllerTests : XCTestCase

@property (nonatomic, retain) LoginViewController *loginViewController;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

@end

@implementation LoginViewControllerTests

#pragma mark - Init & Ending

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[FZTargetManager sharedInstance] loadUnitTesting];
    [[BundleHelper sharedInstance] setRootBundle:FZBundlePayment];
    
    _email = @"test@test.com";
    _password = @"azer1234";
    
    _loginViewController = [[LoginViewController alloc] init];
    
    NSLog(@"Setup passed");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [_loginViewController release], _loginViewController = nil;
}

#pragma mark - Tests

- (void)testInit {
    
    XCTAssertNotNil(_loginViewController, @"No loginViewController");
    XCTAssertTrue([_loginViewController isKindOfClass: [LoginViewController class]], @"Initialization failure");
}

- (void)testInitWithMailAndPassword {
    
    XCTAssertNotNil(_email, @"No email");
    XCTAssertNotNil(_password, @"No password");
 
    _loginViewController = [[LoginViewController alloc] initWithMail:_email andPassword:_password];
    
    XCTAssertTrue([_loginViewController isKindOfClass: [LoginViewController class]], @"Initialization failure");
    
    XCTAssertTrue([_loginViewController mailFromForgottenPassword] == _email, @"Mail initialization failure");
    XCTAssertTrue([_loginViewController pwdFromForgottenPassword] == _password, @"Password initialization failure");
}

/*
- (BOOL)stringIsValidEmail:(NSString *)checkString;
*/
- (void)testStringIsValidEmail {
    
    XCTAssertNotNil(_loginViewController, @"No loginViewController");
    
    _email = @"hello@test.com";
    
    XCTAssertTrue([_loginViewController stringIsValidEmail:_email],@"Email not valid");
}

- (void)testStringIsInvalidEmail {
    
    XCTAssertNotNil(_loginViewController, @"No loginViewController");

    _email = @"hello@@test.com";
    
    XCTAssertFalse([_loginViewController stringIsValidEmail:_email],@"Email not unvalid");
    
    _email = @"hello@test.c";
    
    XCTAssertFalse([_loginViewController stringIsValidEmail:_email],@"Email not unvalid");
    
    _email = @"hello!@test.com";
    
    XCTAssertFalse([_loginViewController stringIsValidEmail:_email],@"Email not unvalid");
}

/*
-(BOOL)stringIsValidPassword:(NSString *)checkString;
*/

- (void)testStringIsValidPassword {
    XCTAssertNotNil(_loginViewController, @"No loginViewController");
    
    _password = @"azer1598@";
    
    XCTAssertTrue([_loginViewController stringIsValidPassword:_password],@"Password not valid");
    
    _password = @"1234567A";
    
    XCTAssertTrue([_loginViewController stringIsValidPassword:_password],@"Password not valid");
}

- (void)testStringIsUnvalidPassword {
    XCTAssertNotNil(_loginViewController, @"No loginViewController");
    
    _password = @"azer1598@!";
    
    XCTAssertFalse([_loginViewController stringIsValidPassword:_password],@"Password is not unvalid");
    
    _password = @"azer45";
    
    XCTAssertFalse([_loginViewController stringIsValidPassword:_password],@"Password is not unvalid");
    
    _password = @"azerefkpw";
    
    XCTAssertFalse([_loginViewController stringIsValidPassword:_password],@"Password is not unvalid");
    
    _password = @"159874625";
    
    XCTAssertFalse([_loginViewController stringIsValidPassword:_password],@"Password is not unvalid");
}

- (void)dealloc {
    [super dealloc];
    
    [_loginViewController release], _loginViewController = nil;
    [_email release], _email = nil;
    [_password release], _password = nil;
}

@end
