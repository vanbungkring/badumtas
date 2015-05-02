//
//  FZButton.h
//  flashiz_ios_core_ui
//
//  Created by Matthieu Barile on 13/02/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZButton : UIButton

+ (void)forceLinkerLoad_;

- (void)setBackgroundNormalColor:(UIColor *)backgroundColor;
- (void)setBackgroundHighlightedColor:(UIColor *)highlightedColor;

- (void)setBorderNormalColor:(UIColor *)borderColor;
- (void)setBorderHighlightedColor:(UIColor *)borderHighlightedColor;

@end
