//
//  BundleHelper.m
//  flashiz_ios_core_ui
//
//  Created by Olivier Demolliens 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "BundleHelper.h"

//FW
#import <UIKit/UIKit.h>

//Target manager
#import "FZTargetManager.h"

@class UIViewController;

@interface BundleHelper()

@property (nonatomic,assign) FZBundleName mainBundle;
@property (nonatomic,assign) FZBundleName rootBundle;

@end

@implementation BundleHelper

#pragma mark - Keys -

/*
 * kBundleHelperLocalizable******* = name of the .plist file
 * kBundleHelper******* = name of the .bundle file
 */

#pragma mark Core Framework

#define kBundleHelperFZBlackBox @"FZResources-BlackBox"
#define kBundleHelperLocalizableFZBlackBox @"FZBlackBox"
#define kBundleHelperFZCoreUI @"FZResources-CoreUI"
#define kBundleHelperLocalizableFZCoreUI @"FZCoreUI"
#define kBundleHelperFZBundleSDK @"FZResources-SDK"
#define kBundleHelperLocalizableFZBundleSDK @"FZSDK"
#define kBundleHelperFZBundleBankSDK @"FZResources-BankSDK"
#define kBundleHelperLocalizableFZBundleBankSDK @"FZBankSDK"

#pragma mark External Framework

#define kBundleHelperFZAPI @"FZResources-API"
#define kBundleHelperLocalizableFZAPI @"FZAPI"
#define kBundleHelperFZExtLibs @"FZExtLibs"
#define kBundleHelperLocalizableFZExtLibs @"FZExtLibs"
#define kBundleHelperFZP2P @"FZResources-P2P"
#define kBundleHelperLocalizableFZP2P @"FZP2P"
#define kBundleHelperFZPayment @"FZResources-Payment"
#define kBundleHelperLocalizableFZPayment @"FZPayment"
#define kBundleHelperFZRewards @"FZResources-Rewards"
#define kBundleHelperLocalizableFZRewards @"FZRewards"

#pragma mark External App

#define kBundleHelperFZLeclerc @"FZResources-Leclerc"
#define kBundleHelperLocalizableFZLeclerc @"FZLeclerc"
#define kBundleHelperFZFlashiz @"FZResources-Flashiz"
#define kBundleHelperLocalizableFZFlashiz @"FZFlashiz"

#pragma mark Type

#define kBundleHelperTypeBundle @"bundle"
#define kBundleHelperTypePng @"png"
#define kBundleHelperTypeXib @"nib"
#define kBundleHelperTypeStrings @"strings"
#define kBundleHelperTypeFont @"ttf"

#pragma mark - Shared Instance -

static BundleHelper *sharedInstance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceBundleHelper;
    dispatch_once(&onceBundleHelper, ^{
        sharedInstance = [[BundleHelper alloc] init];
    });
    
    return [[sharedInstance retain]autorelease];
}

- (void)setBundle:(FZBundleName)mainBundle
{
    [sharedInstance setMainBundle:mainBundle];
}

- (FZBundleName)bundleMain
{
    return [sharedInstance mainBundle];
}

-(void)cleanInstance
{
    [self setMainBundle:FZBundleNone];
    [self setRootBundle:FZBundleNone];
}

- (NSBundle*)bundle
{
    NSString *pathBundle = nil;
    NSBundle *bundle = nil;
    
    pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:[sharedInstance bundleMain]] ofType:kBundleHelperTypeBundle];
    
    bundle = [NSBundle bundleWithPath:pathBundle];
    
    return bundle;
}

- (void)setBundleRoot:(FZBundleName)rootBundle {
    [sharedInstance setRootBundle:rootBundle];
}

- (NSString *)retrievePNGResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrievePNGResourceWithName:ressourceName inMainBundle:[sharedInstance mainBundle] orDefaultBundle:defaultBundleName];
}

- (id)loadNibResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper loadNibResourceWithName:ressourceName inMainBundle:[sharedInstance mainBundle] orDefaultBundle:defaultBundleName];
}

