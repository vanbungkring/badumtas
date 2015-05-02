//
//  StatisticsFactory.h
//  FZBlackBox
//
//  Created by julian Clémot on 09/07/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TrackerProtocol.h"

@interface StatisticsFactory : NSObject <TrackerProtocol>


+(StatisticsFactory *)sharedInstance;

- (void)startCrashlyticsWithApiKey:(NSString *)key;

@end
