//
//  FontsHelper.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 23/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "FontHelper.h"

#import "BundleHelper.h"

#import "FZDefaultTemplateFonts.h"

#import <CoreText/CoreText.h>

@interface FontHelper()
{
    
}

@property (assign, nonatomic) BOOL fontInit;

@end

static FontHelper *sharedInstance = nil;

static NSString *fontFuturaCondensedLight = nil;
static NSString *fontFuturaCondensed = nil;
static NSString *fontHelveticaNeueLight = nil;
static NSString *fontHelveticaNeueBold = nil;

static NSString *fontFuturaCondensedLightName = nil;
static NSString *fontFuturaCondensedName = nil;
static NSString *fontHelveticaNeueLightName = nil;
static NSString *fontHelveticaNeueBoldName = nil;

@implementation FontHelper

#pragma mark - Private -
#pragma mark - Shared Instance

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FontHelper alloc] init];
    });
    
    return [[sharedInstance retain] autorelease];
}

-(void)cleanInstance
{
    fontFuturaCondensedLightName = nil;
    fontFuturaCondensedName = nil;
    fontHelveticaNeueLightName = nil;
    fontHelveticaNeueBoldName = nil;
    
    fontFuturaCondensedLight = nil;
    fontFuturaCondensed = nil;
    fontHelveticaNeueLight = nil;
    fontHelveticaNeueBold = nil;
}

-(void)loadTemplate:(FZDefaultTemplateFonts*)aTemplate{
    
    fontFuturaCondensedLight = [aTemplate futurConLigFileName];
    fontFuturaCondensed = [aTemplate futurConFileName];
    fontHelveticaNeueLight = [aTemplate helveticaFileName];
    fontHelveticaNeueBold = [aTemplate helveticaBoldFileName];
    
    fontFuturaCondensedLightName = [aTemplate futurConLigName];
    fontFuturaCondensedName = [aTemplate futurConName];
    fontHelveticaNeueLightName = [aTemplate helveticaName];
    fontHelveticaNeueBoldName = [aTemplate helveticaBoldName];
    
    NSString *futurConPath = [BundleHelper retrieveFontResourceWithName:[aTemplate futurConFileName] inMainBundle:[aTemplate bundleType] orDefaultBundle:FZBundleBlackBox];
    
    if(futurConPath==nil || [futurConPath isEqualToString:@""]){
        FZBlackBoxLog(@"Can't retrieve font path:%@",[aTemplate futurConName]);
    }
    
    NSString *futurConLigPath = [BundleHelper retrieveFontResourceWithName:[aTemplate futurConLigFileName] inMainBundle:[aTemplate bundleType] orDefaultBundle:FZBundleBlackBox];
    
    
    if(futurConLigPath==nil || [futurConLigPath isEqualToString:@""]){
        FZBlackBoxLog(@"Can't retrieve font path:%@",[aTemplate helveticaName]);
    }
    
    NSString *helveticaPath = [BundleHelper retrieveFontResourceWithName:[aTemplate helveticaFileName] inMainBundle:[aTemplate bundleType] orDefaultBundle:FZBundleBlackBox];
    
    if(helveticaPath==nil || [helveticaPath isEqualToString:@""]){
        FZBlackBoxLog(@"Can't retrieve font path:%@",[aTemplate helveticaName]);
    }
    
    NSString *helveticaBoldPath = [BundleHelper retrieveFontResourceWithName:[aTemplate helveticaBoldFileName] inMainBundle:[aTemplate bundleType] orDefaultBundle:FZBundleBlackBox];
    
    if(helveticaBoldPath==nil || [helveticaBoldPath isEqualToString:@""]){
        FZBlackBoxLog(@"Can't retrieve font path:%@",[aTemplate helveticaBoldName]);
    }
    
    
    if (!_fontInit) {
        _fontInit = YES;
        
        NSData *futurConFontData = [NSData dataWithContentsOfFile:futurConPath];
        NSData *futurConLigFontData = [NSData dataWithContentsOfFile:futurConLigPath];
        NSData *helveticaFontData = [NSData dataWithContentsOfFile:helveticaPath];
        NSData *helveticaBoldFontData = [NSData dataWithContentsOfFile:helveticaBoldPath];
    
        [FontHelper loadDataFont:futurConFontData];
        [FontHelper loadDataFont:futurConLigFontData];
        [FontHelper loadDataFont:helveticaFontData];
        [FontHelper loadDataFont:helveticaBoldFontData];
    }
    
}

#pragma mark - Util

+ (void)loadDataFont:(NSData *)dataFont {
    if(nil==dataFont) {
        FZBlackBoxLog(@"Can't load fonts");
        return;
    }

    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)dataFont);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
    
    /*for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }*/
    
}

#pragma mark - Public -

- (UIFont *)fontFuturaCondensedLightWithSize:(CGFloat)size {
    if (sharedInstance==nil) {
        FZBlackBoxLog(@"Color - not shared instance setted");
        return nil;
    }
    return [UIFont fontWithName:fontFuturaCondensedLightName size:size];
}

- (UIFont *)fontFuturaCondensedWithSize:(CGFloat)size {
    if (sharedInstance==nil) {
        FZBlackBoxLog(@"Color - not shared instance setted");
        return nil;
    }
    return [UIFont fontWithName:fontFuturaCondensedName size:size];
}

- (UIFont *)fontHelveticaNeueLightWithSize:(CGFloat)size {
    if (sharedInstance==nil) {
        FZBlackBoxLog(@"Color - not shared instance setted");
        return nil;
    }
    return [UIFont fontWithName:fontHelveticaNeueLightName size:size];
}

- (UIFont *)fontHelveticaNeueBoldWithSize:(CGFloat)size {
    if (sharedInstance==nil) {
        FZBlackBoxLog(@"Color - not shared instance setted");
        return nil;
    }
    return [UIFont fontWithName:fontHelveticaNeueBoldName size:size];
}

@end
