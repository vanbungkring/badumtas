//
//  FZFlashizFacade.m
//  FZBlackBox
//
//  Created by OlivierDemolliens on 9/23/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "FZFlashizFacade.h"

@class InitialViewController;

//Service
#import <FZAPI/FZAFHTTPClient.h>
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/InvoiceServices.h>

//Stats
#import "StatisticsFactory.h"

//Util
#import "ODCustomAlertView.h"

//Manager
#import "FZTargetManager.h"
#import <FZAPI/CurrenciesManager.h>
#import <FZUrlSchemeManager.h>

//Helper
#import "ImageHelper.h"
#import "FontHelper.h"
#import "LocalizationHelper.h"
#import "BundleHelper.h"
#import "ColorHelper.h"

//Localization
#import "LocalizationHelper.h"

//Template
#import "FZFlashizTemplateFonts.h"
#import "FZFlashizTemplateColor.h"

//Delegate
#import "PaymentViewControllerBB.h"

//User
#import <FZAPI/UserSession.h>

//Controllers
#import "PinViewController.h"
#import "LoginViewController.h"
#import "MainPageLoadingViewController.h"

//Menu
#import "SWRevealViewController.h"

//Navigation
#import "CustomNavigationViewController.h"
#import "CustomTabBarViewController.h"
#import "FZPortraitNavigationController.h"
#import "FZMBProgressHUD.h"

//SDK
#define kDefaultPin @"0000"

@interface FZFlashizFacade()<PinViewControllerDelegate,LoginViewControllerDelegate,PaymentViewControllerDelegate,CustomTabBarViewControllerDelegate>
{
    
}


// TODO : dealloc - memory management
@property(nonatomic,assign) PinViewController *pinViewController;
@property(nonatomic,assign) CustomTabBarViewController *tabBarController;
@property(nonatomic,assign) UINavigationController *tabBarControllerNavigation;
@property(nonatomic,assign) UIViewController *mainController;
@property(nonatomic,retain) SWRevealViewController *revealController;
@property(nonatomic,retain) FZMBProgressHUD *progressHud;


//Utils
@property (nonatomic, assign) BOOL hasReceivedNotification;
@property (nonatomic, retain) NSString *invoiceId;

//SDK
@property (nonatomic, retain) UIViewController *parentViewController;
@property (nonatomic, retain) MainPageLoadingViewController *loadingViewcontroller;
@property (nonatomic, assign) BOOL unknownErrorOccured;

@end

@implementation FZFlashizFacade


#pragma mark  - Constructor

- (id)initAppForBrand:(NSString *)brand withTargetManager:(FZDefaultMultiTargetManager *)manager withDelegate:(id<UIApplicationDelegate>)delegate withColorTemplate:(FZDefaultTemplateColor *)colorTemplate withFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplate {
    
    //Brand partner is not needed for Flashiz
    NSAssert((manager != nil), @"Multi target manager is needed");
    NSAssert((delegate != nil), @"App delegate is needed");
    NSAssert((colorTemplate != nil), @"Colors template is needed");
    NSAssert((fontsTemplate != nil), @"Fonts template is needed");
    
    self = [super init];
    
    if (self) {
        
        [[FZTargetManager sharedInstance] loadAppWithBrandName:brand withTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andApplicationDelegate:delegate andFacade:self];
    }
    
    return self;
}

- (id)initSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme
{
    NSAssert((manager != nil), @"Multi target manager is needed");
    NSAssert((delegate != nil), @"Flashiz facade delegate is needed");
    NSAssert((customerHost != nil), @"Customer host scheme url is needed");
    NSAssert((customerScheme != nil), @"Customer scheme url is needed");
    
    self = [super init];
    if (self) {
        
        [self loadSDKMultiTargetManager:manager withDelegate:delegate configureUrlSchemesWihtCustomerHost:customerHost andCustomerScheme:customerScheme];
        
    }
    return self;
}

- (id)initBankSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate
{
    NSAssert((manager != nil), @"Multi target manager is needed");
    NSAssert((delegate != nil), @"Flashiz facade delegate is needed");
    
    self = [super init];
    if (self) {
        
        [self loadBankSDKMultiTargetManager:manager withDelegate:delegate];
        
    }
    return self;
}

#pragma mark - Delegate

-(id<FlashizFacadeDelegate>)delegate
{
    return (id<FlashizFacadeDelegate>)[[FZTargetManager sharedInstance] delegateSDK];
}

#pragma mark - Loading methods

- (void)loadAppForBrand:(NSString *)brand withTargetManager:(FZDefaultMultiTargetManager *)manager withDelegate:(id<UIApplicationDelegate>)delegate withColorTemplate:(FZDefaultTemplateColor *)colorTemplate withFontsTemplate: (FZDefaultTemplateFonts *)fontsTemplate {
    
    //Init Target Manager
    [[FZTargetManager sharedInstance] loadAppWithBrandName:brand withTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andApplicationDelegate:delegate andFacade:self];
    
}

