//
//  FlashizFacade.m
//  FlashIzMobilePaymentLib
//
//  Created by David Ledanseur on 08/02/12.
//  Modified by Yvan Moté on 13/12/13.
//  Copyright (c) 2012-2014 Flashiz. All rights reserved.
//

#import "FlashizFacade.h"

//Target manager
#import <FZBlackBox/FZTargetManager.h>
#import <FZBlackBox/CoreMultiTargetManager.h>

//UIWindow
#import "AutoCloseWindow.h"

//Constant
#import <FZAPI/ServerConstants.h>

//Services
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/InvoiceServices.h>

//Domain
#import <FZAPI/User.h>
#import <FZAPI/UserSession.h>
@class Error;
@class InitialViewController;

//ComponentHelper
#import <FZBlackBox/ImageHelper.h>
#import <FZBlackBox/FontHelper.h>
#import <FZBlackBox/LocalizationHelper.h>
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/ColorHelper.h>

//ViewControllers
#import <FZBlackBox/MainPageLoadingViewController.h>
#import <FZBlackBox/GenericViewController.h>
#import <FZBlackBox/FZPortraitNavigationController.h>
#import "LoginViewController.h"
#import "PinViewController.h"
#import "PaymentViewControllerBB.h"
#import "PaymentCheckViewControllerBB.h"
#import <FZBlackBox/MainPageLoadingViewController.h>
#import <FZBlackBox/ShowEulaViewController.h>
#import <FZBlackBox/CustomTabBarViewController.h>

#import <FZBlackBox/ShowEulaDelegate.h>

#import "ScannerViewControllerBB.h"

//Utils
#import <FZBlackBox/ODCustomAlertView.h>
#import <FZBlackBox/FZMBProgressHUD.h>
#import <FZAPI/FZAFHTTPClient.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Font
#import "FZFlashizTemplateFonts.h"
#import "FZFlashizTemplateColor.h"

//Currency
#import <FZAPI/CurrenciesManager.h>

//UrlSchemeManager
#import <FZBlackBox/FZUrlSchemeManager.h>

//tracker
#import <FZBlackBox/StatisticsFactory.h>

//simulator
#ifdef __APPLE__
#include "TargetConditionals.h"
#endif

#define kDefaultPin @"0000"

static NSString *const userKeyPreference = @"userKey";

@interface FlashizFacade() <LoginViewControllerDelegate, PinViewControllerDelegate, PaymentCheckViewControllerDelegate, PaymentViewControllerDelegate, ShowEulaDelegate>

//Navigation
@property (retain, nonatomic) UINavigationController *navigationController;

//TabBar
@property (retain, nonatomic) CustomTabBarViewController *tabBarController;

//Menu
@property (retain, nonatomic) PPRevealSideViewController *ppRevealSideViewController;
@property (retain, nonatomic) MenuViewController *menuViewController;

//Host and parent
@property (nonatomic, retain) UIViewController *hostViewController;
@property (nonatomic, retain) UIViewController *parentViewController;

@property (nonatomic,retain) UIViewController* connectionViewController;
@property (nonatomic,retain) UIViewController* paymentCheckViewController;
@property (nonatomic,retain) PinViewController* pinViewController;

//TODO: is it really needed ? it not used...
@property (nonatomic, retain) ScannerViewControllerBB *scannerViewController;

@property (nonatomic,retain) MainPageLoadingViewController *loadingViewcontroller;

@property (assign,nonatomic) BOOL hasReceivedNotification;
@property (nonatomic, copy) NSString *invoiceId;
@property (nonatomic, retain) NSString *serverEnvironment;

@end


@interface FlashizFacade()

- (void) loadBankSDKMultiTargetManager:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate;
- (void) loadSDKMultiTargetManager:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>)delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme;

- (id<FlashizFacadeDelegate>)delegate;


@end


@implementation FlashizFacade {
    FZMBProgressHUD *progressHud;
}

-(id<FlashizFacadeDelegate>)delegate
{
    return (id<FlashizFacadeDelegate>)[[FZTargetManager sharedInstance]delegateSDK];
}


#pragma mark - Init methods

- (id)initAppForBrand:(NSString *)brand withTargetManager:(FZDefaultMultiTargetManager *)manager withDelegate:(id<UIApplicationDelegate>)delegate withColorTemplate:(FZDefaultTemplateColor *)colorTemplate withFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplate {
    self = [super init];
    if (self) {
        [self setModal:NO];
        [self loadAppForBrand:brand withTargetManager:manager withDelegate:delegate withColorTemplate:colorTemplate withFontsTemplate:fontsTemplate];
    }
    return self;
}

