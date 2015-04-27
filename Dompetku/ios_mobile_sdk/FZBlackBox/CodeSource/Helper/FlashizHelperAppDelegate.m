//
//  FlashizHelperAppDelegate.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 16/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "FlashizHelperAppDelegate.h"

@implementation FlashizHelperAppDelegate

- (id<CoreMultiTargetManager>) multiTargetManager {
    return nil;
}

- (id<CoreMultiTargetWindow>)multiTargetWindow {
    return nil;
}

/*- (id<CoreMultiTargetTestFlightService>)multiTargetTestFlightService {
  // TODO: need refactor
    return nil;
}*/

//Util methods
- (void)menu:(id)sender {
    
}

+ (UINavigationController*)navigationController {
    return nil;
}

+ (PPRevealSideViewController*)ppRevealSideViewController {
    return nil;
}

- (CustomTabBarViewController*)tabBarController {
    return nil;
}

+(MenuViewController*)menuViewController {
    return nil;
}

@end
