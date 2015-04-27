//
//  UICustomHeaderViewController.m
//  iMobey
//
//  Created by Olivier Demolliens on 09/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "HeaderViewController.h"

//Multitargets Manager
#import "CoreMultiTargetManager.h"
#import "FZTargetManager.h"
#import "FZPortraitNavigationController.h"


//SubController
// TODO: need refactor
//#import "AccountBannerViewController.h"

//ColorHelper
#import "ColorHelper.h"

@class AccountBannerViewController;

//Deal Success
//#import "ActionSuccessfulViewController.h"
@class ActionSuccessfulViewController;
//#import "ActionSuccessfulAfterPaymentViewController.h"
@class ActionSuccessfulAfterPaymentViewController;

@protocol ActionSuccessfulViewControllerDelegate;
@protocol ActionSuccessfulAfterPaymentViewControllerDelegate;


//Device util
#import "ODDeviceUtil.h"

//CustomNavigationViewController
#import "CustomNavigationViewController.h"

//Color
#import "FZUIColorCreateMethods.h"

//CustomTabBarViewController
#import "CustomTabBarViewController.h"

//User session
#import <FZAPI/UserSession.h>


//Controller
#import "AccountBannerViewControllerBB.h"
#import "ActionSuccessfulAfterPaymentViewControllerBB.h"

#import <objc/message.h>

@class AutoCloseWindow;

@interface HeaderViewController () <CustomNavigationViewControllerAction>

//Model
@property (retain, nonatomic) NSMutableArray *customChildControllers;

@end

@implementation HeaderViewController
@synthesize titleHeader;
@synthesize backgroundColor;
@synthesize titleColor;
@synthesize customNavigationController;

#pragma mark - View Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    _customChildControllers = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - SubController Management

-(void)addChildViewController:(UIViewController *)childController
{
    if(![childController isKindOfClass:[AccountBannerViewControllerBB class]]){
        [_customChildControllers addObject:childController];
    }
    [super addChildViewController:childController];
}

#pragma presentation method - push

-(void)pushFromRootControllerWithCustomHeaderController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated
{
    // TODO : refactor seem's done on it
    /*CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller
     andMode:mode];
     [navigController setManageViewCycleLife:NO];
     [self pushFromRootController:navigController animated:animated];*/
}

-(void)pushFromRootControllerWithCustomHeaderControllerAndNoManage:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated
{
    // TODO : refactor seem's done on it
    /* CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:mode];
     
     [navigController setManageViewCycleLife:NO];
     
     [self pushFromRootController:navigController animated:animated];*/
}

-(void)pushFromSideViewControllerWithCustomHeaderController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated
{
    // TODO : refactor seem's done on it
    /*CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:mode];
     
     [self pushFromSideViewController:navigController animated:animated];*/
}

-(void)pushFromRootController:(UIViewController*)controller  animated:(BOOL)animated
{
    // TODO : refactor seem's done on it
    /*NSMutableArray *array = [NSMutableArray arrayWithArray:[self childRootController]];
     
     [array addObject:controller];
     
     [[self rootNavigController] setViewControllers:array animated:animated];*/
}

- (void)popFromRootViewController {
    // TODO : refactor seem's done on it
    // [[self rootNavigController] popViewControllerAnimated:NO];
}

-(void)pushFromSideViewController:(UIViewController*)controller animated:(BOOL)animated
{
    // TODO : refactor seem's done on it
    /* NSMutableArray *array = [NSMutableArray arrayWithArray:[self childRootController]];
     
     [array addObject:controller];
     
     [[[self revealSideViewController]navigationController] setViewControllers:array animated:animated];*/
}

-(void)pushFromCustomNavigationControllerWithCustomHeaderController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated;
{
    // TODO : refactor seem's done on it
    /* CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller
     andMode:mode];
     
     [[self customNavigationController] pushViewController:navigController
     animated:YES];*/
}

