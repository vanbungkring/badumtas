//
//  TransactionServices.h
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"

@interface TransactionServices : FlashizServices

extern NSString * const TransactionsTypeMail;

/**
 @brief Send money to another user by mail or mobile phone number.
 @param amount the amount to send
 @param comment A comment to add to the transaction
 @param reciver The mail or phone number of the user we want to send to money to
 @param userKey userKey of the user that send the money
 @param type can be either "mail" or "phone"
 @return The new value of the sender balance
 */
+ (void)transfertMoney:(NSString *)amount
           withComment:(NSString *)comment
               forUser:(NSString *)reciver
              fromUser:(NSString *)userKey
              withType:(NSString *)type
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve last transactions of the user in the reverse chronological order (most recent one first)
 @param userKey userKey of the user we want to retrieve transaction from
 @return An Array containing transactions of the user in the reverse-chronological order
 @see Transaction
 */
+ (void)queuedTransactionsreceiverWithUserKey:(NSString *)userKey
                                     successBlock:(NetworkSuccessBlock)successBlock
                                     failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Accept a transaction. It is particularly use to accept money sent by another user via mail or phone numer
 @param idTransaction the id of the transaction to accept
 @param userKey the userkey of the userkey that accept the transaction
 @return The new value of the receiver balance (user that execute the transaction)
 */
+ (void)executeTransactionsWithId:(NSString *)idTransaction
                          forUser:(NSString *)userKey
                     successBlock:(NetworkSuccessBlock)successBlock
                     failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Cancel a transaction.
 @param idTransaction the id of the transaction to cancel
 @param userKey the userkey of the user that cancel the transaction
 @return The new value of the user balance (the one who cancel the transaction)
 */
+ (void)cancelTransactionsWithId:(NSString *)idTransaction
                         forUser:(NSString *)userKey
                         andSide:(NSString *)side
                    successBlock:(NetworkSuccessBlock)successBlock
                    failureBlock:(NetworkFailureBlock)failureBlock;

@end
