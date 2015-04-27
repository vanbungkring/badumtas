//
//  CustomTabBarViewController.m
//  iMobey
//
//  Created by Olivier Demolliens on 09/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "CustomTabBarViewController.h"

//BundleHelper
#import "BundleHelper.h"

//Draw
#import "FZUIColorCreateMethods.h"
#import "ColorHelper.h"

#import <QuartzCore/QuartzCore.h>

//Custom
#import "HeaderViewController.h"
#import "CustomNavigationHeaderViewController.h"

//Controllers
//#import "TransferHomeViewController.h"
@class TransferHomeViewController;
//#import "RewardsHomeViewController.h"
@class RewardsHomeViewController;
//#import "PaymentViewController.h"
@class PaymentViewController;

//Navigation
#import "FZPortraitNavigationController.h"

//UserSession
#import <FZAPI/UserSession.h>

//Helper
#import "FZTargetManager.h"

//Animation
#import "FlashizButtonRiddleAnimation.h"

//Util
#import "ODDeviceUtil.h"
#import "FZUIImageWithImage.h"

//Tracking
#import <FZBlackBox/StatisticsFactory.h>

//Facade
@class FZFlashizFacade;

#include <sys/types.h>
#include <sys/sysctl.h>


#define delta 20.0

#define kWaitingTagView 45646546

@interface CustomTabBarViewController ()
{
    
}

//View
@property (retain, nonatomic) IBOutlet FlashizButtonRiddleAnimation *btnTransfert;
@property (retain, nonatomic) IBOutlet FlashizButtonRiddleAnimation *btnPay;
@property (retain, nonatomic) IBOutlet FlashizButtonRiddleAnimation *btnFid;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *btnList;
@property (retain, nonatomic) IBOutlet UIView *viewTabBar;
@property (retain, nonatomic) IBOutlet UIView *viewHeaders;


@property (retain, nonatomic) UIButton *currentButton;

@property(nonatomic,assign)BOOL canBeAnimated;

//SubController
@property (retain, nonatomic) TransferHomeViewController *transferHomeViewController;
@property (retain, nonatomic) PaymentViewController *paymentViewController;

//NavigationController
@property (retain, nonatomic) FZPortraitNavigationController *navigControllerTransfert;
@property (retain, nonatomic) FZPortraitNavigationController *navigControllerPayment;
@property (retain, nonatomic) FZPortraitNavigationController *navigControllerRewards;

//Components
@property (retain, nonatomic) CustomNavigationHeaderViewController *headerController;

//Util
@property (assign, nonatomic) HeaderViewController *lastController;
@property (assign, nonatomic) FZPortraitNavigationController *lastNavigationController;

//target
@property (assign, nonatomic) FZTarget target;
@property (assign, nonatomic) FZFlashizFacade *facade;

@end

@implementation CustomTabBarViewController {
    NSInteger currentIndex;
}
@synthesize delegate;

#pragma mark - Constructor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    BOOL isNibNameAvailableInCoreUIBundle = [[BundleHelper sharedInstance]isNibResourceExistInMainBundle:[BundleHelper nibNameForController:self]];
    
    NSBundle *bundle = nibBundleOrNil;
    
    if (isNibNameAvailableInCoreUIBundle) {
        bundle = [[BundleHelper sharedInstance]bundle];
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:bundle];
    
    return self;
}

- (id)init
{
    self = [self initWithNibName:@"CustomTabBarViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        _lastIndex = -1;
    }
    return self;
}

#pragma mark - Public method

- (NSInteger)currentSelectedIndex {
    return _lastIndex-1;
}

- (void)selectTabAtIndex:(NSInteger)index {
    FlashizButtonRiddleAnimation *button = _btnPay;
    
    switch (index) {
        case indexButtonTransfert:
            button = _btnTransfert;
            break;
        case indexButtonPayment:
            button = _btnPay;
            break;
        case indexButtonRewards:
            button = _btnFid;
        default:
            button = _btnPay;
            break;
    }
    
    [self selectIndex:button];
}