- (void)loadBankSDKMultiTargetManager:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate {
    
    //Init template
    FZFlashizTemplateColor *colorTemplate = [[FZFlashizTemplateColor alloc] init];
    FZFlashizTemplateFonts *fontsTemplate = [[FZFlashizTemplateFonts alloc] init];
    
    //Init Target Manager
    [[FZTargetManager sharedInstance] loadBankSDKWithTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andDelegate:delegate];
    
    [colorTemplate release];
    [fontsTemplate release];
}

- (void)loadSDKMultiTargetManager:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>)delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme {
    
    //Init template
    FZFlashizTemplateColor *colorTemplate = [[FZFlashizTemplateColor alloc] init];
    FZFlashizTemplateFonts *fontsTemplate = [[FZFlashizTemplateFonts alloc] init];
    
    //Init Target Manager
    [[FZTargetManager sharedInstance] loadSDKWithTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andDelegate:delegate configureUrlSchemesWihtCustomerHost:customerHost andCustomerScheme:customerScheme];
    
    [colorTemplate release];
    [fontsTemplate release];
}

#pragma mark - Present methods in App

- (void) presentFromController:(UINavigationController *)parent inAppWith:(UIViewController *)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated
{
    FZTarget currentTarget = [[FZTargetManager sharedInstance] mainTarget];
    
    NSAssert(currentTarget == FZAppTarget || currentTarget == FZBankSDKTarget, @"FZSDKTarget or FZBankSDKTarget is allowed only");
    
    NSAssert([parent isKindOfClass:[UINavigationController class]]==YES || [parent isKindOfClass:[SWRevealViewController class]]==YES ,@"UINavigationController or SWRevealViewController are only allowed");
    
    CustomNavigationViewController *navigController = [[[FZTargetManager sharedInstance]multiTarget] customNavigationViewControllerWithController:controller andMode:mode];
    
    [parent pushViewController:navigController animated:animated];
}

- (void) goBackToRootAndAnimated:(BOOL)animated
{
    NSAssert([[FZTargetManager sharedInstance]mainTarget] == FZAppTarget,@"FZSDKTarget or FZBankSDKTarget is allowed only");
    
    [_revealController dismissViewControllerAnimated:animated completion:^{}];
    
}

#pragma mark - App methods


- (UIViewController*) appController
{
    NSAssert([[FZTargetManager sharedInstance]mainTarget]==FZAppTarget,@"FZAppTarget is allowed only");
    return _mainController;
}

- (CustomTabBarViewController*) tabBarController
{
    NSAssert([[FZTargetManager sharedInstance]mainTarget]==FZAppTarget,@"FZAppTarget is allowed only");
    return _tabBarController;
}

- (UINavigationController*) tabBarControllerNavigation
{
    NSAssert([[FZTargetManager sharedInstance]mainTarget]==FZAppTarget || [[FZTargetManager sharedInstance]mainTarget]==FZBankSDKTarget,@"FZAppTarget is allowed only");
    return _tabBarControllerNavigation;
}

- (SWRevealViewController*) revealController
{
    return _revealController;
}

- (BOOL) isMenuAvailable
{
    if([[FZTargetManager sharedInstance]mainTarget]==FZAppTarget && [[UserSession currentSession]isUserConnected]){
        return YES;
    }else{
        return NO;
    }
}

-(void)closeSession
{
    UserSession *currentSession = [UserSession currentSession];
    
    if([currentSession isUserConnected] && ![currentSession isThreeDSRunning] && ![currentSession isCardCreationInProgress] && ![currentSession isFlashizLocked]){
        
        //needed in the viewDidAppear of InitialViewController
        InitialViewController *viewControllerInitial = (InitialViewController*)[self appController];
        [viewControllerInitial setLaunch:YES];
        
        //dimiss current controller if we are not on the tabbar
        UINavigationController *subNavCon = (UINavigationController *)[[[[FZTargetManager sharedInstance]facade] tabBarController] presentedViewController];
        if (subNavCon) {
            [subNavCon dismissViewControllerAnimated:NO completion:nil];
        }
        
        UIViewController *subController = [(CustomNavigationViewController *)[[[[FZTargetManager sharedInstance]facade]revealController] presentedViewController] controller];
        if (subController) {
            [subController dismissViewControllerAnimated:NO completion:nil];
        }
        
        // Move to the tabBar
        [[self tabBarControllerNavigation]popToRootViewControllerAnimated:NO];
        
        // Dismiss tabBar displayer
        [[self revealController] dismissViewControllerAnimated:NO completion:nil];
        
        // Reset presented controller
        [[self tabBarControllerNavigation]popToRootViewControllerAnimated:NO];
        
        //kill sub controllers
        [[[self tabBarControllerNavigation]presentedViewController] dismissViewControllerAnimated:NO completion:^{}];
        
        [[[[FZTargetManager sharedInstance]facade]revealController]pushFrontViewController:[self tabBarControllerNavigation] animated:NO];
        
        //Force payment index
        [[self tabBarController]selectTabAtIndex:1];
        
        //If the sdk has engaged the topup process, show the initviewcontroller with lauch to YES so the pin code appears
        if ([[UserSession currentSession] isSdkEngagedTopup]) {
            [[[FZTargetManager sharedInstance] facade] initContextWith:viewControllerInitial];
        }
    }
}

