//
//  NSStringFontSize.h
//  iMobey
//
//  Created by Matthieu Barile on 31/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSStringFontSize : NSString

+ (CGFloat)fontWith:(NSString*)lbl andSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
