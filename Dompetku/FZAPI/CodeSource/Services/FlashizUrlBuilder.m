//
//  FlashizUrlBuilder.m
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizUrlBuilder.h"

#import "URLStringEncoding.h"

#import "ServerConstants.h"

//Targets manager
//#import <FZBlackBox/FZTargetManager.h>

#import "UserSession.h"

//Intégration
//static NSString * const SERVER_URL =@"http://test.mobey.net/mobey";

// sandbox
//static NSString * const SERVER_URL =@"https://sandbox.flashiz.com";
//static NSString * const SERVER_URL =@"https://sandbox.flashiz.com/mobile";

//Test
//static NSString * const SERVER_URL =@"http://test.mobey.net/account";
//static NSString * const SERVER_URL =@"http://test.mobey.net/flashiz_api_in/mobile";
//static NSString * const SERVER_URL =@"http://test.mobey.net/account/mobile";

//Server environment
static NSString* SERVER_PROD = @"https://my.flashiz.com/account";
static NSString* SERVER_UAT = @"https://my-uat.flashiz.com";
static NSString* SERVER_INTEGRATION = @"http://test.mobey.net/mobey";
static NSString* SERVER_SANDBOX = @"https://sandbox.flashiz.com";//@"http://192.168.178.46:7575/flashiz_api_in";//@"https://sandbox.flashiz.com";
static NSString* SERVER_QAT = @"http://qat.mobey.net";
static NSString* SERVER_TEST = @"http://dev.mobey.net";
static NSString* SERVER_IT = @"http://itmobile3.flashiz.com:7575/flashiz_api_in";

static NSMutableDictionary *mapServerEnvironments;

//Server Environment Indonesia
static NSString* SERVER_PROD_INDONESIA = @"https://my.flashiz.co.id";//@"http://192.168.4.5:7575/flashiz_api_in";
static NSString* SERVER_QAT_INDONESIA = @"http://flashizqatind.fexcosoftware.com";//@"http://qat.mobey.net:8080";
static NSString* SERVER_DEV_INDONESIA = @"http://flashiztestind.fexcosoftware.com";//@"https://dev.flashiz.co.id";
static NSString* SERVER_SANDBOX_INDONESIA = @"https://sandbox.flashiz.co.id";

