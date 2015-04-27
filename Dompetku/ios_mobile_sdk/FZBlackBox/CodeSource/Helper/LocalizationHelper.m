//
//  LocalizationHelper.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "LocalizationHelper.h"

#import <UIKit/UIKit.h>

#import "BundleHelper.h"

#import "FZTargetManager.h"

// NSString switch
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT
//

#define FZLocalizedString(key, tbl, bundle, comment) \
[(bundle) localizedStringForKey:(key) value:(comment) table:(tbl)]

@interface LocalizationHelper()

@property(nonatomic,assign)FZBundleName mainBundle;
@property(nonatomic,retain)NSString *defaultLanguage;

@end


#define kBundleHelperTypeBundle @"bundle"


@implementation LocalizationHelper

static LocalizationHelper *sharedInstance = nil;

#pragma mark - Init

#pragma mark - Private -
#pragma mark - Shared Instance

+ (NSString *)reflectErrorForKey:(NSString *)key withComment:(NSString *)comment inDefaultBundle:(NSString*)bundle
{
    FZBundleName rbundle = FZBundleNone;
    
    // TODO : can be improve
    SWITCH (bundle) {
        CASE (@"FZBundleAPI"){
            rbundle = FZBundleAPI;
            break;
        }
        CASE (@"FZBundleBlackBox"){
            rbundle = FZBundleBlackBox;
            break;
        }
        CASE (@"FZBundleCoreUI"){
            rbundle = FZBundleCoreUI;
            break;
        }
        CASE (@"FZBundleExtLibs"){
            rbundle = FZBundleExtLibs;
            break;
        }
        CASE (@"FZBundleP2P"){
            rbundle = FZBundleP2P;
            break;
        }
        CASE (@"FZBundlePayment"){
            rbundle = FZBundlePayment;
            break;
        }
        CASE (@"FZBundleRewards"){
            rbundle = FZBundleRewards;
            break;
        }
        CASE (@"FZBundleSDK"){
            rbundle = FZBundleSDK;
            break;
        }
        CASE (@"FZBundleBankSDK"){
            rbundle = FZBundleBankSDK;
            break;
        }
        CASE (@"FZBundleFlashiz"){
            rbundle = FZBundleFlashiz;
            break;
        }
        CASE (@"FZBundleLeclerc"){
            rbundle = FZBundleLeclerc;
            break;
        }
        DEFAULT{
            rbundle = FZBundleNone;
            break;
        }
    }
    
    return [LocalizationHelper errorForKey:key withComment:comment inDefaultBundle:rbundle];
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocalizationHelper alloc] init];
    });
    
    return [[sharedInstance retain] autorelease];
}

- (void)setLanguage:(NSString*)lang
{
    
    NSString *selectedLang = nil;
    
    NSMutableArray *availableLanguages = [[NSMutableArray alloc]init];
    
    NSArray *languagesList = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    int langCount = (int)languagesList.count;
    
    for (int i = 0; i < langCount;i++)
    {
        NSString *language = [languagesList objectAtIndex:i];
        
        NSBundle *rootBundle = [BundleHelper retrieveBundle:[[BundleHelper sharedInstance] rootBundle]];
                
        NSBundle *bundle = [NSBundle bundleWithPath:[rootBundle pathForResource:language ofType:@"lproj"]];
        
        if(bundle!=nil){
            //Language available
            [availableLanguages addObject:language];
        }
    }
    
    
    int availableCount = (int)availableLanguages.count;
    
    for(int i = 0; i < availableCount;i++){
        NSString *avLang = [availableLanguages objectAtIndex:i];
        if([avLang isEqualToString:lang]){
            selectedLang = lang;
            break;
        }
    }
    
    if(!selectedLang){
        // TODO: Force EN lang
        selectedLang = @"en";
    }
    
    [sharedInstance setDefaultLanguage:selectedLang];
    [availableLanguages release];
}

- (void)setBundle:(FZBundleName)mainBundle
{
    [sharedInstance setMainBundle:mainBundle];
}

- (FZBundleName)bundleMain
{
    return [sharedInstance mainBundle];
}

