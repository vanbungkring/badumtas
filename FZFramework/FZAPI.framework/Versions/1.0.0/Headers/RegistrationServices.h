//
//  RegistrationServices.h
//  iMobey
//
//  Created by Neopixl on 29/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashizServices.h"

@class User;

@interface RegistrationServices : FlashizServices

/**
 @brief Retrieve all the secret questions for registration
 @return NSMutableArray of secret questions */
+ (void)secretQuestionsWithSuccessBlock:(NetworkSuccessBlock)successBlock
                           failureBlock:(NetworkFailureBlock)failureBlock;


/**
 @brief Retrieve all countries for registration
 @return NSMutableArray of countries */
+ (void)countriesWithSuccessBlock:(NetworkSuccessBlock)successBlock
                     failureBlock:(NetworkFailureBlock)failureBlock;


+ (void)captchaSubmitWithCaptcha:(NSString *)captcha
                    successBlock:(NetworkSuccessBlock)successBlock
                    failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)createUserTrialWith:(User *)user
            forBrandPartner:(NSString *)brandPartner
               successBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock;


@end
