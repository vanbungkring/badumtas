//
//  CGUUrlUtil.m
//  iMobey
//
//  Created by Yvan Moté on 31/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "CGUUrlUtil.h"

static NSString * const BASE_URL = @"http://media.flashiz.com/CGU/";

@implementation CGUUrlUtil

+ (NSString *)localizedCGUUrl {
    
    // TODO: need refactor
    
    /*if([[TemplateConfiguration brandPartner] isEqualToString:@"leclerc"]) {
        return [BASE_URL stringByAppendingString:@"Paiement_flash"];
    } else {*/
        NSString *preferredLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if([preferredLanguage isEqualToString:@"fr"]) {
            return [BASE_URL stringByAppendingString:@"CGU_Flashiz_LU"];
        }
        else if([preferredLanguage isEqualToString:@"es"]){
            return [BASE_URL stringByAppendingString:@"CGU_Flashiz_ES"];
        }
        else {
            return [BASE_URL stringByAppendingString:@"CGU_Flashiz_LU"];
        }
    //}
}

+ (NSString *)localizedCGURewardsUrl {
    return [BASE_URL stringByAppendingString:@"CGU_Flashiz_Rewards_LU"];
}

@end
