//
//  AllLoyaltyProgramsNavBarOpenedViewControllerTests.m
//  FZRewards
//
//  Created by OlivierDemolliens on 8/11/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Controllers tested
#import "AllLoyaltyProgramsNavBarOpenedViewController.h"

//Target manager
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface AllLoyaltyProgramsNavBarOpenedViewControllerTests : XCTestCase

@property (nonatomic, retain) AllLoyaltyProgramsNavBarOpenedViewController *controller;

@end


@implementation AllLoyaltyProgramsNavBarOpenedViewControllerTests

- (void)setUp
{
    [super setUp];
    [[FZTargetManager sharedInstance] loadUnitTesting];
    [[BundleHelper sharedInstance] setRootBundle:FZBundleRewards];
}

- (void)tearDown
{
    if(_controller){
        [_controller release],_controller = nil;
    }
    [super tearDown];
}

/*
 - (id)init;
 */
- (void)testInit
{
    _controller = [[[AllLoyaltyProgramsNavBarOpenedViewController alloc] init] autorelease];
    
    XCTAssertNotNil(_controller,@"Initialization failure");
    
    XCTAssertTrue([_controller isKindOfClass: [AllLoyaltyProgramsNavBarOpenedViewController class]], @"Initialization failure");
}

@end
