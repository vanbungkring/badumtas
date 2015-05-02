//
//  LocalizationHelper.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

@interface LocalizationHelper : NSObject
{
    
}

#pragma mark - Shared Instance -

+ (instancetype)sharedInstance;

/*
 * Register the main bundle
 */

- (void)setBundle:(FZBundleName)mainBundle;

- (FZBundleName)bundleMain;

- (NSBundle*)bundle;

- (void)setLanguage:(NSString*)lang;

/**/


#pragma mark - Util -

+ (NSString *)reflectErrorForKey:(NSString *)key withComment:(NSString *)comment inDefaultBundle:(NSString*)bundle;

+ (NSString *)stringForKey:(NSString *)key withComment:(NSString *)comment inDefaultBundle:(FZBundleName)bundle;

+ (NSString *)errorForKey:(NSString *)key withComment:(NSString *)comment inDefaultBundle:(FZBundleName)bundle;


@end
