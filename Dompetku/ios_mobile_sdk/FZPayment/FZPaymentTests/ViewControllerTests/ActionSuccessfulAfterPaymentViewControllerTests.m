//
//  ActionSuccessfulAfterPaymentViewControllerTests.m
//  FZPayment
//
//  Created by Matthieu Barile on 18/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "ActionSuccessfulAfterPaymentViewController.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>


@interface ActionSuccessfulAfterPaymentViewControllerTests : XCTestCase

@property (nonatomic, retain) ActionSuccessfulAfterPaymentViewController *actionSuccessfulAfterPaymentVC;
@property (nonatomic, assign) NSInteger nbOfGeneratedPoints;
@property (nonatomic, assign) NSInteger nbOfPointsToGenerateACoupon;
@property (nonatomic, assign) NSInteger nbOfPointsOnTheLoyaltyCard;
@property (nonatomic, assign) double amountOfACoupon;

@end

@implementation ActionSuccessfulAfterPaymentViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[FZTargetManager sharedInstance] loadUnitTesting];
    [[BundleHelper sharedInstance] setRootBundle:FZBundlePayment];
    
    NSLog(@"Setup passed");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests
/*
 - (id)initWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon;
 */
- (void)testInitWithNbOfGeneratedPointsNbOfPointsToGenerateACouponNbOfPointsOnTheLoyaltyCardAmountOfACoupon {
    
    _nbOfGeneratedPoints = 0;
    _nbOfPointsOnTheLoyaltyCard = 0;
    _nbOfPointsToGenerateACoupon = 0;
    _amountOfACoupon = 0;
    
    XCTAssertGreaterThanOrEqual(_nbOfGeneratedPoints, 0, @"NbOfGeneratedPoints is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsOnTheLoyaltyCard, 0, @"NbOfPointsOnTheLoyaltyCard is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsToGenerateACoupon, 0, @"NbOfPointsToGenerateACoupon is negative");
    XCTAssertGreaterThanOrEqual(_amountOfACoupon, 0, @"AmountOfACoupon is negative");
    
    _actionSuccessfulAfterPaymentVC = [[ActionSuccessfulAfterPaymentViewController alloc] initWithNbOfGeneratedPoints:_nbOfGeneratedPoints nbOfPointsToGenerateACoupon:_nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:_nbOfPointsOnTheLoyaltyCard amountOfACoupon:_amountOfACoupon];
    
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC isKindOfClass: [ActionSuccessfulAfterPaymentViewController class]], @"Initialization failure");
    
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC nbOfGeneratedPoints] == _nbOfGeneratedPoints,@"Init nbOfGeneratedPoints failure");
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC nbOfPointsOnTheLoyaltyCard] == _nbOfPointsOnTheLoyaltyCard,@"Init nbOfPointsOnTheLoyaltyCard failure");
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC nbOfPointsToGenerateACoupon] == _nbOfPointsToGenerateACoupon,@"Init nbOfPointsToGenerateACoupon failure");
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC amountOfACoupon] == _amountOfACoupon,@"Init amountOfACoupon failure");
}

/*
 typedef enum {
 FZActionSuccessFullNoPointsNoCoupons,
 FZActionSuccessFullWithPoints,
 FZActionSuccessFullWithCoupons,
 } FZActionSuccessFull;
 */
- (void)testViewDidLoadNoPointsNoCoupons {
    
    _nbOfGeneratedPoints = 0;
    _nbOfPointsOnTheLoyaltyCard = 0;
    _nbOfPointsToGenerateACoupon = 0;
    _amountOfACoupon = 0;
    
    XCTAssertGreaterThanOrEqual(_nbOfGeneratedPoints, 0, @"NbOfGeneratedPoints is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsOnTheLoyaltyCard, 0, @"NbOfPointsOnTheLoyaltyCard is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsToGenerateACoupon, 0, @"NbOfPointsToGenerateACoupon is negative");
    XCTAssertGreaterThanOrEqual(_amountOfACoupon, 0, @"AmountOfACoupon is negative");
    
    _actionSuccessfulAfterPaymentVC = [[ActionSuccessfulAfterPaymentViewController alloc] initWithNbOfGeneratedPoints:_nbOfGeneratedPoints nbOfPointsToGenerateACoupon:_nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:_nbOfPointsOnTheLoyaltyCard amountOfACoupon:_amountOfACoupon];
    
    [_actionSuccessfulAfterPaymentVC viewDidLoad];
    
    //0 = FZActionSuccessFullNoPointsNoCoupons
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC mode] == 0,@"Bad mode has been loaded");
}

- (void)testViewDidLoadWithPoints {
    
    _nbOfGeneratedPoints = 5;
    _nbOfPointsOnTheLoyaltyCard = 0;
    _nbOfPointsToGenerateACoupon = 10;
    _amountOfACoupon = 2;
    
    XCTAssertGreaterThanOrEqual(_nbOfGeneratedPoints, 0, @"NbOfGeneratedPoints is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsOnTheLoyaltyCard, 0, @"NbOfPointsOnTheLoyaltyCard is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsToGenerateACoupon, 0, @"NbOfPointsToGenerateACoupon is negative");
    XCTAssertGreaterThanOrEqual(_amountOfACoupon, 0, @"AmountOfACoupon is negative");
    
    _actionSuccessfulAfterPaymentVC = [[ActionSuccessfulAfterPaymentViewController alloc] initWithNbOfGeneratedPoints:_nbOfGeneratedPoints nbOfPointsToGenerateACoupon:_nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:_nbOfPointsOnTheLoyaltyCard amountOfACoupon:_amountOfACoupon];
    
    [_actionSuccessfulAfterPaymentVC viewDidLoad];
    
    //1 = FZActionSuccessFullWithPoints
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC mode] == 1,@"Bad mode has been loaded");
}

- (void)testViewDidLoadWithCoupons {
    
    _nbOfGeneratedPoints = 10;
    _nbOfPointsOnTheLoyaltyCard = 0;
    _nbOfPointsToGenerateACoupon = 5;
    _amountOfACoupon = 2;
    
    XCTAssertGreaterThanOrEqual(_nbOfGeneratedPoints, 0, @"NbOfGeneratedPoints is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsOnTheLoyaltyCard, 0, @"NbOfPointsOnTheLoyaltyCard is negative");
    XCTAssertGreaterThanOrEqual(_nbOfPointsToGenerateACoupon, 0, @"NbOfPointsToGenerateACoupon is negative");
    XCTAssertGreaterThanOrEqual(_amountOfACoupon, 0, @"AmountOfACoupon is negative");
    
    _actionSuccessfulAfterPaymentVC = [[ActionSuccessfulAfterPaymentViewController alloc] initWithNbOfGeneratedPoints:_nbOfGeneratedPoints nbOfPointsToGenerateACoupon:_nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:_nbOfPointsOnTheLoyaltyCard amountOfACoupon:_amountOfACoupon];
    
    [_actionSuccessfulAfterPaymentVC viewDidLoad];
    
    //2 = FZActionSuccessFullWithCoupons
    XCTAssertTrue([_actionSuccessfulAfterPaymentVC mode] == 2,@"Bad mode has been loaded");
}



#pragma mark - MM

- (void)dealloc {
    [super dealloc];
    
    [_actionSuccessfulAfterPaymentVC release], _actionSuccessfulAfterPaymentVC = nil;
}

@end
