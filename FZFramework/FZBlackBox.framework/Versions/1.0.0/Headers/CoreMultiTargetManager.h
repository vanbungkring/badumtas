//
//  CoreMultiTargetManager.h
//  iMobey
//
//  Created by Yvan Moté on 10/12/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIColor;

@class InitialDetailViewController;
@class CustomTabBarViewController;
@class MenuViewController;

@class HeaderViewController;

#import "CustomNavigationMode.h"

#import "UserInformationViewControllerDelegate.h"

typedef void(^PinCompletionBlock)(NSString *pinCode);

@class PinViewController;
@class LoginViewController;
@class CountryViewController;
@class RegisterUserViewController;
@class RegisterQuestionsViewController;
@class RegisterResponseViewController;
@class RegisterCaptchaViewController;

@class TermsOfUseViewController;
#import "ValidatorEnums.h"
@class ValidatorViewController;

@class CustomNavigationViewController;
@class CustomNavigationHeaderViewController;

@class TransferHomeViewController;
@class PaymentViewController;
@class RewardsHomeViewController;
@class RewardsTermsOfUseViewController;

@class AccountBannerViewController;

@class HistoryViewController;

@class ActionSuccessfulViewController;
@class ActionSuccessfulAfterPaymentViewController;

@class FZTransferReceiveStep1ViewController;
@class TransferReceiveStep2ViewController;

@class TransferStep1ViewController;

@class UserInformationViewController;

@class PaymentTopupViewController;
@class CardListViewController;
@class TimeoutViewController;
@class CheckMyAccountViewController;
@class ProximityMapViewController;
@class TutorialViewController;
@class FaqViewController;

@class AllLoyaltyProgramsNavBarOpenedViewController;
@class AllLoyaltyProgramsNavBarViewController;
@class AllLoyaltyProgramsViewController;
@class LoyaltyProgramDetailsViewController;
@class YourLoyaltyProgramsViewController;
@class YourLoyaltyProgramDetailsViewController;
@class LoyaltyCard;
@class LoyaltyProgram;

@class ScanPayViewController;
@class CreateCardViewController;
@class CreateCardWithBraintreeViewController;

@class PaymentCheckViewController;
@class FZTipViewController;

@class DatePickerViewController;
@class ForgottenPasswordSendMailViewController;
@class ForgottenPasswordSecretAnswerViewController;
@class ForgottenPasswordNewPasswordViewController;
@class UIViewController;
@class SPCreditCard;
@class FZPortraitNavigationController;

@class Error;

@class CreditCard;
@class Invoice;

//Model
@class User;

#import <FZAPI/FZFilesEnum.h>

@protocol CoreMultiTargetManager <NSObject>


-(FZPortraitNavigationController*)portraitNavigationControllerWithRootViewController:(UIViewController*)controller;

- (FZTipViewController *)tipViewControllerWithInvoice:(Invoice *)invoice andTipAmount:(double)tipAmount;

- (UIViewController *)initialViewController;
- (InitialDetailViewController *)initialDetailViewControllerWithTitle:(NSString *)title imageName:(NSString *)imageName;
- (CustomTabBarViewController *)customTabBarViewController;
- (MenuViewController *)menuViewController;

- (PinViewController *)pinViewController;
- (PinViewController *)pinViewControllerWithModeSmall;
- (PinViewController *)pinViewControllerWithCompletionBlock:(PinCompletionBlock)completionBlock navigationTitle:(NSString *)navigationTitle title:(NSString *)title titleHeader:(NSString *)titleheader description:(NSString *)description animated:(BOOL)animated modeSmall:(BOOL)isSmall;

- (LoginViewController *)loginViewController;
- (LoginViewController *)loginViewControllerWithMail:(NSString *)email andPassword:(NSString *)pwd;
- (CountryViewController *)countryViewController;
- (RegisterUserViewController *)registerUserViewControllerWithUser:(User *)user;
- (RegisterQuestionsViewController *)registerQuestionsViewControllerWithUser:(User *)user;
- (RegisterResponseViewController *)registerResponseViewControllerWithUser:(User *)user;

- (TermsOfUseViewController *)termsOfUseViewControllerWithUrl:(NSString *)url;
- (ValidatorViewController *)validatorViewControllerWithMode:(ValidatorMode)mode skin:(ValidatorSkin)skin;

- (CustomNavigationViewController *)customNavigationViewControllerWithController:(HeaderViewController *)viewController andMode:(CustomNavigationMode)mode;
- (CustomNavigationHeaderViewController *)customNavigationHeaderViewControllerWithMode:(CustomNavigationMode)mode;

