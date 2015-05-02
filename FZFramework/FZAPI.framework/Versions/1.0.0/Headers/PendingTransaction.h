//
//  Transaction.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

/**
 @brief Class that represent a Transaction obtained when requesting the transaction history of an user. A transaction represent any "transactions" that could happen between any flashiz users. (invoice, credit, transfert, ...)
 */
@interface PendingTransaction : FlashizObject

@property (copy, nonatomic) NSString *pendingTransactionId; //id of the transaction
@property (nonatomic) double amount; //amount
@property (nonatomic) BOOL isPending; //if the transaction is still pending or achieved
@property (nonatomic) BOOL isDebit; //if it is a debit or credit transaction (depends on the user side)
@property (copy, nonatomic) NSString *currency; //the currency of the transaction
@property (copy, nonatomic) NSDate *executionDate; //the execution date of the transaction (if executed and not still pending)
@property (copy, nonatomic) NSDate *creationDate; //the creation date of the transaction
@property (copy, nonatomic) NSString *tiers; //the name of the other user related to this transaction
@property (copy, nonatomic) NSString *comment; //a comment on the transaction
@property (copy, nonatomic) NSString *status; //his status
@property (copy, nonatomic) NSString *receiverInfo; //information of the other user related to this transaction
@property (copy, nonatomic) NSString *waitingUser; //dont know ...

/**
 @brief Generate a Transaction object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a an transaction object with
 @return A Transaction object containing user flashiz account information or nil if the dictionary does not contain all the needed keys
 */
+ (void)transactionWithDictionary:(NSDictionary *)transaction successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end