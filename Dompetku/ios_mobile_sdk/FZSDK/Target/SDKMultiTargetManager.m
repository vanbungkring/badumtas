//
//  SDKMultiTargetManager.m
//  FZApp
//
//  Created by Olivier Demolliens on 4/22/14.
//  Copyright (c) 2014 flashiz. All rights reserved.
//

#import "SDKMultiTargetManager.h"

//BlackBox
#import <FZBlackBox/CustomTabBarViewController.h>
#import <FZBlackBox/TermsOfUseViewController.h>
#import <FZBlackBox/CustomNavigationHeaderViewController.h>
#import <FZBlackBox/CustomNavigationViewController.h>
#import <FZBlackBox/PinViewController.h>
#import <FZBlackBox/LoginViewController.h>
#import <FZBlackBox/FZPortraitNavigationController.h>

//Payment
#import <FZPayment/PaymentViewController.h>
#import <FZPayment/HistoryViewController.h>
#import <FZPayment/ActionSuccessfulViewController.h>
#import <FZPayment/ActionSuccessfulAfterPaymentViewController.h>
#import <FZPayment/AccountBannerViewController.h>
#import <FZPayment/PaymentCheckViewController.h>
#import <FZPayment/FZTipViewController.h>

@implementation SDKMultiTargetManager

-(FZPortraitNavigationController*)portraitNavigationControllerWithRootViewController:(UIViewController*)controller
{
    FZPortraitNavigationController *navigationController = [[[FZPortraitNavigationController alloc] initWithRootViewController:controller]autorelease];
    
    navigationController.navigationBarHidden = YES;
    
    return navigationController;
}

- (FZTipViewController *)tipViewControllerWithInvoice:(Invoice *)invoice andTipAmount:(double)tipAmount
{
    FZTipViewController *tipController = [[[FZTipViewController alloc]initWithInvoice:invoice andTipAmount:tipAmount]autorelease];
    
    return tipController;
}

- (UIViewController *)initialViewController {
    return nil;
}

- (InitialDetailViewController *)initialDetailViewControllerWithTitle:(NSString *)title imageName:(NSString *)imageName {
    //SDK: Nothing to do
    return nil;
}

- (CustomTabBarViewController *)customTabBarViewController {
    CustomTabBarViewController *customTabBarViewController = [[[CustomTabBarViewController alloc] init] autorelease];
    
    return customTabBarViewController;
}

- (MenuViewController *)menuViewController {
    //SDK: Nothing to do
    return nil;
}

- (PinViewController *)pinViewController {
    PinViewController *pinViewController = [[[PinViewController alloc] init] autorelease];
    
    return pinViewController;
}

- (PinViewController *)pinViewControllerWithModeSmall {
    PinViewController *pinViewController = [[[PinViewController alloc] initWithModeSmall] autorelease];
    
    return pinViewController;
}

- (PinViewController *)pinViewControllerWithCompletionBlock:(PinCompletionBlock)completionBlock navigationTitle:(NSString *)navigationTitle title:(NSString *)title titleHeader:(NSString *)titleheader description:(NSString *)description animated:(BOOL)animated modeSmall:(BOOL)isSmall{
    PinViewController *pinViewController = [[[PinViewController alloc] initWithCompletionBlock:completionBlock
                                                                            andNavigationTitle:navigationTitle
                                                                                      andTitle:title
                                                                                andTitleHeader:titleheader
                                                                                andDescription:description
                                                                                      animated:animated
                                                                                     modeSmall:isSmall] autorelease];
    
    return pinViewController;
}


- (LoginViewController *)loginViewController {
    LoginViewController *loginViewController = [[[LoginViewController alloc] init] autorelease];
    return loginViewController;
}

- (LoginViewController *)loginViewControllerWithMail:(NSString *)email andPassword:(NSString *)pwd {
    return nil;
}

- (CountryViewController *)countryViewController {
    return nil;
}

- (RegisterUserViewController *)registerUserViewControllerWithUser:(User *)user {
    return nil;
}

- (RegisterQuestionsViewController *)registerQuestionsViewControllerWithUser:(User *)user {
    return nil;
}

