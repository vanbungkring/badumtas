//
//  AutoCloseWindow.m
//  iMobey
//
//  Created by Olivier Demolliens on 04/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "AutoCloseWindow.h"

//Session
#import <FZAPI/UserSession.h>

//Controller
#import <FZPayment/PinViewController.h>

//Delegate
//#import "BaseAppDelegate.h"

//Service
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/InvoiceServices.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//ApplicationLogging
//#import "ApplicationLogging.h"

#import <FZBlackBox/UtilNavigation.h>

//Helper
#import <FZBlackBox/LocalizationHelper.h>

//UrlSchemeManager
#import <FZBlackBox/FZUrlSchemeManager.h>

//Error
#import <FZAPI/Error.h>

//Targetmanager
#import <FZBlackBox/FZTargetManager.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

#define kSessionTime 5

@interface AutoCloseWindow()
{
    
}


@property(nonatomic,assign)NSTimer *timer;
@property(nonatomic,assign)NSTimer *timer3DSSession;

@property(nonatomic,retain)PinViewController *pinViewController;

@property (assign, nonatomic) int counter;

@end

@implementation AutoCloseWindow
{
    
}

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
            
            FZPaymentLog(@"No card in creation => AutoCloseWindow->startTimer");
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
    
    if ([user userKey] != nil && ![[user userKey]isEqualToString:@""]) {
        [self startTimer];
    }else{
        [self stopTimer];
    }
    
    [super sendEvent:event];
}

-(void)startTimer
{
	if ([[UserSession currentSession] userKey] != nil && ![[[UserSession currentSession] userKey ]isEqualToString:@""]) {
		[self stopTimer];
		NSLog(@"startTimer");
		
		[self setTimer:[[NSTimer timerWithTimeInterval:[[UserSession currentSession] timeout]*60
												target:self
											  selector:@selector(showPinCodeController)
											  userInfo:nil
											   repeats:NO] retain]];
		
		[[NSRunLoop mainRunLoop] addTimer:[self timer] forMode:NSDefaultRunLoopMode];
	}
}

-(void)stopTimer
{
		NSLog(@"stopTimer");
		[[self timer] invalidate];
		[[self timer] release];
		_timer = nil;
}