static NSString * const MOBEY_URL_LOGIN = @"/login/auth/connect";
static NSString * const MOBEY_URL_LOGOUT = @"/login/auth/disconnect";
static NSString * const MOBEY_URL_GETUSERINFOS = @"/mobile/getuserinfos";
static NSString * const MOBEY_URL_GETACCOUNT = @"/mobile/getaccount";
static NSString * const MOBEY_URL_STOREPIN = @"/login/auth/storepin";
//static NSString *MOBEY_URL_CASHDESKINFOS = @"/mobile/cashdeskinfos";
static NSString * const MOBEY_URL_CHANGEPIN = @"/login/auth/changepin";
static NSString * const MOBEY_URL_CHECKPIN = @"/login/auth/checkpin";
/* REGISTRATION */
static NSString * const MOBEY_URL_GETREGISTRATIONLISTS = @"/mobile/getregistrationlists";
static NSString * const MOBEY_URL_GETCOUNTRIES = @"/mobile/getcountries";
static NSString * const MOBEY_URL_CAPTCHAGENERATE =  @"/mobile/generatecaptcha";
static NSString * const MOBEY_URL_CAPTCHASUBMIT = @"/mobile/submitcaptcha";
static NSString * const MOBEY_URL_USERTRIAL = @"/mobile/createusertrial";
/* USER */
static NSString * const MOBEY_URL_USERGETINFORMATION = @"/mobile/usergetinformation";//deprecated
static NSString * const MOBEY_URL_USEREDITINFORMATION = @"/mobile/upgradeuser";
/* INVOICES */
static NSString * const MOBEY_URL_GETINVOICE = @"/mobile/getinvoice";
static NSString * const MOBEY_URL_PAYINVOICE = @"/mobile/payinvoice";
static NSString * const MOBEY_URL_CREATEINVOICE = @"/mobile/createinvoice";
static NSString * const MOBEY_URL_CREATECREDIT = @"/mobile/createcredit";
static NSString * const MOBEY_URL_CHECKPAYMENT = @"/mobile/checkpayment";
static NSString * const MOBEY_URL_CANCELINVOICE = @"/mobile/cancelinvoice";
static NSString * const MOBEY_URL_GETURLLIST = @"/mobile/getURLList";
/* TRANSACTIONS */
static NSString * const MOBEY_URL_LISTTRANSACTIONS = @"/mobile/listtransactions";
static NSString * const MOBEY_URL_TRANSFERT = @"/mobile/p2ptransfer";
static NSString * const MOBEY_URL_QUEUEDTRANSACTIONS = @"/mobile/findqueuedtransactionsreceiver";
static NSString * const MOBEY_URL_EXECUTETRANSFERT = @"/mobile/executetransfer";
static NSString * const MOBEY_URL_CANCELTRANSFERT = @"/mobile/canceltransfer";
/* AVATAR */
static NSString * const MOBEY_URL_GETAVATAR = @"/mobile/getavatarwithusername";
static NSString * const MOBEY_URL_GETAVATAR_WITH_MAIL = @"/mobile/getavatarwithuser";
static NSString * const MOBEY_URL_GETAVATAR_LAST_DATE_WITH_MAIL = @"/mobile/getavatartimestamp";
static NSString * const MOBEY_URL_SETAVATAR = @"/mobile/uploadavatar";
/* SIGNiZ */
//static NSString *SIGNIZ_URL_CHECK_TOKEN = @"/signiz/checktoken";
//static NSString *SIGNIZ_USE_TOKEN = @"/signiz/usetoken";
/* CREDIT CARDS */
static NSString *MOBEY_URL_CREATE_WALLET_WEBVIEW = @"/mobile/createwebwallet";
//static NSString *MOBEY_URL_CREATE_WALLET = @"/mobile/createwallet";
static NSString *MOBEY_URL_SET_CREDIT_CARD_NAME = @"/mobile/setwalletname";
static NSString *MOBEY_URL_GET_REGISTERED_CREDIT_CARDS = @"/mobile/getregisteredcards";
static NSString *MOBEY_URL_GET_THE_REGISTERED_CREDIT_CARD = @"/mobile/getcreditcard";
static NSString *MOBEY_URL_DO_IMMEDIATE_REFILL = @"/mobile/doimmediaterefill";
static NSString *MOBEY_URL_AUTO_REFILL = @"/mobile/chargeauto";
static NSString *MOBEY_URL_CANCEL_AUTO_REFILL = @"/mobile/cancelautorefill";
static NSString *MOBEY_URL_GET_AUTO_REFILL = @"/mobile/getautorefillrule";
static NSString *MOBEY_URL_DELETE_CREDIT_CARD = @"/mobile/deletewallet";
/* FIDELITiZ */
static NSString *MOBEY_URL_CREATE_FIDELITiZ_ACCOUNT = @"/mobile/fidelitizAccountEdit?mode=create";
static NSString *MOBEY_URL_GET_FIDELITiZ_CARDS_LIST = @"/mobile/fidelitizCardList";
static NSString *MOBEY_URL_GET_THE_FIDELITiZ_CARD = @"/mobile/fidelitizCardGet";
static NSString *MOBEY_URL_CREATE_FIDELITiZ_CARD = @"/mobile/fidelitizCardCreate";
static NSString *MOBEY_URL_GET_PROGRAMS_LIST_NOT_ALREADY_SUSCRIBE = @"/mobile/individualGetLoyaltyProgramsAvailable";
static NSString *MOBEY_URL_GET_PROGRAM_DETAILS = @"/mobile/fidelitizProgramGet";
static NSString *MOBEY_URL_DELETE_FIDELITiZ_CARD = @"/mobile/fidelitizCardDelete";
static NSString *MOBEY_URL_GET_AFFILIATES_LIST = @"/mobile/fidelitizAffiliationGetAccepted";
/* FORGOTTEN PASSWORD */
static NSString *MOBEY_URL_FORGOTTEN_PWD = @"/mobile/forgottenpwdmail";
static NSString *MOBEY_URL_GET_SECRET_QUESTION = @"/mobile/getquestionsecret";
static NSString *MOBEY_URL_CONFIRM_SECRET_ANSWER = @"/mobile/confirmanswersecret";
static NSString *MOBEY_URL_CHANGE_PASSWORD = @"/mobile/changepassword";

