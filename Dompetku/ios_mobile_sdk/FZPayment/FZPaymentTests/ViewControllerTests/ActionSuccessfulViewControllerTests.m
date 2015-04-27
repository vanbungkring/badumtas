//
//  ActionSuccessfulViewControllerTests.m
//  FZPayment
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ActionSuccessfulViewController.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
//Color
#import <FZBlackBox/ColorHelper.h>
#import <FZBlackBox/FZTargetManager.h>
#import <FZBlackBox/FZUIImageWithImage.h>

@interface ActionSuccessfulViewControllerTests : XCTestCase

@property (nonatomic, retain) ActionSuccessfulViewController *actionSuccessfulVC;
@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) NSString *titleView;
@property (retain, nonatomic) NSString *arrowImageName;
@property (retain, nonatomic) UIImage *arrowImage;
@property (retain, nonatomic) NSString *backgroundImageName;
@property (assign, nonatomic) FZBundleName bundlName;
//Error
@property (retain, nonatomic) Error *currentError;

@property (nonatomic, assign) BOOL isBtnImageCenterForcedHide;


@end

@implementation ActionSuccessfulViewControllerTests

- (void)setUp {
    [super setUp];
    [[FZTargetManager sharedInstance] loadUnitTesting];
    [[BundleHelper sharedInstance] setRootBundle:FZBundlePayment];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithTitleAndBackgroundColorAndArrowImage{
    //
    
    _titleView = @"Title";
    _backgroundColor =[[ColorHelper sharedInstance] monochromeTwoColor];
    _arrowImage = [FZUIImageWithImage imageNamed:@"icon_pin_receiver_big" inBundle:FZBundlePayment];
    
    /* [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_blue" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];*/
    XCTAssertNotNil(_titleView, @"titleView is nil");
    XCTAssertNotNil(_backgroundColor, @"backgroundColor is nil");
    XCTAssertNotNil(_arrowImage, @"arrowImage is nil");
    
    _actionSuccessfulVC = [[ActionSuccessfulViewController alloc] initWithTitle:_titleView andBackgroundColor:_backgroundColor andArrowImage:_arrowImage];
    XCTAssertTrue([_actionSuccessfulVC isKindOfClass: [ActionSuccessfulViewController class]], @"Initialization failure");
    XCTAssertTrue([[_actionSuccessfulVC titleView] isEqualToString:_titleView],@"Init titleView failure");
    XCTAssertTrue([_actionSuccessfulVC backgroundColor] == _backgroundColor,@"Init backgroundColor failure");
    XCTAssertTrue([_actionSuccessfulVC arrowImage] == _arrowImage,@"Init arrowImage failure");
}

- (void)testInitWithTitleAndBackgroundColorAndArrowImageAndError{
    
    _titleView = @"Title";
    _backgroundColor =[[ColorHelper sharedInstance] monochromeTwoColor];
    _arrowImage = [FZUIImageWithImage imageNamed:@"icon_pin_receiver_big" inBundle:FZBundlePayment];
    _currentError = [[Error alloc] init];
    [_currentError setErrorCode:4000];
    
    
    /* [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_blue" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];*/
    XCTAssertNotNil(_titleView, @"titleView is nil");
    XCTAssertNotNil(_backgroundColor, @"backgroundColor is nil");
    XCTAssertNotNil(_arrowImage, @"arrowImage is nil");
    XCTAssertNotNil(_currentError, @"currentError is nil");
    
    _actionSuccessfulVC = [[ActionSuccessfulViewController alloc] initWithTitle:_titleView andBackgroundColor:_backgroundColor andArrowImage:_arrowImage andError:_currentError];
    XCTAssertTrue([_actionSuccessfulVC isKindOfClass: [ActionSuccessfulViewController class]], @"Initialization failure");
    
    XCTAssertTrue([[_actionSuccessfulVC titleView] isEqualToString:_titleView],@"Init titleView failure");
    XCTAssertTrue([_actionSuccessfulVC backgroundColor] == _backgroundColor,@"Init backgroundColor failure");
    XCTAssertTrue([_actionSuccessfulVC arrowImage] == _arrowImage,@"Init arrowImage failure");
    XCTAssertTrue([[_actionSuccessfulVC currentError] errorCode] == [_currentError errorCode],@"Init currentError failure");
}

- (void)testInitWithTitleAndBackgroundColorAndArrowImageAndBackgroundImageInBundleName{
    _titleView = @"Title";
    _backgroundColor =[[ColorHelper sharedInstance] monochromeTwoColor];
    _arrowImage = [FZUIImageWithImage imageNamed:@"icon_pin_receiver_big" inBundle:FZBundlePayment];
    _backgroundImageName = @"pagination_intro_1";
    _bundlName = FZBundleBlackBox;
    
    XCTAssertNotNil(_titleView, @"titleView is nil");
    XCTAssertNotNil(_backgroundColor, @"backgroundColor is nil");
    XCTAssertNotNil(_arrowImage, @"arrowImage is nil");
    XCTAssertNotNil(_backgroundImageName, @"backgroundImageName is nil");
    XCTAssertNotNil(_bundlName, @"bundlName is nil");
    
    _actionSuccessfulVC = [[ActionSuccessfulViewController alloc] initWithTitle:_titleView andBackgroundColor:_backgroundColor andArrowImage:_arrowImage andBackgroundImage:_backgroundImageName inBundleName:_bundlName];
    
    XCTAssertTrue([_actionSuccessfulVC isKindOfClass: [ActionSuccessfulViewController class]], @"Initialization failure");
    
    XCTAssertTrue([[_actionSuccessfulVC titleView] isEqualToString:_titleView],@"Init titleView failure");
    XCTAssertTrue([_actionSuccessfulVC backgroundColor] == _backgroundColor,@"Init backgroundColor failure");
    XCTAssertTrue([_actionSuccessfulVC arrowImage] == _arrowImage,@"Init arrowImage failure");
    XCTAssertTrue([[_actionSuccessfulVC backgroundImageName]isEqualToString:_backgroundImageName],@"Init backgroundImageName failure");
    XCTAssertTrue([_actionSuccessfulVC bundlName] == _bundlName,@"Init bundlName failure");

}

- (void)testInitWithTitleAndBackgroundColorAndArrowImageAndBackgroundImageInBundleNameAndError{
    _titleView = @"Title";
    _backgroundColor =[[ColorHelper sharedInstance] monochromeTwoColor];
    _arrowImage = [FZUIImageWithImage imageNamed:@"icon_pin_receiver_big" inBundle:FZBundlePayment];
    _currentError = [[Error alloc] init];
    [_currentError setErrorCode:4000];
    _backgroundImageName = @"btn_accept_green";
    _bundlName = FZBundlePayment;
    XCTAssertNotNil(_currentError, @"currentError is nil");
    
    XCTAssertNotNil(_titleView, @"titleView is nil");
    XCTAssertNotNil(_backgroundColor, @"backgroundColor is nil");
    XCTAssertNotNil(_arrowImage, @"arrowImage is nil");
    XCTAssertNotNil(_backgroundImageName, @"backgroundImageName is nil");
    XCTAssertNotNil(_bundlName, @"bundlName is nil");
    
    _actionSuccessfulVC = [[ActionSuccessfulViewController alloc] initWithTitle:_titleView andBackgroundColor:_backgroundColor andArrowImage:_arrowImage andBackgroundImage:_backgroundImageName inBundleName:_bundlName andError:_currentError];
    
    XCTAssertTrue([_actionSuccessfulVC isKindOfClass: [ActionSuccessfulViewController class]], @"Initialization failure");
    XCTAssertTrue([[_actionSuccessfulVC titleView] isEqualToString:_titleView],@"Init titleView failure");
    XCTAssertTrue([_actionSuccessfulVC backgroundColor] == _backgroundColor,@"Init backgroundColor failure");
    XCTAssertTrue([_actionSuccessfulVC arrowImage] == _arrowImage,@"Init arrowImage failure");
    XCTAssertNil([_actionSuccessfulVC backgroundImageName],@"Init backgroundImageName failure");
    XCTAssertTrue([_actionSuccessfulVC bundlName] == _bundlName,@"Init bundlName failure");
    XCTAssertTrue([[_actionSuccessfulVC currentError] errorCode] == [_currentError errorCode],@"Init currentError failure");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)dealloc
{
    [_titleView release],_titleView = nil;
    [_backgroundColor release],_backgroundColor = nil;
    [_backgroundImageName release];
    [_currentError release];
    [super dealloc];
}

@end
