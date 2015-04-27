//
//  AutoCloseWindow.m
//  FZBlackBox
//
//  Created by Matthieu Barile on 19/09/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "AutoCloseWindow.h"

//Session
#import <FZAPI/UserSession.h>

//Controller
#import "PinViewController.h"

//Delegate
//#import "BaseAppDelegate.h"

//Service
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/InvoiceServices.h>

//AlertView
#import "ODCustomAlertView.h"

//Helper
#import "LocalizationHelper.h"

//UrlSchemeManager
#import "FZUrlSchemeManager.h"

//Error
#import <FZAPI/Error.h>

//Targetmanager
#import "FZTargetManager.h"

//Tracker
#import "StatisticsFactory.h"

#define kSessionTime 5

@interface AutoCloseWindow()

@property (nonatomic,assign) NSTimer *timer;
@property (nonatomic,assign) NSTimer *timer3DSSession;

@property (nonatomic,retain) PinViewController *pinViewController;

@property (nonatomic,assign) int counter;

@property (nonatomic, assign) BOOL present;

@end

@implementation AutoCloseWindow

+(void)startCloseTimer
{
    // TODO : need cast refactor
    [[[[UIApplication sharedApplication] delegate]window]startTimer];
}

+(void)stopCloseTimer
{
    // TODO : need cast refactor
    [[[[UIApplication sharedApplication] delegate]window]stopTimer];
}

+(void)startCloseTimer3DSSession
{
    // TODO : need cast refactor
    [[[[UIApplication sharedApplication] delegate]window]startTimer3DSSession];
}

+(void)stopCloseTimer3DSSession
{
    // TODO : need cast refactor
    [[[[UIApplication sharedApplication] delegate]window]stopTimer3DSSession];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self startObservingUserSession];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self startObservingUserSession];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self startObservingUserSession];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingUserSession];
    [super dealloc];
}

#pragma mark - Private methods

- (void)startObservingUserSession {
    UserSession *userSession = [UserSession currentSession];
    
    [userSession addObserver:self
                  forKeyPath:@"timeout"
                     options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                     context:nil];
    
    [userSession addObserver:self
                  forKeyPath:@"cardCreationInProgress"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
}

- (void)stopObservingUserSession {
    UserSession *userSession = [UserSession currentSession];
    
    [userSession removeObserver:self forKeyPath:@"timeout"];
    [userSession removeObserver:self forKeyPath:@"cardCreationInProgress"];
}

-(UserSession*)currentUserSession {
    return [UserSession currentSession];
}

#pragma mark - Observing method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"cardCreationInProgress"]) {
        BOOL isCardCreationInProgress = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if(!isCardCreationInProgress) {
            //No card creation in progress so we can re-enable the timer
            
            FZBlackBoxLog(@"No card in creation => AutoCloseWindow->startTimer");
            [self startTimer];
        }
    }
    else if([keyPath isEqualToString:@"timeout"]) {
        [self startTimer];
    }
    else {
        //Nothing to do
    }
}

#pragma mark - Intercept Methods

- (void)sendEvent:(UIEvent *)event
{
    UserSession *user = [self currentUserSession];
    
    if ([user userKey] != nil && ![[user userKey]isEqualToString:@""] && [user isUserConnected]) {
        [self startTimer];
    }else{
        [self stopTimer];
    }
    
    [super sendEvent:event];
}

-(void)startTimer
{
    UserSession *user = [self currentUserSession];
    
    if ([user userKey] != nil && ![[user userKey]isEqualToString:@""] & [user isUserConnected]) {
        [self stopTimer];
        NSLog(@"startTimer");
        
        if(![[self timer] isValid]){
            [self setTimer:[[NSTimer timerWithTimeInterval:[[UserSession currentSession] timeout]*60
                                                    target:self
                                                  selector:@selector(showPinCodeController)
                                                  userInfo:nil
                                                   repeats:NO] retain]];
            
            [[NSRunLoop mainRunLoop] addTimer:[self timer] forMode:NSDefaultRunLoopMode];
        }
    }
}

-(void)stopTimer
{
    if([[self timer] isValid]){
        NSLog(@"stopTimer");
        [[self timer] invalidate];
        [[self timer] release];
        _timer = nil;
    }
}

-(void)startTimer3DSSession
{
    if ([[UserSession currentSession] userKey] != nil && ![[[UserSession currentSession] userKey ]isEqualToString:@""]) {
        if (_timer3DSSession) {
            [_timer3DSSession invalidate];
            [_timer3DSSession release];
            _timer3DSSession = nil;
        }
        
        _timer3DSSession = [[NSTimer scheduledTimerWithTimeInterval:kSessionTime*60//*5 min*/
                                                             target:self
                                                           selector:@selector(leave3DSProcessAndViewController)
                                                           userInfo:nil
                                                            repeats:NO]retain];
    }
}

-(void)stopTimer3DSSession
{
    if (_timer3DSSession) {
        [_timer3DSSession invalidate];
        [_timer3DSSession release];
        _timer3DSSession = nil;
    }
}

#pragma mark - Pin code

-(void)showPinCodeController
{
    
    NSLog(@"showPincodeController before stop timer");
    [self stopTimer];
    [[[FZTargetManager sharedInstance]facade]closeSession];
    
}

- (void)leave3DSProcessAndViewController {
    [[UserSession currentSession] setThreeDSRunning:NO];
    [AutoCloseWindow stopCloseTimer3DSSession];
    
    ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"autoCloseWindow_3ds_session_expired_title" withComment:@"AutoCloseWindow" inDefaultBundle:FZBundleCoreUI]
                                                                    message:[LocalizationHelper stringForKey:@"autoCloseWindow_3ds_session_expired_message" withComment:@"AutoCloseWindow" inDefaultBundle:FZBundleCoreUI]
                                                                   delegate:self
                                                          cancelButtonTitle:[LocalizationHelper stringForKey:@"app_continue" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                          otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
    [alertView show];
    [alertView release];
    
    NSLog(@"leave3DSProcessAndViewController showPinCodeController    !!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    [self showPinCodeController];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

@end
