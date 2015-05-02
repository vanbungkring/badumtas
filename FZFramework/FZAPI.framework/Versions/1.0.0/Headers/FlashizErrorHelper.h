//
//  FlashizErrorHelper.h
//  iMobey
//
//  Created by Yvan Moté on 21/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

 __attribute__((deprecated))
@interface FlashizErrorHelper : NSObject

+ (NSString *)errorMessageForKey:(NSString *)key  __attribute__((deprecated));
+ (NSString *)errorMessageForKey:(NSString *)key inBundle:(NSBundle *)currentBundle  __attribute__((deprecated));

@end
