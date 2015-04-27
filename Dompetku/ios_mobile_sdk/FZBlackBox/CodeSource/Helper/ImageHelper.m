//
//  ImageHelper.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 23/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "ImageHelper.h"

#import <UIKit/UIKit.h>

//Util
#import "FZImageUtil.h"

//Helper
#import "BundleHelper.h"



@interface ImageHelper()

@property(nonatomic,assign)FZBundleName mainBundle;

@end


#pragma mark - Keys -

#pragma mark Type

#define kBundleHelperTypeBundle @"bundle"

#pragma mark - Shared Instance -

@implementation ImageHelper

static ImageHelper *sharedInstance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageHelper alloc] init];
    });
    
    return [[sharedInstance retain]autorelease];
}

-(void)cleanInstance
{
    [self setBundle:FZBundleNone];
}

- (void)setBundle:(FZBundleName)mainBundle
{
    [sharedInstance setMainBundle:mainBundle];
}

- (FZBundleName)bundleType
{
    return [sharedInstance mainBundle];
}

- (NSBundle*)bundle
{
    NSString *pathBundle = nil;
    NSBundle *bundle = nil;
    
    pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:[sharedInstance bundleMain]] ofType:kBundleHelperTypeBundle];
    
    bundle = [NSBundle bundleWithPath:pathBundle];
    
    return bundle;
}


#pragma mark - Public -



@end