- (void)revealOrHideMenu
{
    NSAssert([[FZTargetManager sharedInstance]mainTarget]==FZAppTarget,@"FZAppTarget is allowed only");
    
    
    if([_revealController frontViewPosition]!=FrontViewPositionRightMost){
        [_revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
    }else{
        [_revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
    }
}


-(void)displayTabBarFrom:(UIViewController*)controller andDismissIt:(BOOL)dismiss animated:(BOOL)animated
{
    NSAssert([[FZTargetManager sharedInstance]mainTarget]==FZAppTarget,@"FZAppTarget is allowed only");
    NSAssert(controller!=nil,@"Controller must be allocated");
    
    if(_revealController==nil){
        
        _tabBarController = [[[[FZTargetManager sharedInstance] multiTarget] customTabBarViewController] retain];
        
        _tabBarControllerNavigation = [[FZPortraitNavigationController alloc] initWithRootViewController:_tabBarController];
        
        _tabBarControllerNavigation.navigationBarHidden = YES;
        
        MenuViewController *menuViewController = (MenuViewController*)[[[FZTargetManager sharedInstance] multiTarget] menuViewController];
        
        [self setRevealController:[[SWRevealViewController alloc]initWithRearViewController:(UIViewController*)menuViewController frontViewController:(UIViewController*)_tabBarControllerNavigation]];
        
        
        //TODO : need to see with Justine
        [_revealController setRearViewRevealWidth:0];
        [_revealController setRearViewRevealOverdraw:240];
        [_revealController setBounceBackOnOverdraw:NO];
        [_revealController setStableDragOnOverdraw:YES];
        [_revealController setBounceBackOnLeftOverdraw:NO];
        [_revealController setFrontViewPosition:FrontViewPositionRight];
        
    }else{
        //Force payment index
        [[self tabBarController]selectTabAtIndex:1];
        
        //Force close menu
        if([_revealController frontViewPosition]==FrontViewPositionRightMost){
            [_revealController setFrontViewPosition:FrontViewPositionRight animated:NO];
        }
    }
    
    if(dismiss){
        //Quick pointer reference
        UIViewController *parentController = [controller presentingViewController];
        
        [controller.presentingViewController dismissViewControllerAnimated:animated completion:^{
            [parentController presentViewController:_revealController animated:animated completion:^{}];
        }];
    }else{
        [controller presentViewController:_revealController animated:animated completion:^{}];
    }
}

/* Init the app with two way
 * When user is logged -> display first, pinCodeViewController
 * When user is not logged -> display first, InitialViewController
 */
- (void)initContextWith:(UIViewController*) controller
{
    _mainController = controller;
    //NSAssert([controller isKindOfClass:[InitialViewController class]], @"Multi target manager is needed");
    
    BOOL isUserKeyStored = ([[[UserSession currentSession] userKey] length]>0);
    
    if(isUserKeyStored) {
        NSLog(@"isUserKeyStored");
        [self displayPinViewControllerOn:controller animated:NO];
    } else {
        NSLog(@"!isUserKeyStored");
    }
}

/*
 * Retrieve the valid urls
 */
- (void)retrieveValidUrls {
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
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle: [LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"Global" inDefaultBundle:FZBundlePayment]
                                                                            message:[error localizedError]
                                                                           delegate:nil
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView show];
            [alertView release];
        }];
    }
}

/*
 * Display the Pin view controller
 */
