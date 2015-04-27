//
//  MultiTargetAppDelegate.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 13/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreMultiTargetManager.h"

#import "CoreMultiTargetWindow.h"
//TODO: need refactor
//#import "CoreMultiTargetTestFlightService.h"

@class PPRevealSideViewController;
@class UINavigationController;

@protocol CoreMultiTargetAppDelegate <NSObject>

- (id<CoreMultiTargetManager>) multiTargetManager;
//- (id<CoreMultiTargerLanguageService>) multiTargetLanguageService; //needed again if we want to let the wording overridable
- (id<CoreMultiTargetWindow>)multiTargetWindow;
//TODO: need refactor
//- (id<CoreMultiTargetTestFlightService>)multiTargetTestFlightService;

//Util methods
- (void)menu:(id)sender;
+(UINavigationController*)navigationController;
+(PPRevealSideViewController*)ppRevealSideViewController;
- (CustomTabBarViewController *)tabBarController;
+(MenuViewController*)menuViewController;

@end
