//
//  FZUrlSchemeManager.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/25/14.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface FZUrlSchemeManager : NSObject

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (void)applicationDidBecomeActive:(UIApplication *)application;

+ (NSDictionary *)parseQueryString:(NSString *)query;

- (void)connectWithMail:(NSString *)email andPassword:(NSString *)pwd;

+ (void)backToTheHostApplicationWithUserkey:(NSString *)aUserKey;

@end