/* INDONESIAN URLS FOR BANK SDK (INCLUDING MIDDLEWARESTEST WEBSERVICES)*/

static NSString *MOBEY_URL_MW_CREATE_USER = @"/banking/v1/middleware/user/create"; //For Testing Only
static NSString *MOBEY_URL_MW_PAY_INVOICE = @"/banking/v1/middleware/invoice/pay"; //For Testing Only
static NSString *MOBEY_URL_PAY_INVOICE_STATUS = @"/banking/v1/mobile/invoice/status";
static NSString *MOBEY_URL_GET_INVOICE = @"/banking/v1/mobile/invoice/get";
static NSString *MOBEY_URL_MW_GET_MERCHANT_API_KEY = @"/api/generateApiKey";

static NSString * const ENVIRONMENT = @"environment";

@implementation FlashizUrlBuilder

#pragma mark - Mapping server environments

+ (NSMutableDictionary *)mapServerEnvironments {
    if (!mapServerEnvironments || [mapServerEnvironments count] == 0) {
        mapServerEnvironments = [[NSMutableDictionary alloc] init];
        //long key
        [mapServerEnvironments setValue:SERVER_IT forKey:kITEnvironmentKey];
        [mapServerEnvironments setValue:SERVER_TEST forKey:kTestEnvironmentKey];
        [mapServerEnvironments setValue:SERVER_QAT forKey:kQatEnvironmentKey];
        [mapServerEnvironments setValue:SERVER_UAT forKey:kUatEnvironmentKey];
        [mapServerEnvironments setValue:SERVER_PROD forKey:kProdEnvironmentKey];
        [mapServerEnvironments setValue:SERVER_SANDBOX forKey:kSandboxEnvironmentKey];
        [mapServerEnvironments setValue:SERVER_INTEGRATION forKey:kIntegrationEnvironmentKey];
        //short key
        [mapServerEnvironments setValue:SERVER_IT forKey:kITKey];
        [mapServerEnvironments setValue:SERVER_TEST forKey:kTestKey];
        [mapServerEnvironments setValue:SERVER_QAT forKey:kQatKey];
        [mapServerEnvironments setValue:SERVER_UAT forKey:kUatKey];
        [mapServerEnvironments setValue:SERVER_PROD forKey:kProdKey];
        [mapServerEnvironments setValue:SERVER_SANDBOX forKey:kSandboxKey];
        [mapServerEnvironments setValue:SERVER_INTEGRATION forKey:kIntKey];
    }
    return mapServerEnvironments;
}

+ (BOOL)isValidEnvironment:(NSString *)testedEnvironment {
    if([[[self mapServerEnvironments] objectForKey:testedEnvironment] length] > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Url methods

+ (NSURL *)connectionUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_LOGIN];
}

+ (NSURL *)connectionUrlWithGetParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_LOGIN
                          withGetParameters:parameters];
}

+ (NSURL *)disconnectionUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_LOGOUT
                          withGetParameters:parameters];
}

+ (NSURL *)accountUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETACCOUNT
                          withGetParameters:parameters];
}

+ (NSURL *)userAccountUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETUSERINFOS
                          withGetParameters:parameters];
}

#pragma mark - Pin urls

+ (NSURL *)sendPinUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_STOREPIN
                          withGetParameters:parameters];
}

+ (NSURL *)changePinUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CHANGEPIN
                          withGetParameters:parameters];
}

