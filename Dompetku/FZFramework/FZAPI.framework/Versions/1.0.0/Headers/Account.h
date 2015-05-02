//
//  Account.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@interface Account : FlashizObject

@property (nonatomic) int accountId;
@property (copy, nonatomic) NSString *desc;
@property (nonatomic) double balance;
@property (copy, nonatomic) NSDate *openingDate;
@property (copy, nonatomic) NSArray *tag;
@property (nonatomic, copy) NSString *currency;

/**
 @brief Generate an Account object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a an account object with
 @return An Account object containing user flashiz account information or nil if the dictionary does not contain all the needed keys
 */
+ (void)accountWithDictionary:(NSDictionary *)account successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end