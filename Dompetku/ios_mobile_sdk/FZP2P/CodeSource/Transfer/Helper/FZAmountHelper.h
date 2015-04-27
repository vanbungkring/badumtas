//
//  AmountHelper.h
//  iMobey
//
//  Created by Yvan Moté on 17/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZAmountHelper : NSObject

+ (NSString *)correctedAmountFromAmount:(NSString *)amount;
+ (BOOL)isValid:(NSString *)amount;

@end
