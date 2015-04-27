//
//  CrashlyticsHelper.h
//  flashiz_ios_core_ui
//
//  Created by Matthieu Barile on 05/03/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashlyticsHelper : NSObject

+ (CrashlyticsHelper *)sharedInstance;

- (void)sendWithScreenView:(NSString *)screenView andCategory:(NSString *)category andAction:(NSString *)action andData:(NSString *)data;

- (void)startCrashlyticsWithApiKey:(NSString *)key;

- (void)crash;

@end