+ (NSURL *)checkPinUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CHECKPIN
                          withGetParameters:parameters];
}

#pragma mark - Registration

+(NSURL *)registrationListsWithParameters:(NSDictionary *)parameters{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETREGISTRATIONLISTS
                          withGetParameters:parameters];
}

+(NSURL *)countriesWithParameters:(NSDictionary *)parameters{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETCOUNTRIES
                          withGetParameters:parameters];
}

+(NSURL *)captchaGenerate{
    //dd timestamp to avoid cache
    return [FlashizUrlBuilder urlForService:[NSString stringWithFormat:@"%@?%@",MOBEY_URL_CAPTCHAGENERATE,[NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]]]];
}


+(NSURL *)captchaSubmitWithParameters:(NSDictionary *)parameters{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CAPTCHASUBMIT withGetParameters:parameters];
}

+(NSURL *)userTrial:(NSDictionary *)parameters{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_USERTRIAL withGetParameters:parameters];
}


#pragma mark - user
+(NSURL *)userGetInformation{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_USERGETINFORMATION];
}

#pragma mark - user
+(NSURL *)userEditInformationWithParameters:(NSDictionary *)parameters{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_USEREDITINFORMATION withGetParameters:parameters];
}

#pragma mark - Transactions urls

+ (NSURL *)listTransactionsUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_LISTTRANSACTIONS
                          withGetParameters:parameters];
}


#pragma mark - Invoice


+ (NSURL *)invoiceUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETINVOICE
                          withGetParameters:parameters];
}

+ (NSURL *)payInvoiceUrlWithParemeters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_PAYINVOICE
                          withGetParameters:parameters];
}

+ (NSURL *)createInvoiceUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CREATEINVOICE
                          withGetParameters:parameters];
}

+ (NSURL *)cancelInvoiceUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CANCELINVOICE
                          withGetParameters:parameters];
}

+ (NSURL *)createCreditUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CREATECREDIT
                          withGetParameters:parameters];
}

+ (NSURL *)checkPaymentUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CHECKPAYMENT
                          withGetParameters:parameters];
}

+ (NSURL *)transfertMoneyUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_TRANSFERT
                          withGetParameters:parameters];
}

+ (NSURL *)queuedTransactionsUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_QUEUEDTRANSACTIONS
                          withGetParameters:parameters];
}

+ (NSURL *)executeTransactionsUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_EXECUTETRANSFERT
                          withGetParameters:parameters];
}

+ (NSURL *)cancelTransactionsUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CANCELTRANSFERT
                          withGetParameters:parameters];
}

+ (NSURL *)urlList {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETURLLIST];
}

#pragma mark - Avatar url

+ (NSURL *)avatarUrlFromMailWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETAVATAR_WITH_MAIL
                          withGetParameters:parameters];
}

+ (NSURL *)avatarUrlWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETAVATAR
                          withGetParameters:parameters];
}

+ (NSURL *)avatarTimestampFromMailWithParameters:(NSDictionary *)parameters {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GETAVATAR_LAST_DATE_WITH_MAIL
                          withGetParameters:parameters];
}

+ (NSURL *)avatarUploadUrl{
    return [FlashizUrlBuilder urlForService:MOBEY_URL_SETAVATAR];
}

#pragma mark - Credit Card url

+ (NSURL *)createWalletWebViewUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CREATE_WALLET_WEBVIEW];
}

+ (NSURL *)setCreditCardNameUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_SET_CREDIT_CARD_NAME];
}

+ (NSURL *)registeredCardsUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_REGISTERED_CREDIT_CARDS];
}

+ (NSURL *)registeredCardWithIDUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_THE_REGISTERED_CREDIT_CARD];
}

+ (NSURL *)doImmediateRefillUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_DO_IMMEDIATE_REFILL];
}

+ (NSURL *)autoRefillUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_AUTO_REFILL];
}

+ (NSURL *)cancelAutoRefillUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CANCEL_AUTO_REFILL];
}

