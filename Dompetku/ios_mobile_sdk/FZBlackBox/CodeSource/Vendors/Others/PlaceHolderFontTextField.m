//
//  PlaceHolderFontTextField.m
//  iMobey
//
//  Created by Olivier Demolliens on 06/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "PlaceHolderFontTextField.h"

#import "FontHelper.h"


@implementation PlaceHolderFontTextField

+ (void)forceLinkerLoad_ {
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f]];
  
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f],NSFontAttributeName, nil];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
        
        [super setAttributedPlaceholder:attributedString];
        
        [attributedString release];

        [self setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
    else {
        [self setKeyboardAppearance:UIKeyboardAppearanceAlert];  //iOS 7 Deprecated:Use UIKeyboardAppearanceDark instead
    }
}


- (void) drawPlaceholderInRect:(CGRect)rect
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [super drawPlaceholderInRect:rect];
    }
    else {
        [self setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f]];
        [[UIColor grayColor] setFill];
        
        //This code will be executed on iOS 6.1 and earlier so we can ignore the warning using "-Wdeprecated-declarations"
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[self placeholder] drawInRect:rect withFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f]];
#pragma clang diagnostic pop
 
    }
}

@end
