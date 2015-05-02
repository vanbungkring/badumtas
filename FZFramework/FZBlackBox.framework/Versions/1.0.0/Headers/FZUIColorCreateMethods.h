//
//  FZUIColorCreateMethods
//  iMobey
//
//  Created by Olivier Demolliens on 11/07/13.
//  Copyright (c) 2013 Olivier Demolliens. All rights reserved.
//

@interface FZUIColorCreateMethods : UIColor

// wrapper for [UIColor colorWithRed:green:blue:alpha:]
// values must be in range 0 - 255
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

// Creates color using hex representation
// hex - must be in format: #FF00CC
// alpha - must be in range 0.0 - 1.0
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithKey:(NSString *) key alpha:(CGFloat)alpha;
+ (NSString *)colorHexWithKey:(NSString *) key;

@end















