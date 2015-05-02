//
//  Wallet.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

/**
 Have no really infor about Wallet and how it works.
 */
@interface Wallet : FlashizObject

@property (copy, nonatomic) NSString *redirectUrl;
@property (copy, nonatomic) NSString *creditCardId;

/**
 @brief Generate an Wallet object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a a Wallet object with
 @return A Wallet object
 */
+ (void)walletWithDictionary:(NSDictionary *)wallet successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end