- (NSBundle*)bundle
{
    return [NSBundle bundleWithPath: [BundleHelper retrieveBundlePath:[sharedInstance bundleMain]]];
}

#pragma mark - Public -


+ (NSString *)stringForKey:(NSString *)key withComment:(NSString *)comment inDefaultBundle:(FZBundleName)bundle
{
    //Please keep these lines commented (uncomment for debug)
    //NSBundle *testedBundle = [NSBundle bundleWithPath:[[BundleHelper retrieveBundle:[[LocalizationHelper sharedInstance]bundleMain]] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]];
    //NSString *testedTable = [BundleHelper retrieveLocalizableName:[[LocalizationHelper sharedInstance]bundleMain]];
    
    NSString *string = FZLocalizedString(key,
                                         [BundleHelper retrieveLocalizableName:[[LocalizationHelper sharedInstance]bundleMain]],
                                         [NSBundle bundleWithPath:[[BundleHelper retrieveBundle:[[LocalizationHelper sharedInstance]bundleMain]] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]],
                                         comment);
    
    if([string length] == 0 || [string isEqualToString:comment] || [string  rangeOfString:@"null"].location != NSNotFound){
        
        //Please keep these lines commented (uncomment for debug)
        //testedBundle = [NSBundle bundleWithPath:[[BundleHelper retrieveBundle:bundle] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]];
        //testedTable = [BundleHelper retrieveLocalizableName:bundle];
        
        string = FZLocalizedString(key,
                                   [BundleHelper retrieveLocalizableName:bundle],
                                   [NSBundle bundleWithPath:[[BundleHelper retrieveBundle:bundle] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]],
                                   comment);
        
    }
    
    return string;
}

+ (NSString *)errorForKey:(NSString *)key withComment:(NSString *)comment inDefaultBundle:(FZBundleName)bundle
{
    //Please keep these lines commented (uncomment for debug)
    //NSLog(@"retrieveLocalizableName:%@",[BundleHelper retrieveLocalizableName:[[LocalizationHelper sharedInstance]bundleType]]);
    //NSLog(@"retrieveBundle:%@",[BundleHelper retrieveBundle:[[LocalizationHelper sharedInstance]bundleType]]);
    
    //NSLog(@"path:%@",[NSBundle bundleWithPath:[[BundleHelper retrieveBundle:[[LocalizationHelper sharedInstance]bundleType]] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]]);
    
    NSString *string = FZLocalizedString(key,[BundleHelper retrieveLocalizableName:[[LocalizationHelper sharedInstance]bundleMain]],[NSBundle bundleWithPath:[[BundleHelper retrieveBundle:[[LocalizationHelper sharedInstance]bundleMain]] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]],comment);
    
    //First search in the specified bundle
    if([string length] == 0 || [string isEqualToString:comment] || [string  rangeOfString:@"null"].location != NSNotFound){
        string = FZLocalizedString(key,[BundleHelper retrieveLocalizableName:bundle],[NSBundle bundleWithPath:[[BundleHelper retrieveBundle:bundle] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]],comment);
    }
    
    //if string not found, search in the default bundle (FZAPI.string)
    if([string length] == 0 || [string isEqualToString:comment] || [string  rangeOfString:@"null"].location != NSNotFound){
        string = FZLocalizedString(key,[BundleHelper retrieveLocalizableName:FZBundleAPI],[NSBundle bundleWithPath:[[BundleHelper retrieveBundle:FZBundleAPI] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]],comment);
    }
    
    //if the error does'nt exist, get the default error
    if([string length] == 0 || [string isEqualToString:comment] || [string  rangeOfString:@"null"].location != NSNotFound){
        key = @"-10000";
        string = FZLocalizedString(key,[BundleHelper retrieveLocalizableName:FZBundleAPI],[NSBundle bundleWithPath:[[BundleHelper retrieveBundle:FZBundleAPI] pathForResource:[sharedInstance defaultLanguage] ofType:@"lproj"]],comment);
    }
    
    return string;
}

-(void)dealloc {
    [_defaultLanguage release];
    
    [super dealloc];
}

@end
