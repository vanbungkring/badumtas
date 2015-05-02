//
//  UniversalAnalyticsHelper.h
//  FZBlackBox
//
//  Created by julian Clémot on 10/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversalAnalyticsHelper : NSObject


+ (UniversalAnalyticsHelper *)sharedInstance;


- (void)setTrackerWithTrackingIdProductionFlashiz;

- (void)setTrackerWithTrackingIdProductionLeclerc;

- (void)setTrackerWithTrackingIdDebugLeclerc;

- (void)setTrackerWithTrackingIdDebugFlashiz;


- (void)setDefaultTrackerToFlashizProd;

- (void)setDefaultTrackerToLeclercProd;

- (void)setDefaultTrackerToDebugFlashiz;

- (void)setDefaultTrackerToDebugLeclerc;

- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action andData:(NSString *)data;

@end