- (NSString *)retrieveNibResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveNibResourceWithName:ressourceName inMainBundle:[sharedInstance mainBundle] orDefaultBundle:defaultBundleName];
}

- (NSString *)retrieveStringsResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveStringsResourceWithName:ressourceName inMainBundle:[sharedInstance mainBundle] orDefaultBundle:defaultBundleName];
}

- (NSString *)retrieveFontResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveFontResourceWithName:ressourceName inMainBundle:[sharedInstance mainBundle] orDefaultBundle:defaultBundleName];
}

- (NSString *)retrieveSoundResourceInMainBundleWithName:(NSString*)ressourceName orLoadRessourceInDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveSoundResourceWithName:ressourceName inMainBundle:[sharedInstance mainBundle] orDefaultBundle:defaultBundleName];
}

- (BOOL)isPNGResourceExistInMainBundle:(NSString*)ressourceName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZPng inBundle:[sharedInstance mainBundle]];
}

- (BOOL)isNibResourceExistInMainBundle:(NSString*)ressourceName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZNib inBundle:[sharedInstance mainBundle]];
}

- (BOOL)isStringsResourceExistInMainBundle:(NSString*)ressourceName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZStrings inBundle:[sharedInstance mainBundle]];
}

- (BOOL)isFontResourceExistInMainBundle:(NSString*)ressourceName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZFont inBundle:[sharedInstance mainBundle]];
}

- (BOOL)isSoundResourceExistInMainBundle:(NSString*)ressourceName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZSound inBundle:[sharedInstance mainBundle]];
}

#pragma mark - Private -


#pragma mark - Public -

#pragma mark Util

+ (NSString*)retrieveBundleName:(FZBundleName) bundleName
{
    NSDictionary *stateStrings =
    @{
      @(FZBundleAPI) : kBundleHelperFZAPI,
      @(FZBundleBlackBox) : kBundleHelperFZBlackBox,
      @(FZBundleCoreUI) : kBundleHelperFZCoreUI,
      @(FZBundleExtLibs) : kBundleHelperFZExtLibs,
      @(FZBundleP2P) : kBundleHelperFZP2P,
      @(FZBundlePayment) : kBundleHelperFZPayment,
      @(FZBundleRewards) : kBundleHelperFZRewards,
      @(FZBundleSDK) : kBundleHelperFZBundleSDK,
      @(FZBundleBankSDK) : kBundleHelperFZBundleBankSDK,
      @(FZBundleLeclerc) : kBundleHelperFZLeclerc,
      @(FZBundleFlashiz) : kBundleHelperFZFlashiz
      };
    return [stateStrings objectForKey:@(bundleName)];
}

+ (NSString*)retrieveLocalizableName:(FZBundleName) bundleName
{
    NSDictionary *stateStrings =
    @{
      @(FZBundleAPI) : kBundleHelperLocalizableFZAPI,
      @(FZBundleBlackBox) : kBundleHelperLocalizableFZBlackBox,
      @(FZBundleCoreUI) : kBundleHelperLocalizableFZCoreUI,
      @(FZBundleExtLibs) : kBundleHelperLocalizableFZExtLibs,
      @(FZBundleP2P) : kBundleHelperLocalizableFZP2P,
      @(FZBundlePayment) : kBundleHelperLocalizableFZPayment,
      @(FZBundleRewards) : kBundleHelperLocalizableFZRewards,
      @(FZBundleSDK) : kBundleHelperLocalizableFZBundleSDK,
      @(FZBundleBankSDK) : kBundleHelperLocalizableFZBundleBankSDK,
      @(FZBundleLeclerc) : kBundleHelperLocalizableFZLeclerc,
      @(FZBundleFlashiz) : kBundleHelperLocalizableFZFlashiz
      };
    return [stateStrings objectForKey:@(bundleName)];
}

