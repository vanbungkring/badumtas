//
//  TrackerProtocol.h
//  FZBlackBox
//
//  Created by julian Clémot on 10/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

//screenViews
#define kViewStartScreen @"test"

#define R_VIEW_START_SCREEN @"START_SCREEN"
#define R_VIEW_SELECT_COUNTRY_SCREEN @"SELECT_COUNTRY_SCREEN" 
#define R_VIEW_CREATE_USER  @"CREATE_USER" 
#define R_VIEW_CHOOSE_SECURITY_QUESTION @"CHOOSE_SECURITY_QUESTION" 
#define R_VIEW_ANSWER_SECURITY_QUESTION @"ANSWER_SECURITY_QUESTION" 
#define R_VIEW_LOGIN @"LOGIN" 
#define R_VIEW_PINCODE @"PINCODE" 
#define R_VIEW_SCAN @"SCAN" 
#define R_VIEW_PAYMENT_CONFIRM @"PAYMENT_CONFIRM" 
#define R_VIEW_PAYMENT_POPUP_CONFIRM @"PAYMENT_POPUP_CONFIRM" 
#define R_VIEW_HISTORY @"HISTORY" 
#define R_VIEW_P2P @"P2P" 
#define R_VIEW_TABBAR @"TABBAR"
#define R_VIEW_RECEIVE_ENTER_AMOUNT @"RECEIVE_ENTER_AMOUNT" 
#define R_VIEW_RECEIVE_QRCODE @"RECEIVE_QRCODE" 
#define R_VIEW_RECEIVE_POPUP @"RECEIVE_POPUP" 
#define R_VIEW_SEND @"SEND" 
#define R_VIEW_SEND_POPUP @"SEND_POPUP" 
#define R_VIEW_REWARDS_MY_PROG_DETAILS @"REWARDS_MY_PROG_DETAILS" 
#define R_VIEW_REWARDS_ALL_DETAILS_DETAILS @"REWARDS_ALL_DETAILS_DETAILS" 
#define R_VIEW_MENU @"MENU" 
#define R_VIEW_REFILL @"REFILL" 
#define R_VIEW_CARD @"CARD" 
#define R_VIEW_SECURITY @"SECURITY" 
#define R_VIEW_FORGOTTEN_PSW_EMAIL @"FORGOTTEN_PSW_EMAIL" 
#define R_VIEW_FORGOTTEN_PSW_SECURITY_QUESTION @"FORGOTTEN_PSW_SECURITY_QUESTION"
#define R_VIEW_FORGOTTEN_PSW_NEW_PASSWORD @"FORGOTTEN_PSW_NEW_PASSWORD" 