#pragma presentation method - present

-(void)presentControllerWithNavigationController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode
{
    // TODO : refactor seem's done on it
    /* CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller
     andMode:CustomNavigationModeClose];
     
     FZPortraitNavigationController *navigationController = [[FZPortraitNavigationController alloc]initWithRootViewController:navigController];
     
     navigationController.navigationBarHidden = YES;
     
     [controller setCustomNavigationController:navigationController];
     
     [self presentController:navigationController];
     
     [navigationController release];*/
}


-(void)presentController:(UIViewController*)controller
{
    // TODO : refactor seem's done on it
    // [[self revealSideViewController] presentViewController:controller animated:YES completion:^{}];
}

#pragma mark dismiss method

-(void)dismissController
{
    /* UIViewController *controller = [[self revealSideViewController] presentedViewController];
     
     if([controller isKindOfClass:[FZPortraitNavigationController class]]) {
     FZPortraitNavigationController *navigationController = (FZPortraitNavigationController *)controller;
     
     NSArray *viewControllers = [navigationController viewControllers];
     
     if([viewControllers count]>0) {
     UIViewController *firstController = [viewControllers objectAtIndex:0];
     
     if([firstController isKindOfClass:[CustomNavigationViewController class]]) {
     CustomNavigationViewController *custom = (CustomNavigationViewController *)firstController;
     
     HeaderViewController *headerViewController = [custom controller];
     
     //We need to release the parent customNavigationController to break the retain cycle
     [headerViewController setCustomNavigationController:nil];
     }
     }
     }
     
     if([[FZTargetManager sharedInstance]mainTarget]==FZBankSDKTarget){
     [[self revealSideViewController] dismissViewControllerAnimated:NO
     completion:nil];
     }else{
     [[self revealSideViewController] dismissViewControllerAnimated:YES
     completion:nil];
     }*/
    
}

-(void)dismissControllerWithCustomNavigationController
{
    //[[self customNavigationController] dismissViewControllerAnimated:YES
    // completion:^{}];
    
    //We need to release the parent customNavigationController to break the retain cycle
    // [self setCustomNavigationController:nil];
}



-(void)back
{
    /* NSMutableArray *array = [NSMutableArray arrayWithArray:[self childRootController]];
     
     if ([array count]>1) {
     [array removeLastObject];
     }
     
     [[self rootNavigController] setViewControllers:array animated:YES];*/
}

-(void)backToRootWithAnimation:(BOOL)animated
{
    /*UIViewController *rootController = [self rootController];
     
     [[self rootNavigController] setViewControllers:[NSArray arrayWithObject:rootController] animated:animated];*/
}

#pragma mark Deal Success method

-(void) presentActionViewControllerWithTitle:(NSString*)title andBackgroundColor:(UIColor *)aBackgroundColor andArrowImage:(UIImage *)image andDelegate:(UIViewController*)delegate withCorrectiveDelta:(CGFloat)delta {
    [self presentActionViewControllerWithTitle:title andBackgroundColor:aBackgroundColor andArrowImage:image andDelegate:delegate withCorrectiveDelta:delta andError:nil];
}

-(void) presentActionViewControllerWithTitle:(NSString*)title andBackgroundColor:(UIColor *)aBackgroundColor andArrowImage:(UIImage *)image andDelegate:(UIViewController*)delegate withCorrectiveDelta:(CGFloat)delta andError:(Error *) anError {
    ActionSuccessfulViewController *validateViewController = [[self multiTargetManager]actionSuccessfullViewControllerWithTitle:title backgroundColor:aBackgroundColor arrowImage:image andError:anError];
    
    [validateViewController setDelegate:(id<ActionSuccessfulViewControllerDelegate>)delegate];
    
    [[self view] setUserInteractionEnabled:NO];
    
    [self presentActionViewController:(UIViewController *)validateViewController withCorrectiveDelta:delta andNavigationController:(UINavigationController *)self];
}

