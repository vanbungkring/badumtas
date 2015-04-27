//
//  AmountHelper.m
//  iMobey
//
//  Created by Yvan Moté on 17/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FZAmountHelper.h"

@implementation FZAmountHelper

+ (NSString *)correctedAmountFromAmount:(NSString *)amount {
    return [amount stringByReplacingOccurrencesOfString:@"," withString:@"."];
}

+ (BOOL)isValid:(NSString *)amount {
    NSString *correctedAmount = [FZAmountHelper correctedAmountFromAmount:amount];
    
    return ([[correctedAmount componentsSeparatedByString:@"."] count]<=2);
}

@end