//categories
#define R_CHECKPOINT_SLIDESHOW @"0001_START_SLIDESHOW" 
#define R_CHECKPOINT_ACCOUNT_CREATION_COUNTRY @"0101_ACCOUNT_CREATION_COUNTRY" 
#define R_CHECKPOINT_ACCOUNT_CREATION_USER_CREATION @"0102_ACCOUNT_CREATION_USER_CREATION" 
#define R_CHECKPOINT_ACCOUNT_CREATION_EMAIL_CHECK @"0103_ACCOUNT_CREATION_EMAIL_CHECK" 
#define R_CHECKPOINT_ACCOUNT_CREATION_PSW_CHECK @"0104_ACCOUNT_CREATION_PSW_CHECK" 
#define R_CHECKPOINT_ACCOUNT_CREATION_SECURITY_QUESTION @"0105_ACCOUNT_CREATION_SECURITY_QUESTION" 
#define R_CHECKPOINT_ACCOUNT_CREATION_SECURITY_ANSWER @"0106_ACCOUNT_CREATION_SECURITY_ANSWER" 
#define R_CHECKPOINT_LOGIN @"0200_LOGIN" 
#define R_CHECKPOINT_PINCODE_CREATION @"0301_PINCODE_CREATION" 
#define R_CHECKPOINT_PINCODE_CONFIRM @"0302_PINCODE_CONFIRM" 
#define R_CHECKPOINT_PINCODE_CHECK @"0303_PINCODE_CHECK" 
#define R_CHECKPOINT_SCAN_NO_CARD @"0401_SCAN_NO_CARD" 
#define R_CHECKPOINT_SCAN_TRIAL @"0402_SCAN_TRIAL" 
#define R_CHECKPOINT_PAYMENT_CONFIRM @"0510_PAYMENT_CONFIRM" 
#define R_CHECKPOINT_PAYMENT_POPUP_CONFIRM @"0511_PAYMENT_POPUP_CONFIRM" 
#define R_CHECKPOINT_HISTORY @"0600_HISTORY" 
#define R_CHECKPOINT_P2P_START @"0700_P2P_START"
#define R_CHECKPOINT_TABBAR_PAY @"TABBAR_PAY"
#define R_CHECKPOINT_TABBAR_REWARDS @"TABBAR_REWARDS"
#define R_CHECKPOINT_TABBAR_P2P @"TABBAR_P2P"
#define R_CHECKPOINT_P2P_RECEIVE_AMOUNT @"0710_P2P_RECEIVE_AMOUNT"
#define R_CHECKPOINT_P2P_RECEIVE_AMOUNT_STEP_TWO @"0711_P2P_RECEIVE_AMOUNT" 
#define R_CHECKPOINT_P2P_POPUP_RECEIVE @"0712_P2P_POPUP_RECEIVE" 
#define R_CHECKPOINT_P2P_SEND @"0720_P2P_SEND"
#define R_CHECKPOINT_P2P_SEND_AMOUNT @"0721_P2P_SEND_AMOUNT" 
#define R_CHECKPOINT_P2P_POPUP_SEND @"0724_P2P_POPUP_SEND" 
#define R_CHECKPOINT_REWARDS_MY_PROGRAMS_DETAILS @"0812_REWARDS_MY_PROGRAMS_DETAILS" 
#define R_CHECKPOINT_REWARDS_ALL_PROGRAMS_DETAILS @"0821_REWARDS_ALL_PROGRAMS_DETAILS" 
#define R_CHECKPOINT_OPTIONS_MENU @"0900_OPTIONS_MENU" 
#define R_CHECKPOINT_OPTIONS_SWITCH_ACCOUNT @"0902_OPTIONS_SWITCH_ACCOUNT" 
#define R_CHECKPOINT_OPTIONS_REFILL @"0912_OPTIONS_REFILL" 
#define R_CHECKPOINT_OPTIONS_CARD @"0931_OPTIONS_CARD" 
#define R_CHECKPOINT_OPTIONS_SECURITY @"0940_OPTIONS_SECURITY" 
#define R_CHECKPOINT_FORGOTTEN_PSW_EMAIL @"1000_FORGOTTEN_PSW_EMAIL" 
#define R_CHECKPOINT_FORGOTTEN_PSW_SECURITY_QUESTION @"1002_FORGOTTEN_PSW_SECURITY_QUESTION" 
#define R_CHECKPOINT_FORGOTTEN_PSW_NEW_PASSWORD @"1003_FORGOTTEN_PSW_NEW_PASSWORD" 

