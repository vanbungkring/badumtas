//
//  ChangePassword.h
//  flashiz_ios_api
//
//  Created by Matthieu Barile on 22/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "FlashizObject.h"
#import "Error.h"

@interface ChangePassword : FlashizObject

@property (copy, nonatomic) NSString *email; //email of the user

/**
 @brief Generate an ChangePassword object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param changePassword The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a user object with
 @return An ChangePassword object containing the email of the user nil if the dictionary does not contain all the needed keys
 */
+ (void)changePasswordWithDictionary:(NSDictionary *)changePassword successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
