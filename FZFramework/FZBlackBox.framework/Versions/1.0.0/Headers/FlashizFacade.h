
//
//  FlashizFacade.h
//  FlashIzMobilePaymentLib
//
//  Created by David Ledanseur on 08/02/12.
//  Modified by Yvan Moté on 13/12/13.
//  Modified by Olivier Demolliens on 24/07/14.
//  Copyright (c) 2012-2014 Flashiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/FlashizFacadeDelegate.h>

@class MainPageLoadingViewDelegate;

@class FZDefaultMultiTargetManager;
@class FZDefaultTemplateColor;
@class FZDefaultTemplateFonts;
@class PPRevealSideViewController;
@class CustomTabBarViewController;


#import "PinViewController.h"

/**
 The object that acts as the delegate of the receiving FlashizFacade.
 
 @discussion The delegate must adopt the FlashizPaymentDelegate protocol. The delegate is not retained.
 */


@interface FlashizFacade : NSObject {
    
}

/**
 Indicates whether the login view or pin view will be presented modally or with a push transition.
 
 @discussion The default value of this property is NO.
 
 */

@property (nonatomic, assign, getter = isModal) BOOL modal;
@property (assign, nonatomic) BOOL unknownErrorOccured;

/**
 * Application initializer
 * TODO : documentation !!!!
 */
- (id)initAppForBrand:(NSString *)brand withTargetManager:(FZDefaultMultiTargetManager *)manager withDelegate:(id<UIApplicationDelegate>)delegate withColorTemplate:(FZDefaultTemplateColor *)colorTemplate withFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplate;


/**
 * SDK initializer
 * @param manager bank SDK target
 * @param delegate FlashizFacadeDelegate
 * @return FlashizFacade
 */
- (id)initSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>)delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme;

/**
 * Send the user api key to the SDK.
 * @param userKey must be valid
 */
- (void)storeUserKey:(NSString *)userKey;

/**
 * Bank SDK initializer
 * @param manager bank SDK target
 * @param delegate FlashizFacadeDelegate
 * @return FlashizFacade
 */
- (id)initBankSDKWith:(FZDefaultMultiTargetManager*)manager withDelegate:(id<FlashizFacadeDelegate>) delegate;

/**
 Execute the payment process for an invoice id and display it from a parent view controller.
 
 @param invoiceId The Flashiz invoice id used to pay.
 @param parentViewController The parentViewController from which Flashiz view controllers will be displayed.
 
 */
- (void)executePaymentForInvoiceId:(NSString *)invoiceId
            inParentViewController:(UIViewController *)parentViewController;

/**
 Starts the Bank Sdk
 
 */
- (void) startBankSDKinParentViewController:(UIViewController *)parentViewController;

/**
 Close the sdk.
 */
-(void) closeSDK;

#pragma mark - AppDelegate


/**
 * TODO : doc?
 */
- (void)launchPinCodeAndpresentedWith:(UIViewController *)aController andUseTabBar:(CustomTabBarViewController *)tabBarController andNavController:(UINavigationController *)navController andPpRevealSide:(PPRevealSideViewController *)ppRevealSideViewController;

/**
 * TODO : doc?
 */
- (void)showInitialViewControllerFromPpRevealSide:(PPRevealSideViewController *)ppRevealSideViewController andNavController:(UINavigationController *)navController andUseTabBar:(CustomTabBarViewController *)tabBarController;

/**
 * TODO : doc?
 */
- (void)goBackToCustomTabBarController;

/**
 * TODO : doc?
 */
- (void)menu:(id)sender;

/**
 * TODO : doc?
 */
- (void)forceCloseMenu;

/**
 * TODO : doc?
 */
- (PPRevealSideViewController *) ppRevealSideViewController;

#pragma mark - BankSDK

/*
 * Inform FlashizFacade with debug information
 */
- (void)showDebugLog:(NSString *)log;

/*
 * Inform FlashizFacade with user api key
 */
- (void)registerUserApiKey:(NSString *)apikey;

@end