- (id)initSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme
{
    self = [super init];
    if (self) {
        [self setModal:NO];
        [self loadSDKMultiTargetManager:manager withDelegate:delegate configureUrlSchemesWihtCustomerHost:customerHost andCustomerScheme:customerScheme];
    }
    return self;
}

- (id)initBankSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate
{
    self = [super init];
    if (self) {
        [self setModal:YES];
        [self loadBankSDKMultiTargetManager:manager withDelegate:delegate];
    }
    return self;
}

#pragma mark - Loading methods

- (void)loadAppForBrand:(NSString *)brand withTargetManager:(FZDefaultMultiTargetManager *)manager withDelegate:(id<UIApplicationDelegate>)delegate withColorTemplate:(FZDefaultTemplateColor *)colorTemplate withFontsTemplate: (FZDefaultTemplateFonts *)fontsTemplate {
    
    [[FZTargetManager sharedInstance] loadAppWithBrandName:brand withTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andApplicationDelegate:delegate andFacade:self];
}

- (void)loadBankSDKMultiTargetManager:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate {
    FZFlashizTemplateColor *colorTemplate = [[FZFlashizTemplateColor alloc] init];
    FZFlashizTemplateFonts *fontsTemplate = [[FZFlashizTemplateFonts alloc] init];
    
    [[FZTargetManager sharedInstance] loadBankSDKWithTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andDelegate:delegate];
    
    if([[[FZTargetManager sharedInstance] delegateSDK] respondsToSelector:@selector(isClosingSdkAfterUnknownError)]){
        _unknownErrorOccured = [[[FZTargetManager sharedInstance] delegateSDK] isClosingSdkAfterUnknownError];
    }
    
    [colorTemplate release];
    [fontsTemplate release];
    
    _unknownErrorOccured = NO;
}

- (void)loadSDKMultiTargetManager:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>)delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme {
    FZFlashizTemplateColor *colorTemplate = [[FZFlashizTemplateColor alloc] init];
    FZFlashizTemplateFonts *fontsTemplate = [[FZFlashizTemplateFonts alloc] init];
    
    [[FZTargetManager sharedInstance] loadSDKWithTarget:manager withColorTemplate:colorTemplate andFontsTemplate:fontsTemplate andDelegate:delegate configureUrlSchemesWihtCustomerHost:customerHost andCustomerScheme:customerScheme];
    
    [colorTemplate release];
    [fontsTemplate release];
}

#pragma mark - Receive notification from Link With Flashiz

-(void)pushNotificationReceived:(NSNotification *)notification {
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
        if ([notification.name isEqualToString:@"launchFlashizSDK"] && !_hasReceivedNotification) {
            
            _hasReceivedNotification = YES;
            
            NSDictionary *dict = [notification object];
            
            [self storeUserKey:[dict objectForKey:@"u"]];
            
            NSString *server = [dict objectForKey:@"e"];
            
            //Store environment
            [[UserSession currentSession] storeEnvironmentWithEnvironment:server];
            
            NSString *invoiceId = [dict objectForKey:@"i"];
            UIViewController *parentViewController = [dict objectForKey:@"p"];
            
            [self executePaymentForInvoiceId:invoiceId inParentViewController:parentViewController];
        }
    }
}

#pragma mark - Start methods

- (void) startBankSDKinParentViewController:(UIViewController *)parentViewController {
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start SDK"];
    
    [[UserSession currentSession]setIsInBankSdk:YES];
    [self setParentViewController:parentViewController];
    
    [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:NO];
    
    [self launchAppropriateBankSdkController];
}

