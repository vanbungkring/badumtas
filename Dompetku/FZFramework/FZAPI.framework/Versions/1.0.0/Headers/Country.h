//
//  Country.h
//  iMobey
//
//  Created by Neopixl on 29/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

@interface Country : FlashizObject

@property (copy, nonatomic) NSString *code; //country code
@property (copy, nonatomic) NSString *name; //localized name
@property (copy, nonatomic) NSString *phone_prefix; //phone prefix
@property (copy, nonatomic) NSString *reference; //Reference is a code representing the name of the country, always in english, without space (ex: UnitedStates)

/**
 @brief Generate an Country object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param country The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a user object with
 @return An Country object containing country information or nil if the dictionary does not contain all the needed keys
 */
+ (void)countryWithDictionary:(NSDictionary *)country successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end