- (RegisterResponseViewController *)registerResponseViewControllerWithUser:(User *)user {
    return nil;
}

- (TermsOfUseViewController *)termsOfUseViewControllerWithUrl:(NSString *)url {
    return nil;
}

- (ValidatorViewController *)validatorViewControllerWithMode:(ValidatorMode)mode skin:(ValidatorSkin)skin {
    return nil;
}

#pragma mark - VC

- (CustomNavigationViewController *)customNavigationViewControllerWithController:(HeaderViewController *)viewController andMode:(CustomNavigationMode)mode {
    CustomNavigationViewController *customNavigationViewController = [[[CustomNavigationViewController alloc] initWithController:viewController andMode:mode] autorelease];
    
    return customNavigationViewController;
}

- (CustomNavigationHeaderViewController *)customNavigationHeaderViewControllerWithMode:(CustomNavigationMode)mode {
    CustomNavigationHeaderViewController *customNavigationHeaderViewController = [[[CustomNavigationHeaderViewController alloc] initWithMode:mode] autorelease];
    
    return customNavigationHeaderViewController;
}

- (TransferHomeViewController *)tranferHomeViewController {
    return nil;
}

- (PaymentViewController *)paymentViewController {
    PaymentViewController *paymentViewController = [[[PaymentViewController alloc] init] autorelease];
    
    return paymentViewController;
}

- (RewardsHomeViewController *)rewardsHomeViewController {
    return nil;
}

- (RewardsTermsOfUseViewController *)rewardsTermsOfUserViewController {
    return nil;
}

- (AccountBannerViewController *)accountBannerViewController {
    AccountBannerViewController *accountBannerViewController = [[[AccountBannerViewController alloc] init] autorelease];
    
    return accountBannerViewController;
}

- (AccountBannerViewController *)accountBannerViewControllerWithShowAmount {
    AccountBannerViewController *accountBannerViewController = [[[AccountBannerViewController alloc] initShowAmount] autorelease];
    
    return accountBannerViewController;
}

- (AccountBannerViewController *)accountBannerViewControllerLight {
    AccountBannerViewController *accountBannerViewController = [[[AccountBannerViewController alloc] initLight] autorelease];
    
    return accountBannerViewController;
}

- (HistoryViewController *)historyViewController {
    return nil;
}

- (ActionSuccessfulViewController *)actionSuccessfullViewControllerWithTitle:(NSString *)titleView backgroundColor:(UIColor *)backgroundColor arrowImage:(UIImage *)image {
    return [self actionSuccessfullViewControllerWithTitle:titleView backgroundColor:backgroundColor arrowImage:image andError:nil];
}

- (ActionSuccessfulViewController *)actionSuccessfullViewControllerWithTitle:(NSString *)titleView backgroundColor:(UIColor *)backgroundColor arrowImage:(UIImage *)image andError:(Error *) anError {
    ActionSuccessfulViewController *actionSucessFulViewController = [[[ActionSuccessfulViewController alloc] initWithTitle:titleView andBackgroundColor:backgroundColor andArrowImage:image andError:anError] autorelease];
    
    return actionSucessFulViewController;
}

- (ActionSuccessfulViewController *)actionSuccessfullViewControllerWithTitle:(NSString *)titleView backgroundColor:(UIColor *)backgroundColor arrowImage:(UIImage *)image andBackgroundImage:(NSString *)backgroundImageName inBundleName:(FZBundleName)aBundleName {
    ActionSuccessfulViewController *actionSucessFulViewController = [[[ActionSuccessfulViewController alloc] initWithTitle:titleView andBackgroundColor:backgroundColor andArrowImage:image andBackgroundImage:backgroundImageName inBundleName:aBundleName] autorelease];
    
    return actionSucessFulViewController;
}

- (ActionSuccessfulAfterPaymentViewController *)actionSuccessFulAfterWithPaymentNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon {
    
    ActionSuccessfulAfterPaymentViewController *validateViewController = [[[ActionSuccessfulAfterPaymentViewController alloc] initWithNbOfGeneratedPoints:nbOfGeneratedPoints nbOfPointsToGenerateACoupon:nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:nbOfPointsOnTheLoyaltyCard amountOfACoupon:amountOfACoupon] autorelease];
    
    return validateViewController;
}