-(void)displayPinViewControllerOn:(InitialViewController*)controller animated:(BOOL)animated
{
    PinCompletionBlock pinCompletionBlock = ^(NSString *pinCode) {
        
        UserSession *currentSession = [UserSession currentSession];
        
        NSString *userKey = [currentSession userKey];
        
        [[StatisticsFactory sharedInstance] checkPointConnectPincode];
        
        //[_pinViewController ];
        
        [self displayProgressHud];
        
        //Connection with userkey and pincode
        [ConnectionServices connectWithKey:userKey andPin:pinCode successBlock:^(id context) {
            //Retrieve light info
            [ConnectionServices retrieveUserInfosLight:userKey successBlock:^(id context) {
                
                [[CurrenciesManager currentManager] setDefaultCurrency:[[[currentSession user] account] currency]];
                
                [currentSession setUser:context];
                [currentSession setConnected:YES];
                
                // the user is connected so the app/SDK is unlocked
                [currentSession setLocked:NO];
                
                //set valid urls
                [self retrieveValidUrls];
                
                [_pinViewController hideWaitingView];
                
                //check if we are in a LinkWithFlashizProcess
                if([currentSession isLinkWithFlashizProcess]){ //if yes
                    
                    //back to the host application
                    [FZUrlSchemeManager backToTheHostApplicationWithUserkey:userKey];
                    
                    //update the session
                    [currentSession setConnected:NO];
                    [currentSession setLinkWithFlashiz:NO];

                    // the user leave the App so set locked to YES
                    [currentSession setLocked:YES];
                    
                    //reset the pin code for the next connection to the Flashiz App
                    [_pinViewController resetPinCode];
                } else {
                
                    [[[FZTargetManager sharedInstance] facade] displayTabBarFrom:_pinViewController andDismissIt:YES animated:NO];
                
                    [_pinViewController release];
                }

            } failureBlock:^(Error *error) {
                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundlePayment]
                                                                                message:[error localizedError]
                                                                               delegate:nil
                                                                      cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                      otherButtonTitles:nil];
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView show];
                [alertView release];
                
                //By default we reset the pin code
                [_pinViewController resetPinCode];
                [_pinViewController hideWaitingView];
            }];
        } failureBlock:^(Error *error) {
            [self connectWithKeyFailureBlockFromPinViewController:_pinViewController WithError:error delegated:NO];
        }];
    };
    
    _pinViewController  = [[[[FZTargetManager sharedInstance] multiTarget] pinViewControllerWithCompletionBlock:pinCompletionBlock navigationTitle:[LocalizationHelper stringForKey:@"?" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] title:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] titleHeader:@"" description:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_enter" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] animated:NO modeSmall:NO] retain];
    
    [_pinViewController setShowCloseButton:YES];
    
    //Initial controller present Pin View Controller
    [controller presentViewController:_pinViewController animated:animated completion:^{/**/}];
}

#pragma mark - HUD methods

- (void)displayProgressHud {
    [self hideProgressHud];
    
    _progressHud = [[FZMBProgressHUD showHUDAddedTo:[_pinViewController view] animated:YES] retain];
}

- (void)hideProgressHud {
    [_progressHud hide:YES];
    [_progressHud release];
    _progressHud = nil;
}

#pragma mark - PinViewControllerDelegate methods

- (void)pinViewControllerDidClose:(PinViewController *)pinViewController
{
    NSLog(@"close");
}


- (void)pinViewControllerDidBack:(PinViewController *)pinViewController
{
    NSLog(@"back");
}

#pragma mark - Execute payment

/*
 * Execute the payment for the given invoiceID in the given viewController (SDK)
 */
- (void)executePaymentForInvoiceId:(NSString *)invoiceId
            inParentViewController:(UIViewController *)parentViewController {
    
    [[FZTargetManager sharedInstance] setFacade:self];
    
    [self setInvoiceId:invoiceId];
    
    //save the parentViewController for the SDK
    [self setParentViewController:parentViewController];
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
        //Register data and observer in case of "Link with Flashiz account"
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if(_invoiceId) {
            [dict setObject:_invoiceId forKey:@"invoiceId"];
        }
        [dict setObject:parentViewController forKey:@"parentViewController"];
        
        [[FZTargetManager sharedInstance] setCallbackData:dict];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"launchFlashizSDK" object:nil];
    }
    
    //Display a background loading view
    [self displayLoadingViewAndComplete:^{
        
        //display the pin code or the login with email/password view controller
        NSString *userKey = [[UserSession currentSession] retrieveUserKeyFromPrefs];
        
        if([userKey length]==0) {
            [self displayConnectionViewAnimated:YES];
        } else {
            
            __block FZFlashizFacade *weakSelf = self;
            __block PinViewController *aPinViewController = [[PinViewController alloc] initWithCompletionBlock:^(NSString *pinCode) {
                
                [[StatisticsFactory sharedInstance] checkPointConnectPincode];
                
                //Connection with userkey and pincode
                [ConnectionServices connectWithKey:userKey andPin:pinCode successBlock:^(id context) {
                    //Retrieve all info
                    [ConnectionServices retrieveUserInfos:userKey
                                             successBlock:^(id context) {
                                                 
                                                 [[UserSession currentSession] setUser:context];
                                                 [[UserSession currentSession] setConnected:YES];
                                                 
                                                 // the user is connected so the app/SDL is unlocked
                                                 [[UserSession currentSession] setLocked:NO];
                                                 
                                                 //set valid urls
                                                 [self retrieveValidUrls];
                                                 
                                                 //dismiss PinViewController before showing the payment view
                                                 [_loadingViewcontroller dismissViewControllerAnimated:YES completion:^{
                                                     [weakSelf startPaymentProcess];
                                                 }];
                                                 
                                             } failureBlock:^(Error *error) {
                                                 [weakSelf displayAlertViewWithError:error fromViewController:(GenericViewController *)aPinViewController];
                                                 
                                                 if([[weakSelf delegate] respondsToSelector:@selector(didFailLoginForInvoice:)]) {
                                                     [[weakSelf delegate] didFailLoginForInvoice:_invoiceId];
                                                 }
                                             }];
                } failureBlock:^(Error *error) {
                    [self connectWithKeyFailureBlockFromPinViewController:aPinViewController WithError:error delegated:YES];
                }];
                
                [weakSelf setPinViewController:nil];
                
            } andNavigationTitle:[LocalizationHelper stringForKey:@"?" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] andTitle:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] andTitleHeader:@"" andDescription:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_enter" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] animated:YES modeSmall:NO];
            
            [self setPinViewController:aPinViewController];
            
            [aPinViewController setShowCloseButton:YES];
            
            [self displayController:aPinViewController inParentViewController:_loadingViewcontroller animated:YES];
            
            [aPinViewController release];
        }
    }];
}

