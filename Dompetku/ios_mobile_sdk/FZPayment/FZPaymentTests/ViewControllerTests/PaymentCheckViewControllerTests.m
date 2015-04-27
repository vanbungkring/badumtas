//
//  PaymentCheckViewControllerTests.m
//  FZPayment
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "PaymentCheckViewController.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>
#import "FlashizMultiTargetManager.h"

@interface PaymentCheckViewControllerTests : XCTestCase

@end

@implementation PaymentCheckViewControllerTests

#pragma mark - Init & Ending

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    FlashizMultiTargetManager *multiTarget = [[FlashizMultiTargetManager alloc] init];
    
    //NSLog(@"multiTarget : %@",multiTarget);
    
    [[FZTargetManager sharedInstance] loadUnitTestingWithMultiTargetManager:multiTarget];
    
    [multiTarget release];
        
    [[BundleHelper sharedInstance] setRootBundle:FZBundlePayment];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests
/*
- (id)init;
 */
- (void)testInit {
    XCTAssert(NO, @"TODO");
    //TODO: don't works...
    //PaymentCheckViewController *payViewController = [[PaymentCheckViewController alloc] init];
    //XCTAssertTrue([payViewController isKindOfClass: [PaymentCheckViewController class]], @"Initialization failure");
}

@end
