//
//  FidelitizServices.h
//  iMobey
//
//  Created by Yvan Moté on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"

@interface RewardsServices : FlashizServices

/**
 @brief Create a new fidelitiz account
 @return JSON formatted response containing the new fidelitiz account
 */
+ (void)createFidelitizAccountWithSuccessBlock:(NetworkSuccessBlock)successBlock
                                  failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Create a new fidelitiz card for a particular program (public)
 @param fidelitizId the user fidelitiz id
 @param loyaltyProgramId the program id to create the card for
 @return JSON formatted response contaning the new fidelitiz card
 */
+ (void)createFidelitizCard:(NSString*)fidelitizId
   AffiliatedToTheProgramId:(NSString*)loyaltyProgramId
           withSuccessBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Create a new fidelitiz card for a particular program (private)
 @param fidelitizId the user fidelitiz id
 @param loyaltyProgramId the program id to create the card for
 @param the reference code adherent of the user
 @return JSON formatted response contaning the new fidelitiz card
 */
+ (void)createFidelitizCard:(NSString*)fidelitizId AffiliatedToTheProgramId:(NSString*)loyaltyProgramId PrivateReference:(NSString*)reference withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Delete a fidelitiz card
 @param fidelitizId the user fidelitiz id
 @param loyaltyCardId the id of the fidelitiz card to delete
 @return JSON formatted response indicating if the operation is a success or not
 */
+ (void)deleteFidelitizCard:(NSString*)fidelitizId CardId:(NSString*)loyaltyCardId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve all the fidelitiz cards of the user
 @param fdelitizId the fidelitiz id of the user
 @return JSON formatted response contaning user fidelitiz cards
 */
+ (void)fidelitizCards:(NSString*)fidelitizId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve information a the given fidelitiz card
 @param loyaltyCardId the id of the fidelitiz card we want to get information from
 @return JSON formatted response containing the fidelitiz card information
 */
+ (void)fidelitizCard:(NSString*)loyaltyCardId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
+ (void)fidelitizCardsWithUserkey:(NSString*)userkey withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief retrieve the detail a fidelitiz program
 @param loyaltyProgramId the program id
 @param withLogo
 @return JSON formatted response contaning the detail of the program
 */
+ (void)programDetails:(NSString*)loyaltyProgramId withLogo:(BOOL)withLogo withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve the list of all fidelitiz programs that user has not subscribed to
 @param fidelitizId user fidelitiz id
 @return JSON formatted response contaning the list of all fidelitiz programs user not subscribed to
 */
+ (void)programsListNotAlreadySuscribe:(NSString*)fidelitizId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
+ (void)programsListNotAlreadySuscribeWithUserkey:(NSString*)userkey withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve the program affiliated to the one given in parameter
 @param proId the program id
 @return JSON formatted response contaning the programs affiliated to the one in parameters
 */
+ (void)affiliatesList:(NSString*)proId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;


@end