//actions
#define createAccount @"CREATE_ACCOUNT"
#define connectMainScreen @"CONNECT"
#define createAccountQuitCountry @"CREATE_ACCOUNT_QUIT_COUNTRY"
#define createAccountSearchCountry @"CREATE_ACCOUNT_SEARCH_COUNTRY"
#define createAccountQuitLogin @"CREATE_ACCOUNT_QUIT_LOGIN"
#define createAccountShowPassword @"CREATE_ACCOUNT_SHOW_PSW"
#define createAccountReadCGU @"CREATE_ACCOUNT_READ_CGU"
#define createAccountValidateLogin @"CREATE_ACCOUNT_VALIDATE_LOGIN"
#define createAccountRewriteEmail @"CREATE_ACCOUNT_REWRITE_EMAIL"
#define createAccountRewritePassword @"CREATE_ACCOUNT_REWRITE_PSW"
#define createAccountQuitQuestion @"CREATE_ACCOUNT_QUIT_QUESTION"
#define createAccountQuitAnswer @"CREATE_ACCOUNT_QUIT_ANSWER"
#define createAccountValidateAnswer @"CREATE_ACCOUNT_VALIDATE_ANSWER"
#define connectQuitLogin @"CONNECT_QUIT_LOGIN"
#define connectViewPassword @"CONNECT_VIEW_PSW"
#define connectValidateLogin @"CONNECT_VALIDATE_LOGIN"
#define connectForgottenPassword @"CONNECT_FORGOTTEN_PSW"
#define createPincodeQuit @"CREATE_PINCODE_QUIT"
#define createPincodeDone @"CREATE_PINCODE_DONE"
#define connectPincodeQuit @"CONNECT_QUIT_PINCODE"
#define connectPincode @"CONNECT_PINCODE"
#define viewHistory @"VIEW_HISTORY"
#define addAvatar @"ADD_AVATAR"
#define scanAddCard @"SCAN_ADDCARD"
#define scanAddInfo @"ADDINFO"
#define tabBarPay @"PAY_BTN_TABBAR"
#define tabBarTransfer @"P2P_BTN_TABBAR"
#define tabBarRewards @"REWARDS_BTN_TABBAR"
#define paymentQuit @"PAYMENT_QUIT"
#define paymentUseCoupons @"PAYMENT_USE_COUPON"
#define paymentValidate @"PAYMENT_VALIDATE"
#define paymentDoneSeeShops @"PAYMENT_DONE_SEE_SHOPS"
#define paymentDone @"PAYMENT_DONE"
#define historyQuit @"HISTORY_QUIT"
#define historyPending @"HISTORY_PENDING"
#define historyCredit @"HISTORY_CREDIT"
#define historyDebit @"HISTORY_DEBIT"
#define historyAll @"HISTORY_ALL"
#define transferSendMoney @"SEND_MONEY"
#define transferReceiveMoney @"RECEIVE_MONEY"
#define receiveQuit @"RECEIVE_QUIT"
#define receiveQRCodeQuit @"RECEIVE_QR_BACK"
#define receiveQRCodeDone @"RECEIVE_QR_OK"
#define sendQuit @"SEND_QUIT"
#define sendSearch @"SEND_SEARCH"
#define sendComment @"SEND_COMMENT"
#define sendValidate @"SEND_VALIDATE"
#define sendQRCodeDone @"SEND_OK"
#define rewardsMyProgramDetailStop @"FID_PROG_STOP"
#define rewardsAllProgramsDetailQuit @"FID_PROG_QUIT"
#define rewardsAllProgramsDetailJoin @"FID_PROG_JOIN"
#define menuMyAccount @"MENU_MY_ACCOUNT"
#define menuHome @"MENU_MY_INFOS"
#define menuRefill @"MENU_REFILL"
#define menuMyInformations @"MENU_MY_INFOS"
#define menuMyCards @"MENU_MY_CARDS"
#define menuSecurity @"MENU_SECURITY"
#define menuShops @"MENU_SHOPS"
#define menuTuto @"MENU_TUTO"
#define menuFaq @"MENU_FAQ"
#define menuLogOut @"MENU_LOGOUT"
#define refillAutomaticRefillActivate @"REFILL_ACTIVATE"
#define refillAutomaticRefillDeactivate @"REFILL_DEACTIVATE"
#define refillExecuteRefill @"REFILL_VALIDATE"
#define myCardsDeleteCard @"CARD_DELETE"
#define myCardsAddCard @"CARD_NEW"
#define securityChangePincode @"SECURITY_CHANGE_PINCODE"
#define securityAutolockTwo @"SECURITY_AUTOLOCK_2"
#define securityAutolockFive @"SECURITY_AUTOLOCK_5"
#define securityAutolockTen @"SECURITY_AUTOLOCK_10"
#define forgottenPasswordEmailQuit @"FORGOTTEN_PSW_EMAIL_QUIT"
#define forgottenPasswordEmailValidate @"FORGOTTEN_PSW_EMAIL_VALIDATE"
#define forgottenPasswordSecurityQuestionQuit @"FORGOTTEN_PSW_QUESTION_QUIT"
#define forgottenPasswordSecurityQuestionValidate @"FORGOTTEN_PSW_QUESTION_VALIDATE"
#define forgottenPasswordNewPasswordQuit @"FORGOTTEN_PSW_ANSWER_QUIT"
#define forgottenPasswordNewPasswordValidate @"FORGOTTEN_PSW_ANSWER_VALIDATE"

@protocol TrackerProtocol <NSObject>


#pragma mark - Send Event Methods

- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action andData:(NSString *)data;
- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action;

@required
#pragma mark - Home View

- (void)checkPointCreateAccount;
- (void)checkPointConnect;

#pragma mark - Create Account - Select Countries

- (void)checkPointCreateAccountQuitCountry;
- (void)checkPointCreateAccountSearchCountryWithCountry:(NSString *)countryName;

#pragma mark - Create Account - Create Credentials

