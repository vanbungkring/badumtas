//
//  UniversalAnalyticsHelper.m
//  FZBlackBox
//
//  Created by julian Clémot on 10/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <objc/message.h>

#import "UniversalAnalyticsHelper.h"

#define trackingIDProductionFlashiz @"UA-42476394-2"
#define trackingIDProductionLeclerc @"UA-42476394-5"
#define trackingIDDebugLeclerc @"UA-42476394-4"
#define trackingIDDebugFlashiz @"UA-42476394-3"
#define kGAIScreenName @"&cd"

#define kSharedInstanceSelector NSSelectorFromString(@"sharedInstance")


@interface UniversalAnalyticsHelper ()

@property (assign, nonatomic) id trackerProdLeclerc;
@property (assign, nonatomic) id trackerProdFlashiz;
@property (assign, nonatomic) id trackerDebugFlashiz;
@property (assign, nonatomic) id trackerDebugLeclerc;

@end

@implementation UniversalAnalyticsHelper


#pragma mark - Shared Instance
static UniversalAnalyticsHelper *sharedInstance = nil;


+ (UniversalAnalyticsHelper *)sharedInstance {
    static dispatch_once_t onceBundleHelper;
    dispatch_once(&onceBundleHelper, ^{
        sharedInstance = [[UniversalAnalyticsHelper alloc] init];
    });
    
    return [[sharedInstance retain] autorelease];
    
}

#pragma mark - Init
- (UniversalAnalyticsHelper*)init
{
    self = [super init];
    if (self) {
        
        // Optional: automatically send uncaught exceptions to Google Analytics.
        //[GAI sharedInstance].trackUncaughtExceptions = YES;
        objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"setTrackUncaughtExceptions:"),YES);
        
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        //[GAI sharedInstance].dispatchInterval = 20;
        objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"setDispatchInterval:"),20);
        
        // Optional: set Logger to VERBOSE for debug information.
        /*kGAILogLevelNone = 0,
        kGAILogLevelError = 1,
        kGAILogLevelWarning = 2,
        kGAILogLevelInfo = 3,
        kGAILogLevelVerbose = 4*/
        //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
        objc_msgSend(objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")), NSSelectorFromString(@"logger")),NSSelectorFromString(@"setLogLevel:"),0);
        
        // Initialize tracker. Replace with your tracking ID.
        //[[GAI sharedInstance] trackerWithTrackingId:@"UA-XXXX-Y"];
        [self setTrackerWithTrackingIdProductionFlashiz];
        [self setTrackerWithTrackingIdProductionLeclerc];
        [self setTrackerWithTrackingIdDebugLeclerc];
        [self setTrackerWithTrackingIdDebugFlashiz];
        
        
    }
    return self;
}

+ (Class)gaiClass {
    
    Class class = NSClassFromString(@"GAI");
    
    return class;
}

- (void)setTrackerWithTrackingIdProductionFlashiz{
    [self setTrackerProdFlashiz:objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], kSharedInstanceSelector),NSSelectorFromString(@"trackerWithTrackingId:"),trackingIDProductionFlashiz)];
}

- (void)setTrackerWithTrackingIdProductionLeclerc{
    [self setTrackerProdLeclerc:objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"trackerWithTrackingId:"),trackingIDProductionLeclerc)];
}

- (void)setTrackerWithTrackingIdDebugLeclerc{
    [self setTrackerDebugLeclerc:objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"trackerWithTrackingId:"),trackingIDDebugLeclerc)];
}

- (void)setTrackerWithTrackingIdDebugFlashiz{
    [self setTrackerDebugFlashiz:objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"trackerWithTrackingId:"),trackingIDProductionFlashiz)];
}


- (void)setDefaultTrackerToFlashizProd{
    objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"setDefaultTracker:"),[self trackerProdFlashiz]);
}

- (void)setDefaultTrackerToLeclercProd{
    objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"setDefaultTracker:"),[self trackerProdLeclerc]);
}

- (void)setDefaultTrackerToDebugFlashiz{
    objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"setDefaultTracker:"),[self trackerDebugFlashiz]);
}

- (void)setDefaultTrackerToDebugLeclerc{
    objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"setDefaultTracker:"),[self trackerDebugLeclerc]);
}

- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action andData:(NSString *)data{
    // Set screen name on the tracker to be sent with all hits.
    //[tracker set:kGAIScreenName value:screenView];
    
    
     objc_msgSend(objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"defaultTracker")),NSSelectorFromString(@"set:value:"),kGAIScreenName,screenView);
     
   //  NSLog(@"value : %@",objc_msgSend(objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"defaultTracker")),NSSelectorFromString(@"get:"),kGAIScreenName));
     
    
    // Send a screen view for "Home Screen".
    //[[[GAI sharedInstance] defaultTracker] send:[GAIDictionaryBuilder createAppView]];
    /* objc_msgSend(objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"defaultTracker")),NSSelectorFromString(@"send:"),objc_msgSend(NSClassFromString(@"GAIDictionaryBuilder"),NSSelectorFromString(@"createAppView")));
     */
    // This event will also be sent with &cd=screenView
    //[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX" action:@"touch" label:@"menuButton" value:nil] build]];

     id sharedinstance =objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance"));
     id defaulttracker =objc_msgSend(sharedinstance,NSSelectorFromString(@"defaultTracker"));
     id eventWithCategory = objc_msgSend(NSClassFromString(@"GAIDictionaryBuilder"),NSSelectorFromString(@"createEventWithCategory:action:label:value:"),category,action,data,nil);
     
     
     //NSLog(@"sharedinstance : %@",sharedinstance);
     // NSLog(@"defaulttracker : %@",defaulttracker);
     //NSLog(@"eventWithCategory : %@",eventWithCategory);
     
     if(!(sharedInstance==nil || defaulttracker == nil || eventWithCategory == nil)){
     //objc_msgSend(defaulttracker,NSSelectorFromString(@"send:"),objc_msgSend(eventWithCategory,NSSelectorFromString(@"build")));
     //objc_msgSend(objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"defaultTracker")),NSSelectorFromString(@"send:"),objc_msgSend(NSClassFromString(@"GAIDictionaryBuilder"),NSSelectorFromString(@"createEventWithCategory:action:label:value:"),category,action,data,nil));
     
     
     // Clear the screen name field when we're done.
     objc_msgSend(objc_msgSend(objc_msgSend([UniversalAnalyticsHelper gaiClass], NSSelectorFromString(@"sharedInstance")),NSSelectorFromString(@"defaultTracker")),NSSelectorFromString(@"set:value:"),kGAIScreenName,nil);
     }
}

@end
