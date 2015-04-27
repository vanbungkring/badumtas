//
//  AppDelegate.m
//  Dompetku
//
//  Created by iMac on 11/8/14.
//
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "NetraUserModel.h"
#import "NRealmSingleton.h"
#import <SplunkMint-iOS.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Mint sharedInstance] initAndStartSession:@"0364bcce"];
    //  Default font configuration
    
    
    ///doublecheck otp and guide
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"isOTP"];
    NSObject * object2 = [prefs objectForKey:@"isGuide"];
    if(object == nil){
        [prefs setBool:0 forKey:@"isOTP"];
        //object is there
    }
    if(object2 == nil){
        [prefs setBool:0 forKey:@"isGuide"];
        //object is there
    }
    [prefs synchronize];
    UIFont *defaultFontType = [UIFont fontWithName:@"HelveticaNeue"
                                              size:14];
    
    NSDictionary *defaultFontAttributes = [NSDictionary dictionaryWithObject:defaultFontType
                                                                      forKey:NSFontAttributeName];
    
    //  Title font configuration
    UIFont *titleFontType = [UIFont fontWithName:@"HelveticaNeue"
                                            size:17];
    
    NSDictionary *titleFontAttributes = [NSDictionary dictionaryWithObjects:@[titleFontType, [UIColor whiteColor]]
                                                                    forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    
    //  Segmented control configuration
    [[UISegmentedControl appearance] setTitleTextAttributes:defaultFontAttributes
                                                   forState:UIControlStateNormal];
    
    //  Navigation bar configuration
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:titleFontAttributes];
    
    //  Navigation bar button item configuration
    [[UIBarButtonItem appearance] setTitleTextAttributes:defaultFontAttributes
                                                forState:UIControlStateNormal];
    
    //  Back button configuration
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UIImage *originalBackButtonImage = [UIImage imageNamed:@"back"];
    CGSize backButtonSize = CGSizeMake(33, 33);
    UIGraphicsBeginImageContextWithOptions(backButtonSize, NO, 0.0);
    [originalBackButtonImage drawInRect:CGRectMake(0, 0, backButtonSize.width, backButtonSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    backButtonImage = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 33, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    
    //    UIImage *originalBackButtonImage = [UIImage imageNamed:@"icon-back.png"];
    //    CGSize backButtonSize = CGSizeMake(33, 33);
    //    UIGraphicsBeginImageContextWithOptions(backButtonSize, NO, 0.0);
    //    [originalBackButtonImage drawInRect:CGRectMake(0, 0, backButtonSize.width, backButtonSize.height)];
    //    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    backButtonImage = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 33, 0, 0)];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
    //                                                      forState:UIControlStateNormal
    //                                                    barMetrics:UIBarMetricsDefault];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    netraUserModel *modelUser = [netraUserModel getUserProfile];

    if(![modelUser.tripleDes isEqualToString:@""]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:[NSDate date] forKey:@"lastDate"];
        [prefs synchronize];
    }
    NSLog(@"resign active");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"enter background");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    netraUserModel *modelUser = [netraUserModel getUserProfile];
    
    if(![modelUser.tripleDes isEqualToString:@""]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:[prefs objectForKey:@"lastDate"]];
        
        int myInt = (int) secondsBetween;
        if(myInt>120 && myInt<30*60){
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoHome" object:nil userInfo:nil];
            
        }
        else if(myInt>30*60+1){
            NSLog(@"Goto Logout");
            [[NRealmSingleton sharedMORealmSingleton]deleteRealm];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoHome" object:nil userInfo:nil];
        }
        
        
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
     NSLog(@"enter applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