+ (NSURL *)retrieveAutoRefillRuleUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_AUTO_REFILL];
}

+ (NSURL *)deleteCreditCardUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_DELETE_CREDIT_CARD];
}

#pragma mark - Fidelitiz url

+ (NSURL *)createRewardsAccountUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CREATE_FIDELITiZ_ACCOUNT];
}

+ (NSURL *)createRewardsCardUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CREATE_FIDELITiZ_CARD];
}

+ (NSURL *)createRewardsCardPrivateUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CREATE_FIDELITiZ_CARD];
}

+ (NSURL *)deleteRewardsCardUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_DELETE_FIDELITiZ_CARD];
}

+ (NSURL *)rewardsCardsListUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_FIDELITiZ_CARDS_LIST];
}

+ (NSURL *)rewardsCardUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_THE_FIDELITiZ_CARD];
}

+ (NSURL *)programDetailsUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_PROGRAM_DETAILS];
}

+ (NSURL *)programsListNotAlreadyUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_PROGRAMS_LIST_NOT_ALREADY_SUSCRIBE];
}

+ (NSURL *)affiliatesListUrl {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_AFFILIATES_LIST];
}

#pragma mark - Forgotten password
+ (NSURL *)forgottenPassword {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_FORGOTTEN_PWD];
}

+ (NSURL *)secretQuestion {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_SECRET_QUESTION];
}

+ (NSURL *)confirmSecretAnswer {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CONFIRM_SECRET_ANSWER];
}

+ (NSURL *)changePassword {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_CHANGE_PASSWORD];
}

#pragma mark - Indonesia Bank SDK webservices

+ (NSURL *)middleWareIndonesiaCreateUser {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_MW_CREATE_USER];
}

+ (NSURL *)middleWareIndonesiaPayInvoice {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_MW_PAY_INVOICE];
}

+ (NSURL *)middleWareIndonesiaGenerateApiKey {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_MW_GET_MERCHANT_API_KEY];
}

+ (NSURL *)indonesianGetInvoice {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_GET_INVOICE];
}

+ (NSURL *)indonesianStatusPayInvoice {
    return [FlashizUrlBuilder urlForService:MOBEY_URL_PAY_INVOICE_STATUS];
}

#pragma mark - Server Url

+ (NSString *)serverUrl{
    
    NSString *environment = [[UserSession currentSession]environment];
    
    if(environment==nil) {
        environment = kProdEnvironmentKey;
    }
    
    NSString *server = [[self mapServerEnvironments] valueForKey:environment];
    
    if([[UserSession currentSession]isInBankSdk]){
        if ([environment isEqualToString:kSandboxEnvironmentKey]){
            return SERVER_SANDBOX_INDONESIA;
        } else if([environment isEqualToString:kTestEnvironmentKey]) {
            return SERVER_DEV_INDONESIA;
        } else if([environment isEqualToString:kQatEnvironmentKey]) {
            return SERVER_QAT_INDONESIA;
        }else if([environment isEqualToString:kProdEnvironmentKey] || [environment isEqualToString:@""]) {
			return SERVER_PROD_INDONESIA;
		} else {
            return environment;
        }
    }
    
    return server;
}

#pragma mark - Private method

+ (NSURL *)urlForService:(NSString *)service {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self serverUrl],service]];
}

+ (NSURL *)urlForService:(NSString *)service withGetParameters:(NSDictionary *)parameters {
    NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"%@%@",[self serverUrl],service];
    
    if(parameters != nil && [parameters count] > 0){
        
        [urlString appendString:@"?"];
        
        for(NSString *key in parameters){
            
            id value = [parameters objectForKey:key];
            
            if([value isKindOfClass:[NSString class]]) {
                [urlString appendFormat:@"%@=%@&", key, [URLStringEncoding string:value usingEncoding:NSUTF8StringEncoding]];
            }
            else {
                [urlString appendFormat:@"%@=%@&", key, value];
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:[urlString substringToIndex:([urlString length]-1)]];
    
    [urlString release];
    
    return url;
    
}

@end
