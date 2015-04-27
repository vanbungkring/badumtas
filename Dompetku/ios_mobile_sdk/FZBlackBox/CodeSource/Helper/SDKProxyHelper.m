//
//  SDKProxyHelper.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 25/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "SDKProxyHelper.h"
#import <UIKit/UIKit.h>

#import "FZUrlSchemes.h"
#import "FlashizUrlSchemeDatasource.h"

#import "FZTargetManager.h"

@implementation SDKProxyHelper

#pragma mark - Utils

+ (BOOL)isApplicationUsingSDK {
    return [[FZTargetManager sharedInstance] isApplicationUsingSDK];
}

+ (BOOL)isLoginAvailable {
    // TODO : need to use MultiTargetManager
    id loginViewController = nil;//[[ComponentHelper proxy] loginViewController];

    return (loginViewController!=nil);
}

+ (BOOL)isTopupAvailable {
    return [SDKProxyHelper canOpenUrl:[SDKProxyHelper topupProcessUrl]];
}

+ (BOOL)isFillUserInfoAvailable {
    return [SDKProxyHelper canOpenUrl:[SDKProxyHelper fillUserInfoProcessUrl]];
}

+ (BOOL)isForgottenPasswordAvailable {
    return [SDKProxyHelper canOpenUrl:[SDKProxyHelper forgottenPasswordUrl]];
}

+ (BOOL)isRegisteringAvailable {
    return [SDKProxyHelper canOpenUrl:[SDKProxyHelper registeringProcessUrl]];
}

+ (BOOL)isLinkWithFlashizAvailable {
    return [SDKProxyHelper canOpenUrl:[SDKProxyHelper linkWithFlashizProcessUrl]];

}

+ (BOOL)isAddCreditCardAvailableWithUserKey:(NSString *)userKey
                                environment:(NSString *)environment {
    return [SDKProxyHelper canOpenUrl:[SDKProxyHelper addCreditCardProcessUrlWithUserKey:userKey environment:environment]];
}

#pragma mark - Open methods

+ (void)openFlashizAppStoreUrl {
    NSString *appStoreUrl = @"https://itunes.apple.com/fr/app/flashiz/id467111347?l=en&mt=8";
    
    [SDKProxyHelper openUrl:[NSURL URLWithString:appStoreUrl]];
}

+ (void)openForgottenPasswordProcessWithMail:(NSString *)mail {
    if([SDKProxyHelper isForgottenPasswordAvailable]) {
        [SDKProxyHelper openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mail=%@",[SDKProxyHelper forgottenPasswordUrl],mail]]];
    }
    else {
        [SDKProxyHelper openFlashizAppStoreUrl];
    }
}

+ (void)openRegisterProcess {
    if([SDKProxyHelper isRegisteringAvailable]) {
        [SDKProxyHelper openUrl:[SDKProxyHelper registeringProcessUrl]];
    }
    else {
        [SDKProxyHelper openFlashizAppStoreUrl];
    }
}

+ (void)openTopupProcessWithUserKey:(NSString *)userKey
                        environment:(NSString *)environment {
    if([SDKProxyHelper isTopupAvailable]) {
        [SDKProxyHelper openUrl:[SDKProxyHelper topupProcessUrlWithUserKey:userKey
                                                               environment:environment]];
    } else {
        [SDKProxyHelper openFlashizAppStoreUrl];
    }
}

+ (void)openFillUserInformationsProcessWithUserKey:(NSString *)userKey
                                       environment:(NSString *)environment {
    NSURL *fillUserInfoProcessUrl = [SDKProxyHelper fillUserInfoProcessUrlWithUserKey:userKey environment:environment];
    
    if([SDKProxyHelper isFillUserInfoAvailable]) {
        [SDKProxyHelper openUrl:fillUserInfoProcessUrl];
    } else {
        [SDKProxyHelper openFlashizAppStoreUrl];
    }
}

+ (void)openLinkToFlashizApplicationWithCustomerScheme:(NSString *)customerScheme customerHost:(NSString *)customerHost {
    
    if([SDKProxyHelper isLinkWithFlashizAvailable]){

        NSString *baseUrlString = [SDKProxyHelper baseUrlString];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sdk/linkWithFlashiz?c=%@://%@",baseUrlString,customerScheme,customerHost]];
        
        [SDKProxyHelper openUrl:url];
    } else {
        [SDKProxyHelper openFlashizAppStoreUrl];
    }
}

+ (void)backToTheHostApplicationWithCustomerUrlScheme:(NSString *)customerUrlScheme userKey:(NSString *)userKey environment:(NSString *)environment {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sdk/linkWithFlashiz?u=%@&e=%@",customerUrlScheme,userKey,environment]];
    
    [SDKProxyHelper openUrl:url];
}

+ (void)openAddCreditCardProcessWithUserKey:(NSString *)userKey environment:(NSString *)environment {
    if([SDKProxyHelper isAddCreditCardAvailableWithUserKey:userKey environment:environment]) {
        [SDKProxyHelper openUrl:[SDKProxyHelper addCreditCardProcessUrlWithUserKey:userKey environment:environment]];
    } else {
        [SDKProxyHelper openFlashizAppStoreUrl];
    }
}

#pragma mark - Urls methods

+ (NSString *)baseUrlString {
    id<FlashizUrlSchemeDatasource> urlSchemeDatasource = (id<FlashizUrlSchemeDatasource>)[[UIApplication sharedApplication] delegate];
    
    NSString *urlScheme = nil;
    NSString *urlHost = nil;
    
    NSString *baseUrl = nil;
    
    if([urlSchemeDatasource respondsToSelector:@selector(customUrlScheme)]) {
        urlScheme = [urlSchemeDatasource customUrlScheme];
    }
    
    if([urlSchemeDatasource respondsToSelector:@selector(customUrlHost)]) {
        urlHost = [urlSchemeDatasource customUrlHost];
    }
    
    if([urlHost length]>0 && [urlScheme length]>0) {
        baseUrl = [NSString stringWithFormat:@"%@://%@",urlScheme,urlHost];
    }
    
    if([baseUrl length]==0) {
        baseUrl = @"flashiz://flashiz";
    }
    
    return baseUrl;
}

+ (void)openUrl:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)canOpenUrl:(NSURL *)url {
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+ (NSURL *)forgottenPasswordUrl {
    if([self isApplicationUsingSDK]){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkForgottenPassword]];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SDKProxyHelper baseUrlString],kUrlSchemeStartForgottenPasswordPath]];
    }
}

+ (NSURL *)registeringProcessUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkRegisterNewUser]];
}

+ (NSURL *)topupProcessUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkTopup]];
}

+ (NSURL *)topupProcessUrlWithUserKey:(NSString *)userKey
                          environment:(NSString *)environment {
    //u = user
    //e = environment
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?u=%@&e=%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkTopup,userKey,environment]];
}

+ (NSURL *)fillUserInfoProcessUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkFillUserInfoTopup]];
}

+ (NSURL *)fillUserInfoProcessUrlWithUserKey:(NSString *)userKey
                                 environment:(NSString *)environment {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?u=%@&e=%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkFillUserInfoTopup,userKey,environment]];
}

+ (NSURL *)linkWithFlashizProcessUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkLinkWithFlashiz]];
}

+ (NSURL *)addCreditCardProcessUrlWithUserKey:(NSString *)userKey
                                  environment:(NSString *)environment {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?u=%@&e=%@",[SDKProxyHelper baseUrlString],kUrlSchemeSdkAddCreditCard,userKey,environment]];
}

@end
