//
//  TransferReceiveStep1ViewControllerTests.m
//  FZP2P
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

#import "FZTransferReceiveStep1ViewController.h"

@interface TransferReceiveStep1ViewControllerTests : XCTestCase


@property (nonatomic, retain) FZTransferReceiveStep1ViewController *transferStepOne;

@end

@implementation TransferReceiveStep1ViewControllerTests

- (void)setUp {
	[[BundleHelper sharedInstance] setRootBundle:FZBundleP2P];
    [super setUp];
}

- (void)tearDown {
	[_transferStepOne release];
    [super tearDown];
}

- (void)testInit {
	_transferStepOne = [[FZTransferReceiveStep1ViewController alloc] init];
	XCTAssertTrue([_transferStepOne isKindOfClass: [FZTransferReceiveStep1ViewController class]], @"Initialization failure");
}

#pragma mark - MM

- (void)dealloc {
	[super dealloc];
	[_transferStepOne release], _transferStepOne = nil;
}

@end
