//
//  FontsHelper.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 23/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//
#import <UIKit/UIKit.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

@class FZDefaultTemplateFonts;

static NSString *fontFuturaCondensedLight;
static NSString *fontFuturaCondensed;
static NSString *fontHelveticaNeueLight;
static NSString *fontHelveticaNeueBold;

static NSString *fontFuturaCondensedLightName;
static NSString *fontFuturaCondensedName;
static NSString *fontHelveticaNeueLightName;
static NSString *fontHelveticaNeueBoldName;

@interface FontHelper : NSObject
{
    
}

+ (instancetype)sharedInstance;

- (void)cleanInstance;

- (void)loadTemplate:(FZDefaultTemplateFonts*)aTemplate;

- (UIFont *)fontFuturaCondensedLightWithSize:(CGFloat)size;
- (UIFont *)fontFuturaCondensedWithSize:(CGFloat)size;
- (UIFont *)fontHelveticaNeueLightWithSize:(CGFloat)size;
- (UIFont *)fontHelveticaNeueBoldWithSize:(CGFloat)size;

@end
