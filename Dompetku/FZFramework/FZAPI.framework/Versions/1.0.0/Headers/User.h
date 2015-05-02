//
//  User.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

#import "Account.h"

@interface User : FlashizObject

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSNumber *fidelitizId;

//New - not added in parse
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSDate *birthday;
@property (copy, nonatomic) NSString *nationality;
@property (copy, nonatomic) NSString *address1;
@property (copy, nonatomic) NSString *cityCode;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *country;

//needed for registration
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *secretQuestion;
@property (copy, nonatomic) NSString *secretAnswer;
@property (copy, nonatomic) NSString *captcha;
@property (copy, nonatomic) NSString *pin;
//New

@property (nonatomic) BOOL isUserUpgraded;
@property (nonatomic) BOOL isMailValidated;
@property (nonatomic) BOOL isVerified;
@property (nonatomic) BOOL isCompany;
@property (nonatomic) BOOL canCreateCredit;
@property (retain, nonatomic) Account *account;

/**
 @brief Generate an User object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a user object with
 @return An User object containing user flashiz account information or nil if the dictionary does not contain all the needed keys
 */
+ (void)userWithDictionary:(NSDictionary *)user successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

+ (void)userWithInformationDictionary:(NSDictionary *)user successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

- (BOOL)isTrial;

#pragma mark Util

+ (BOOL)isTextBlankOrWhitespace: (NSString *)text;

+ (void)fillBlank:(User *)aUser;

@end
