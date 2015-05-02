//
//  CheckPaymentResult.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

/**
 @brief Class that is obtained when trying to know if an invoice is currently paid or not. 
 */
@interface CheckPaymentResult : FlashizObject

@property (nonatomic) BOOL isPaid; //indicate if the invoice is paid or not
@property (nonatomic) double balance; //if paid indicates the new balance of the user after payment
@property (copy, nonatomic) NSString *currency; //the currency of the payment
@property (copy, nonatomic) NSString *username; //the name of the user who paid
@property (copy, nonatomic) NSString *user; //the full name of the user who paid (first + last name)

/**
 @brief Generate an CheckPaymentResult object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a an account object with
 @return An Account object containing user flashiz account information or nil if the dictionary does not contain all the needed keys
 */
+ (void)checkPaymentResultWithDictionary:(NSDictionary *)check successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
