//
//  FZFlashizFacade.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 9/23/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

//Manager
@class FZDefaultMultiTargetManager;

//Template
@class FZDefaultTemplateColor;
@class FZDefaultTemplateFonts;

//Delegate
#import "FlashizFacadeDelegate.h"

//Controllers
@class CustomTabBarViewController;

//Menu
@class SWRevealViewController;

//Nav
#import "CustomNavigationMode.h"

/*
 * Provide utils methods to display wallet app or SDK or Bank SDK
 *
 * TODO : detailled DOC
 *
 */
@interface FZFlashizFacade : NSObject
{
    
}

#pragma mark - Constructor

/*
 * Init SDK with manager with delegate and configure Url Schemes with customer host and customer scheme
 * TODO : detailled DOC
 */
- (id)initSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme;

/* Init Bank SDK with manager and with delegate;
 * BankSDK
 * TODO : detailled DOC
 */
- (id)initBankSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate;


/*
 * Wallet App
 * TODO : detailled DOC
 */
- (id)initAppForBrand:(NSString *)brand withTargetManager:(FZDefaultMultiTargetManager *)manager withDelegate:(id<UIApplicationDelegate>)delegate withColorTemplate:(FZDefaultTemplateColor *)colorTemplate withFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplate;

#pragma mark - Present methods in SDK

/* Present Controller SDK
 * Present SDK or Bank SDK in controller
 * TODO : detailled DOC
 */
- (void) presentControllerSDK:(UIViewController *)parentViewController;

/* Push Controller SDK
 * Push SDK or Bank SDK in controller
 * TODO : detailled DOC
 */
- (void) pushControllerSDK:(UIViewController *)parentViewController;


#pragma mark - SDKs

/* Show debug log
 * Display message in console if delegate ask to get some debug information
 * TODO : detailled DOC
 */
- (void)showDebugLog:(NSString *)log;


#pragma mark - Present methods in App

/* Present a controller with custom header and custom action.
 *
 *
 */
- (void) presentFromController:(UINavigationController *)parent inAppWith:(UIViewController *)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated;


/*
 *
 *
 */
- (void) goBackToRootAndAnimated:(BOOL)animated;

/*
 * Method used to close the sdk
 */
- (void)forceCloseSdk;

/*
 * Store the user's userkey (apikey)
 */
- (void)registerUserApiKey:(NSString *)apikey;

#pragma mark - App

/* App Controller
 * Get first App controller
 * TODO : detailled DOC
 */
- (UIViewController*) appController;

/* Tab bar controller
 * TODO : detailled DOC
 */
- (CustomTabBarViewController*) tabBarController;

/* Tab bar controller Navigation
 * TODO : detailled DOC
 */
- (UINavigationController*) tabBarControllerNavigation;

/* Reveal controller
 * Manage the menu
 * TODO : detailled DOC
 */
- (SWRevealViewController*) revealController;

/* Is menu available
 * TODO : detailled DOC
 */
- (BOOL) isMenuAvailable;


/* Close Session
 * TODO : close the session if user is connected
 */
-(void)closeSession;

/* Reveal or hide menu
 * TODO : detailled DOC
 */
- (void)revealOrHideMenu;


/* Display tabBar from
 * Easy way to display the tabBar
 * TODO : detailled DOC
 */

-(void)displayTabBarFrom:(UIViewController*)controller andDismissIt:(BOOL)dismiss animated:(BOOL)animated;

/* Init Context With
 * Display the app with personnalized comportment
 */
- (void)initContextWith:(UIViewController*) controller;

#pragma mark - Execute payment

/*
 * Execute the payment with a given invoiceId
 */
- (void)executePaymentForInvoiceId:(NSString *)invoiceId
            inParentViewController:(UIViewController *)parentViewController;

/*
 * Lauch the payment process
 */
- (void)startPaymentProcess;

/*
 * Start the BankSDK in the given viewController
 */
- (void) startBankSDKinParentViewController:(UIViewController *)parentViewController;

#pragma mark - Display methods

/*
 * Display the Check Payment view
 */
- (void)displayPaymentCheckViewController;

/*
 * Display the login view in order to connect to the app
 */
- (void)displayConnectionViewAnimated:(BOOL) animated;

#pragma mark - delegate method

/*
 * The payment is accepted
 */
- (void)paymentAcceptedForInvoice:(NSString *)invoiceId;

#pragma mark - Eula

/*
 * he user has accepted the Eula
 */
- (void)didRefuseEula;

/*
 * he user has refused the Eula
 */
- (void)didAcceptEula;

#pragma mark - Close

/*
 * Hide the loading view (close SDK)
 */
- (void)hideLoadingView;

@end
