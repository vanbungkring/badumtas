//
//  SDKProxyHelper.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 25/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKProxyHelper : NSObject

+ (void)openForgottenPasswordProcessWithMail:(NSString *)mail;

+ (void)openRegisterProcess;

+ (void)openTopupProcessWithUserKey:(NSString *)userKey
                        environment:(NSString *)environment;

+ (void)openLinkToFlashizApplicationWithCustomerScheme:(NSString *)customerScheme customerHost:(NSString *)customerHost;
+ (void)backToTheHostApplicationWithCustomerUrlScheme:(NSString *)customerUrlScheme userKey:(NSString *)userKey environment:(NSString *)environment;

+ (void)openFillUserInformationsProcessWithUserKey:(NSString *)userKey
                                       environment:(NSString *)environment;

+ (void)openAddCreditCardProcessWithUserKey:(NSString *)userKey
                                environment:(NSString *)environment;

+ (BOOL)isApplicationUsingSDK;

+ (BOOL)isLoginAvailable;
+ (BOOL)isTopupAvailable;

@end