-(void) presentActionViewControllerWithTitle:(NSString*)titleView andBackgroundColor:(UIColor *)aBackgroundColor andBackgroundImageName:(NSString*)bgdImageName inBundleName:(FZBundleName)aBundleName andArrowImage:(UIImage*) aImage andDelegate:(UIViewController*)delegate withCorrectiveDelta:(CGFloat)delta
{
    
    ActionSuccessfulViewController *validateViewController = [[self multiTargetManager]actionSuccessfullViewControllerWithTitle:titleView backgroundColor:aBackgroundColor arrowImage:aImage andBackgroundImage:bgdImageName inBundleName:aBundleName];
    
    [validateViewController setDelegate:(id<ActionSuccessfulViewControllerDelegate>)delegate];
    
    
    [[self view] setUserInteractionEnabled:NO];
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        [self presentActionViewController:(UIViewController *)validateViewController withCorrectiveDelta:delta andNavigationController:self.parentViewController.navigationController];
    }
    else{
        [self presentActionViewController:(UIViewController *)validateViewController withCorrectiveDelta:delta andNavigationController:(UINavigationController *)self];
    }
}

-(void) presentActionViewControllerWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon andDelegate:(UIViewController*)delegate
{
    ActionSuccessfulAfterPaymentViewController *validateViewController = [[self multiTargetManager] actionSuccessFulAfterWithPaymentNbOfGeneratedPoints:nbOfGeneratedPoints nbOfPointsToGenerateACoupon:nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:nbOfPointsOnTheLoyaltyCard amountOfACoupon:amountOfACoupon];
    
    [validateViewController setDelegate:(id<ActionSuccessfulAfterPaymentViewControllerDelegate>)delegate];
    
    [[self view] setUserInteractionEnabled:NO];
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        [self presentActionViewController:(UIViewController *)validateViewController withCorrectiveDelta:0.0 andNavigationController:self.parentViewController.navigationController];
    }
    else{
        [self presentActionViewController:(UIViewController *)validateViewController withCorrectiveDelta:0.0 andNavigationController:(UINavigationController *)self];
    }
}

-(void) presentActionViewControllerWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon andDelegate:(UIViewController*)delegate andCustomArrow:(NSString *)customArrow
{
    
    ActionSuccessfulAfterPaymentViewControllerBB *validateViewController = (ActionSuccessfulAfterPaymentViewControllerBB*)[[self multiTargetManager] actionSuccessFulAfterWithPaymentNbOfGeneratedPoints:nbOfGeneratedPoints nbOfPointsToGenerateACoupon:nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:nbOfPointsOnTheLoyaltyCard amountOfACoupon:amountOfACoupon];
    
    [validateViewController setDelegate:(id<ActionSuccessfulAfterPaymentViewControllerDelegate>)delegate];
    [validateViewController customArrow:customArrow];
    
    [[self view] setUserInteractionEnabled:NO];
    
    [self presentActionViewController:(UIViewController *)validateViewController withCorrectiveDelta:0.0 andNavigationController:(UINavigationController *)self];
}

-(void) presentPopupViewController: (UIViewController *) aViewController
{
    
    UIView *view = aViewController.view;
    UIView *subview = [[aViewController.view subviews]objectAtIndex:0];
    
    //TODO: refactor iPhone 6
    
    if ([ODDeviceUtil isAnIphoneFive]) {
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 568+1)];
        [subview setFrame:CGRectMake(0, 70, view.frame.size.width, 440)];
    } else {
        [subview setFrame:CGRectMake(0, 92, view.frame.size.width, 320)];
    }
    [self.view addSubview:view];
    
    [self addChildViewController:aViewController];
    
    //TODO: refactor iPhone 6
    
    view.center = CGPointMake(160, 800);
    
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        //TODO: refactor iPhone 6
        
        if ([ODDeviceUtil isAnIphoneFive]) {
            view.center = CGPointMake(160, [[self view] center].y-[[[self customNavigationController] navigationBar] frame].size.height+1-48);
        }else{
            view.center = CGPointMake(160, [[self view] center].y-[[[self customNavigationController] navigationBar] frame].size.height+1-30);
        }
        
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled=YES;
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        
        UIColor *blackColor = [[ColorHelper sharedInstance] blackColor];
        
        [view setBackgroundColor:[blackColor colorWithAlphaComponent:0.7f]];
        [UIView commitAnimations];
    }];
}

