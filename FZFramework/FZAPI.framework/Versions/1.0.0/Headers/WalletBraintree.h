//
//  WalletBraintree.h
//  iMobey
//
//  Created by Matthieu Barile on 05/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

@interface WalletBraintree : FlashizObject

@property (copy, nonatomic) NSString *actionFormUrl;
@property (copy, nonatomic) NSString *trData;


/**
 @brief Generate an WalletBraintree object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a a Wallet object with
 @return A WalletBraintree object
 */
+ (void)walletBraintreeWithDictionary:(NSDictionary *)wallet successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end