+ (NSString*)retrieveType:(FZFileType) type
{
    NSDictionary *stateStrings =
    @{
      @(FZBundle) : kBundleHelperTypeBundle,
      @(FZPng) : kBundleHelperTypePng,
      @(FZNib) : kBundleHelperTypeXib,
      @(FZFont) : kBundleHelperTypeFont,
      @(FZStrings) : kBundleHelperTypeStrings
      };
    return [stateStrings objectForKey:@(type)];
}

+ (NSBundle*)retrieveBundle:(FZBundleName)bundleName
{
    NSString *pathBundle = nil;
    
    //NSLog(@"bundleName : %u",bundleName);
   
    if([sharedInstance rootBundle] && [sharedInstance rootBundle] != bundleName) {
        pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:[sharedInstance rootBundle]] ofType:kBundleHelperTypeBundle];
        
        //NSLog(@"pathBundle A : %@",pathBundle);
        
        pathBundle = [[NSBundle bundleWithPath:pathBundle]pathForResource:[BundleHelper retrieveBundleName:bundleName] ofType:kBundleHelperTypeBundle];
        
    } else {
        
        if([[FZTargetManager sharedInstance] mainTarget] == FZUnitTesting) {
            
            //NSLog(@"UNITTESTING:%@",[NSString stringWithFormat:@"%@",[self class]]);
            
            
            NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString([NSString stringWithFormat:@"%@",[self class]])];
            
            //NSLog(@"bundle : %@",bundle);
            
            pathBundle = [bundle pathForResource:[BundleHelper retrieveBundleName:[sharedInstance rootBundle]] ofType:kBundleHelperTypeBundle];
            
            //NSLog(@"pathBundle : %@",pathBundle);
            
        } else {
            pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:bundleName] ofType:kBundleHelperTypeBundle];
        }
    }
    
    //NSLog(@"pathBundle B : %@",pathBundle);
    
    NSBundle *bundle = [NSBundle bundleWithPath:pathBundle];
    
    //NSLog(@"bundle : %@",bundle);
    
    return bundle;
}

+ (NSString*)retrieveBundlePath:(FZBundleName)bundleName
{
    NSString *pathBundle = nil;
    NSBundle *bundle = nil;
    
    if([sharedInstance rootBundle] && [sharedInstance rootBundle] != bundleName) {
        pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:[sharedInstance rootBundle]] ofType:kBundleHelperTypeBundle];
        pathBundle = [[NSBundle bundleWithPath:pathBundle]pathForResource:[BundleHelper retrieveBundleName:bundleName] ofType:kBundleHelperTypeBundle];
    } else {
        pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:bundleName] ofType:kBundleHelperTypeBundle];
    }
    
    bundle = [NSBundle bundleWithPath:pathBundle];
    
    return [bundle bundlePath];
}

+ (NSString *)nibNameForController:(UIViewController*)controller
{
    return NSStringFromClass([controller class]);
}

+ (NSString *)retrievePNGResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveResourceWithName:ressourceName ofType:FZPng inMainBundle:mainBundleName orDefaultBundle:defaultBundleName];
}

+ (id)loadNibResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper loadResourceWithName:ressourceName ofType:FZNib inMainBundle:mainBundleName orDefaultBundle:defaultBundleName];
}

+ (NSString *)retrieveNibResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveResourceWithName:ressourceName ofType:FZNib inMainBundle:mainBundleName orDefaultBundle:defaultBundleName];
}

+ (NSString *)retrieveStringsResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveResourceWithName:ressourceName ofType:FZStrings inMainBundle:mainBundleName orDefaultBundle:defaultBundleName];
}

+ (NSString *)retrieveFontResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveResourceWithName:ressourceName ofType:FZFont inMainBundle:mainBundleName orDefaultBundle:defaultBundleName];
}

+ (NSString *)retrieveSoundResourceWithName:(NSString*)ressourceName inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    return [BundleHelper retrieveResourceWithName:ressourceName ofType:FZSound inMainBundle:mainBundleName orDefaultBundle:defaultBundleName];
}

+ (BOOL)isPNGResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZPng inBundle:bundleName];
}

