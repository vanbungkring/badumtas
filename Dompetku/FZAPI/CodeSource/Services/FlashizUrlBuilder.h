//
//  FlashizUrlBuilder.h
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlashizUrlBuilder : NSObject

+ (NSString *)serverUrl;
+ (NSMutableDictionary *)mapServerEnvironments;
+ (BOOL)isValidEnvironment:(NSString *)testedEnvironment;

+ (NSURL *)connectionUrl;
+ (NSURL *)connectionUrlWithGetParameters:(NSDictionary *)parameters;
+ (NSURL *)disconnectionUrlWithParameters:(NSDictionary *)parameters;

+ (NSURL *)accountUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)userAccountUrlWithParameters:(NSDictionary *)parameters;

+ (NSURL *)sendPinUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)changePinUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)checkPinUrlWithParameters:(NSDictionary *)parameters;


//Registration
+(NSURL *)registrationListsWithParameters:(NSDictionary *)parameters;
+(NSURL *)countriesWithParameters:(NSDictionary *)parameters;
+(NSURL *)captchaGenerate;
+(NSURL *)captchaSubmitWithParameters:(NSDictionary *)parameters;
+(NSURL *)userTrial:(NSDictionary *)parameters;

//User
+(NSURL *)userGetInformation;
+(NSURL *)userEditInformationWithParameters:(NSDictionary *)parameters;

//Transactions
+ (NSURL *)listTransactionsUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)invoiceUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)payInvoiceUrlWithParemeters:(NSDictionary *)parameters;
+ (NSURL *)createInvoiceUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)cancelInvoiceUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)createCreditUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)checkPaymentUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)transfertMoneyUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)queuedTransactionsUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)executeTransactionsUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)cancelTransactionsUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)urlList;

//Avatar
+ (NSURL *)avatarUrlFromMailWithParameters:(NSDictionary *)parameters;
+ (NSURL *)avatarUrlWithParameters:(NSDictionary *)parameters;
+ (NSURL *)avatarTimestampFromMailWithParameters:(NSDictionary *)parameters;
+ (NSURL *)avatarUploadUrl;

//Credit Card
+ (NSURL *)createWalletWebViewUrl;
+ (NSURL *)setCreditCardNameUrl;
+ (NSURL *)registeredCardsUrl;
+ (NSURL *)registeredCardWithIDUrl;
+ (NSURL *)doImmediateRefillUrl;
+ (NSURL *)autoRefillUrl;
+ (NSURL *)cancelAutoRefillUrl;
+ (NSURL *)retrieveAutoRefillRuleUrl;
+ (NSURL *)deleteCreditCardUrl;

//Rewards
+ (NSURL *)createRewardsAccountUrl;
+ (NSURL *)createRewardsCardUrl;
+ (NSURL *)createRewardsCardPrivateUrl;
+ (NSURL *)deleteRewardsCardUrl;
+ (NSURL *)rewardsCardsListUrl;
+ (NSURL *)rewardsCardUrl;
+ (NSURL *)programDetailsUrl;
+ (NSURL *)programsListNotAlreadyUrl;
+ (NSURL *)affiliatesListUrl;

//Forgotten password
+ (NSURL *)forgottenPassword;
+ (NSURL *)secretQuestion;
+ (NSURL *)confirmSecretAnswer;
+ (NSURL *)changePassword;

//Indonesian Bank SDK web Services
+ (NSURL *)middleWareIndonesiaCreateUser;
+ (NSURL *)middleWareIndonesiaPayInvoice;
+ (NSURL *)middleWareIndonesiaGenerateApiKey;
+ (NSURL *)indonesianGetInvoice;
+ (NSURL *)indonesianStatusPayInvoice;

@end