/*
 * Launch the Payment process according to the invoiceId
 */
- (void)startPaymentProcess {
    
    _hasReceivedNotification = NO;
    
    if([[self invoiceId] length]>0) {
        //Display the invoice
        [self displayPaymentCheckViewController];
    } else {
        //Display the scan
        [self displayScannerViewController];
    }
}

/*
 * Factorization on the failure block for the connectWithKey server call
 */
- (void)connectWithKeyFailureBlockFromPinViewController:(PinViewController*)aPinViewController WithError:(Error *)error delegated:(BOOL)delegated {
    if ([(Error *)error errorCode] == FZ_NO_INTERNET_CONNECTION) {
        ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"Global" inDefaultBundle:FZBundlePayment]
                                                                        message:[error localizedError]
                                                                       delegate:nil
                                                              cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                              otherButtonTitles:nil];
        [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
        [alertView show];
        [alertView release];
        
        //By default we reset the pin code
        [aPinViewController setWrongPinCode:[aPinViewController wrongPinCode] - 1]; //internet connection lost is not concidered has a wrong pin code
        [aPinViewController resetPinCode];
        [aPinViewController hideWaitingView];
        
    } else if([aPinViewController wrongPinCode] > 1){
        [aPinViewController forceClose];
        [aPinViewController hideWaitingView];
    } else {
        ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"pinViewController_error_pincode_alert_title" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment]
                                                                        message:[NSString stringWithFormat:[LocalizationHelper stringForKey:@"pinViewController_error_pincode_alert_message" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment],2 - [aPinViewController wrongPinCode]]
                                                                       delegate:nil
                                                              cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                              otherButtonTitles:nil];
        [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
        [alertView show];
        [alertView release];
        
        //By default we reset the pin code
        [aPinViewController resetPinCode];
        [aPinViewController hideWaitingView];
        
        if (delegated) {
            
            if([[self  delegate] respondsToSelector:@selector(didFailLoginForInvoice:)]) {
                [[self delegate] didFailLoginForInvoice:_invoiceId];
            }
        }
    }
}

#pragma mark - Display methods

/*
 * Display the payment check view controller (PaymentCheckViewController)
 */
- (void)displayPaymentCheckViewController {
    
    FZDefaultMultiTargetManager *multiTarget = [[FZTargetManager sharedInstance] multiTarget];
    
    PaymentCheckViewController *paymentCheckViewController = [multiTarget paymentCheckViewController];
    [paymentCheckViewController setInvoiceId:[self invoiceId]];
    
    CustomNavigationViewController *navigCtrler = [multiTarget customNavigationViewControllerWithController:paymentCheckViewController andMode:CustomNavigationModeClose];
    [[paymentCheckViewController navigationController] setNavigationBarHidden:YES];
    
    if (_parentViewController) {
        [self displayController:navigCtrler inParentViewController:_loadingViewcontroller animated:YES];
    } //else not parent was set
}

/*
 * Display the connection view (LoginViewController)
 */
-(void)displayConnectionViewAnimated:(BOOL) animated {
    
    LoginViewController *loginViewController = [[[FZTargetManager sharedInstance] multiTarget] loginViewController];
    
    FZPortraitNavigationController *navigCtrler = [[FZPortraitNavigationController alloc] initWithRootViewController:loginViewController];
    [[loginViewController navigationController] setNavigationBarHidden:YES];
    
    if (_parentViewController) {
        [self displayController:navigCtrler inParentViewController:_loadingViewcontroller animated:YES];
    } //else not parent was set
    
    [navigCtrler release];
}

/*
 * Display the scanner view because no invoiceId has been detected
 */
