//
//  FZTargetManager.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/24/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIApplication.h>

#import <FZBlackBox/FZModelTargetManager.h>

@class FZDefaultMultiTargetManager;
@class FZDefaultTemplateColor;
@class FZDefaultTemplateFonts;

//From FZPayment
#import "FZFlashizFacade.h"
#import <FZBLackBox/FlashizFacadeDelegate.h>

/* Targets enum
 * TODO: DOC
 */
typedef enum {
    FZSDKTarget,
    FZBankSDKTarget,
    FZAppTarget,
    FZUnitTesting
} FZTarget;

@interface FZTargetManager : NSObject
{
    
}

//Model
@property (retain, nonatomic) FZModelTargetManager *model;

//Delegate
@property (assign, nonatomic) id<UIApplicationDelegate> delegate;
@property (assign, nonatomic) id<FlashizFacadeDelegate> delegateSDK;

//Target
@property (assign, nonatomic) FZTarget mainTarget;

//Facade
@property (assign, nonatomic) FZFlashizFacade *facade;


//For the application
@property (retain, nonatomic) NSString *customerUrlScheme;
@property (retain, nonatomic) NSString *brandName;

//For the SDK
@property (retain, nonatomic) NSString *customerScheme;
@property (retain, nonatomic) NSString *customerHost;
@property (retain, nonatomic) NSMutableDictionary *callbackData;

+ (FZTargetManager*)sharedInstance;

- (void)cleanInstance;

- (void)loadSDKWithTarget:(FZDefaultMultiTargetManager *)target withColorTemplate:(FZDefaultTemplateColor *)colorTemplate andFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplace andDelegate:(id<NSObject>) delegateSDK configureUrlSchemesWihtCustomerHost:(NSString *)customerHost andCustomerScheme:(NSString *)customerScheme;

- (void)loadBankSDKWithTarget:(FZDefaultMultiTargetManager *)target withColorTemplate:(FZDefaultTemplateColor *)colorTemplate andFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplace andDelegate:(id<NSObject>) delegateSDK;

- (void)loadAppWithBrandName:(NSString *)aBrandName withTarget:(FZDefaultMultiTargetManager *)target withColorTemplate:(FZDefaultTemplateColor *)colorTemplate andFontsTemplate:(FZDefaultTemplateFonts *)fontsTemplace andApplicationDelegate:(id<UIApplicationDelegate>)delegate andFacade:(FZFlashizFacade *)facade;

- (void)loadUnitTesting;
- (void)loadUnitTestingWithMultiTargetManager:(FZDefaultMultiTargetManager *)multiTarget;

- (FZDefaultMultiTargetManager *)multiTarget;

- (BOOL)isApplicationUsingSDK;

@end
