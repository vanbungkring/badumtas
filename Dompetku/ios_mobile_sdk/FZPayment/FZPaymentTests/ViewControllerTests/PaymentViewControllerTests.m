//
//  PaymentViewControllerTests.m
//  FZPayment
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//


#import <XCTest/XCTest.h>

//Tested
#import "PaymentViewController.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface PaymentViewControllerTests : XCTestCase

@property (nonatomic, retain) PaymentViewController *paymentViewVC;
@property (nonatomic, assign) BOOL hasAnyCreditCards;
@property (nonatomic,assign) BOOL firstLaunch;
@end

@implementation PaymentViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[FZTargetManager sharedInstance] loadUnitTesting];
    [[BundleHelper sharedInstance] setRootBundle:FZBundlePayment];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit{
    _paymentViewVC = [[PaymentViewController alloc] init];
    XCTAssertTrue([_paymentViewVC isKindOfClass: [PaymentViewController class]], @"Initialization failure");
}

#pragma mark - MM

- (void)dealloc {
    [super dealloc];
    [_paymentViewVC release], _paymentViewVC = nil;
}


@end
