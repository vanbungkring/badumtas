//
//  CrashlyticsHelper.m
//  flashiz_ios_core_ui
//
//  Created by Matthieu Barile on 05/03/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "CrashlyticsHelper.h"

#import <objc/message.h>
#import <objc/objc-api.h>

static NSString * const apiKey = @"64b2dafd212d4066bc948443a3b744f610cf2eb5";

@implementation CrashlyticsHelper


#pragma mark - Shared Instance

static CrashlyticsHelper *sharedInstance = nil;

+ (CrashlyticsHelper *)sharedInstance {
    static dispatch_once_t onceBundleHelper;
    dispatch_once(&onceBundleHelper, ^{
        sharedInstance = [[CrashlyticsHelper alloc] init];
    });
    
    return [[sharedInstance retain] autorelease];
    
}

#pragma mark - Init

- (CrashlyticsHelper*)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (Class)crashlyticsClass {
    
    Class class = NSClassFromString(@"Crashlytics");
    
    return class;
}

/*#ifdef DEBUG
#define FZ_CLS_LOG(__FORMAT__, ...) CLSNSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    OBJC_EXTERN void CLSNSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
#endif

#ifdef FZPRODUCTION
#define FZ_CLS_LOG(__FORMAT__, ...) CLSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    OBJC_EXTERN void CLSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
#endif*/



- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action andData:(NSString *)data{
    //objc_msgSend([CrashlyticsHelper crashlyticsClass], NSSelectorFromString(@"CLS_LOG:"),[NSString stringWithFormat:@"screenView : %@ | category : %@ | action : %@ | label : %@", screenView, category, action,data]);

/*#ifdef DEBUG
    FZ_CLS_LOG(@"screenView : %@ | category : %@ | action : %@ | label : %@",screenView, category, action,data);
#endif
    
#ifdef FZPRODUCTION
    FZ_CLS_LOG(@"screenView : %@ | category : %@ | action : %@ | label : %@",screenView, category, action,data);
#endif*/
}

- (void)startCrashlyticsWithApiKey:(NSString *)key {
    if([key isEqualToString:apiKey]){
        // crash on arm64
        //objc_msgSend([CrashlyticsHelper crashlyticsClass], NSSelectorFromString(@"startWithAPIKey:"),@"64b2dafd212d4066bc948443a3b744f610cf2eb5");
    }
}

- (void)crash {
    objc_msgSend([CrashlyticsHelper crashlyticsClass], NSSelectorFromString(@"crash"));
}


@end
