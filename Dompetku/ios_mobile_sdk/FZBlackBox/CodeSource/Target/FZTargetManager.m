//
//  FZTargetManager.m
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/24/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import "FZTargetManager.h"

#import "FZDefaultMultiTargetManager.h"
#import "FZDefaultTemplateColor.h"
#import "FZDefaultTemplateFonts.h"

//Session
#import <FZAPI/UserSession.h>

//Helper
#import <FZBlackBox/ImageHelper.h>
#import <FZBlackBox/FontHelper.h>
#import <FZBlackBox/LocalizationHelper.h>
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/ColorHelper.h>

@interface FZTargetManager ()

@property (retain, nonatomic) FZDefaultMultiTargetManager *multiTarget;

- (FZTargetManager*)init;


@end

@implementation FZTargetManager

#pragma mark - Shared Instance

static FZTargetManager *sharedInstance = nil;

+ (FZTargetManager*)sharedInstance {
    static dispatch_once_t onceBundleHelper;
    dispatch_once(&onceBundleHelper, ^{
        sharedInstance = [[FZTargetManager alloc] init];
        
    });
    
    return [[sharedInstance retain] autorelease];
}

-(void)cleanInstance
{
    [self setMultiTarget:nil];
}

- (FZTargetManager*)init
{
    self = [super init];
    if (self) {
        _model = [[FZModelTargetManager alloc]init];
    }
    return self;
}

#pragma mark - Init App

- (void)loadAppWithBrandName:(NSString *)aBrandName withTarget:(FZDefaultMultiTargetManager *)target withColorTemplate:(FZDefaultTemplateColor *)colorTemplate andFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplace andApplicationDelegate:(id<UIApplicationDelegate>)delegate andFacade:(FZFlashizFacade *)facade {
    
    [self setMainTarget:FZAppTarget];
    [self setMultiTarget:target];
    [self setDelegate:delegate];
    [self setFacade:facade];
    [self setBrandName:aBrandName];
    
    //Configure User session
    [[UserSession currentSession]setAccountBanner:YES];
    [[UserSession currentSession]setTabBar:YES];
    [[UserSession currentSession]setRewards:YES];
    [[UserSession currentSession]setReceive:YES];
    [[UserSession currentSession]setSend:YES];
    [[UserSession currentSession]setMenu:YES];
    
    //Set main resources bundle
    
    if([[self brandName] isEqualToString:@"leclerc"]) {
        //Set root resource bundle
        [[BundleHelper sharedInstance]setBundleRoot:FZBundleLeclerc];
        
        [[BundleHelper sharedInstance]setBundle:FZBundleLeclerc];
        [[ImageHelper sharedInstance]setBundle:FZBundleLeclerc];
        [[LocalizationHelper sharedInstance]setBundle:FZBundleLeclerc];
        [[LocalizationHelper sharedInstance]setLanguage:@"fr"];
        
    } else {
        //Set root resource bundle
        [[BundleHelper sharedInstance]setBundleRoot:FZBundleFlashiz];
        
        [[BundleHelper sharedInstance]setBundle:FZBundleFlashiz];
        [[ImageHelper sharedInstance]setBundle:FZBundleFlashiz];
        [[LocalizationHelper sharedInstance]setBundle:FZBundleFlashiz];
        [[LocalizationHelper sharedInstance]setLanguage:[[NSLocale preferredLanguages]objectAtIndex:0]];
    }
    
    //Load template
    [[ColorHelper sharedInstance]loadTemplate:colorTemplate];
    [[FontHelper sharedInstance]loadTemplate:fontsTemplace];
}

#pragma mark - Init SDK

