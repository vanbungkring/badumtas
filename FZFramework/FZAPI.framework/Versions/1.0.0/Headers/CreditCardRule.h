//
//  CreditCardRule.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

/**
 @brief class that represents an automatic refill rule that can be put on a credit card
 */

//must be merged in CreditCard -> cannot be merge because we've got a specific service to retrive only the credit card rule
//__attribute__((deprecated))
@interface CreditCardRule : FlashizObject

@property (nonatomic) int takenAmount; //the amount that will be taken automaticly from the credit card when the user balance reach 0
@property (copy, nonatomic) NSString *pan; //credit card pan
@property (copy, nonatomic) NSString *currency; //the currency of the rule
@property (copy, nonatomic) NSString *creditCardId; //the id of the card on which is the rule
@property (copy, nonatomic) NSDate *expirationDate; //the date of the expiration of the rule (or the card ?)

/**
 @brief Generate CreditCard object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a an account object with
 @return A CreditCard object containing information of a particular credit card
 */
+ (void)creditCardRuleWithDictionary:(NSDictionary *)cardRule successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