- (void) launchAppropriateBankSdkController {
    
    _loadingViewcontroller = [[MainPageLoadingViewController alloc] init];
    if (_loadingViewcontroller && _loadingViewcontroller.isViewLoaded && _loadingViewcontroller.view.window){
        // viewController is visible
    } else {
        //_loadingViewcontroller = [[MainPageLoadingViewController alloc] init];
        
        FZPortraitNavigationController *navigationController = [[[FZTargetManager sharedInstance]multiTarget]portraitNavigationControllerWithRootViewController:_loadingViewcontroller];
        
        [_parentViewController presentViewController:navigationController
                                            animated:NO
                                          completion:nil];
    }
    
    //S'il a accepté les eula ALORS:
    //s'il a une userKey
    //==> payment
    //pas d'userkey
    //==>Creation d'userkey
    //S'il n'a pas accepté les eula ALORS:
    //display eula
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        
#warning TODO: get url list from the indonesian server (see code commented below on step 2)
        
        NSMutableArray *urlList = [[NSMutableArray alloc] init];
        [urlList addObject:@"http://www.flashiz.com/fr/infos/"];
        [urlList addObject:@"http://www.flashiz.com/en/infos/"];
        [urlList addObject:@"http://www.flashiz.com/es/infos/"];
        [urlList addObject:@"http://www.flashiz.com/de/infos/"];
        [urlList addObject:@"http://www.flashiz.com/nl/infos/"];
        [[UserSession currentSession] setValidUrls:urlList];
        [urlList release];
    }
    
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
        
        if([[[FZTargetManager sharedInstance] delegateSDK]respondsToSelector:@selector(controllerEULA)]){
            showEulaController = [[[FZTargetManager sharedInstance] delegateSDK] controllerEULA];
            
            [(id)showEulaController setDelegateEula:self];
            
            if(showEulaController==nil){
                // TODO : improve error?
                [self showDebugLog:@"step 4 - show eula - controller is nil"];
                return;
            }
        }
        
        [_parentViewController dismissViewControllerAnimated:NO completion:nil];
        
        FZPortraitNavigationController *navigationController = [[[FZTargetManager sharedInstance]multiTarget]portraitNavigationControllerWithRootViewController:showEulaController];
        
        [_parentViewController presentViewController:navigationController
                                            animated:YES
                                          completion:nil];
        
        [showEulaController release],showEulaController = nil;
    }
}

- (void)registerUserApiKey:(NSString *)apikey {
    if([apikey length] == 0) {
        [self showDebugLog:@"Create userkey seems not working: userkey is empty"];
    } else {
        [self showDebugLog:[NSString stringWithFormat:@"Create userkey seems working: userkey is %@",apikey]];
        
        [[UserSession currentSession] storeUserKey:apikey];
        [self launchAppropriateBankSdkController];
    }
}

- (void)resetUserApiKey {
    [[UserSession currentSession] storeUserKey:@""];
}

- (void)connectUserWithUserkey {
    
    //TODO: remove this for phase 2
    //----------
    /*
     [self showDebugLog:[NSString stringWithFormat:@"Connection has succeeded"]];
     
     [[UserSession currentSession] setConnected:YES];
     
     [_parentViewController dismissViewControllerAnimated:NO completion:nil];
     [self displayScannerViewController];
     */
    //----------
    
    //TODO: uncomment this for phase 2
    
    [ConnectionServices connectWithKey:[[UserSession currentSession] userKey] andPin:kDefaultPin successBlock:^(id userkey) {
        [self showDebugLog:[NSString stringWithFormat:@"Connection has succeeded"]];
        
        [[UserSession currentSession] setConnected:YES];
        
        [_parentViewController dismissViewControllerAnimated:NO completion:nil];
        [self displayScannerViewController];
        
    } failureBlock:^(Error *error) {
        [self showDebugLog:[NSString stringWithFormat:@"Connection has failed"]];
        [_parentViewController dismissViewControllerAnimated:NO completion:nil];
        
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

- (void)startPaymentProcess {
    
    _hasReceivedNotification = NO;
    
    if([[self invoiceId] length]>0) {
        [self displayPaymentCheckViewController];
    } else {
        //Display scan view
        [self displayScannerViewController];
    }
}

#pragma mark - Execute payment

- (void)executePaymentForInvoiceId:(NSString *)invoiceId
            inParentViewController:(UIViewController *)parentViewController {
    
    [self setInvoiceId:invoiceId];
    [self setHostViewController:parentViewController];
    [self setParentViewController:parentViewController];
    
    NSAssert(_parentViewController!=nil, @"No parentViewController specified. No parent view controller specified. Set it via the FlashizFacade.parentViewController property.");
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
        //Register data and observer in case of "Link with Flashiz account"
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if(_invoiceId) {
            [dict setObject:_invoiceId forKey:@"invoiceId"];
        }
        [dict setObject:_parentViewController forKey:@"parentViewController"];
        
        [[FZTargetManager sharedInstance] setCallbackData:dict];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"launchFlashizSDK" object:nil];
    }
    
    //display the pin code or the login with email/password view controller
    NSString *userKey = [self userKeyFromPreferences];
    
    if([userKey length]==0) {
        [self displayConnectionViewAnimated:YES];
    } else {
        
        [self displayProgressHud];
        
        __block FlashizFacade *weakSelf = self;
        __block PinViewController *aPinViewController = [[PinViewController alloc] initWithCompletionBlock:^(NSString *pinCode) {
            
            //NSLog(@"userkey: %@ - environement: %@",userKey,[[UserSession currentSession] shortEnvironmentValue]);
            
            [[StatisticsFactory sharedInstance] checkPointConnectPincode];
            [ConnectionServices connectWithKey:userKey andPin:pinCode successBlock:^(id context) {
                [ConnectionServices retrieveUserInfos:userKey
                                         successBlock:^(id context) {
                                             
                                             [[UserSession currentSession] setUser:context];
                                             [[UserSession currentSession] setConnected:YES];
                                             
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
                                                     ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                                                     message:[error localizedError]
                                                                                                                    delegate:nil
                                                                                                           cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                                           otherButtonTitles:nil];
                                                     [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                                                     [alertView show];
                                                     [alertView release];
                                                 }];
                                             }
                                             
                                             [weakSelf startPaymentProcess];
                                             
                                             [weakSelf hideProgressHud];
                                             
                                         } failureBlock:^(Error *error) {
                                             [weakSelf displayAlertViewWithError:error fromViewController:(GenericViewController *)aPinViewController];
                                             
                                             [self hideProgressHud];
                                             
                                             if([[weakSelf delegate] respondsToSelector:@selector(didFailLoginForInvoice:)]) {
                                                 [[weakSelf delegate] didFailLoginForInvoice:[weakSelf invoiceId]];
                                             }
                                         }];
                
            } failureBlock:^(Error *error) {
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
                    
                    [self hideProgressHud];
                    
                    if([[weakSelf delegate] respondsToSelector:@selector(didFailLoginForInvoice:)]) {
                        [[weakSelf delegate] didFailLoginForInvoice:[weakSelf invoiceId]];
                    }
                }
            }];
            
            [weakSelf setPinViewController:nil];
            
        } andNavigationTitle:[LocalizationHelper stringForKey:@"?" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] andTitle:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] andTitleHeader:@"" andDescription:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_enter" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] animated:YES modeSmall:NO];
        
        [self setPinViewController:aPinViewController];
        
        [aPinViewController setShowCloseButton:YES];
        [aPinViewController setDelegate:self];
        
        [self displayInParentViewController:aPinViewController];
        
        [self setParentViewController:aPinViewController];
        
        [aPinViewController release];
    }
}