-(void) presentActionViewController: (UIViewController *) aViewController withCorrectiveDelta:(CGFloat)delta andNavigationController:(UINavigationController *) navController
{
    
    UIViewController* rootViewController = self;
    
    /*if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget || navController == nil){
     rootViewController =  [[navController viewControllers] objectAtIndex:0];
     } else {
     rootViewController = self;
     }
     */
    UIView *view = aViewController.view;
    
    [rootViewController.view addSubview:view];
    [view setFrame:[[[rootViewController parentViewController] view] bounds]];
    
    [rootViewController addChildViewController:aViewController];
    
    //TODO: refactor iPhone 6
    
    view.center = CGPointMake(160, 800);
    
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        //TODO: refactor iPhone 6
        
        
        
        if ([ODDeviceUtil isAnIphoneFive]) {
            
            
            if ([self manageHotspotStatusBar]) {
                view.center = CGPointMake(160, [[rootViewController view] center].y-([[[rootViewController parentViewController] view] center].y-[[rootViewController view] center].y) + 20.0);
            } else {
                view.center = CGPointMake(160, [[rootViewController view] center].y-([[[rootViewController parentViewController] view] center].y-[[rootViewController view] center].y));
            }
            
        }else{
            
            if ([self manageHotspotStatusBar]) {
                view.center = CGPointMake(160, [[rootViewController view] center].y-([[[rootViewController parentViewController] view] center].y-[[rootViewController view] center].y)-delta + 20.0);
            } else {
                view.center = CGPointMake(160, [[rootViewController view] center].y-([[[rootViewController parentViewController] view] center].y-[[rootViewController view] center].y)-delta);
            }
        }
        
    } completion:^(BOOL finished) {
        rootViewController.view.userInteractionEnabled=YES;
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        
        UIColor *blackColor = [[ColorHelper sharedInstance] blackColorWithAlpha:0.7f];
        
        [view setBackgroundColor:blackColor];
        [UIView commitAnimations];
    }];
}

- (BOOL)manageHotspotStatusBar {
    if([[UIApplication sharedApplication] statusBarFrame].size.height > 20.0) {
        //NSLog(@"Hotspot is running");
        return YES;
    } else {
        //NSLog(@"Hotspot is not running");
        return NO;
    }
}

-(void) dismissActionViewController:(UIViewController *)aViewController{
    UIView *view = aViewController.view;
    
    //TODO: refactor iPhone 6
    
    if ([ODDeviceUtil isAnIphoneFive]) {
        view.center = CGPointMake(160, 231);
    }else{
        view.center = CGPointMake(160, 180);
    }
    
    [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        //TODO: refactor iPhone 6
        view.center = CGPointMake(160, 800);
    } completion:^(BOOL finished) {
        
    }];
}

-(void) dismissActionViewController:(UIViewController *)aViewController andPopToRootViewControllerAnimated:(BOOL)animated{
    UIView *view = aViewController.view;
    
    //TODO: refactor iPhone 6
    
    if ([ODDeviceUtil isAnIphoneFive]) {
        view.center = CGPointMake(160, 231);
    }else{
        view.center = CGPointMake(160, 180);
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        //TODO: refactor iPhone 6
        view.center = CGPointMake(160, 800);
    } completion:^(BOOL finished) {
        [self backToRootWithAnimation:animated];
    }];
    
}

