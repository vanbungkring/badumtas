//
//  AllLoyaltyProgramsNavBarOpenedViewControllerTests.m
//  FZRewards
//
//  Created by OlivierDemolliens on 8/11/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Controllers tested
#import "LoyaltyProgramDetailsViewController.h"

//Target manager
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface LoyaltyProgramDetailsViewControllerTests : XCTestCase

@property (nonatomic, retain) LoyaltyProgramDetailsViewController *controller;

@end


@implementation LoyaltyProgramDetailsViewControllerTests

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
- (id)initWithProgram:(LoyaltyProgram *)program;
 */
- (void)testInitWithProgram
{
    LoyaltyProgram *prog = [[LoyaltyProgram alloc]init];

    _controller = [[[LoyaltyProgramDetailsViewController alloc] initWithProgram:prog] autorelease];
    
    XCTAssertNotNil(_controller,@"Initialization failure");
    
    XCTAssertTrue([_controller isKindOfClass: [LoyaltyProgramDetailsViewController class]], @"Initialization failure");
}

@end
