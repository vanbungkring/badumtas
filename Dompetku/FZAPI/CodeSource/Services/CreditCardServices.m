//
//  CreditCardServices.m
//  iMobey
//
//  Created by Yvan Moté on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "CreditCardServices.h"
#import "FlashizUrlBuilder.h"
#import "Wallet.h"
#import "WalletBraintree.h"
#import "CreditCard.h"
#import "CreditCardRule.h"

static NSString * const createWalletServiceDescription = @"create wallet";
static NSString * const saveBraintreeWalletServiceDescription = @"save braintree wallet";
static NSString * const setCreditCardServiceDescription = @"set credit card";
static NSString * const registeredCardsServiceDescription = @"registered cards";
static NSString * const registeredCardServiceDescription = @"registered card";
static NSString * const immediateRefillServiceDescription = @"immediate refill";
static NSString * const autoRefillServiceDescription = @"auto refill";
static NSString * const cancelAutoRefillServiceDescription = @"cancel auto refill";
//static NSString * const retrieveAutoRefillServiceDescription = @"auto refill information";
static NSString * const deletetCreditCardServiceDescription = @"delete credit card";

@implementation CreditCardServices

+ (void)createWalletWebView:(NSString *)userkey
               successBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    [params setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"lang"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder createWalletWebViewUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:createWalletServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       FZAPILog(@"withSuccessBlock context : %@",context);
                       
                       if([[context objectForKey:@"trData"] length] > 0){ //register credit card with Braintree (USD AUD)
                           //WalletBraintree *walletBraintree = [WalletBraintree walletBraintreeWithDictionary:context error:error];
                           [WalletBraintree walletBraintreeWithDictionary:context successBlock:^(id object) {
                                successBlock((WalletBraintree *)object);
                           } failureBlock:^(Error *error) {
                               failureBlock(error);
                           }];
                       } else { //register credit card with PayLine (EUR)
                           //Wallet *wallet = [Wallet walletWithDictionary:context error:error];
                           [Wallet walletWithDictionary:context successBlock:^(id object) {
                               successBlock((Wallet *)object);
                           } failureBlock:^(Error *error) {
                               failureBlock(error);
                           }];
                       }
                   } failureBlock:failureBlock];
}

+ (void) savePaymentInfo:(NSDictionary *)paymentInfo
                withData:(NSString *)trData
             toServerUrl:(NSString *)actionFormUrl
            successBlock:(NetworkSuccessBlock)successBlock
            failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[paymentInfo valueForKey:@"card_number"] forKey:@"credit_card[number]"];
    
    NSString *expiration_date = [NSString stringWithFormat:@"%@/%@",[paymentInfo valueForKey:@"expiration_month"],[[paymentInfo valueForKey:@"expiration_year"] substringFromIndex:[[paymentInfo valueForKey:@"expiration_year"] length]-2]];
    
    FZAPILog(@"exp_date : %@",expiration_date);
    
    [params setObject:expiration_date forKey:@"credit_card[expiration_date]"];
    [params setObject:[paymentInfo valueForKey:@"cvv"] forKey:@"credit_card[cvv]"];
    [params setObject:trData forKey:@"tr_data"];
    [params setObject:@"" forKey:@"credit_card[cardholder_name]"];
    
    //[params setObject:[paymentInfo valueForKey:@"venmo_sdk_session"] forKey:@"venmo_sdk_session"];

    NSURLRequest *request = [FlashizServices requestPostCustomForUrl:[NSURL URLWithString:actionFormUrl] withParameters:params];
        
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:saveBraintreeWalletServiceDescription
                   withSuccessBlock:^(id context) {
                   
                       NSString *creditCardId = [NSString stringWithFormat:@"%@",[context objectForKey:@"creditcardid"]];

                       successBlock(creditCardId);
                       
                   } failureBlock:failureBlock];
}

+ (void)setCreditCardName:(NSString*)cardName
                   WithId:(NSString*)cardId
              WithUserKey:(NSString*)userkey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:cardName forKey:@"walletname"];
    [params setObject:cardId forKey:@"creditcardid"];
    [params setObject:userkey forKey:userKeyParameter];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder setCreditCardNameUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:setCreditCardServiceDescription
                   withSuccessBlock:successBlock
                       failureBlock:failureBlock];
}

