//
//  CreditCardServices.h
//  iMobey
//
//  Created by Yvan Moté on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"


@interface CreditCardServices : FlashizServices

/**
 @brief Create a web view contaning a wallet (need more infos)
 @param userkey the user which want to get a wallet userkey
 @return JSON formatted response contaning the wallet web view
 */
+ (void)createWalletWebView:(NSString *)userkey
               successBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief send to Braintree the credit card informations
 @param paymentInfo the credit card information form the Braintree iOs form
 @param trData the trData given by the Flashiz server
 @param actionFormUrl the url to post the request
 @param paymentViewController the Braintree payment form view
 @return JSON formatted response from braintree
 */
+ (void) savePaymentInfo:(NSDictionary *)paymentInfo
                withData:(NSString *)trData
             toServerUrl:(NSString *)actionFormUrl
            successBlock:(NetworkSuccessBlock)successBlock
            failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Change the name associated to a credit card
 @param cardName the new name to give to the card
 @param cardId the id of the card to set
 @param userkey the user userkey
 @return JSON formatted response indicating whether or not the operation succeeded
 */
+ (void)setCreditCardName:(NSString*)cardName
                   WithId:(NSString*)cardId
              WithUserKey:(NSString*)userkey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve all the registered credit cards of the given user
 @param userkey the user userkey
 @return JSON formatted response contanining the user registered credit cards
 */
+ (void)registeredCards:(NSString *)userkey
              successBlock:(NetworkSuccessBlock)successBlock
              failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve the credit card information of the given credit card id
 @param idCard the id of the card we want to get information from
 @param userkey the user userkey
 @return JSON formatted response contaning the information of the credit card
 */
+ (void)registeredCardWithID:(NSString*)idCard
                         AndUseKey:(NSString *)userkey
                      successBlock:(NetworkSuccessBlock)successBlock
                      failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief brief Refill the user FLASHiZ account with the given amount from the given credit card
 @param userkey the user userkey
 @param amount the amount to refill
 @param chosenCard the credit card id to use to refill
 @return JSON formatted response indicating whether or not the refill succeeded
 */
+ (void)doImmediateRefill:(NSString *)userkey
                   Amount:(int) amount
                 WithCard:(NSString*)chosenCard
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Add an autorefill rule that automaticly refill the user FLASHiZ account when it is below a given amount
 @param userkey user userkey
 @param amount the amount to refill when reaching the limit
 @param limit the minimum amount of the FLASHiZ account before performing an auto refill of the given amount
 @param chosenCard the id of the credit card to use for performing refill with this rule
 @return JSON formatted response indicating the success or not of the operation
 */
+ (void)autoRefill:(NSString *)userkey
            Amount:(int) amount
             Limit:(int) limit
          WithCard:(NSString*)chosenCard
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief cancel an autorefill rule previously added.
 @param userkey the user userkey
 @param chosenCard the credit card id associated to the rule
 @return JSON formatted response indicating the success or not of the operation
 */
+ (void)cancelAutoRefill:(NSString *)userkey
                WithCard:(NSString*)chosenCard
            successBlock:(NetworkSuccessBlock)successBlock
            failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief get the autorefill rule if user added one
 @param userkey the user userkey
 @return JSON formatted response contaning the autorefill rule if there is one
 */
+ (void)retrieveAutoRefillRule:(NSString *)userkey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Remove a credit card from user FLASHiZ account
 @param userkey the user userkey
 @param idCard the id of the credit card to remove
 @return JSON formatted response indicating whether or not credit card is successfully deleted
 */
+ (void)deleteCreditCard:(NSString *)userkey
                  withId:(NSString*)idCard
            successBlock:(NetworkSuccessBlock)successBlock
            failureBlock:(NetworkFailureBlock)failureBlock;

@end