- (void)loadSDKWithTarget:(FZDefaultMultiTargetManager *)target withColorTemplate:(FZDefaultTemplateColor *)colorTemplate andFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplace andDelegate:(id<NSObject>) delegateSDK configureUrlSchemesWihtCustomerHost:(NSString *)customerHost andCustomerScheme:(NSString *)customerScheme {
    
    [self setMainTarget:FZSDKTarget];
    [self setMultiTarget:target];
    [self setDelegateSDK:delegateSDK];
    [self setCustomerHost:customerHost];
    [self setCustomerScheme:customerScheme];
    
    //Configure User session
    [[UserSession currentSession]setAccountBanner:YES];
    [[UserSession currentSession]setTabBar:NO];
    [[UserSession currentSession]setRewards:NO];
    [[UserSession currentSession]setReceive:NO];
    [[UserSession currentSession]setSend:NO];
    
    //Set root resource bundle
    [[BundleHelper sharedInstance]setBundleRoot:FZBundleSDK];
    
    //Set main resources bundle
    [[BundleHelper sharedInstance]setBundle:FZBundleSDK];
    [[ImageHelper sharedInstance]setBundle:FZBundleSDK];
    [[LocalizationHelper sharedInstance]setBundle:FZBundleSDK];
    [[LocalizationHelper sharedInstance]setLanguage:[[NSLocale preferredLanguages]objectAtIndex:0]];
    
    //Load template
    [[ColorHelper sharedInstance]loadTemplate:colorTemplate];
    [[FontHelper sharedInstance]loadTemplate:fontsTemplace];
}

#pragma mark - Init Bank SDK

- (void)loadBankSDKWithTarget:(FZDefaultMultiTargetManager *)target withColorTemplate:(FZDefaultTemplateColor *)colorTemplate andFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplace andDelegate:(id<NSObject>) delegateSDK {
    
    [self setMainTarget:FZBankSDKTarget];
    [self setMultiTarget:target];
    [self setDelegateSDK:delegateSDK];
    
    //Configure User session
    [[UserSession currentSession]setAccountBanner:NO];
    [[UserSession currentSession]setTabBar:YES];
    [[UserSession currentSession]setRewards:YES];
    [[UserSession currentSession]setReceive:YES];
    [[UserSession currentSession]setSend:NO];
    
    //Set root resource bundle
    [[BundleHelper sharedInstance]setBundleRoot:FZBundleBankSDK];
    
    //Set main resources bundle
    [[BundleHelper sharedInstance]setBundle:FZBundleBankSDK];
    [[ImageHelper sharedInstance]setBundle:FZBundleBankSDK];
    [[LocalizationHelper sharedInstance]setBundle:FZBundleBankSDK];
    [[LocalizationHelper sharedInstance]setLanguage:[[NSLocale preferredLanguages]objectAtIndex:0]];
    
    //Load template
    [[ColorHelper sharedInstance]loadTemplate:colorTemplate];
    [[FontHelper sharedInstance]loadTemplate:fontsTemplace];
}

- (void)loadUnitTesting {
    [self loadUnitTestingWithMultiTargetManager:nil];
}

- (void)loadUnitTestingWithMultiTargetManager:(FZDefaultMultiTargetManager *)multiTarget {
    
    [self setMainTarget:FZUnitTesting];
    
    //TODO: Use Flashiz multitarget for the moment for the unit testing
    //FZDefaultMultiTargetManager *multiTarget = [[NSClassFromString(@"FlashizMultiTargetManager") alloc] init];
    
    //NSLog(@"multiTarget : %@",multiTarget);
    if(multiTarget) {
        [self setMultiTarget:multiTarget];
    } else {
        [self setMultiTarget:nil];
    }
    
    FZDefaultTemplateColor *colorTemplate = [[FZDefaultTemplateColor alloc] init];
    
    // TODO : bad idea to do that
    Class aFZFlashizTemplateFonts = NSClassFromString(@"FZFlashizTemplateFonts");
    
    FZDefaultTemplateFonts *fontsTemplate = [[aFZFlashizTemplateFonts alloc] init];
    
    //Load template
    [[ColorHelper sharedInstance]loadTemplate:colorTemplate];
    [[FontHelper sharedInstance]loadTemplate:fontsTemplate];
    
    [colorTemplate release];
    [fontsTemplate release];
    [multiTarget release];
}

#pragma mark - Utils

- (BOOL)isApplicationUsingSDK {
    if (_mainTarget == FZSDKTarget || _mainTarget == FZBankSDKTarget) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - MM

- (void)dealloc {
    [_callbackData release];
    [_multiTarget release];
    [_model release];
    [_customerHost release];
    [_customerScheme release];
    [_brandName release];
    [_facade release];
    
    [super dealloc];
}

@end