+ (void)registeredCards:(NSString *)userkey
              successBlock:(NetworkSuccessBlock)successBlock
              failureBlock:(NetworkFailureBlock)failureBlock {
    
    if([userkey length]==0) {
        FZAPILog(@"userkey is empty, can't retrieve registered cards");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder registeredCardsUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:registeredCardsServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       // TODO : not the good place to parse the object 🙈
                       NSMutableArray *creditCardsList = [[[NSMutableArray alloc] init] autorelease];
                       
                       NSArray *creditCardsListTemp = [context objectForKey:@"creditcards"];
                       
                       if(creditCardsListTemp.count==0){
                           successBlock(creditCardsList);
                       }
                       
                       for(int i = 0; i < creditCardsListTemp.count; i++ ) {
                           
                           //CreditCard *creditCard = [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] error:error];
                           
                           [CreditCard creditCardWithDictionary:[creditCardsListTemp[i] valueForKey:@"creditcard"] successBlock:^(id object) {
                               [creditCardsList addObject:(CreditCard *)object];

                               successBlock(creditCardsList);
                               
                           } failureBlock:^(Error *error) {
                               failureBlock(error);
                           }];
                       }
                   } failureBlock:failureBlock];
}

+ (void)registeredCardWithID:(NSString*)idCard
                         AndUseKey:(NSString *)userkey
                      successBlock:(NetworkSuccessBlock)successBlock
                      failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    [params setObject:idCard forKey:@"id"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder registeredCardWithIDUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:registeredCardServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       //CreditCard *creditCard = [CreditCard creditCardWithDictionary:context error:error];
                       [CreditCard creditCardWithDictionary:context successBlock:^(id object) {
                           successBlock((CreditCard *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

+ (void)doImmediateRefill:(NSString *)userkey
                   Amount:(int) amount
                 WithCard:(NSString*)chosenCard
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    [params setObject:[NSString stringWithFormat:@"%d", amount] forKey:@"amount"];
    [params setObject:chosenCard forKey:@"chosenCard"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder doImmediateRefillUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:immediateRefillServiceDescription
                   withSuccessBlock:successBlock
                       failureBlock:failureBlock];
    
}

+ (void)autoRefill:(NSString *)userkey
            Amount:(int) amount
             Limit:(int) limit
          WithCard:(NSString*)chosenCard
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    [params setObject:[NSString stringWithFormat:@"%d", amount] forKey:@"amount"];
    [params setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    [params setObject:chosenCard forKey:@"chosenCard"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder autoRefillUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:autoRefillServiceDescription
                   withSuccessBlock:successBlock
                       failureBlock:failureBlock];
}

+ (void)cancelAutoRefill:(NSString *)userkey
                WithCard:(NSString*)chosenCard
            successBlock:(NetworkSuccessBlock)successBlock
            failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    [params setObject:chosenCard forKey:@"chosenCard"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder cancelAutoRefillUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:cancelAutoRefillServiceDescription
                   withSuccessBlock:successBlock
                       failureBlock:failureBlock];
}

+ (void)retrieveAutoRefillRule:(NSString *)userkey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder retrieveAutoRefillRuleUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:autoRefillServiceDescription
                   withSuccessBlock:^(id context) {
                       //CreditCardRule *creditCardRule = [CreditCardRule creditCardRuleWithDictionary:context error:error];
                       [CreditCardRule creditCardRuleWithDictionary:context successBlock:^(id object) {
                           successBlock((CreditCardRule *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

+ (void)deleteCreditCard:(NSString *)userkey
                  withId:(NSString*)idCard
            successBlock:(NetworkSuccessBlock)successBlock
            failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    [params setObject:idCard forKey:@"id"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder deleteCreditCardUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:deletetCreditCardServiceDescription
                   withSuccessBlock:successBlock
                       failureBlock:failureBlock];
    
}
@end
