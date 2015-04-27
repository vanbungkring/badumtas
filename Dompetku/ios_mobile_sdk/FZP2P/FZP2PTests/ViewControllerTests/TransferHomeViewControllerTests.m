//
//  TransferHomeViewControllerTests.m
//  FZP2P
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

#import "TransferHomeViewController.h"

@interface TransferHomeViewControllerTests : XCTestCase


@property (nonatomic, retain) TransferHomeViewController *transferHomeController;

@end

@implementation TransferHomeViewControllerTests

- (void)setUp {
		[[BundleHelper sharedInstance] setRootBundle:FZBundleP2P];
	
	
    [super setUp];
}

- (void)tearDown {
	[_transferHomeController release];
    [super tearDown];
}

- (void)testInit {
	_transferHomeController = [[TransferHomeViewController alloc] init];
	XCTAssertTrue([_transferHomeController isKindOfClass: [TransferHomeViewController class]], @"Initialization failure");
}

#pragma mark - MM

- (void)dealloc {
	[super dealloc];
	[_transferHomeController release], _transferHomeController = nil;
}

@end
