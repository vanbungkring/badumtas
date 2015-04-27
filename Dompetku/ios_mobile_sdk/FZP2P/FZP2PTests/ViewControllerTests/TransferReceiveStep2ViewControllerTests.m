//
//  TransferReceiveStep2ViewControllerTests.m
//  FZP2P
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>
#import <FZAPI/CurrenciesManager.h>

#import "TransferReceiveStep2ViewController.h"

@interface TransferReceiveStep2ViewControllerTests : XCTestCase


@property (nonatomic, retain) TransferReceiveStep2ViewController *transferStepTwo;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *currency;

@end

@implementation TransferReceiveStep2ViewControllerTests

- (void)setUp {
	[[BundleHelper sharedInstance] setRootBundle:FZBundleP2P];
	[super setUp];
}

- (void)tearDown {
	[_transferStepTwo release];
	[super tearDown];
}

- (void)testInitWithUrlAndCurrency {
	_transferStepTwo = [[TransferReceiveStep2ViewController alloc] initWithURL:_url amount:_amount currency:_currency];
	XCTAssertTrue([_transferStepTwo isKindOfClass: [TransferReceiveStep2ViewController class]], @"Initialization failure");
}

#pragma mark - MM

- (void)dealloc {
	[super dealloc];
	[_transferStepTwo release], _transferStepTwo = nil;
	[_url release], _url = nil;
	[_amount release], _amount = nil;
	[_currency release], _currency = nil;
}

@end
