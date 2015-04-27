//
//  StatisticsFactory.m
//  FZBlackBox
//
//  Created by julian Clémot on 09/07/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "StatisticsFactory.h"
#import "CrashlyticsHelper.h"
#import "UniversalAnalyticsHelper.h"


//Target manager
#import <FZBlackBox/FZTargetManager.h>
#import <FZBlackBox/CoreMultiTargetManager.h>

//Session
#import <FZAPI/UserSession.h>

@interface StatisticsFactory ()


@property (nonatomic, assign) CrashlyticsHelper *crashlyticsTracker;
@property (nonatomic, assign) UniversalAnalyticsHelper *analyticsTracker;

@end


@implementation StatisticsFactory



#pragma mark - Shared Instance

static StatisticsFactory *sharedInstance = nil;

+ (StatisticsFactory *)sharedInstance {
    static dispatch_once_t onceBundleHelper;
    dispatch_once(&onceBundleHelper, ^{
        sharedInstance = [[StatisticsFactory alloc] init];
    });
    
    return [[sharedInstance retain] autorelease];
    
}

#pragma mark - Init

- (StatisticsFactory*)init
{
    self = [super init];
    if (self) {
        [self setCrashlyticsTracker:[CrashlyticsHelper sharedInstance]];
        [self setAnalyticsTracker:[UniversalAnalyticsHelper sharedInstance]];
    }
    return self;
}

#pragma mark - Send Event Methods

- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action andData:(NSString *)data{
    
    //we first look if we are in an app and not in a sdk
    if([[FZTargetManager sharedInstance] mainTarget] == FZAppTarget) {
        [[self crashlyticsTracker] sendWithScreenView:screenView andCategory:category andAction:action andData:data];
        //then we look if we are not in production environment
        if([[UserSession currentSession] environment] !=nil && ![[[UserSession currentSession] environment] isEqualToString:@""]){ // if we are not in production
            //we look which app it is
            if([[[[FZTargetManager sharedInstance] brandName] uppercaseString] isEqualToString:[@"flashiz" uppercaseString]]) {// we're in flashiz app
                [[self analyticsTracker] setDefaultTrackerToDebugFlashiz];
                //send event
                [[self analyticsTracker] sendWithScreenView:screenView andCategory:category andAction:action andData:data];
            }else if([[[[FZTargetManager sharedInstance] brandName] uppercaseString] isEqualToString:[@"leclerc" uppercaseString]]) {//we're in Leclerc Flash app
                [[self analyticsTracker] setDefaultTrackerToDebugLeclerc];
                //send event
                [[self analyticsTracker] sendWithScreenView:screenView andCategory:category andAction:action andData:data];
            }
            else{
                //no tracking
            }
        }else{ //if we in production
            //we look which app it is
            if([[[[FZTargetManager sharedInstance] brandName] uppercaseString] isEqualToString:[@"flashiz" uppercaseString]]) { // we're in flashiz app
                [[self analyticsTracker] setDefaultTrackerToFlashizProd];
                //send event
                [[self analyticsTracker] sendWithScreenView:screenView andCategory:category andAction:action andData:data];
            }else if([[[[FZTargetManager sharedInstance] brandName] uppercaseString] isEqualToString:[@"leclerc" uppercaseString]]) { //we're in Leclerc Flash app
                [[self analyticsTracker] setDefaultTrackerToLeclercProd];
                //send event
                [[self analyticsTracker] sendWithScreenView:screenView andCategory:category andAction:action andData:data];
            }
            else{
                //no tracking
            }
        }
    } else if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget || [[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget){
        //in banksdk and sdk, only crashlytics.
        [[self crashlyticsTracker] sendWithScreenView:screenView andCategory:category andAction:action andData:data];
    } else {
        //no tracking
    }
}

- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action{
    [[StatisticsFactory sharedInstance] sendWithScreenView:screenView andCategory:category andAction:action andData:@""];
}


#pragma mark - Home View

- (void)checkPointCreateAccount {
    [self sendWithScreenView:R_VIEW_START_SCREEN andCategory:R_CHECKPOINT_SLIDESHOW andAction:createAccount];
}

- (void)checkPointConnect {
    [self sendWithScreenView:R_VIEW_START_SCREEN andCategory:R_CHECKPOINT_SLIDESHOW andAction:connectMainScreen];
}

#pragma mark - Create Account - Select Countries

- (void)checkPointCreateAccountQuitCountry {
    [self sendWithScreenView:R_VIEW_SELECT_COUNTRY_SCREEN andCategory:R_CHECKPOINT_ACCOUNT_CREATION_COUNTRY andAction:createAccountQuitCountry];
}

- (void)checkPointCreateAccountSearchCountryWithCountry:(NSString *)countryName {
    [self sendWithScreenView:R_VIEW_SELECT_COUNTRY_SCREEN andCategory:R_CHECKPOINT_ACCOUNT_CREATION_COUNTRY andAction:createAccountSearchCountry andData:countryName];
}

#pragma mark - Create Account - Create Credentials


- (void)checkPointCreateAccountQuitLogin {
    [self sendWithScreenView:R_VIEW_CREATE_USER andCategory:R_CHECKPOINT_ACCOUNT_CREATION_USER_CREATION andAction:createAccountQuitLogin];
}

- (void)checkPointCreateAccountShowPassword {
    [self sendWithScreenView:R_VIEW_CREATE_USER andCategory:R_CHECKPOINT_ACCOUNT_CREATION_USER_CREATION andAction:createAccountShowPassword];
}

- (void)checkPointCreateAccountReadCGU {
    [self sendWithScreenView:R_VIEW_CREATE_USER andCategory:R_CHECKPOINT_ACCOUNT_CREATION_USER_CREATION andAction:createAccountReadCGU];
}

- (void)checkPointCreateAccountValidateLogin {
    [self sendWithScreenView:R_VIEW_CREATE_USER andCategory:R_CHECKPOINT_ACCOUNT_CREATION_USER_CREATION andAction:createAccountValidateLogin];
}

- (void)checkPointCreateAccountRewriteEmail {
    [self sendWithScreenView:R_VIEW_CREATE_USER andCategory:R_CHECKPOINT_ACCOUNT_CREATION_EMAIL_CHECK andAction:createAccountRewriteEmail];
}

- (void)checkPointCreateAccountRewritePassword {
    [self sendWithScreenView:R_VIEW_CREATE_USER andCategory:R_CHECKPOINT_ACCOUNT_CREATION_PSW_CHECK andAction:createAccountRewritePassword];
}

#pragma mark - Create Account - Select Security question

- (void)checkPointCreateAccountQuitQuestion {
    [self sendWithScreenView:R_VIEW_CHOOSE_SECURITY_QUESTION andCategory:R_CHECKPOINT_ACCOUNT_CREATION_SECURITY_QUESTION andAction:createAccountQuitQuestion];
}

#pragma mark - Create Account - Answer Security question

- (void)checkPointCreateAccountQuitAnswer {
    [self sendWithScreenView:R_VIEW_ANSWER_SECURITY_QUESTION andCategory:R_CHECKPOINT_ACCOUNT_CREATION_SECURITY_ANSWER andAction:createAccountQuitAnswer];
}

- (void)checkPointCreateAccountValidateAnswer {
    [self sendWithScreenView:R_VIEW_ANSWER_SECURITY_QUESTION andCategory:R_CHECKPOINT_ACCOUNT_CREATION_SECURITY_ANSWER andAction:createAccountValidateAnswer];
}

#pragma mark - Connect

- (void)checkPointConnectQuitLogin {
    [self sendWithScreenView:R_VIEW_LOGIN andCategory:R_CHECKPOINT_LOGIN andAction:connectQuitLogin];
}

- (void)checkPointConnectViewPassword {
    [self sendWithScreenView:R_VIEW_LOGIN andCategory:R_CHECKPOINT_LOGIN andAction:connectViewPassword];
}

- (void)checkPointConnectValidateLogin {
    [self sendWithScreenView:R_VIEW_LOGIN andCategory:R_CHECKPOINT_LOGIN andAction:connectValidateLogin];
}

- (void)checkPointConnectForgottenPassword {
    [self sendWithScreenView:R_VIEW_LOGIN andCategory:R_CHECKPOINT_LOGIN andAction:connectForgottenPassword];
}

#pragma mark - Create Pincode

- (void)checkPointCreatePincodeQuit {
    [self sendWithScreenView:R_VIEW_PINCODE andCategory:R_CHECKPOINT_PINCODE_CREATION andAction:createPincodeQuit];
}

- (void)checkPointCreatePincodeDone {
    [self sendWithScreenView:R_VIEW_PINCODE andCategory:R_CHECKPOINT_PINCODE_CONFIRM andAction:createPincodeDone];
}

#pragma mark - Connect With Pincode

- (void)checkPointConnectPincodeQuit {
    [self sendWithScreenView:R_VIEW_PINCODE andCategory:R_CHECKPOINT_PINCODE_CHECK andAction:connectPincodeQuit];
}

- (void)checkPointConnectPincode {
    [self sendWithScreenView:R_VIEW_PINCODE andCategory:R_CHECKPOINT_PINCODE_CHECK andAction:connectPincode];
}

#pragma mark - All Views

- (void)checkPointViewHistory {
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_PAYMENT_CONFIRM andAction:viewHistory];
}