#pragma mark Util

-(PPRevealSideViewController *)revealSideViewController
{
    /* if([[[FZTargetManager sharedInstance] delegate] respondsToSelector:@selector(ppRevealSideViewController)]) {
     return /*[[[FZTargetManager sharedInstance] delegate] ppRevealSideViewController];
     }
     
     if ([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
     return (PPRevealSideViewController*)self;
     }*/
    
    // TODO: broken
    return nil;
}

-(UINavigationController*)navigationRoot
{
    if([[UserSession currentSession]isUserAccessToMenu]){
        return [[[FZTargetManager sharedInstance] delegate] navigationController];
        
    }else{
        return nil;
    }
}

-(UINavigationController*)rootNavigController
{
    /*if([[UserSession currentSession]isUserAccessToMenu]){
     return (UINavigationController *)[[[[FZTargetManager sharedInstance] delegate] ppRevealSideViewController] rootViewController];
     
     }else{*/
    return nil;
    //}
}

-(UIViewController*)rootController
{
    return [[self childRootController]objectAtIndex:0];
}

-(NSArray*)childRootController
{
    
    /*if([[UserSession currentSession]isUserAccessToMenu]){
     return [[[[[FZTargetManager sharedInstance] delegate] ppRevealSideViewController] rootViewController] childViewControllers];
     }else{
     return nil;
     }*/
    return nil;
}

#pragma mark - Close button methods

- (void)hideCloseButton {
    // [[(CustomNavigationViewController *)[[self customNavigationController] topViewController] navigController] hideCloseButton];
}

- (void)showCloseButton {
    // [[(CustomNavigationViewController *)[[self customNavigationController] topViewController] navigController] showCloseButton];
}

- (BOOL)isCustomTabBarViewControllerVisible {
    
    /*if([self rootNavigController]==nil){
     return NO;
     }
     
     UIViewController *lastViewControllerDisplayed = [[[self rootNavigController] viewControllers] lastObject];
     
     return [lastViewControllerDisplayed isKindOfClass:[CustomTabBarViewController class]];*/
    return YES;
}

- (BOOL)isPaymentViewControllerVisible {
    
    /*if ([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget  || [[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
     return YES;
     } else {
     
     BOOL isUserKeyStored = ([[[UserSession currentSession] userKey] length]>0);
     
     if([self isCustomTabBarViewControllerVisible] && isUserKeyStored) {
     UIViewController *lastViewControllerDisplayed = [[[self rootNavigController] viewControllers] lastObject];
     
     return [(CustomTabBarViewController *)lastViewControllerDisplayed currentSelectedIndex]==indexButtonPayment;
     }
     
     return NO;
     }*/
    return YES;
}

#pragma mark - CustomNavigationHeaderViewControllerAction

- (void)didClose:(CustomNavigationHeaderViewController *)controller {
    [self leave3DSProcess];
}

- (void)didGoBack:(CustomNavigationHeaderViewController *)controller {
    [self leave3DSProcess];
}

- (void)leave3DSProcess {
    if([[UserSession currentSession] isThreeDSRunning]) {
        [[UserSession currentSession] setThreeDSRunning:NO];
        
        objc_msgSend(NSClassFromString(@"AutoCloseWindow"),NSSelectorFromString(@"stopCloseTimer3DSSession"));
        
    }
}

#pragma mark MM

- (void)dealloc
{
    if (_customChildControllers) {
        [_customChildControllers removeAllObjects];
        [_customChildControllers release], _customChildControllers = nil;
    }
    
    if (customNavigationController) {
        [customNavigationController release], customNavigationController = nil;
    }
    
    if (backgroundColor) {
        [backgroundColor release], backgroundColor = nil;
    }
    
    if (titleColor) {
        [titleColor release], titleColor = nil;
    }
    
    if (titleHeader) {
        [titleHeader release], titleHeader = nil;
    }
    
    [super dealloc];
}

@end