- (void)displayScannerViewController {
    if (!TARGET_IPHONE_SIMULATOR) { //real device mode
        
        if ([[UserSession currentSession]isUserAccessToTabBar]) { //TabBar mode
            
            _tabBarController = [[[[FZTargetManager sharedInstance] multiTarget] customTabBarViewController]retain];
            
            _tabBarControllerNavigation = [[FZPortraitNavigationController alloc] initWithRootViewController:_tabBarController];
            
            _tabBarControllerNavigation.navigationBarHidden = YES;
            
            [self displayController:_tabBarControllerNavigation inParentViewController:_loadingViewcontroller animated:YES];
            
        } else { //Payment only mode
            
            FZDefaultMultiTargetManager *multiTarget = [[FZTargetManager sharedInstance] multiTarget];
            
            PaymentViewController *scanner = [multiTarget paymentViewController];
            
            CustomNavigationViewController *navigCtrler = [multiTarget customNavigationViewControllerWithController:scanner andMode:CustomNavigationModeClose];
            [[scanner navigationController] setNavigationBarHidden:YES];
            
            if (_parentViewController) {
                [self displayController:navigCtrler inParentViewController:_loadingViewcontroller animated:YES];
            } //else not parent was set
        }
    } else { //Simulator mode: switch the scanner
        
        NSLog(@"WARNING: hardcoded invoiceId on QAT Indo");
        //TxcwS3s08BA3 is for daddy@yopmail.com, QAT Indo, apiKey: b7b03bdbca440e77f5f7a48d4ea48c356644d6ae
        //UJsklFtuAqKX is for mummy@yopmail.com, Test Indo, apiKey: 58d59000890ffa14b9b3b797a700091fbc2454d9
        [self setInvoiceId:@"UJsklFtuAqKX"];
        
        [self displayPaymentCheckViewController];
    }
}

/*
 * Display a specific controller with a specified parentViewController
 * Animated or not
 */
-(void) displayController:(UIViewController*)controllerToShow inParentViewController:(UIViewController*) parentViewController animated:(BOOL) animated {
    
    NSAssert(parentViewController != nil, @"A parent viewController is needed");
    
    [parentViewController presentViewController:controllerToShow animated:animated completion:nil];
}

/*
 * Display the loading view
 */
- (void)displayLoadingViewAndComplete:(void (^)(void))completion {
    
    //Loading view
    _loadingViewcontroller = [[MainPageLoadingViewController alloc] init];
    
    FZPortraitNavigationController *navigCtrler = [[FZPortraitNavigationController alloc] initWithRootViewController:_loadingViewcontroller];
    [[_loadingViewcontroller navigationController] setNavigationBarHidden:YES];
    
    [_parentViewController presentViewController:navigCtrler animated:YES completion:completion];
}

/*
 * Dismiss the loading view
 */
- (void)hideLoadingView {
    if (_parentViewController) {
        [_parentViewController dismissViewControllerAnimated:YES completion:nil];
    } //else not parent was set
}

/*
 * Display Error
 */
- (void)displayAlertViewWithError:(Error *)error fromViewController:(GenericViewController *)viewController{
    [viewController displayAlertForError:error];
}

#pragma mark - BankSDK

/*
 * Start the Bank SDK
 */
- (void) startBankSDKinParentViewController:(UIViewController *)parentViewController {
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start SDK"];
    
    [[FZTargetManager sharedInstance] setFacade:self];
    
    [[UserSession currentSession]setIsInBankSdk:YES];
    [self setParentViewController:parentViewController];
    
    [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:NO];
    
    [self displayLoadingViewAndComplete:^{
        [self launchAppropriateBankSdkController];
    }];
}

/*
 * Connect the anonymous user
 */
- (void)connectUserWithUserkey {
    
    [ConnectionServices connectWithKey:[[UserSession currentSession] userKey] andPin:kDefaultPin successBlock:^(id userkey) {
        [self showDebugLog:[NSString stringWithFormat:@"Connection has succeeded"]];
        
        [[UserSession currentSession] setConnected:YES];
        
        // the user is connected so the app/SDL is unlocked
        [[UserSession currentSession] setLocked:NO];
        
        // for the BankSDK, the conection is automatic, as we dont retrieve the user infos (retrieveUserInfos) we set the default currency manually
        [[CurrenciesManager currentManager] setDefaultCurrency:@"IDR"];
        
        //Start the payment process
        [self startPaymentProcess];
        
    } failureBlock:^(Error *error) {
        [self showDebugLog:[NSString stringWithFormat:@"Connection has failed"]];
        
        //hide the loading view
        [self hideLoadingView];
        
        ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                        message:[error localizedError]
                                                                       delegate:nil
                                                              cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                              otherButtonTitles:nil];
        [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
        [alertView show];
        [alertView release];
    }];
}

/*
 * According to the situation, display the appropriate controller
 */
- (void) launchAppropriateBankSdkController {
    
    //S'il a accepté les eula ALORS:
    //s'il a une userKey
    //==> payment
    //pas d'userkey
    //==>Creation d'userkey
    //S'il n'a pas accepté les eula ALORS:
    //display eula
    
    [self retrieveValidUrls];
    
    if([[UserSession currentSession] isAcceptedEula]){
        [self showDebugLog:@"step 1 - eula accepted"];
        if (![[[UserSession currentSession] userKey] isEqual:@""] && [[UserSession currentSession] userKey]!=nil) {
            [self showDebugLog:@"step 2 - an userkey exists"];
            
            [self connectUserWithUserkey];
            
        } else {
            [self showDebugLog:@"step 3 - generate an userkey"];
            if([[[FZTargetManager sharedInstance] delegateSDK]respondsToSelector:@selector(generateUserkey)]){
                [[[FZTargetManager sharedInstance] delegateSDK] generateUserkey];
            }
        }
    } else {
        [self showDebugLog:@"step 4 - show eula"];
        
        UIViewController *showEulaController = nil;
        
        id delegate = [[FZTargetManager sharedInstance] delegateSDK];
        
        if([delegate respondsToSelector:@selector(controllerEULA)]){
            showEulaController = [delegate controllerEULA];
            
            [(id)showEulaController setDelegateEula:self];
            
            if(showEulaController==nil){
                // TODO : improve error?
                [self showDebugLog:@"step 4 - show eula - controller is nil"];
                return;
            }
        }
        
        [self displayController:showEulaController inParentViewController:_loadingViewcontroller animated:YES];
    }
}

