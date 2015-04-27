//
//  BundleHelper.h
//  flashiz_ios_core_ui
//
//  Created by Olivier Demolliens on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

@class UIViewController;

@interface BundleHelper : NSObject

#pragma mark - Shared Instance -

+ (instancetype)sharedInstance;

- (void)cleanInstance;

/*
 * Register the main bundle
 */

- (void)setBundle:(FZBundleName)mainBundle;

- (FZBundleName)bundleMain;

- (NSBundle*)bundle;

/*
 * Register the root bundle (which contains the others bundles
 */

- (void)setBundleRoot:(FZBundleName)rootBundle;

#pragma mark - Private -

- (NSString *)retrievePNGResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName;

- (NSString *)retrieveNibResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName;

- (NSString *)retrieveStringsResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName;

- (NSString *)retrieveFontResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName;

- (id)loadNibResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName;

- (BOOL)isPNGResourceExistInMainBundle:(NSString*)ressourceName;

- (BOOL)isNibResourceExistInMainBundle:(NSString*)ressourceName;

- (BOOL)isStringsResourceExistInMainBundle:(NSString*)ressourceName;

- (BOOL)isFontResourceExistInMainBundle:(NSString*)ressourceName;

#pragma mark - Static -

#pragma mark Util

+ (NSString *)nibNameForController:(UIViewController*)controller;

+ (BOOL)isPNGResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName;

+ (BOOL)isNibResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName;

+ (BOOL)isStringsResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName;

+ (BOOL)isFontResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName;

+ (NSString *)retrievePNGResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

+ (NSString *)retrieveNibResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

+ (NSString *)retrieveStringsResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

+ (NSString *)retrieveFontResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

+ (id)loadNibResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

#pragma mark Bundle Core

+ (NSBundle*)retrieveBundle:(FZBundleName)bundleName;

+ (NSString*)retrieveBundleName:(FZBundleName) bundleName;

+ (NSString*)retrieveLocalizableName:(FZBundleName) bundleName;

+ (NSString*)retrieveType:(FZFileType) type;

+ (NSString*)retrieveBundlePath:(FZBundleName)bundleName;

+ (NSString *)retrieveResourceWithName:(NSString*)ressourceName ofType:(FZFileType)type inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

+ (id)loadResourceWithName:(NSString*)ressourceName ofType:(FZFileType)type inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName;

+ (BOOL)isResourceExist:(NSString*)ressourceName ofType:(FZFileType)type inBundle:(FZBundleName)mainBundleName;

#pragma mark - Unit Testing

- (void)setRootBundle:(FZBundleName) bundleName;
- (FZBundleName)rootBundle;

@end
