//
//  CreditCard.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

/**
 @brief Class that represent a Credit Card.
 */
@interface CreditCard : FlashizObject


@property (copy, nonatomic) NSString *pan; //pan of the credit card
@property (copy, nonatomic) NSString *creditCardId; //id of the credit card  --> // TODO : declared as a NSString, but it's a NSNumber when u parse 🙈
@property (copy, nonatomic) NSString *owner; //the name of the owner
@property (copy, nonatomic) NSDate *expirationDate; //the expiration date of the card
@property (nonatomic) BOOL automaticRefill; //if there is an automatic refill rule on this card
@property (copy, nonatomic) NSString *comment; //a comment about this credit card

/**
 @brief Generate CreditCard object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a an account object with
 @return A CreditCard object containing information of a particular credit card 
 */
+ (void)creditCardWithDictionary:(NSDictionary *)card successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

- (BOOL)isExpired;
- (NSString *)month;
- (NSString *)year;

@end