-(void)startTimer3DSSession
{
    if ([[UserSession currentSession] userKey] != nil && ![[[UserSession currentSession] userKey ]isEqualToString:@""]) {
        if (_timer3DSSession) {
            [_timer3DSSession invalidate];
            [_timer3DSSession release];
            _timer3DSSession = nil;
        }
        
        _timer3DSSession = [[NSTimer scheduledTimerWithTimeInterval:kSessionTime*60/*5 min*/
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
		
	if(![[self topMostController] isMemberOfClass:[PinViewController class]]){
		
		NSLog(@"showPincodeController before after timer");
		
		if([[UserSession currentSession] isThreeDSRunning]){
			//[[UserSession currentSession] setThreeDSRunning:NO];
			return;
		} else {
			[self stopTimer3DSSession];
		}
		
		if([[UserSession currentSession] isCardCreationInProgress]) {
			return;
		}
		
		if (!_present) {
			PinCompletionBlock pinCompletionBlock = ^(NSString *pinCode) {
				NSString *userKey = [[UserSession currentSession] userKey];
				
				[_pinViewController showForUserNotConnectedWaitingViewWithMessage:[LocalizationHelper stringForKey:@"loading" withComment:@"PinViewController"  inDefaultBundle:FZBundlePayment]];
				[[StatisticsFactory sharedInstance] checkPointConnectPincode];
				[ConnectionServices connectWithKey:userKey
											andPin:pinCode
									  successBlock:^(id context) {
										  
										  [[UserSession currentSession] setConnected:YES];
										  
										  //set valid urls
										  if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
#warning TODO: get url list from the indonesian server
											  NSMutableArray *urlList = [[NSMutableArray alloc] init];
											  [urlList addObject:@"http://www.flashiz.com/fr/infos/"];
											  [urlList addObject:@"http://www.flashiz.com/en/infos/"];
											  [urlList addObject:@"http://www.flashiz.com/es/infos/"];
											  [urlList addObject:@"http://www.flashiz.com/de/infos/"];
											  [urlList addObject:@"http://www.flashiz.com/nl/infos/"];
											  [[UserSession currentSession] setValidUrls:urlList];
											  [urlList release];
										  } else {
											  [InvoiceServices urlListSuccessBlock:^(id context) {
												  [[UserSession currentSession] setValidUrls:context];
											  } failureBlock:^(Error *error) {
												  ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"Global" inDefaultBundle:FZBundlePayment]
																												  message:[error localizedError]
																												 delegate:nil
																										cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
																										otherButtonTitles:nil];
												  [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
												  [alertView show];
												  [alertView release];
											  }];
										  }
										  
										  [_pinViewController hideWaitingView];
										  
										  if([[[[FZTargetManager sharedInstance] facade] ppRevealSideViewController] presentedViewController]==_pinViewController) {
											  
											  [[[UtilNavigation menuViewController]navigationController]popToRootViewControllerAnimated:NO];
											  
											  if([[UtilNavigation menuViewController]lastSelectedController]!=nil){
												  [[UtilNavigation menuViewController] setLastSelectedController:nil];
											  }
											  
											  [_pinViewController dismissViewControllerAnimated:YES completion:nil];
										  }
										  else {
											  [_pinViewController.view removeFromSuperview];
										  }
										  [[UtilNavigation tabBarController] forceRiddles];
										  [_pinViewController release];
										  _pinViewController = nil;
										  _present = NO;
										  [self startTimer];
										  
										  if([[UserSession currentSession] isLinkWithFlashizProcess]){
											  [FZUrlSchemeManager backToTheHostApplicationWithUserkey:userKey];
											  
											  [[UserSession currentSession] setConnected:NO];
											  
											  [[UserSession currentSession] setLinkWithFlashiz:NO];
										  }
										  
									  } failureBlock:^(Error *error) {
										  if ([(Error *)error errorCode] == FZ_NO_INTERNET_CONNECTION) {
											  
											  
											  
											  ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
																											  message:[error localizedError]
																											 delegate:nil
																									cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
																									otherButtonTitles:nil];
											  [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
											  [alertView show];
											  [alertView release];
											  
											  //By default we reset the pin code
											  [_pinViewController setWrongPinCode:[_pinViewController wrongPinCode]-1]; //internet connection lost is not concidered has a wrong pin code
											  [_pinViewController resetPinCode];
											  [_pinViewController hideWaitingView];
											  
										  } else if([_pinViewController wrongPinCode] > 1){
											  [_pinViewController forceClose];
											  [_pinViewController hideWaitingView];
										  } else {
											  ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"pinViewController_error_pincode_alert_title" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment]
																											  message:[NSString stringWithFormat:[LocalizationHelper stringForKey:@"pinViewController_error_pincode_alert_message" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment],2 - [_pinViewController wrongPinCode]]
																											 delegate:nil
																									cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
																									otherButtonTitles:nil];
											  [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
											  [alertView show];
											  [alertView release];
											  
											  //By default we reset the pin code
											  [_pinViewController resetPinCode];
											  [_pinViewController hideWaitingView];
										  }
									  }];
			};
			
			[_pinViewController release];
			_pinViewController = [[[[FZTargetManager sharedInstance] multiTarget] pinViewControllerWithCompletionBlock:pinCompletionBlock navigationTitle:[LocalizationHelper stringForKey:@"?" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] title:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] titleHeader:@"" description:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_enter" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] animated:NO modeSmall:NO] retain];
			
			[_pinViewController setShowCloseButton:YES];
			
			[_pinViewController setFromWindow:YES];
			
			if([[self rootViewController] presentedViewController]==nil) {
				
				if([self rootViewController]){
					
					[[self rootViewController] presentViewController:_pinViewController
															animated:YES
														  completion:^(void){
															  [_pinViewController setupBackButton];
														  }];
				} else {
					[[[[FZTargetManager sharedInstance] facade] ppRevealSideViewController] presentViewController:_pinViewController
																										 animated:YES
																									   completion:^(void){
																										   [_pinViewController setupBackButton];
																									   }];
					
				}
			}
			else {
				[_pinViewController.view setFrame:CGRectMake(0, +20, _pinViewController.view.frame.size.width, _pinViewController.view.frame.size.height)];
				[self addSubview:_pinViewController.view];
			}
			
			_present = YES;
		}
	}
}

- (void)hidePinCodeController {
    if([_pinViewController presentingViewController]==[self rootViewController]) {
        [_pinViewController dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        [[_pinViewController view] removeFromSuperview];
    }
	
    [_pinViewController release];
    _pinViewController = nil;
}

-(PPRevealSideViewController*)revealSideViewController
{
    return [[[UIApplication sharedApplication] delegate]ppRevealSideViewController];
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
