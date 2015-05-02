//
//  AvatarServices.h
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"

@class UIImage;

@interface AvatarServices : FlashizServices

/**
 @brief retrieve the user FLASHiZ account avatar using his mail
 @param user mail (login)
 @return The user avatar image (array of bytes)
 */
+ (void)avatarWithMail:(NSString *)userMail
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief get the user FLASHiZ account avatar using the user username
 @param userName the user username
 @return The user avatar image (array of bytes)
 */
+ (void)avatarWithUserName:(NSString *)userName
                 successBlock:(NetworkSuccessBlock)successBlock
                 failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve the user avatar timestamp
 @param mail the mail of the user
 @return The current user flashiz avatar timestamp
 */
+ (void)avatarTimestampWithMail:(NSString *)mail
                      successBlock:(NetworkSuccessBlock)successBlock
                      failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Change the user avatar by the given one
 @param userKey the user userkey
 @param avatarFile the avatar file to put on user FLASHiZ account
 @param token should be nil
 @return YES if the avatar has been correctly uploaded and saved on the user flashiz account
 */
+ (void)setAvatarWithUserKey:(NSString *)userKey avatar:(UIImage *)avatarFile token:(NSString *)token
                successBlock:(NetworkSuccessBlock)successBlock
                failureBlock:(NetworkFailureBlock)failureBlock;


@end