- (void)checkPointAddAvatar {
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_PAYMENT_CONFIRM andAction:addAvatar];
}

- (void)checkPointTabBarPay{
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_TABBAR_PAY andAction:tabBarPay];
}
- (void)checkPointTabBarTransfer{
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_TABBAR_P2P andAction:tabBarTransfer];
}
- (void)checkPointTabBarRewards{
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_TABBAR_REWARDS andAction:tabBarRewards];
}

#pragma mark - Scanner View

- (void)checkPointScanAddCard {
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_SCAN_NO_CARD andAction:scanAddCard];
}

- (void)checkPointScanAddInfo {
    [self sendWithScreenView:R_VIEW_SCAN andCategory:R_CHECKPOINT_SCAN_TRIAL andAction:scanAddInfo];
}

#pragma mark - Pay Invoice

- (void)checkPointPaymentQuit {
    [self sendWithScreenView:R_VIEW_PAYMENT_CONFIRM andCategory:R_CHECKPOINT_PAYMENT_CONFIRM andAction:paymentQuit];
}

- (void)checkPointPaymentUseCoupons {
    [self sendWithScreenView:R_VIEW_PAYMENT_CONFIRM andCategory:R_CHECKPOINT_PAYMENT_CONFIRM andAction:paymentUseCoupons];
}

- (void)checkPointPaymentValidate {
    [self sendWithScreenView:R_VIEW_PAYMENT_CONFIRM andCategory:R_CHECKPOINT_PAYMENT_CONFIRM andAction:paymentValidate];
}

#pragma mark - Action Successfull - Payment Done

- (void)checkPointPaymentDoneSeeShops {
    [self sendWithScreenView:R_VIEW_PAYMENT_POPUP_CONFIRM andCategory:R_CHECKPOINT_PAYMENT_POPUP_CONFIRM andAction:paymentDoneSeeShops];
}

- (void)checkPointPaymentDone {
    [self sendWithScreenView:R_VIEW_PAYMENT_POPUP_CONFIRM andCategory:R_CHECKPOINT_PAYMENT_POPUP_CONFIRM andAction:paymentDone];
}

#pragma mark - History

- (void)checkPointHistoryQuit {
    [self sendWithScreenView:R_VIEW_HISTORY andCategory:R_CHECKPOINT_HISTORY andAction:historyQuit];
}

- (void)checkPointHistoryPending {
    [self sendWithScreenView:R_VIEW_HISTORY andCategory:R_CHECKPOINT_HISTORY andAction:historyPending];
}

- (void)checkPointHistoryCredit {
    [self sendWithScreenView:R_VIEW_HISTORY andCategory:R_CHECKPOINT_HISTORY andAction:historyCredit];
}

- (void)checkPointHistoryDebit {
    [self sendWithScreenView:R_VIEW_HISTORY andCategory:R_CHECKPOINT_HISTORY andAction:historyDebit];
}

- (void)checkPointHistoryAll {
    [self sendWithScreenView:R_VIEW_HISTORY andCategory:R_CHECKPOINT_HISTORY andAction:historyAll];
}

#pragma mark - Transfer

- (void)checkPointTransferSendMoney {
    [self sendWithScreenView:R_VIEW_P2P andCategory:R_CHECKPOINT_P2P_START andAction:transferSendMoney];
}

