//
//  CustomNavigationViewController.m
//  iMobey
//
//  Created by Olivier Demolliens on 09/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "CustomNavigationHeaderViewController.h"

//Manager
#import "FZTargetManager.h"
//BundleHelper
#import "BundleHelper.h"

//ImageHelper
#import <FZBlackBox/FZUIImageWithImage.h>

//BundleHelper
#import "BundleHelper.h"

//HeaderViewController
#import "HeaderViewController.h"

//Special Button for map
@class ProximityMapViewController;

#import <CoreLocation/CoreLocation.h>

//Menu
#import "SWRevealViewController.h"

//Fonts
#import "FontHelper.h"

@interface CustomNavigationHeaderViewController ()
{
    
}

//View
@property (retain, nonatomic) IBOutlet UIView *viewHeader;
@property (retain, nonatomic) IBOutlet UIButton *btnMenu;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnClose;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UIButton *btnMap;


@property(assign, nonatomic) UIViewController *controller;

@end


@implementation CustomNavigationHeaderViewController

#pragma mark - Init

- (id)initWithMode:(CustomNavigationMode)mode
{
    self = [super initWithNibName:@"CustomNavigationHeaderViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        _mode = mode;
    }
    return self;
}

#pragma mark - view cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)setupView
{
    [_lblTitle setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:14.0f]];
    [_lblTitle setAdjustsFontSizeToFitWidth:YES];
    [_lblTitle setMinimumScaleFactor:0.5];
    
    [_btnBack setImage:[FZUIImageWithImage imageNamed:@"btn_back" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
    [_btnClose setImage:[FZUIImageWithImage imageNamed:@"icon_cross_white" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
    
    [_btnMenu setImage:[FZUIImageWithImage imageNamed:@"btn_menu" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
}

#pragma mark - Action method

- (IBAction)showMenu:(id)sender
{
    [[[FZTargetManager sharedInstance] facade] revealOrHideMenu];
}

- (IBAction)back:(id)sender
{
    
    /*NSArray* arrayController = [[self navigationController]childViewControllers];
     
     UIViewController *controller = [arrayController objectAtIndex:[arrayController count]-2];
     [[self navigationController]popToViewController:controller animated:YES];
     */
    if([_delegate respondsToSelector:@selector(didGoBack:)]) {
        [_delegate didGoBack:self];
    }
    
}
- (IBAction)mapCenter:(id)sender {
#warning can't be fixed with import. Must be managed in the MultiTargetManager
    if (_controller != nil && [_controller respondsToSelector:@selector(centerMe:)]) {
        [(ProximityMapViewController*)_controller centerMe:nil];
    }
}

- (IBAction)closeNavigation:(id)sender
{
    if([_delegate respondsToSelector:@selector(didClose:)]) {
        [_delegate didClose:self];
    }
}

-(void)upgradeViewWithController:(HeaderViewController*)controller
{
    _controller = controller;
    
    if ([controller isKindOfClass:[HeaderViewController class]]) {
        [_lblTitle setText:[controller.titleHeader uppercaseString]];
        
        [_lblTitle setTextColor:[controller titleColor]];
        [_viewHeader setBackgroundColor:[controller backgroundColor]];
        
        
        [_lblTitle setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
    }else{
        NSAssert(NO, @"CustomNavigationViewController - can't upgradeViewWithController:%@",controller);
    }
    
    if (_mode == CustomNavigationModeMenu) {
        [_btnClose setHidden:YES];
        [_btnBack setHidden:YES];
        [_imgView setHidden:YES];
    }else if (_mode == CustomNavigationModeMenuMap) {
        [_btnClose setHidden:YES];
        [_btnBack setHidden:YES];
        [_imgView setHidden:YES];
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
        [_btnMap setImage:[FZUIImageWithImage imageNamed:@"btn_locate" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
        [_btnMap setHidden:NO];
        }
    }else if (_mode == CustomNavigationModeBack) {
        [_btnClose setHidden:YES];
        [_btnMenu setHidden:YES];
        [_btnBack setHidden:NO];
        [_imgView setHidden:YES];
    }else if (_mode == CustomNavigationModeClose) {
        [_btnMenu setHidden:YES];
        [_btnClose setHidden:NO];
        [_btnBack setHidden:YES];
        [_imgView setHidden:YES];
    }else if (_mode == CustomNavigationModeBackRegisterStep1) {
        [_btnClose setHidden:YES];
        [_btnMenu setHidden:YES];
        [_btnBack setHidden:NO];
        [_imgView setImage:[FZUIImageWithImage imageNamed:@"pagination_intro_1" inBundle:FZBundleBlackBox]];
        [_imgView setHidden:NO];
    }else if (_mode == CustomNavigationModeBackRegisterStep2) {
        [_btnClose setHidden:YES];
        [_btnMenu setHidden:YES];
        [_btnBack setHidden:NO];
        [_imgView setImage:[FZUIImageWithImage imageNamed:@"pagination_intro_2" inBundle:FZBundleBlackBox]];
        [_imgView setHidden:NO];
    }else if (_mode == CustomNavigationModeBackRegisterStep3) {
        [_btnClose setHidden:YES];
        [_btnMenu setHidden:YES];
        [_btnBack setHidden:NO];
        [_imgView setImage:[FZUIImageWithImage imageNamed:@"pagination_intro_2" inBundle:FZBundleBlackBox]];
        [_imgView setHidden:NO];
    }else if (_mode == CustomNavigationModeBackRegisterStep4) {
        [_btnClose setHidden:YES];
        [_btnMenu setHidden:YES];
        [_btnBack setHidden:NO];
        [_imgView setImage:[FZUIImageWithImage imageNamed:@"pagination_intro_3" inBundle:FZBundleBlackBox]];
        [_imgView setHidden:NO];
    }
}

- (void)hideCloseButton {
    [_btnClose setHidden:YES];
}

- (void)showCloseButton {
    [_btnClose setHidden:NO];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {

    _controller = nil;//_controller no release -> assign (normal ?)
    [_viewHeader release], _viewHeader = nil;
    [_btnMenu release], _btnMenu = nil;
    [_lblTitle release], _lblTitle = nil;
    [_btnClose release], _btnClose = nil;
    [_btnBack release], _btnBack = nil;
    [_imgView release], _imgView = nil;
    [_btnMap release], _btnMap = nil;
    [super dealloc];
}

@end
