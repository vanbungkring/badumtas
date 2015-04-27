//
//  GenericViewController.m
//  iMobey
//
//  Created by Yvan Moté on 30/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "GenericViewController.h"

//BundleHelper
#import "BundleHelper.h"

//MultiTargets
#import "FZDefaultMultiTargetManager.h"
#import "FZTargetManager.h"

#import "FZMBProgressHUD.h"

//AlertView
#import "ODCustomAlertView.h"

//Localization
#import "LocalizationHelper.h"

//Error
#import <FZAPI/Error.h>
#import <FZAPI/UserSession.h>

//Menu
#import "SWRevealViewController.h"



int const kAlertViewError = 1042;

@interface GenericViewController () {
    
}

@property(retain,nonatomic)UIView *waitingView;

@property(retain,nonatomic)FZMBProgressHUD *hud;

//prevent the multiple displaying of error messages. Display only the first. (particulary for bug https://flashiz.atlassian.net/browse/IOS-580 point 5)
@property (assign,nonatomic)BOOL errorMessageIsAlreadyDisplayed;

@end

@implementation GenericViewController


#pragma mark - init method

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    // BY default : YES
    
    [self setCanDisplayMenu:YES];
    NSString *currentNibName = nibNameOrNil;
    
    NSString *controllerName = nibNameOrNil;
    
    // TODO : workaround Leclerc
    currentNibName = [controllerName stringByReplacingOccurrencesOfString:@"Leclerc" withString:@""];
    
    BOOL isNibNameAvailableInCoreUIBundle = [[BundleHelper sharedInstance]isNibResourceExistInMainBundle:currentNibName];
    
    NSBundle *bundle = nibBundleOrNil;
    
    if(isNibNameAvailableInCoreUIBundle) {
        bundle = [[BundleHelper sharedInstance]bundle];
    }
    
    self = [super initWithNibName:currentNibName bundle:bundle];
    
    /*if(nil!=self) {
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(applicationDidEnterBackground)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
     
     [[UserSession currentSession] addObserver:self
     forKeyPath:@"connected"
     options:NSKeyValueObservingOptionNew
     context:nil];
     
     [self setErrorMessageIsAlreadyDisplayed:NO];
     }*/
    
    return self;
}

-(void)addMenuGesture
{
    if([[[FZTargetManager sharedInstance]facade]isMenuAvailable]){
        
        SWRevealViewController *revealController = [[[FZTargetManager sharedInstance]facade]revealController];
        
        [self.view addGestureRecognizer:[revealController panGestureRecognizer]];
        
    }else{
        
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self canDisplayMenu] && self.view.gestureRecognizers.count==0){
        [self addMenuGesture];
    }
}

#pragma mark Display methods

- (UIAlertView *)displayAlertForError:(Error *)error{
    return [self displayAlertForError:error completion:nil];
}

- (UIAlertView *)displayAlertForError:(Error *)error completion:(GenericViewControllerCompletionBlock)completion {
    
    NSString *title = [LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment];
    
    NSString *cancelButtonTitle = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
    
    
    //NSLog(@"message:%@",[error localizedError]);
    //NSLog(@"message:%li",(long)[error errorRequest]);
    
    ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title
                                                                    message:[error localizedError]
                                                                   delegate:self
                                                          cancelButtonTitle:cancelButtonTitle
                                                          otherButtonTitles:nil];
    [alertView setTag:kAlertViewError];
    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
    
    if(!_errorMessageIsAlreadyDisplayed){
        
        [self setErrorMessageIsAlreadyDisplayed:YES];
        
        [alertView showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                
                [self setErrorMessageIsAlreadyDisplayed:NO];
                
                if(nil != completion){
                    completion();
                }
            }
        }];
    }
    
    return [alertView autorelease];
}

- (void)showForUserNotConnectedWaitingViewWithMessage:(NSString *)message {
    [self showWaitingViewWithMessage:message
                    inViewController:nil];
}

- (void)showWaitingViewWithMessage:(NSString *)message {
    if([[UserSession currentSession] isUserConnected]) {
        [self showWaitingViewWithMessage:message
                        inViewController:nil];
    }
}

- (void)showWaitingViewWithMessage:(NSString *)message
                  inViewController:(UIViewController *)viewController {
    
    UIView *viewForWaitingView = nil;
    
    if(nil!=viewController) {
        viewForWaitingView = [viewController view];
    } else {
        viewForWaitingView = [self view];
    }
    
    CGRect viewBounds = [viewForWaitingView bounds];
    
    [_waitingView removeFromSuperview];
    [_waitingView release];
    _waitingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewBounds.size.width, viewBounds.size.height+50)];
    [_waitingView setAlpha:0.4];
    [_waitingView setBackgroundColor:[UIColor darkGrayColor]];
    
    [viewForWaitingView addSubview:_waitingView];
    
    [_hud removeFromSuperview];
    [_hud release];
    _hud = nil;
    
    if([[[UIApplication sharedApplication] windows] count]>0){
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        _hud= [[FZMBProgressHUD alloc] initWithWindow:window];
        [_hud setDetailsLabelText:message];
        [window addSubview:_hud];
        [_hud show:YES];
    }
}

- (void)hideWaitingView {
    [_hud hide:YES];
    [_hud removeFromSuperview];
    [_hud release];
    _hud = nil;
    
    [_waitingView removeFromSuperview];
    [_waitingView release];
    _waitingView = nil;
}

- (FZDefaultMultiTargetManager *)multiTargetManager {
    return [[FZTargetManager sharedInstance] multiTarget];
}

#pragma mark - Observing methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"connected"]) {
        BOOL isConnected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if(!isConnected) {
            [self hideWaitingView];
        }
    }
}

- (void)applicationDidEnterBackground {
    [self hideWaitingView];
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

#pragma mark - MM

- (void)dealloc {
    
    NSLog(@"Dealloc:%@",self);
    
    /* [[NSNotificationCenter defaultCenter] removeObserver:self
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
     
     [[UserSession currentSession] removeObserver:self forKeyPath:@"connected"];*/
    
    [self hideWaitingView];
    
    [super dealloc];
}

@end