- (void)checkPointTransferReceiveMoney {
    [self sendWithScreenView:R_VIEW_P2P andCategory:R_CHECKPOINT_P2P_START andAction:transferReceiveMoney];
}

#pragma mark - Receive

- (void)checkPointReceiveQuit {
    [self sendWithScreenView:R_VIEW_RECEIVE_ENTER_AMOUNT andCategory:R_CHECKPOINT_P2P_RECEIVE_AMOUNT andAction:receiveQuit];
}

#pragma mark - Receive QR Code

- (void)checkPointReceiveQRCodeQuit {
    [self sendWithScreenView:R_VIEW_RECEIVE_QRCODE andCategory:R_CHECKPOINT_P2P_RECEIVE_AMOUNT_STEP_TWO andAction:receiveQRCodeQuit];
}

#pragma mark - Action Successfull - Receive Done

- (void)checkPointReceiveQRCodeDone {
    [self sendWithScreenView:R_VIEW_RECEIVE_POPUP andCategory:R_CHECKPOINT_P2P_POPUP_RECEIVE andAction:receiveQRCodeDone];
}

#pragma mark - Send

- (void)checkPointSendQuit {
    [self sendWithScreenView:R_VIEW_SEND andCategory:R_CHECKPOINT_P2P_SEND andAction:sendQuit];
}

- (void)checkPointSendSearch {
    [self sendWithScreenView:R_VIEW_SEND andCategory:R_CHECKPOINT_P2P_SEND_AMOUNT andAction:sendSearch];
}

- (void)checkPointSendComment {
    [self sendWithScreenView:R_VIEW_SEND andCategory:R_CHECKPOINT_P2P_SEND_AMOUNT andAction:sendComment];
}

- (void)checkPointSendValidate {
    [self sendWithScreenView:R_VIEW_SEND andCategory:R_CHECKPOINT_P2P_SEND_AMOUNT andAction:sendValidate];
}

#pragma mark - Action Successfull - Send Done

- (void)checkPointSendQRCodeDone {
    [self sendWithScreenView:R_VIEW_SEND_POPUP andCategory:R_CHECKPOINT_P2P_POPUP_SEND andAction:sendQRCodeDone];
}

#pragma mark - Rewards My Programs Detail

- (void)checkPointRewardsMyProgramDetailStop {
    [self sendWithScreenView:R_VIEW_REWARDS_MY_PROG_DETAILS andCategory:R_CHECKPOINT_REWARDS_MY_PROGRAMS_DETAILS andAction:rewardsMyProgramDetailStop];
}

#pragma mark - Rewards All Programs Detail

- (void)checkPointRewardsAllProgramsDetailQuit {
    [self sendWithScreenView:R_VIEW_REWARDS_ALL_DETAILS_DETAILS andCategory:R_CHECKPOINT_REWARDS_ALL_PROGRAMS_DETAILS andAction:rewardsAllProgramsDetailQuit];
}

- (void)checkPointRewardsAllProgramsDetailJoin {
    [self sendWithScreenView:R_VIEW_REWARDS_ALL_DETAILS_DETAILS andCategory:R_CHECKPOINT_REWARDS_ALL_PROGRAMS_DETAILS andAction:rewardsAllProgramsDetailJoin];
}

#pragma mark - Menu

- (void)checkPointMenuMyAccount {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuMyAccount];
}

- (void)checkPointMenuHome {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuHome];
}

- (void)checkPointMenuRefill {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuRefill];
}

- (void)checkPointMenuMyInformations {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuMyInformations];
}

- (void)checkPointMenuMyCards {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuMyCards];
}

- (void)checkPointMenuSecurity {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuSecurity];
}

- (void)checkPointMenuShops {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuShops];
}

- (void)checkPointMenuTuto {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuTuto];
}

- (void)checkPointMenuFaq {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_MENU andAction:menuFaq];
}

- (void)checkPointMenuLogOut {
    [self sendWithScreenView:R_VIEW_MENU andCategory:R_CHECKPOINT_OPTIONS_SWITCH_ACCOUNT andAction:menuLogOut];
}

#pragma mark - Refill

