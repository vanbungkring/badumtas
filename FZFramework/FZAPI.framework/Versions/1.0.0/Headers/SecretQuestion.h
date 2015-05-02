//
//  SecretQuestion.h
//  flashiz_ios_api
//
//  Created by Matthieu Barile on 22/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashizObject.h"
#import "Error.h"

@interface SecretQuestion : FlashizObject

@property (copy, nonatomic) NSString *secretQuestion; //secret question of the user

/**
 @brief Generate an SecretQuestion object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param secretQuestion The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a user object with
 @return An SecretQuestion object containing the secret question or nil if the dictionary does not contain all the needed keys
 */
+ (void)secretQuestionWithDictionary:(NSDictionary *)secretQuestion successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
