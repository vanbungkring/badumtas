//
//  ConnectionServices.h
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"

@interface ConnectionServices : FlashizServices

+ (void)connect:(NSString *)theUser
       password:(NSString *)pwd
      firstTime:(BOOL)firstTime
     withDevice:(NSString *)device
 withDeviceName:(NSString *)name
   successBlock:(NetworkSuccessBlock)successBlock
   failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)connectWithKey:(NSString *)userKey
                andPin:(NSString *)pin
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)disconnect:(NSString *)userkey
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)retrieveAccount:(NSString *)userKey
           successBlock:(NetworkSuccessBlock)successBlock
           failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)retrieveUserInfos:(NSString *)userKey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)retrieveUserInfosLight:(NSString *)userKey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

#pragma mark - Pin Code management

+ (void)sendPIN:(NSString *)PIN
    withUserKey:(NSString *)userKey
      withToken:(NSString *)token
   successBlock:(NetworkSuccessBlock)successBlock
   failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)checkPIN:(NSString *)PIN
     withUserKey:(NSString *)userKey
    successBlock:(NetworkSuccessBlock)successBlock
    failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)changePIN:(NSString *)oldPIN
         toNewPIN:(NSString *)newPIN
      withUserKey:(NSString *)userKey
     successBlock:(NetworkSuccessBlock)successBlock
     failureBlock:(NetworkFailureBlock)failureBlock;

#pragma mark - Forgotten password

+ (void)forgottenPassword:(NSString *)email
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)secretQuestion:(NSString *)token
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)confirmSecretAnswer:(NSString *)token
               secretAnswer:(NSString *)secretAnswer
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

+ (void)changePassword:(NSString *)password
                 token:(NSString *)token
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

#pragma mark - update trial status

//Test if the mail is validated while the account is trial
+ (void)updateIfStillTrial;

@end
