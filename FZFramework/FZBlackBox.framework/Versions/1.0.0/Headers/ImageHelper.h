//
//  ImageHelper.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 23/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

//Enum
#import <FZAPI/FZFilesEnum.h>

@interface ImageHelper : NSObject

+ (instancetype)sharedInstance;

- (void)cleanInstance;

/*
 * Register the main bundle
 */

- (void)setBundle:(FZBundleName)mainBundle;

- (FZBundleName)bundleType;

- (NSBundle*)bundle;


@end
