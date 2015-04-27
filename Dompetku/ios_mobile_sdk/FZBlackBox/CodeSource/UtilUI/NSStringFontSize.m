//
//  NSStringFontSize.m
//  iMobey
//
//  Created by Matthieu Barile on 31/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "NSStringFontSize.h"

# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping

@implementation NSStringFontSize

+ (CGFloat)fontWith:(NSString*)lbl andSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGFloat fontSize = [font pointSize];
    CGFloat height = [lbl sizeWithFont:font constrainedToSize:CGSizeMake(size.width,FLT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height;
    UIFont *newFont = font;
    
    //Reduce font size while too large, break if no height (empty string)
    while (height > size.height && height != 0) {
        fontSize--;
        newFont = [UIFont fontWithName:font.fontName size:fontSize];
        height = [lbl sizeWithFont:newFont constrainedToSize:CGSizeMake(size.width,FLT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height;
    };
    
    // Loop through words in string and resize to fit
    for (NSString *word in [lbl componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
        CGFloat width = [word sizeWithFont:newFont].width;
        while (width > size.width && width != 0) {
            fontSize--;
            newFont = [UIFont fontWithName:font.fontName size:fontSize];
            width = [word sizeWithFont:newFont].width;
        }
    }
    return fontSize;
}

@end