/*
 * Store the user's userkey (apikey)
 */
- (void)registerUserApiKey:(NSString *)apikey {
    if([apikey length] == 0) {
        [self showDebugLog:@"Create userkey seems not working: userkey is empty"];
    } else {
        [self showDebugLog:[NSString stringWithFormat:@"Create userkey seems working: userkey is %@",apikey]];
        
        [[UserSession currentSession] storeUserKey:apikey];
        [self launchAppropriateBankSdkController];
    }
}

#pragma mark - LoginViewController delegate

/*
 * Catch the user's connection
 */
- (void)didConnectWithUser:(User *)user withUserKey:(NSString *)userKey {
    
    [[UserSession currentSession] setUser:user];
    [[UserSession currentSession] setConnected:YES];
    
    // the user is connected so the app/SDL is unlocked
    [[UserSession currentSession] setLocked:NO];
    
    [[UserSession currentSession] storeUserKey:userKey];
    
    if (_parentViewController) {
        
        //Dismiss the login view from the stack
        [_loadingViewcontroller dismissViewControllerAnimated:YES completion:^{
            
            //Start the payment process which will display the right controller
            [self startPaymentProcess];
        }];
    }
}

#pragma mark - PaymentCheckViewController delegate method

/*
 * PaymentCheckViewController delegate when the payment is valid
 */
- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didValidatePaymentForInvoiceId:(NSString *)invoiceId {
    
    FZTarget currentTarget = [[FZTargetManager sharedInstance] mainTarget];
    BOOL animated = currentTarget != FZBankSDKTarget;
    
    //Manage callback (isClosingSdkAfterPaymentFailedOrSucceeded)
    if([self isClosingSdkAfterPaymentFailedOrSucceeded]) {// if is On
        
        //Dismiss the payment view (scanner) from the stack
        [_loadingViewcontroller dismissViewControllerAnimated:animated completion:^{
            
            if([[self delegate] respondsToSelector:@selector(paymentAcceptedForInvoice:)]) {
                [[self delegate] paymentAcceptedForInvoice:invoiceId];
            }
            
            [self hideLoadingView];
        }];
    } else {
        
        if (currentTarget != FZBankSDKTarget) {
            [self hideLoadingView];
        } else {
            //keep on the scanner
        }
    }
}

/*
 * PaymentCheckViewController delegate when the payment is canceled
 */
- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didCancelPaymentForInvoiceId:(NSString *)invoiceId {
    
    if([[self delegate] respondsToSelector:@selector(paymentCanceledForInvoice:)]) {
        [[self delegate] paymentCanceledForInvoice:invoiceId];
    }
}

/*
 * PaymentCheckViewController delegate when the payment has failed
 */
- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didFailPaymentForInvoiceId:(NSString *)invoiceId {
    
    if([[self delegate] respondsToSelector:@selector(paymentFailedForInvoice:)]) {
        [[self delegate] paymentFailedForInvoice:invoiceId];
    }
}

#pragma mark - PaymentViewController delegate

/*
 * The payment is accepted for the specified invoice
 */
- (void)paymentAcceptedForInvoice:(NSString *)invoiceId {
    
    //Dismiss the scanner (PaymentViewController)
    [_loadingViewcontroller dismissViewControllerAnimated:YES completion:^{
        
        //Dismiss the loading view
        [self hideLoadingView];
    }];
}

#pragma mark - Global delegate

- (void)didClose:(UIViewController *)viewController {
    [self hideLoadingView];
}

#pragma mark - Close SDK Delegate

/*
 * Delegate the notify those which are registered that the SDK did closed
 */
- (void) didCloseSdk {
    if([[self delegate] respondsToSelector:@selector(didCloseSdk)]) {
        [[self delegate] didCloseSdk];
    }
}

/*
 * Force close BankSDK and shutdown all network calls
 * We assume, we have to close the BankSDK when the user is trying to pay an invoice and the bank refuse the transaction
 * Only the host application have this information so it has to be able to stop the pament process and close the BankSDK
 */