- (FZTransferReceiveStep1ViewController *)transferReceiveStep1ViewController {
    return nil;
}

- (TransferReceiveStep2ViewController *)transferReceiveStep2ViewControllerWithUrl:(NSString *)url amount:(NSString *)amount currency:(NSString *)currency {
    return nil;
}

- (TransferStep1ViewController *)transferStep1ViewController {
    return nil;
}

- (UIViewController *)userInformationViewController {
    return nil;
}

- (UIViewController *)createCardViewControllerFromPaymentView:(bool)paymentView andDelegate:(UIViewController *)delegate andFreshCreditCard:(CreditCard *)creditCard{
    return nil;
}

- (UIViewController *)userInformationViewControllerWithDelegate:(UIViewController *)delegate {
    return nil;
}

#pragma mark - Menu

- (PaymentTopupViewController *)paymentTopupViewController {
    return nil;
}

- (PaymentTopupViewController *)paymentTopupViewControllerWithDelegate:(UIViewController *)delegate {
    return nil;
}

- (CardListViewController *)cardListViewController {
    return nil;
}

- (CardListViewController *)cardListViewControllerWithEditionMode:(BOOL)editionMode andTitle:(NSString*)title {
    return nil;
}

- (CardListViewController *)cardListViewControllerWithSelectAndEditionMode:(BOOL)editionMode andTitle:(NSString*)title {
    return nil;
}

- (TimeoutViewController *)timeoutViewController {
    return nil;
}

- (CheckMyAccountViewController *)checkMyAccountViewController {
    return nil;
}

- (ProximityMapViewController *)proximityMapViewController {
    return nil;
}

- (TutorialViewController *)tutorialViewController {
    return nil;
}

- (FaqViewController *)faqViewController {
    return nil;
}

#pragma mark - Loyalty

- (AllLoyaltyProgramsNavBarOpenedViewController *)allLoyaltyProgramsNavBarOpenedViewController {
    return nil;
}

- (AllLoyaltyProgramsNavBarViewController *)allLoyaltyProgramsNavBarViewController {
    return nil;
}

- (AllLoyaltyProgramsViewController *)allLoyaltyProgramsViewController {
    return nil;
}

- (LoyaltyProgramDetailsViewController *)loyaltyProgramDetailsViewControllerWithProgram:(LoyaltyProgram *)loyaltyProgram {
    return nil;
}

- (YourLoyaltyProgramsViewController *)yourLoyaltyProgramsViewController {
    return nil;
}
- (YourLoyaltyProgramDetailsViewController *)yourLoyaltyProgramDetailsViewControllerWithLoyaltyCard:(LoyaltyCard *)card program:(LoyaltyProgram *)program {
    return nil;
}


#pragma mark - Cards


- (ScanPayViewController *)scanPayViewController {
    return nil;
}


- (UIViewController *)scanPayViewControllerWithDelegate:(UIViewController*)scanPayDelegate {
    return nil;
}


- (CreateCardViewController *)createCardViewController {
    return nil;
}

- (CreateCardWithBraintreeViewController *)createCardWithBraintreeViewController {
    return nil;
}

#pragma mark - Payment

- (PaymentCheckViewController *)paymentCheckViewController {
    PaymentCheckViewController *paymentCheckViewController = [[[PaymentCheckViewController alloc] init] autorelease];
    
    return paymentCheckViewController;
}

- (DatePickerViewController *)datePickerViewControllerWithSelectedDate:(NSDate*)selectedDate withMinimunDate:(NSDate*)minimumDate andMaximunDate:(NSDate*)maximumDate {
    return nil;
}

#pragma mark - Forgotten password
- (ForgottenPasswordSendMailViewController *)forgottenPasswordSendMailViewControllerWithMail:(NSString *)email {
    return nil;
}

- (ForgottenPasswordSecretAnswerViewController *)forgottenPasswordSecretAnswerViewControllerWithToken:(NSString *)aToken {
    return nil;
}

- (ForgottenPasswordNewPasswordViewController *)forgottenPasswordNewPasswordViewControllerWithToken:(NSString *)aToken {
    return nil;
}

@end
