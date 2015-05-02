//
//  UserServices.h
//  iMobey
//
//  Created by Neopixl on 02/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashizServices.h"

@class User;
@interface UserServices : FlashizServices

+ (void)userGetInformation:(NetworkSuccessBlock)successBlock
                           failureBlock:(NetworkFailureBlock)failureBlock;


+ (void)userEditInformation:(User *)user userkey:(NSString *)userkey withSuccesBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock;


@end