- (void)checkPointCreateAccountQuitLogin;
- (void)checkPointCreateAccountShowPassword;
- (void)checkPointCreateAccountReadCGU;
- (void)checkPointCreateAccountValidateLogin;
- (void)checkPointCreateAccountRewriteEmail;
- (void)checkPointCreateAccountRewritePassword;

#pragma mark - Create Account - Select Security question

- (void)checkPointCreateAccountQuitQuestion;

#pragma mark - Create Account - Answer Security question

- (void)checkPointCreateAccountQuitAnswer;
- (void)checkPointCreateAccountValidateAnswer;

#pragma mark - Connect

- (void)checkPointConnectQuitLogin;
- (void)checkPointConnectViewPassword;
- (void)checkPointConnectValidateLogin;
- (void)checkPointConnectForgottenPassword;

#pragma mark - Create Pincode

- (void)checkPointCreatePincodeQuit;
- (void)checkPointCreatePincodeDone;

#pragma mark - Connect With Pincode

- (void)checkPointConnectPincodeQuit;
- (void)checkPointConnectPincode;

#pragma mark - All Views

- (void)checkPointViewHistory;
- (void)checkPointAddAvatar;
- (void)checkPointTabBarPay;
- (void)checkPointTabBarTransfer;
- (void)checkPointTabBarRewards;


#pragma mark - Scanner View

- (void)checkPointScanAddCard;
- (void)checkPointScanAddInfo;

#pragma mark - Pay Invoice

- (void)checkPointPaymentQuit;
- (void)checkPointPaymentUseCoupons;
- (void)checkPointPaymentValidate;

#pragma mark - Action Successfull - Payment Done

- (void)checkPointPaymentDoneSeeShops;
- (void)checkPointPaymentDone;

#pragma mark - History

- (void)checkPointHistoryQuit;
- (void)checkPointHistoryPending;
- (void)checkPointHistoryCredit;
- (void)checkPointHistoryDebit;
- (void)checkPointHistoryAll;

#pragma mark - Transfer

- (void)checkPointTransferSendMoney;
- (void)checkPointTransferReceiveMoney;

#pragma mark - Receive

- (void)checkPointReceiveQuit;

#pragma mark - Receive QR Code

- (void)checkPointReceiveQRCodeQuit;

#pragma mark - Action Successfull - Receive Done

- (void)checkPointReceiveQRCodeDone;

#pragma mark - Send

- (void)checkPointSendQuit;
- (void)checkPointSendSearch;
- (void)checkPointSendComment;
- (void)checkPointSendValidate;
#pragma mark - Action Successfull - Send Done

- (void)checkPointSendQRCodeDone;

#pragma mark - Rewards My Programs Detail

- (void)checkPointRewardsMyProgramDetailStop;

#pragma mark - Rewards All Programs Detail

- (void)checkPointRewardsAllProgramsDetailQuit;
- (void)checkPointRewardsAllProgramsDetailJoin;

#pragma mark - Menu

- (void)checkPointMenuMyAccount;
- (void)checkPointMenuHome;
- (void)checkPointMenuRefill;
- (void)checkPointMenuMyInformations;
- (void)checkPointMenuMyCards;
- (void)checkPointMenuSecurity;
- (void)checkPointMenuShops;
- (void)checkPointMenuTuto;
- (void)checkPointMenuFaq;
- (void)checkPointMenuLogOut;

#pragma mark - Refill

- (void)checkPointRefillAutomaticRefillActivate;
- (void)checkPointRefillAutomaticRefillDeactivate;
- (void)checkPointRefillExecuteRefill;

#pragma mark - My Cards

- (void)checkPointMyCardsDeleteCard;
- (void)checkPointMyCardsAddCard;

#pragma mark - Security

- (void)checkPointSecurityChangePincode;
- (void)checkPointSecurityAutolockTwo;
- (void)checkPointSecurityAutolockFive;
- (void)checkPointSecurityAutolockTen;

#pragma mark - ForgottenPassword - Send Email

- (void)checkPointForgottenPasswordEmailQuit;
- (void)checkPointForgottenPasswordEmailValidate;

#pragma mark - ForgottenPassword - Security Question

- (void)checkPointForgottenPasswordSecurityQuestionQuit;
- (void)checkPointForgottenPasswordSecurityQuestionValidate;

#pragma mark - ForgottenPassword - New Password

- (void)checkPointForgottenPasswordNewPasswordQuit;
- (void)checkPointForgottenPasswordNewPasswordValidate;


@end
