//
//  AllLoyaltyProgramsNavBarOpenedViewControllerTests.m
//  FZRewards
//
//  Created by OlivierDemolliens on 8/11/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Controllers tested
#import "ShowEULAViewController.h"

//Target manager
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface ShowEULAViewControllerTests : XCTestCase

@property (nonatomic, retain) ShowEULAViewController *controller;

@end


@implementation ShowEULAViewControllerTests

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
- (id)initWithUrl:(NSString *)urlOfEula;
 */
- (void)testInit
{
    _controller = [[[ShowEULAViewController alloc] initWithUrl:@"http://google.fr"] autorelease];
    
    XCTAssertNotNil(_controller,@"Initialization failure");
    
    XCTAssertTrue([_controller isKindOfClass: [ShowEULAViewController class]], @"Initialization failure");
}

@end
