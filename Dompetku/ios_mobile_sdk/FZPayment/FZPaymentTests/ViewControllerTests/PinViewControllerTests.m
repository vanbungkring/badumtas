//
//  PinViewControllerTests.m
//  FZCoreUI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "PinViewController.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface PinViewControllerTests : XCTestCase

@property (nonatomic, retain) PinViewController *pinViewController;

@end

@implementation PinViewControllerTests

#pragma mark - Init & Ending

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
- (id)init;
 */

- (void)testInit {
 
    _pinViewController = [[PinViewController alloc] init];
    
    XCTAssertTrue([_pinViewController isKindOfClass: [PinViewController class]], @"Initialization failure");
}

/*
- (id)initWithModeSmall {
    self = [super initWithNibName:@"PinViewControllerSmall" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if(self){
        
    }
    return self;
}
 */
- (void)testInitWithModeSmall {
    _pinViewController = [[PinViewController alloc] initWithModeSmall];
    
    XCTAssertTrue([_pinViewController isKindOfClass: [PinViewController class]], @"Initialization failure");
}

/*
- (id)initWithCompletionBlock:(PinCompletionBlock)completionBlock andNavigationTitle:(NSString*)navtitle  andTitle:(NSString*)title andTitleHeader:(NSString *)headerTitle andDescription:(NSString*)description animated:(BOOL)animated modeSmall:(BOOL)isSmall
*/
- (void)testInitInitWithCompletionBlockAndNavigationTitleAndTitleAndTitleHeaderAndDescriptionAnimatedModeSmallOn {
    _pinViewController = [[PinViewController alloc] initWithCompletionBlock:^(NSString *pinCode) {
        //empty completion block
    }
                                                         andNavigationTitle:@"test"
                                                                   andTitle:@"test"
                                                             andTitleHeader:@"test"
                                                             andDescription:@"test"
                                                                   animated:NO
                                                                  modeSmall:YES];
    
    XCTAssertTrue([_pinViewController isKindOfClass: [PinViewController class]], @"Initialization failure");
}

- (void)testInitInitWithCompletionBlockAndNavigationTitleAndTitleAndTitleHeaderAndDescriptionAnimatedModeSmallOff {
    _pinViewController = [[PinViewController alloc] initWithCompletionBlock:^(NSString *pinCode) {
        //empty completion block
    }
                                                         andNavigationTitle:@"test"
                                                                   andTitle:@"test"
                                                             andTitleHeader:@"test"
                                                             andDescription:@"test"
                                                                   animated:NO
                                                                  modeSmall:NO];
    
    XCTAssertTrue([_pinViewController isKindOfClass: [PinViewController class]], @"Initialization failure");
}

- (void)testViewDidLoadForInit {
    
    _pinViewController = [[PinViewController alloc] init];
    
    [_pinViewController viewDidLoad];
    
    for (UITextField *textField in [_pinViewController textFieldList]) {
        XCTAssertTrue([[textField text] isEqualToString:@""], @"Textfield is not initialized correctly");
    }
}

- (void)testViewDidLoadForInitWithModeSmall {
    
    _pinViewController = [[PinViewController alloc] initWithModeSmall];
    
    [_pinViewController viewDidLoad];
    
    for (UITextField *textField in [_pinViewController textFieldList]) {
        XCTAssertTrue([[textField text] isEqualToString:@""], @"Textfield is not initialized correctly");
    }
}

- (void)testViewDidLoadForWithCompletionBlockAndNavigationTitleAndTitleAndTitleHeaderAndDescriptionAnimatedModeSmallOn {
    
    _pinViewController = [[PinViewController alloc] initWithCompletionBlock:^(NSString *pinCode) {
        //empty completion block
    }
                                                         andNavigationTitle:@"test"
                                                                   andTitle:@"test"
                                                             andTitleHeader:@"test"
                                                             andDescription:@"test"
                                                                   animated:NO
                                                                  modeSmall:YES];
    
    [_pinViewController viewDidLoad];
    
    for (UITextField *textField in [_pinViewController textFieldList]) {
        XCTAssertTrue([[textField text] isEqualToString:@""], @"Textfield is not initialized correctly");
    }
}

- (void)testViewDidLoadForWithCompletionBlockAndNavigationTitleAndTitleAndTitleHeaderAndDescriptionAnimatedModeSmallOff {
    
    _pinViewController = [[PinViewController alloc] initWithCompletionBlock:^(NSString *pinCode) {
        //empty completion block
    }
                                                         andNavigationTitle:@"test"
                                                                   andTitle:@"test"
                                                             andTitleHeader:@"test"
                                                             andDescription:@"test"
                                                                   animated:NO
                                                                  modeSmall:NO];
    
    [_pinViewController viewDidLoad];
    
    for (UITextField *textField in [_pinViewController textFieldList]) {
        XCTAssertTrue([[textField text] isEqualToString:@""], @"Textfield is not initialized correctly");
    }
}


#pragma mark - MM

- (void)dealloc {
    [super dealloc];
    [_pinViewController release], _pinViewController = nil;
}

@end
