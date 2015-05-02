//
//  SDKUrlSchemeManager.h
//  FZSDK
//
//  Created by Matthieu Barile on 06/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSMutableDictionary *data;

@interface SDKUrlSchemeManager : NSObject

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end