#pragma mark - Launch methods

- (void)launchPinCodeAndpresentedWith:(UIViewController *)aController andUseTabBar:(CustomTabBarViewController *)tabBarController andNavController:(UINavigationController *)navController andPpRevealSide:(PPRevealSideViewController *)ppRevealSideViewController{
    
    [self setNavigationController:navController];
    [self setPpRevealSideViewController:ppRevealSideViewController];
    
    [self setTabBarController:tabBarController];
    
    PinCompletionBlock pinCompletionBlock = ^(NSString *pinCode) {
        NSString *userKey = [[UserSession currentSession] userKey];
        
        [_pinViewController showForUserNotConnectedWaitingViewWithMessage:[LocalizationHelper stringForKey:@"loading" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment]];
        
        [[StatisticsFactory sharedInstance] checkPointConnectPincode];
        [ConnectionServices connectWithKey:userKey
                                    andPin:pinCode
                              successBlock:^(id context) {
                                  
                                  [ConnectionServices retrieveUserInfosLight:userKey successBlock:^(id context) {
                                      
                                      [[UserSession currentSession] setUser:context];
                                      [[CurrenciesManager currentManager] setDefaultCurrency:[[[[UserSession currentSession] user] account] currency]];
                                      
                                      if([[[UserSession currentSession] user] isCompany]){
                                          [tabBarController setCustomTabBarForProfessional];
                                      } else {
                                          [tabBarController setCustomTabBarForClient];
                                      }
                                      
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
                                                                                                              message:[LocalizationHelper errorForKey:[NSString stringWithFormat:@"%ld",(long)[error errorCode]] withComment:@"" inDefaultBundle:FZBundleAPI]
                                                                                                             delegate:nil
                                                                                                    cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                                    otherButtonTitles:nil];
                                              [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                                              [alertView show];
                                              [alertView release];
                                          }];
                                      }
                                      
                                      
                                      [_pinViewController hideWaitingView];
                                      
                                      // TODO : dismiss?
                                      [_pinViewController release];
                                      
                                      [AutoCloseWindow startCloseTimer];
                                      
                                      //[TestFlightHelper passLoginWithPinCode];
                                      
                                      if([[UserSession currentSession] isLinkWithFlashizProcess]){
                                          [FZUrlSchemeManager backToTheHostApplicationWithUserkey:userKey];
                                          
                                          [[UserSession currentSession] setConnected:NO];
                                          
                                          [[UserSession currentSession] setLinkWithFlashiz:NO];
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
                                      [_pinViewController setWrongPinCode:[_pinViewController wrongPinCode]-1]; //internet connection lost is not concidered has a wrong pin code
                                      [_pinViewController resetPinCode];
                                      [_pinViewController hideWaitingView];
                                      
                                  } else if ([_pinViewController wrongPinCode] > 1){
                                      [_pinViewController hideWaitingView];
                                      [_pinViewController forceClose];
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
    
    _pinViewController = [[[[FZTargetManager sharedInstance] multiTarget] pinViewControllerWithCompletionBlock:pinCompletionBlock navigationTitle:[LocalizationHelper stringForKey:@"?" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] title:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] titleHeader:@"" description:[LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_enter" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment] animated:NO modeSmall:NO] retain];
    
    [_pinViewController setShowCloseButton:YES];
    [_pinViewController setDelegate:self];
    
    //controller
    if(aController){
        [aController presentViewController:_pinViewController
                                  animated:YES
                                completion:^{
                                    [_pinViewController setupBackButton];
                                }];
    }
    [AutoCloseWindow stopCloseTimer];
}

#pragma mark - Show methods

- (void)showInitialViewControllerFromPpRevealSide:(PPRevealSideViewController *)ppRevealSideViewController andNavController:(UINavigationController *)navController andUseTabBar:(CustomTabBarViewController *)tabBarController {
    
    [self setNavigationController:navController];
    
    [self setPpRevealSideViewController:ppRevealSideViewController];
    
    [self setTabBarController:tabBarController];
    
    InitialViewController *initialViewController = [[[FZTargetManager sharedInstance] multiTarget] initialViewController];
    
    /*UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:(UIViewController *)initialViewController];
     
     [navigationController setNavigationBarHidden:YES];*/
    
    //Without that, we lost the initial view controller
    // TODO : hazardous fix
    
    [_ppRevealSideViewController popViewControllerAnimated:NO];
    /*[_ppRevealSideViewController dismissViewControllerAnimated:NO
     completion:^{}];*/
    
    [_ppRevealSideViewController presentViewController:initialViewController
                                              animated:NO
                                            completion:nil];
    
    //[navigationController release];
}

#pragma mark - Go methods

- (void)goBackToCustomTabBarController {
    
    //[_navigationController setViewControllers:[NSArray arrayWithObject:_tabBarController]];
    
    //Animation disabled: bug on iOS 7
    [_ppRevealSideViewController popViewControllerWithNewCenterController:_navigationController animated:NO];
}

#pragma mark - HUD methods

- (void)displayProgressHud {
    [self hideProgressHud];
    
    progressHud = [[FZMBProgressHUD showHUDAddedTo:[_parentViewController view] animated:YES] retain];
}

- (void)hideProgressHud {
    [progressHud hide:YES];
    [progressHud release];
    progressHud = nil;
}

#pragma mark - Private methods

- (void)storeUserKey:(NSString *)userKey {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setObject:userKey forKey:userKeyPreference];
    [standardUserDefaults synchronize];
    
    [[UserSession currentSession] setUserKey:userKey];
}

- (NSString *)userKeyFromPreferences {
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:userKeyPreference];
    [[UserSession currentSession] setUserKey:userKey];
    
    return userKey;
}

#pragma mark - Display methods

- (void)displayPaymentCheckViewController {
    
    PaymentCheckViewController *paymentCheckViewController = [[[FZTargetManager sharedInstance] multiTarget] paymentCheckViewController];
    [paymentCheckViewController setInvoiceId:[self invoiceId]];
    [paymentCheckViewController setDelegate:self];
    
    CustomNavigationViewController *navigController = [[FZTargetManager sharedInstance]customNavigationViewControllerWithController:paymentCheckViewController andMode:CustomNavigationModeClose];
    
    FZPortraitNavigationController *navigationController = [[[FZTargetManager sharedInstance]multiTarget]portraitNavigationControllerWithRootViewController:paymentCheckViewController];
    
    [paymentCheckViewController setCustomNavigationController:navigationController];
    
    [_parentViewController presentViewController:navigationController
                                        animated:YES
                                      completion:nil];
    
    [navigController release];
}

- (void)displayAlertViewWithError:(Error *)error fromViewController:(GenericViewController *)viewController{
    [viewController displayAlertForError:error];
}

-(void) displayInParentViewController:(UIViewController*) controllerToShow {
    [self displayInParentViewController:controllerToShow animated:NO];
}

-(void) displayInParentViewController:(UIViewController*) controllerToShow animated:(BOOL) animated {
    if (_modal) {
        FZPortraitNavigationController *navigationController = [[[FZTargetManager sharedInstance]multiTarget]portraitNavigationControllerWithRootViewController:controllerToShow];
        [navigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [[self parentViewController] presentViewController:navigationController
                                                  animated:animated
                                                completion:nil];
    } else {
        UINavigationController* navController = self.parentViewController.navigationController;
        
        NSAssert(navController!=nil, @"Wrong parentViewController specified. When using non-modal display, parentViewController have to be an instance of UIViewController with a valid navigationController assigned");
        
        [navController pushViewController:controllerToShow animated:animated];
    }
}

-(void)displayConnectionViewAnimated:(BOOL) animated {
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    
    [loginViewController setDelegate:self];
    [self setConnectionViewController:loginViewController];
    
    [self displayInParentViewController:loginViewController animated:YES];
    
    [self setParentViewController:loginViewController];
    
    [loginViewController release];
}

- (void)displayScannerViewController {
    
    if ([[UserSession currentSession]isUserAccessToTabBar]) {
        if (!TARGET_IPHONE_SIMULATOR) {
            //TabBar mode
            
            CustomTabBarViewController *tabBar = [[[[FZTargetManager sharedInstance] multiTarget] customTabBarViewController]retain];
            
            [self displayInParentViewController:tabBar];
            
            [[FZTargetManager sharedInstance] setFacade:self];
            
            [tabBar release];
        } else {
            PaymentCheckViewController *paymentCheckViewController = [[[FZTargetManager sharedInstance] multiTarget] paymentCheckViewController];
            [paymentCheckViewController setInvoiceId:@"TxcwS3s08BA3"];//WARNING: hardcoded invoiceId (daddy@yopmail.com, QAT Indo, apiKey: b7b03bdbca440e77f5f7a48d4ea48c356644d6ae)
            [paymentCheckViewController setDelegate:self];
            
            CustomNavigationViewController *navigController = [[FZTargetManager sharedInstance]customNavigationViewControllerWithController:paymentCheckViewController andMode:CustomNavigationModeClose];
            
            FZPortraitNavigationController *navigationController = [[[FZTargetManager sharedInstance]multiTarget]portraitNavigationControllerWithRootViewController:navigController];
            
            [paymentCheckViewController setCustomNavigationController:navigationController];
            
            [_parentViewController presentViewController:navigationController
                                                animated:YES
                                              completion:nil];
        }
    } else {
        
        PaymentViewController *scanner = [[[FZTargetManager sharedInstance] multiTarget] paymentViewController];
        [scanner setDelegate:self];
        
        CustomNavigationViewController *navigController = [[FZTargetManager sharedInstance]customNavigationViewControllerWithController:scanner andMode:CustomNavigationModeClose];
        
        //NSLog(@"navigController : %@",navigController);
        
        FZPortraitNavigationController *navigationController = [[[FZTargetManager sharedInstance]multiTarget]portraitNavigationControllerWithRootViewController:navigController];
        
        //NSLog(@"navigationController : %@",navigationController);
        
        
        [scanner setCustomNavigationController:navigationController];
        
        //NSLog(@"_parentViewController : %@",_parentViewController);
        
        [_parentViewController presentViewController:navigationController
                                            animated:YES
                                          completion:nil];
    }
}

- (void)hideScannerViewControllerWithCompletion:(void (^)(void))completion {
    [[_parentViewController presentedViewController] dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark - Action methods

- (void)didCancelScan:(id)sender {
    [self hideScannerViewControllerWithCompletion:nil];
    
    if([[self delegate] respondsToSelector:@selector(paymentCanceledForInvoice:)]) {
        [[self delegate] paymentCanceledForInvoice:nil];
    }
}

#pragma mark - LoginViewController delegate method

- (void)didConnectWithUser:(User *)user withUserKey:(NSString *)userKey {
    
    [self displayProgressHud];
    
    [[UserSession currentSession] setUser:user];
    [[UserSession currentSession] setConnected:YES];
    [self storeUserKey:userKey];
    
    if([[self connectionViewController] presentingViewController]!=nil) {
        
        [self startPaymentProcess];
        
        [self setConnectionViewController:nil];
        
        [self hideProgressHud];
    } else {
        
        [self startPaymentProcess];
        
        [self setConnectionViewController:nil];
        
        [self hideProgressHud];
    }
}

- (void)didFailConnecting {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundlePayment]
                                                        message:[LocalizationHelper stringForKey:@"user_invalid" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment]
                                                       delegate:nil
                                              cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)didClose:(UIViewController *)viewController {
    
    if([viewController isKindOfClass:[LoginViewController class]]) {
        
        [self storeUserKey:nil];
        
        [progressHud hide:YES];
        [progressHud release];
        progressHud = nil;
        
        if([[self delegate] respondsToSelector:@selector(didCancelLoginForInvoice:)]) {
            [[self delegate] didCancelLoginForInvoice:[self invoiceId]];
        }
        
        if(!_modal) {
            [[[self parentViewController] navigationController] popViewControllerAnimated:YES];
        } else {
            [_hostViewController dismissViewControllerAnimated:YES completion:^{}];
        }
    } else if([viewController isKindOfClass:[PinViewController class]]){
        [_pinViewController release];
        _pinViewController = nil;
        
        //[TestFlightHelper passLoginClose];
    } else {
        [self showDebugLog:@"Fail : - (void)didClose:(UIViewController *)viewController"];
    }
}

#pragma mark - FlashizEnvironment datasource

- (NSString *)environment {
    return [self serverEnvironment];
}

#pragma mark - PinViewController delegate method

- (void)pinViewControllerDidClose:(PinViewController *)pinViewController {
    
    //User dismiss the modal pin view controller, we can reset the user key stored
    //in user preferences
    [self storeUserKey:nil];
    
    [progressHud hide:YES];
    [progressHud release];
    progressHud = nil;
    
    if([[self delegate] respondsToSelector:@selector(didCancelLoginForInvoice:)]) {
        [[self delegate] didCancelLoginForInvoice:[self invoiceId]];
    }
}

- (void)pinViewControllerDidBack:(PinViewController *)pinViewController {
    //Do nothing
}

#pragma mark - PinViewController delegate methods

- (void)menu:(id)sender {
    if (!_menuViewController) {
        [self setMenuViewController:[[[FZTargetManager sharedInstance] multiTarget] menuViewController]];
        
        [_ppRevealSideViewController preloadViewController:_menuViewController forSide:2];
    }else{
        [_ppRevealSideViewController pushViewController:_menuViewController onDirection:2 animated:YES];
    }
}

- (void)forceCloseMenu {
    if (_menuViewController) {
        [_ppRevealSideViewController pushViewController:_menuViewController onDirection:2 animated:NO];
    }
}

/*
 - (void)didClose:(PinViewController *)pinViewController {
 
 [_pinViewController release];
 _pinViewController = nil;
 
 //[TestFlightHelper passLoginClose];
 }
 */

#pragma mark - PaymentViewController delegate method

- (void)didScanValidInvoice:(NSString *)invoiceId {
    [self setInvoiceId:invoiceId];
    [self startPaymentProcess];
}

- (void)qrCodeisInvalid {
    
    [_hostViewController dismissViewControllerAnimated:YES completion:^{}];
    
    if([[self delegate] respondsToSelector:@selector(qrCodeisInvalid)]) {
        [[self delegate] qrCodeisInvalid];
    }
}

- (void)didCancelScanInvoice {
    
    [_hostViewController dismissViewControllerAnimated:YES completion:^{}];
    
    if([[self delegate] respondsToSelector:@selector(paymentCanceledForInvoice:)]) {
        [[self delegate] paymentCanceledForInvoice:nil];
    }
}

#pragma mark - PaymentCheckViewController delegate method

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didValidatePaymentForInvoiceId:(NSString *)invoiceId {
    
    // [_scannerViewController forceStopRunning];
    
    [_hostViewController dismissViewControllerAnimated:YES completion:^{}];
    
    if([[self delegate] respondsToSelector:@selector(paymentAcceptedForInvoice:)]) {
        [[self delegate] paymentAcceptedForInvoice:invoiceId];
    }
}

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didCancelPaymentForInvoiceId:(NSString *)invoiceId {
    
    // [_scannerViewController forceStopRunning];
    
    [_hostViewController dismissViewControllerAnimated:YES completion:^{}];
    
    if([[self delegate] respondsToSelector:@selector(paymentCanceledForInvoice:)]) {
        [[self delegate] paymentCanceledForInvoice:invoiceId];
    }
}

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didFailPaymentForInvoiceId:(NSString *)invoiceId {
    
    //[_scannerViewController forceStopRunning];
    
    [_hostViewController dismissViewControllerAnimated:YES completion:^{}];
    
    if([[self delegate] respondsToSelector:@selector(paymentFailedForInvoice:)]) {
        [[self delegate] paymentFailedForInvoice:invoiceId];
    }
}
/*
 #pragma mark - Observing methods
 
 //listen the field "connected" in the UserSession class
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 if([keyPath isEqualToString:userConnected]){
 BOOL isConnected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
 
 if(isConnected){
 
 [self goBackToCustomTabBarControllerInNavigationController:_navigationController FromPpRevealSide:_ppRevealSideViewController withTabBar:_tabBarController];
 
 //load user informations
 [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
 
 [[UserSession currentSession] setUser:context];
 
 [[CurrenciesManager currentManager] setDefaultCurrency:[[[[UserSession currentSession] user] account] currency]];
 
 [AutoCloseWindow startCloseTimer];
 
 } failureBlock:^(Error *error) {
 
 }];
 
 _isConnectionProccess = NO;
 } else {
 [self showInitialViewControllerFromPpRevealSide:_ppRevealSideViewController];
 [AutoCloseWindow stopCloseTimer];
 }
 }
 }*/

#pragma mark - ShowEula delegate method

- (void)didRefuseEula
{
    [_parentViewController dismissViewControllerAnimated:NO completion:nil];
    [[UserSession currentSession] storeAcceptedEula:NO];
    if([[self delegate] respondsToSelector:@selector(didRefuseEula)]) {
        [[self delegate] didRefuseEula];
    }
}


-(void)didAcceptEula
{
    [_parentViewController dismissViewControllerAnimated:NO completion:nil];
    [[UserSession currentSession] storeAcceptedEula:YES];
    
    if([[self delegate] respondsToSelector:@selector(didAcceptEula)]) {
        [[self delegate] didAcceptEula];
    }
    
    [self launchAppropriateBankSdkController];
}

#pragma mark - Close SDK Delegate

- (void) didCloseSdk
{
    if([[self delegate] respondsToSelector:@selector(didCloseSdk)]) {
        [[self delegate] didCloseSdk];
    }
}

#pragma mark - Force Close SDK

- (void)closingSdkAfterUnknownError {
    if(YES) {
        [[self parentViewController] dismissViewControllerAnimated:NO completion:^{}];
    }
}

- (void)closeSDK {
    NSMutableArray *controllersArray = [[NSMutableArray alloc] init];
    
    UIViewController *fzVC = [self parentViewController];
    
    UIViewController *controller = fzVC;
    
    while (controller!=nil) {
        [controllersArray addObject:controller];
        controller = [controller presentedViewController];
    }
    
    int arrayC = (int)[controllersArray count];
    
    //for each controller in the fzViewController
    for (NSInteger i=(arrayC-1); i>=0; i--) {
        
        id container = [controllersArray objectAtIndex:i];
        
        if([container isKindOfClass:[FZPortraitNavigationController class]]){
            
            UINavigationController *portraitNavC = (UINavigationController*)container;
            
            //all viewController into the FZPortraitNavigationController
            NSArray *viewControllers = [portraitNavC viewControllers];
            
            if([viewControllers count]>0){
                
                if([[viewControllers objectAtIndex:0] isKindOfClass:[CustomNavigationViewController class]]){
                    
                    UIViewController *customNavVC = [viewControllers objectAtIndex:0];
                    
                    UIViewController *paymentCheckVC = [(id)customNavVC controller];
                    
                    [(PaymentCheckViewController *)paymentCheckVC stopPolling];
                    
                    FZAFHTTPClient *httpClient = [[FZAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
                    [[httpClient operationQueue] cancelAllOperations];
                    
                    [paymentCheckVC dismissViewControllerAnimated:NO completion:^{
                        [customNavVC dismissViewControllerAnimated:NO completion:^{
                            [portraitNavC dismissViewControllerAnimated:NO completion:nil];
                        }];
                    }];
                    
                } else if([[viewControllers objectAtIndex:0] isKindOfClass:[CustomTabBarViewController class]]){
                    
                    UIViewController *customTabBarVC = [viewControllers objectAtIndex:0];
                    
                    [(id)customTabBarVC dismissViewControllerAnimated:NO completion:^{
                        [portraitNavC dismissViewControllerAnimated:NO completion:nil];
                    }];
                }
            }
        }
    }
    [controllersArray release],controllersArray=nil;
}

#pragma mark - Debug Mode

- (void)showDebugLog:(NSString *)log
{
    if([[self delegate] respondsToSelector:@selector(isDebugMode)]) {
        if([[self delegate] isDebugMode]) {
            NSLog(@"BankSDK : %@",log);
        }
    }
}

#pragma mark - Memory management

-(void) dealloc {
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [_connectionViewController release], _connectionViewController = nil;
    [_paymentCheckViewController release], _paymentCheckViewController = nil;
    [_parentViewController release], _parentViewController = nil;
    
    [_invoiceId release], _invoiceId = nil;
    
    [progressHud hide:YES];
    [progressHud release];
    progressHud = nil;
    
    [_hostViewController release];
    
    [super dealloc];
}

@end