- (void)forceCloseSdk {
	//Retrieve the PaymentCheckViewController
	PaymentCheckViewController *paymentCheckVC = [(PaymentViewController *)[(CustomTabBarViewController *)_tabBarController lastController] paymentCheckViewController];

	
	//Stop the timer which is calling the serveur
	[(PaymentCheckViewController *)paymentCheckVC stopPolling];

	
	//Cancel all pending http requests
	FZAFHTTPClient *httpClient = [[FZAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
	[[httpClient operationQueue] cancelAllOperations];
	
	//Dismiss controllers
	
	// TODO : nice leaks here
	[paymentCheckVC dismissViewControllerAnimated:NO completion:^{
		
		[_tabBarController dismissViewControllerAnimated:NO completion:^{
			
			[self hideLoadingView];
		}];
	}];}

#pragma mark - EULA

/*
 * The user has refused the Eula
 */
- (void)didRefuseEula
{
    [_loadingViewcontroller dismissViewControllerAnimated:NO completion:nil];
    [[UserSession currentSession] storeAcceptedEula:NO];
    if([[self delegate] respondsToSelector:@selector(didRefuseEula)]) {
        [[self delegate] didRefuseEula];
    }
    [self hideLoadingView];
}

/*
 * The user has accpeted the Eula
 */
- (void)didAcceptEula
{
    [_loadingViewcontroller dismissViewControllerAnimated:YES completion:^{
        [[UserSession currentSession] storeAcceptedEula:YES];
        
        if([[self delegate] respondsToSelector:@selector(didAcceptEula)]) {
            [[self delegate] didAcceptEula];
        }
        
        [self launchAppropriateBankSdkController];
    }];
}

#pragma mark - Receive notification from Link With Flashiz

-(void)pushNotificationReceived:(NSNotification *)notification {
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
        if ([notification.name isEqualToString:@"launchFlashizSDK"] && !_hasReceivedNotification) {
            
            _hasReceivedNotification = YES;
            
            NSDictionary *dict = [notification object];
            
            //Store userKey
            [[UserSession currentSession] storeUserKey:[dict objectForKey:@"u"]];
            
            //Store environment
            [[UserSession currentSession] storeEnvironmentWithEnvironment:[dict objectForKey:@"e"]];
            
            NSString *invoiceId = [dict objectForKey:@"i"];
            UIViewController *parentViewController = [dict objectForKey:@"p"];
            
            [self executePaymentForInvoiceId:invoiceId inParentViewController:parentViewController];
        }
    }
}

#pragma mark - BankSDK callback

- (void)qrCodeisInvalid {
    if([[self delegate] respondsToSelector:@selector(qrCodeisInvalid)]) {
        [[self delegate] qrCodeisInvalid];
    }
}

- (BOOL)isClosingSdkAfterPaymentFailedOrSucceeded
{
    if([[self delegate] respondsToSelector:@selector(isClosingSdkAfterPaymentFailedOrSucceeded)]) {
        return [[self delegate] isClosingSdkAfterPaymentFailedOrSucceeded];
    } else {
        return NO;
    }
}

- (BOOL)isClosingSdkAfterUserCancelTransaction
{
    if([[self delegate] respondsToSelector:@selector(isClosingSdkAfterUserCancelTransaction)]) {
        return [[self delegate] isClosingSdkAfterUserCancelTransaction];
    } else {
        return NO;
    }
}

- (BOOL)isClosingSdkAfterInvalidQrCode
{
    if([[self delegate] respondsToSelector:@selector(isClosingSdkAfterInvalidQrCode)]) {
        return [[self delegate] isClosingSdkAfterInvalidQrCode];
    } else {
        return NO;
    }
}

- (BOOL)isDebugMode
{
    if([[self delegate] respondsToSelector:@selector(isDebugMode)]) {
        return [[self delegate] isDebugMode];
    } else {
        return NO;
    }
}

- (BOOL)isClosingSdkAfterUnknownError
{
    if([[self delegate] respondsToSelector:@selector(isClosingSdkAfterUnknownError)]) {
        return [[self delegate] isClosingSdkAfterUnknownError];
    } else {
        return NO;
    }
}

- (BOOL)isForcingCancelTransaction
{
    if([[self delegate] respondsToSelector:@selector(isForcingCancelTransaction)]) {
        return [[self delegate] isForcingCancelTransaction];
    } else {
        return NO;
    }
}

- (double)timeBeforeStartingPoll
{
    if([[self delegate] respondsToSelector:@selector(timeBeforeStartingPoll)]) {
        return [[self delegate] timeBeforeStartingPoll];
    } else {
        return 0;
    }
}

- (double)timeBetweenEachPollCall
{
    if([[self delegate] respondsToSelector:@selector(timeBetweenEachPollCall)]) {
        return [[self delegate] timeBetweenEachPollCall];
    } else {
        return 0;
    }
}

- (void)showDebugLog:(NSString *)log
{
    id<FlashizFacadeDelegate> delegate = [[FZTargetManager sharedInstance]delegateSDK];
    if([delegate respondsToSelector:@selector(isDebugMode)]) {
        if([delegate isDebugMode]) {
            NSLog(@"BankSDK : %@",log);
        }
    }
}

#pragma mark - MM

- (void)dealloc {
    [_invoiceId release], _invoiceId = nil;
    
    [super dealloc];
}

@end
