//
//  FlashizErrorHelper.m
//  iMobey
//
//  Created by Yvan Moté on 21/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizErrorHelper.h"


@implementation FlashizErrorHelper

+ (NSString *)errorMessageForKey:(NSString *)key {
    
    return [self errorMessageForKey:key inBundle:nil];
}

+ (NSString *)errorMessageForKey:(NSString *)key inBundle:(NSBundle *)currentBundle {
    
    if([key length]==0) {
        return nil;
    }
    
    #warning Quick Fix! The real fix will be done on server.
    if([key isEqualToString:@"null"]) {
        return nil;
    }
    
    #warning TODO : override error for Leclerc or other apps
    
    NSString *value = [currentBundle localizedStringForKey:key value:nil table:@"FZAPI"];
    
    if(value==nil || [value isEqualToString:key]){
        value = [currentBundle localizedStringForKey:@"-10000" value:@"Error" table:@"FZAPI"];
    }
    
    return value;
}

@end