- (TransferHomeViewController *)tranferHomeViewController;
- (PaymentViewController *)paymentViewController;
- (RewardsHomeViewController *)rewardsHomeViewController;
- (RewardsTermsOfUseViewController *)rewardsTermsOfUserViewController;

- (AccountBannerViewController *)accountBannerViewController;
- (AccountBannerViewController *)accountBannerViewControllerWithShowAmount;
- (AccountBannerViewController *)accountBannerViewControllerLight;

- (HistoryViewController *)historyViewController;

- (ActionSuccessfulViewController *)actionSuccessfullViewControllerWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor arrowImage:(UIImage *)image;
- (ActionSuccessfulViewController *)actionSuccessfullViewControllerWithTitle:(NSString *)titleView backgroundColor:(UIColor *)backgroundColor arrowImage:(UIImage *)image andError:(Error *) anError;
- (ActionSuccessfulViewController *)actionSuccessfullViewControllerWithTitle:(NSString *)titleView backgroundColor:(UIColor *)backgroundColor arrowImage:(UIImage *)image andBackgroundImage:(NSString *)backgroundImageName inBundleName:(FZBundleName)aBundleName;

- (ActionSuccessfulAfterPaymentViewController *)actionSuccessFulAfterWithPaymentNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon;

- (FZTransferReceiveStep1ViewController *)transferReceiveStep1ViewController;
- (TransferReceiveStep2ViewController *)transferReceiveStep2ViewControllerWithUrl:(NSString *)url amount:(NSString *)amount currency:(NSString *)currency;

- (TransferStep1ViewController *)transferStep1ViewController;

- (UIViewController *)userInformationViewControllerWithDelegate:(UIViewController*)delegate;


//Menu
- (PaymentTopupViewController *)paymentTopupViewController;
- (PaymentTopupViewController *)paymentTopupViewControllerWithDelegate:(UIViewController*)delegate;
- (CardListViewController *)cardListViewController;
- (UserInformationViewController *)userInformationViewController;
- (TimeoutViewController *)timeoutViewController;
- (CheckMyAccountViewController *)checkMyAccountViewController;
- (ProximityMapViewController *)proximityMapViewController;
- (TutorialViewController *)tutorialViewController;
- (FaqViewController *)faqViewController;

//Loyalty
- (AllLoyaltyProgramsNavBarOpenedViewController *)allLoyaltyProgramsNavBarOpenedViewController;
- (AllLoyaltyProgramsNavBarViewController *)allLoyaltyProgramsNavBarViewController;
- (AllLoyaltyProgramsViewController *)allLoyaltyProgramsViewController;
- (LoyaltyProgramDetailsViewController *)loyaltyProgramDetailsViewControllerWithProgram:(LoyaltyProgram *)loyaltyProgram;
- (YourLoyaltyProgramsViewController *)yourLoyaltyProgramsViewController;
- (YourLoyaltyProgramDetailsViewController *)yourLoyaltyProgramDetailsViewControllerWithLoyaltyCard:(LoyaltyCard *)card program:(LoyaltyProgram *)program;

//Card
- (ScanPayViewController *)scanPayViewController;
- (UIViewController *)scanPayViewControllerWithDelegate:(UIViewController*)scanPayDelegate;

- (CreateCardViewController *)createCardViewController __attribute__((deprecated)); //Must be replace by below method (or not?)
- (UIViewController *)createCardViewControllerFromPaymentView:(bool)paymentView andDelegate:(UIViewController*)delegate andFreshCreditCard:(CreditCard*)creditCard;

- (CreateCardWithBraintreeViewController *)createCardWithBraintreeViewController;

//Payment
- (PaymentCheckViewController *)paymentCheckViewController;

- (DatePickerViewController *)datePickerViewControllerWithSelectedDate:(NSDate*)selectedDate withMinimunDate:(NSDate*)minimumDate andMaximunDate:(NSDate*)maximumDate;

//Forgotten password
- (ForgottenPasswordSendMailViewController *)forgottenPasswordSendMailViewControllerWithMail:(NSString *)email;
- (ForgottenPasswordSecretAnswerViewController *)forgottenPasswordSecretAnswerViewControllerWithToken:(NSString *)aToken;
- (ForgottenPasswordNewPasswordViewController *)forgottenPasswordNewPasswordViewControllerWithToken:(NSString *)aToken;

//CardList
- (CardListViewController *)cardListViewControllerWithSelectAndEditionMode:(BOOL)editionMode andTitle:(NSString*)title;

@end
