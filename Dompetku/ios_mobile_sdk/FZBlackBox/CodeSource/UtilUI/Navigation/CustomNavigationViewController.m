//
//  CustomNavigationViewController.m
//  iMobey
//
//  Created by Olivier Demolliens on 10/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "CustomNavigationViewController.h"

//BundleHelper
#import "BundleHelper.h"

//Controller
#import "HeaderViewController.h"

//Util
#import "ODDeviceUtil.h"

//Target
#import <FZBlackBox/FZTargetManager.h>

#ifdef __IPHONE_7_0
# define STATUS_STYLE UIStatusBarStyleLightContent
#else
# define STATUS_STYLE UIStatusBarStyleBlackTranslucent
#endif

#define delta 20.0

@interface CustomNavigationViewController () <CustomNavigationHeaderViewControllerDelegate>

@end

@implementation CustomNavigationViewController
@synthesize viewHeader;
@synthesize viewContent;
@synthesize mode;
@synthesize controller;
@synthesize navigController;

#pragma mark Init

- (id)initWithController:(HeaderViewController*)_controller andMode:(CustomNavigationMode)_mode
{
    self = [super initWithNibName:@"CustomNavigationViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        [self setController:_controller];
        [self setMode:_mode];
        _manageViewCycleLife = YES;
    }
    return self;
}

#pragma mark View Cycle Life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self viewContent]addSubview:[controller view]];
    
    // TODO : need refactor (MultiTargetManager)
    navigController = [[[[FZTargetManager sharedInstance]multiTarget] customNavigationHeaderViewControllerWithMode:mode] retain];
    
    [navigController setDelegate:self];
    
    //Force loading to display controller
    [navigController loadView];
    
    [navigController upgradeViewWithController:controller];
    
    [viewHeader addSubview:navigController.view];
    [self addChildViewController:navigController];
    [self addChildViewController:controller];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return STATUS_STYLE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_manageViewCycleLife) {
        
        if(![[self childViewControllers] containsObject:controller]) {
            [controller viewWillAppear:animated];
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    if (_manageViewCycleLife) {
        [controller viewDidAppear:animated];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [[controller view] setFrame:[[self viewContent] bounds]];
}

#pragma mark - CustomNavigationHeaderViewController delegate methods

- (void)didClose:(CustomNavigationViewController*)aController {
    
    if([controller respondsToSelector:@selector(didClose:)]){
        [controller didClose:aController];
    }else{
        NSAssert(NO, @"Did close not managed");
    }
}

- (void)didGoBack:(CustomNavigationHeaderViewController *)_controller {
    
    if([controller respondsToSelector:@selector(didGoBack:)]){
        [controller didGoBack:_controller];
    }else{
        NSAssert(NO, @"Did go back not managed");
    }
}

#pragma mark - Lock rotation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
        
    if (controller) {
        [controller release];
        controller = nil;
    }
    
    if (navigController) {
        [navigController release];
        navigController = nil;
    }
    
    [viewHeader release], viewHeader = nil;
    [viewContent release], viewContent = nil;
    [super dealloc];
}

@end