- (void)checkPointRefillAutomaticRefillActivate {
    [self sendWithScreenView:R_VIEW_REFILL andCategory:R_CHECKPOINT_OPTIONS_REFILL andAction:refillAutomaticRefillActivate];
}

- (void)checkPointRefillAutomaticRefillDeactivate {
    [self sendWithScreenView:R_VIEW_REFILL andCategory:R_CHECKPOINT_OPTIONS_REFILL andAction:refillAutomaticRefillDeactivate];
}

- (void)checkPointRefillExecuteRefill {
    [self sendWithScreenView:R_VIEW_REFILL andCategory:R_CHECKPOINT_OPTIONS_REFILL andAction:refillExecuteRefill];
}

#pragma mark - My Cards

- (void)checkPointMyCardsDeleteCard {
    [self sendWithScreenView:R_VIEW_CARD andCategory:R_CHECKPOINT_OPTIONS_CARD andAction:myCardsDeleteCard];
}

- (void)checkPointMyCardsAddCard {
    [self sendWithScreenView:R_VIEW_CARD andCategory:R_CHECKPOINT_OPTIONS_CARD andAction:myCardsAddCard];
}

#pragma mark - Security

- (void)checkPointSecurityChangePincode {
    [self sendWithScreenView:R_VIEW_SECURITY andCategory:R_CHECKPOINT_OPTIONS_SECURITY andAction:securityChangePincode];
}

- (void)checkPointSecurityAutolockTwo {
    [self sendWithScreenView:R_VIEW_SECURITY andCategory:R_CHECKPOINT_OPTIONS_SECURITY andAction:securityAutolockTwo];
}

- (void)checkPointSecurityAutolockFive {
    [self sendWithScreenView:R_VIEW_SECURITY andCategory:R_CHECKPOINT_OPTIONS_SECURITY andAction:securityAutolockFive];
}

- (void)checkPointSecurityAutolockTen {
    [self sendWithScreenView:R_VIEW_SECURITY andCategory:R_CHECKPOINT_OPTIONS_SECURITY andAction:securityAutolockTen];
}

#pragma mark - ForgottenPassword - Send Email

- (void)checkPointForgottenPasswordEmailQuit {
    [self sendWithScreenView:R_VIEW_FORGOTTEN_PSW_EMAIL andCategory:R_CHECKPOINT_FORGOTTEN_PSW_EMAIL andAction:forgottenPasswordEmailQuit];
}

- (void)checkPointForgottenPasswordEmailValidate {
    [self sendWithScreenView:R_VIEW_FORGOTTEN_PSW_EMAIL andCategory:R_CHECKPOINT_FORGOTTEN_PSW_EMAIL andAction:forgottenPasswordEmailValidate];
}

#pragma mark - ForgottenPassword - Security Question

- (void)checkPointForgottenPasswordSecurityQuestionQuit {
    [self sendWithScreenView:R_VIEW_FORGOTTEN_PSW_SECURITY_QUESTION andCategory:R_CHECKPOINT_FORGOTTEN_PSW_SECURITY_QUESTION andAction:forgottenPasswordSecurityQuestionQuit];
}

- (void)checkPointForgottenPasswordSecurityQuestionValidate {
    [self sendWithScreenView:R_VIEW_FORGOTTEN_PSW_SECURITY_QUESTION andCategory:R_CHECKPOINT_FORGOTTEN_PSW_SECURITY_QUESTION andAction:forgottenPasswordSecurityQuestionValidate];
}

#pragma mark - ForgottenPassword - New Password

- (void)checkPointForgottenPasswordNewPasswordQuit {
    [self sendWithScreenView:R_VIEW_FORGOTTEN_PSW_NEW_PASSWORD andCategory:R_CHECKPOINT_FORGOTTEN_PSW_NEW_PASSWORD andAction:forgottenPasswordNewPasswordQuit];
}

- (void)checkPointForgottenPasswordNewPasswordValidate {
    [self sendWithScreenView:R_VIEW_FORGOTTEN_PSW_NEW_PASSWORD andCategory:R_CHECKPOINT_FORGOTTEN_PSW_NEW_PASSWORD andAction:forgottenPasswordNewPasswordValidate];
}

- (void)startCrashlyticsWithApiKey:(NSString *)key {
    [[self crashlyticsTracker] startCrashlyticsWithApiKey:key];
}



@end
