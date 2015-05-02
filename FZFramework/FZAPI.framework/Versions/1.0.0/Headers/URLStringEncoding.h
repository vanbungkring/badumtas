//
//  URLStringEncoding.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLStringEncoding : NSObject

+ (NSString *)string:(NSString *)string usingEncoding:(NSStringEncoding)encoding;

@end