- (void)setCustomTabBarForProfessional {
    [_btnFid setHidden:YES];
    
    CGRect frameBtnTransfert = [_btnTransfert frame];
    frameBtnTransfert.origin.x = 100 - _btnTransfert.frame.size.width/2;
    
    [_btnTransfert setFrame:frameBtnTransfert];
    
    CGRect frameBtnPay = [_btnPay frame];
    frameBtnPay.origin.x = 220 - _btnPay.frame.size.width/2;
    
    [_btnPay setFrame:frameBtnPay];
}

- (void)setCustomTabBarForClient {
    [_btnFid setHidden:NO];
    
    CGRect frameBtnTransfert = [_btnTransfert frame];
    frameBtnTransfert.origin.x = 46 - _btnTransfert.frame.size.width/2;
    
    [_btnTransfert setFrame:frameBtnTransfert];
    
    CGRect frameBtnPay = [_btnPay frame];
    frameBtnPay.origin.x = 160 - _btnPay.frame.size.width/2;
    
    [_btnPay setFrame:frameBtnPay];
}

#pragma mark - View cycle life

-(void)willEnterForeground
{
    //Nothing to do
}

-(void)willEnterBackground
{
    //TODO: should we close the SDK when the host app is in background
    /*
    if(_target == FZSDKTarget || _target == FZBankSDKTarget) {
        if(_currentButton==_btnPay){
            if([_paymentViewController presentedViewController]==nil){
                [_paymentViewController forceStopRunning];
                
                [self performSelector:@selector(dismissModalViewControl lerAnimated:) withObject:NO];
            }
        }
    }*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _target = [[FZTargetManager sharedInstance] mainTarget];
    _facade = [[FZTargetManager sharedInstance] facade];
    
    //Used "close" navigation mode
    CustomNavigationMode mode = CustomNavigationModeMenu;
    
    if(_target==FZBankSDKTarget){
        mode = CustomNavigationModeClose;
    }
    
    [self setHeaderController:[[self multiTargetManager] customNavigationHeaderViewControllerWithMode:mode]];
    
    [_viewHeaders addSubview:[[self headerController]view]];
    [self addChildViewController:[self headerController]];
    
    if([ODDeviceUtil currentDeviceModel]==ODDeviceModeliPhone3GS) {
        _canBeAnimated = NO;
    }else{
        _canBeAnimated = YES;
    }
    
    [self setupView];
    
    //Used to close the SDK when we go in background
    if(_target == FZSDKTarget || _target == FZBankSDKTarget) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    [_viewShowed setAutoresizesSubviews:YES];
}

-(void)setupView
{
    //Display tab bar icone
    if(_target!=FZBankSDKTarget){
        [_btnTransfert setImage:[FZUIImageWithImage imageNamed:@"btn_send" inBundle:FZBundleP2P] forState:UIControlStateNormal];
        [_btnTransfert setImage:[FZUIImageWithImage imageNamed:@"btn_send_red" inBundle:FZBundleP2P] forState:UIControlStateSelected];
        
        [_btnTransfert setImage:[FZUIImageWithImage imageNamed:@"btn_send_red" inBundle:FZBundleP2P] forState:UIControlStateHighlighted];
        
    }
    
    [_btnFid setImage:[FZUIImageWithImage imageNamed:@"btn_fid" inBundle:FZBundleRewards] forState:UIControlStateNormal];
    [_btnPay setImage:[FZUIImageWithImage imageNamed:@"btn_flash" inBundle:FZBundlePayment] forState:UIControlStateNormal];
    
    [_btnFid setImage:[FZUIImageWithImage imageNamed:@"btn_fid_green" inBundle:FZBundleRewards] forState:UIControlStateSelected];
    
    [_btnFid setImage:[FZUIImageWithImage imageNamed:@"btn_fid_green" inBundle:FZBundleRewards] forState:UIControlStateHighlighted];
    
    [_btnPay setImage:[FZUIImageWithImage imageNamed:@"btn_flash_blue" inBundle:FZBundlePayment] forState:UIControlStateSelected];
    
    [_btnPay setImage:[FZUIImageWithImage imageNamed:@"btn_flash_blue" inBundle:FZBundlePayment] forState:UIControlStateHighlighted];
}

- (void)viewDidLayoutSubviews
{
    //Force select pay index
    //
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[UserSession currentSession]isUserConnected]){
        
        if([self currentSelectedIndex]==-2){
            [self selectIndex:_btnPay animated:YES];
        }
        
        [self closeOverlayView];
        
    }else{
        
        UIImageView *imgOverlay = [[UIImageView alloc]initWithImage:[FZUIImageWithImage imageNamed568h:@"Default" inBundle:FZBundleBlackBox]];
        [imgOverlay setTag:kWaitingTagView];
        
        [self.view.superview addSubview:imgOverlay];
        
        [imgOverlay release];
    }
}

-(void)closeOverlayView
{
    UIView *v = [self.view.superview viewWithTag:kWaitingTagView];
    
    if(v!=nil){
        [v removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)manageHotspotStatusBar {
    if([[UIApplication sharedApplication] statusBarFrame].size.height > 20.0) {
        
        CGRect UILayoutContainerViewFrame = [[[_viewShowed subviews] objectAtIndex:0] frame];
        UILayoutContainerViewFrame.origin.y = 0.0;
        [[[_viewShowed subviews] objectAtIndex:0] setFrame:UILayoutContainerViewFrame];
        
    } else {
        //no hotspot
    }
}

#pragma mark Loading components

- (void)loadTransfer
{
    if(_transferHomeViewController!=nil){
        return;
    }
    
    if(_target != FZBankSDKTarget){
        _transferHomeViewController = [[[self multiTargetManager] tranferHomeViewController] retain];
        _navigControllerTransfert = [[FZPortraitNavigationController alloc]initWithRootViewController:(UIViewController *)_transferHomeViewController];;
    }
}

- (void)loadScanner
{
    if(_paymentViewController!=nil){
        return;
    }
    
    [self setPaymentViewController:[[self multiTargetManager] paymentViewController]];
    
    //Load Payment controller
    [self setNavigControllerPayment:[[[FZPortraitNavigationController alloc]initWithRootViewController:(UIViewController *)_paymentViewController]autorelease]];
    
    [[self paymentViewController] setDelegate:self];
    [[self headerController] setDelegate:_paymentViewController];
}

- (void)loadRewards
{
    if(_rewardsHomeViewController!=nil || ![[UserSession currentSession] isUserAccessToRewards]){
        return;
    }
    
    [self setRewardsHomeViewController:[[self multiTargetManager] rewardsHomeViewController]];
    
    [self setNavigControllerRewards:[[[FZPortraitNavigationController alloc]initWithRootViewController:(UIViewController *)[self rewardsHomeViewController]]autorelease]];
}

#pragma mark - Action method

-(IBAction)selectIndex:(id)sender
{
    [self selectIndex:sender animated:YES];
}

- (void)selectIndex:(id)sender animated:(BOOL)animated {
    if(_currentButton == sender){
        return;
    }
    
    [self.view setUserInteractionEnabled:NO];
    
    _currentButton = sender;
    
    [_btnList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setSelected:NO];
    }];
    
    UIButton *button = sender;
    [button setSelected:YES];
    
    if(animated) {
        if (_canBeAnimated) {
            if (sender == _btnPay) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [[self btnPay] startWithNumberOfRiddles:3 direction:kFlashizRiddleAnimationDirectionExpand color:[[ColorHelper sharedInstance] customTabBarViewController_btnPay_riddleColor]];
                });
                
            } else {
                [_btnPay stopRiddles];
            }
        }
    }
    
    [self selectNewIndex:(int)[button tag]];
}

-(void)selectNewIndex:(int)index
{
    int newIndex = index;
    
    HeaderViewController *controller = nil;
    FZPortraitNavigationController *navigController = nil;
    
    if(newIndex==1){
        [[StatisticsFactory sharedInstance] checkPointTabBarTransfer];
        [self loadTransfer];
        controller = (HeaderViewController*)_transferHomeViewController;
        navigController = _navigControllerTransfert;
        [_viewTabBar setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        
    }else if(newIndex==2){
        [[StatisticsFactory sharedInstance] checkPointTabBarPay];
        [self loadScanner];
        controller = (HeaderViewController*)_paymentViewController;
        navigController = _navigControllerPayment;
        [_viewTabBar setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        
    }else if(newIndex==3){
        [[StatisticsFactory sharedInstance] checkPointTabBarRewards];
        [self loadRewards];
        controller = (HeaderViewController*)_rewardsHomeViewController;
        navigController = _navigControllerRewards;
        [_viewTabBar setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        
    }else{
        NSAssert(NO, @"CustomTabBarViewController - unknow selectIndex");
    }
    
    [[_lastNavigationController view] removeFromSuperview];
    
    [_headerController upgradeViewWithController:controller];
    
    navigController.navigationBarHidden = YES;
    
    [_viewShowed addSubview:navigController.view];
    [self addChildViewController:navigController];
    
    [self manageHotspotStatusBar];
    
    [self.view setUserInteractionEnabled:YES];
    
    if (_lastNavigationController) {
        
        BOOL animated = NO;
        if (_lastIndex == newIndex) {
            animated = YES;
        }
        [_lastNavigationController popViewControllerAnimated:animated];
    }
    
    _lastController = controller;
    _lastNavigationController = navigController;
    _lastIndex = newIndex;
}

- (void)forceRiddles {
    if (_canBeAnimated) {
        if ([_btnPay isSelected]) {
            [_btnPay startWithNumberOfRiddles:3 direction:kFlashizRiddleAnimationDirectionExpand color:[[ColorHelper sharedInstance] customTabBarViewController_btnPay_riddleColor]];
        }else{
            [_btnPay stopRiddles];
        }
    }
}

#pragma mark - Private

- (FZDefaultMultiTargetManager *)multiTargetManager {
    return [[FZTargetManager sharedInstance] multiTarget];
}

#pragma mark - Delegate

- (void)didClose:(UIViewController *)viewController {
    if ([delegate respondsToSelector:@selector(didClose:)]) {
        [delegate didClose:viewController];
    }
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)deallocRewards {
    //not used
}

- (void)dealloc {
    
    if(_target == FZSDKTarget || _target == FZBankSDKTarget) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    //Force stop animation on btnpay
    [_btnPay stopRiddles];
    
    if(_target != FZBankSDKTarget){
        if(_transferHomeViewController){
            [_transferHomeViewController release],_transferHomeViewController = nil;
        }
        
        if(_navigControllerTransfert){
            [_navigControllerTransfert release],_navigControllerTransfert = nil;
        }
    }
    
    if(_navigControllerPayment){
        [_navigControllerPayment release],_navigControllerPayment = nil;
    }
    
    if(_paymentViewController){
        [_paymentViewController release],_paymentViewController= nil;
    }
    
    if(_navigControllerRewards){
        [_navigControllerRewards release],_navigControllerRewards = nil;
    }
    
    if(_rewardsHomeViewController){
        [_rewardsHomeViewController release],_rewardsHomeViewController = nil;
    }
    
    //Target
    _facade = nil;
    
    [_btnTransfert release], _btnTransfert = nil;
    [_btnPay release], _btnPay = nil;
    [_btnFid release], _btnFid = nil;
    [_btnList release], _btnList = nil;
    [_viewTabBar release], _viewTabBar = nil;
    [_viewShowed release], _viewShowed = nil;
    [_viewHeaders release], _viewHeaders = nil;
    
    [super dealloc];
}

@end
