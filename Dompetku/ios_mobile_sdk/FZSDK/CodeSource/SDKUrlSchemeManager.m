//
//  SDKUrlSchemeManager.m
//  FZSDK
//
//  Created by Matthieu Barile on 06/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "SDKUrlSchemeManager.h"

#import <FZBlackBox/FZUrlSchemeManager.h>

#import <FZBlackBox/FZUrlSchemes.h>

#import "SDKFlashizFacade.h"

#import <FZBlackBox/FZTargetManager.h>

@interface SDKUrlSchemeManager()

@end

@implementation SDKUrlSchemeManager

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    /*
    NSLog(@"url received: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    NSDictionary *dict = [FZUrlSchemeManager parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
     */
        
    if([[url path] isEqualToString:kUrlSchemeSdkLinkWithFlashiz]){

        NSDictionary *dict = [FZUrlSchemeManager parseQueryString:[url query]];
        NSString *userKey = [dict objectForKey:@"u"];
        NSString *environment = [dict objectForKey:@"e"];
        
        NSMutableDictionary *dataDict = [[FZTargetManager sharedInstance] callbackData];
        NSString *invoiceId = [dataDict objectForKey:@"invoiceId"];
        NSString *parentViewController = [dataDict objectForKey:@"parentViewController"];
        
        NSMutableDictionary *sharedData = [NSMutableDictionary dictionary];
        if(userKey) {
            [sharedData setObject:userKey forKey:@"u"];
        }
        if(environment) {
            [sharedData setObject:environment forKey:@"e"];
        }
        if(invoiceId) {
            [sharedData setObject:invoiceId forKey:@"i"];
        }
        if(parentViewController){
            [sharedData setObject:parentViewController forKey:@"p"];
        }
        
        //If we are in the SDK, FZFlashizFacade is registered to respond to this notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchFlashizSDK" object:sharedData userInfo:nil];
        
        return YES;
    }
    return NO;
}

- (void)dealloc {
//    [data release];
//    [super dealloc];
}

@end