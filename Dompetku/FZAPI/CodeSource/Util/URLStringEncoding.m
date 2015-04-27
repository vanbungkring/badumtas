//
//  URLStringEncoding.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "URLStringEncoding.h"

@implementation URLStringEncoding

+ (NSString *)string:(NSString *)string usingEncoding:(NSStringEncoding)encoding {
    NSString *urlString  = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                               (CFStringRef)string,
                                                                               NULL,
                                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
    
	return [urlString autorelease];
}

@end