+ (BOOL)isNibResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZNib inBundle:bundleName];
}

+ (BOOL)isStringsResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZStrings inBundle:bundleName];
}

+ (BOOL)isFontResourceExist:(NSString*)ressourceName inBundle:(FZBundleName)bundleName
{
    return [BundleHelper isResourceExist:ressourceName ofType:FZFont inBundle:bundleName];
}

#pragma mark Bundle Core

+ (NSString *)retrieveResourceWithName:(NSString*)ressourceName ofType:(FZFileType)type inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    
    NSAssert((ressourceName != nil) && (![ressourceName isEqualToString:@""]), @"Resource Name can't be nil or empty");
    
    NSBundle *bundle = nil;
    NSString *pathResources = nil;
    NSString *typeResources = [BundleHelper retrieveType:type];
    
    //In a first time, we try to find the resource in main bundle
    
    bundle = [BundleHelper retrieveBundle:mainBundleName];
    
    pathResources =[bundle pathForResource:ressourceName ofType:typeResources];
    
    if(pathResources != nil){
        return pathResources;
    }
    
    bundle = nil;
    pathResources = nil;
    
    //We don't have found an override ressources. So we load default resources
    
    bundle = [NSBundle bundleWithPath:[BundleHelper retrieveBundlePath:defaultBundleName]];
    
    pathResources = [bundle pathForResource:ressourceName ofType:typeResources];
    
    if(pathResources != nil){
        return pathResources;
    }
    
    return nil;
}

+ (id)loadResourceWithName:(NSString*)ressourceName ofType:(FZFileType)type inMainBundle:(FZBundleName)mainBundleName orDefaultBundle:(FZBundleName)defaultBundleName
{
    
    NSAssert((ressourceName != nil) && (![ressourceName isEqualToString:@""]), @"Resource Name can't be nil or empty");
    
    NSString *pathBundle = nil;
    NSBundle *bundle = nil;
    NSArray *pathResources = nil;
    NSString *typeResources = [BundleHelper retrieveType:type];
    
    //In a first time, we try to find the resource in main bundle
    
    bundle = [BundleHelper retrieveBundle:mainBundleName];
    
    NSString *path = [bundle pathForResource:ressourceName ofType:typeResources];
    
    if (path){
        pathResources =[bundle loadNibNamed:ressourceName owner:nil options:nil];
        
        
        if(pathResources != nil && [pathResources count]>=1){
            
            if([pathResources count]>1){
                FZBlackBoxLog(@"Warning, seems to have more than one:%@ in bundle :%@",ressourceName,typeResources);
            }
            return [pathResources objectAtIndex:0];
        }
    }
    
    pathBundle = nil;
    bundle = nil;
    pathResources = nil;
    
    //We don't have found an override ressources. So we load default resources
    
    bundle = [BundleHelper retrieveBundle:defaultBundleName];

    
    pathResources = [bundle loadNibNamed:ressourceName owner:nil options:nil];
    
    if(pathResources != nil && [pathResources count]>=1){
        
        if([pathResources count]>1){
            FZBlackBoxLog(@"Warning, seems to have more than one:%@ in bundle :%@",ressourceName,typeResources);
        }
        
        return [pathResources objectAtIndex:0];
    }
    
    return nil;
}

+ (BOOL)isResourceExist:(NSString*)ressourceName ofType:(FZFileType)type inBundle:(FZBundleName)bundleName
{
    NSString *pathBundle = nil;
    NSBundle *bundle = nil;
    NSString *pathResources = nil;
    NSString *typeResources = [BundleHelper retrieveType:type];
    
    pathBundle = [[NSBundle mainBundle] pathForResource:[BundleHelper retrieveBundleName:bundleName] ofType:kBundleHelperTypeBundle];
    bundle = [NSBundle bundleWithPath:pathBundle];
    
    pathResources =[bundle pathForResource:ressourceName ofType:typeResources];
    
    if(pathResources != nil){
        return YES;
    }else{
        return NO;
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
