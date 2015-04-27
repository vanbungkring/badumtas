//
//  FZUrlSchemeManager.m
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/25/14.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "FZUrlSchemeManager.h"

#import "FZTargetManager.h"

#import "FZUrlSchemes.h"

#import "SDKProxyHelper.h"

//Domain
#import <FZAPI/UserSession.h>

//Service
#import <FZAPI/ConnectionServices.h>

#import "CustomNavigationViewController.h"
#import "FZPortraitNavigationController.h"
#import "FZDefaultMultiTargetManager.h"

@class CountryViewController;
@class ForgottenPasswordSendMailViewController;
@class ForgottenPasswordNewPasswordViewController;
@class ForgottenPasswordSecretAnswerViewController;
@class InitialViewController;

@implementation FZUrlSchemeManager

+ (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive");
    
    FZModelTargetManager *model = [[FZTargetManager sharedInstance] model];
    
    if ([[model tokenFromLaunchUrl] length] > 0 && [model isModeAdmin]) {
        
        [self launchForgottenPasswordFromNewPassword];
        
    } else if([[model tokenFromLaunchUrl] length]>0) {
        
        [self launchForgottenPasswordFromAnswer];
        
    } else if([model shouldStartForgottenPassword]) {
        
        [self launchForgottenPasswordFromStart];
        
    }
    
    if([model shouldRegisterNewUser]) {
        
        [self launchRegisterNewUser];
        
    } else if([model shouldLaunchTopUp]) {
        
        [self launchTopUp];
    }
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    /*
     NSLog(@"url recieved: %@", url);
     NSLog(@"query string: %@", [url query]);
     NSLog(@"host: %@", [url host]);
     NSLog(@"url path: %@", [url path]);
     NSDictionary *dict = [FZUrlSchemeManager parseQueryString:[url query]];
     NSLog(@"query dict: %@", dict);
     */
    
    if([[url path] isEqualToString:kUrlSchemeForgottenPasswordPath]){
        NSDictionary *dict = [FZUrlSchemeManager parseQueryString:[url query]];
        NSString *token = [dict objectForKey:@"token"];
        NSString *mode = [dict objectForKey:@"mode"];
        
        if ([token length] > 0 && [mode length] > 0) {
            if([mode integerValue] == 1){
                FZBlackBoxLog(@"Forgotten password admin");
                
                [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:YES];
                [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:token];
                
                if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
                    [self launchForgottenPasswordFromNewPassword];
                    
                } //else the method applicationDidBecomeActive:(UIApplication *)application should be launched in the normal cycle life of the application
                
                return YES;
            } else {
                
                [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
                [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
            }
        } else if ([token length] > 0) {
            FZBlackBoxLog(@"Forgotten password");
            
            [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:token];
            
            if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
                [self launchForgottenPasswordFromAnswer];
                
            } //else the method applicationDidBecomeActive:(UIApplication *)application should be launched in the normal cycle life of the application
            
            return YES;
        } else {
            [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
            [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
        }
    } else if([[url path] isEqualToString:kUrlSchemeStartForgottenPasswordPath] || [[url path] isEqualToString:kUrlSchemeSdkForgottenPassword]){//ok
        
        FZBlackBoxLog(@"Start forgotten password process");
        
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSString *mail = [dict objectForKey:@"mail"];
        
        [[[FZTargetManager sharedInstance] model] setMailForStartForgottenPassword:mail];
        
        [[[FZTargetManager sharedInstance] model] setStartForgottenPassword:YES];
        [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
        [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
        
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            [self launchForgottenPasswordFromStart];
            
        } //else the method applicationDidBecomeActive:(UIApplication *)application should be launched in the normal cycle life of the application
        
        return YES;
    } else {
        [[[FZTargetManager sharedInstance] model] setStartForgottenPassword:NO];
        [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
        [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
    }
    
    //Create an account
    if([[url path] isEqualToString:kUrlSchemeSdkRegisterNewUser]){
        [[[FZTargetManager sharedInstance] model] setRegisterNewUser:YES];
        
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            [self launchRegisterNewUser];
        } //else the method applicationDidBecomeActive:(UIApplication *)application should be launched in the normal cycle life of the application
        
        return YES;
    } else if([[url path] isEqualToString:kUrlSchemeSdkTopup]){
        
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSString *userkey = [dict objectForKey:@"u"];
        NSString *server = [dict objectForKey:@"e"];
        
        [[UserSession currentSession] storeEnvironmentWithEnvironment:server];
        
        [[[FZTargetManager sharedInstance] model] setUserKeyForTopUp:userkey];
        [[[FZTargetManager sharedInstance] model] setTopUp:YES];
        
        return YES;
    } else {
        [[[FZTargetManager sharedInstance] model] setRegisterNewUser:NO];
        [[[FZTargetManager sharedInstance] model] setForgottenPassword:NO];
        [[[FZTargetManager sharedInstance] model] setTopUp:NO];
    }
    
    if([[url path] isEqualToString:kUrlSchemeSdkLinkWithFlashiz]){
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSString *customerUrlScheme = [dict objectForKey:@"c"];
        
        [[FZTargetManager sharedInstance] setCustomerUrlScheme:customerUrlScheme];
        
        UserSession *currentSession = [UserSession currentSession];
        
        [currentSession setLinkWithFlashiz:YES];
        
        BOOL isUserKeyStored = [[currentSession userKey] length] > 0;
        
        //Check if the user is connected
        if (!isUserKeyStored) { //if not connected
            
            UIViewController *initialViewController = (InitialViewController *)[[[FZTargetManager sharedInstance] facade] mainController];
            
            [(InitialViewController *)initialViewController login:self];
        }
        
        return YES;
    }
    
    return NO;
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:6] autorelease];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

#pragma mark - Url scheme methods

+ (void)launchTopUp {
    
    UserSession *userSession = [UserSession currentSession];
    
    if([[[FZTargetManager sharedInstance] model] userKeyForTopUp]) {//the app has well retrieve the userkey from the sdk
        
        //check if an user was already connected
        if ([[userSession userKey] length] > 0) {
            
            //retrieve the userkey from the sdk
            [userSession storeUserKey: [[[FZTargetManager sharedInstance] model] userKeyForTopUp]];
            [userSession setSdkTopupEngage:YES];
            
            //close the previous session (it will launch the new one)
            [[[FZTargetManager sharedInstance] facade] closeSession];
            
        } else {// no user is connected
            
            //retrieve the userkey from the sdk
            [userSession storeUserKey: [[[FZTargetManager sharedInstance] model] userKeyForTopUp]];
            [userSession setSdkTopupEngage:YES];
            
            //start the initviewcontroller
            InitialViewController *viewControllerInitial = (InitialViewController*)[[[FZTargetManager sharedInstance] facade] appController];
            
            //init the context to launch the pin code
            [[[FZTargetManager sharedInstance] facade] initContextWith:viewControllerInitial];
        }
    } else { //no userkey found
        //clean the session
        [self cleanSession];
        
        //disengage the topup
        UserSession *userSession = [UserSession currentSession];
        [userSession setSdkTopupEngage:NO];
    }
    
    [[[FZTargetManager sharedInstance] model] setTopUp:NO];
}

/*
 * Lauch the account's creation
 */
+ (void)launchRegisterNewUser {
    
    //get the InitialViewController
    UIViewController *initialViewController = [[[FZTargetManager sharedInstance] facade] appController];
    
    //if an user is already connected, disconnect him and dismiss the pin view
    if ([[UserSession currentSession] isFlashizLocked]) {
        
        [ConnectionServices disconnect:[[UserSession currentSession] userKey] successBlock:^(id context) {
            
            //clean the previous session
            [self cleanSession];
            
            //dismiss the pin code viewController
            [initialViewController dismissViewControllerAnimated:NO completion:nil];
            
            [self launchRegisterNewUserWithInitialViewController:initialViewController];
            
        } failureBlock:^(Error *error) {
            
            //keep the previous user connected and avoid the user creation
            [self launchRegisterNewUserWithInitialViewController:initialViewController];
        }];
    } else {
        
        //clean the previous session
        [self cleanSession];
        
        //if we are not on the initialViewController (ie. LoginViewController)
        UIViewController *subViewController = (UIViewController *)[initialViewController presentedViewController];
        if (subViewController) {
            [subViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        [self launchRegisterNewUserWithInitialViewController:initialViewController];
    }
}

/*
 * Factorization of launchRegisterNewUser
 */
+ (void)launchRegisterNewUserWithInitialViewController:(UIViewController *) initialViewController {
    //prepare CountryViewController
    CountryViewController *controller = [[self multiTargetManager] countryViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeClose];
    
    UINavigationController *secondNavigationController = [[FZPortraitNavigationController alloc]initWithRootViewController:navigController];
    
    secondNavigationController.navigationBarHidden = YES;
    
    [controller setCustomNavigationController:secondNavigationController];
    
    //present CountryViewController
    [initialViewController presentViewController:secondNavigationController animated:YES completion:^{}];
    
    [secondNavigationController release];
    
    [[[FZTargetManager sharedInstance] model] setRegisterNewUser:NO];
}

+ (void)launchForgottenPasswordFromStart {
    [self cleanSession];
    
    UIViewController *initialViewController = [[[FZTargetManager sharedInstance] facade]appController];
    
    ForgottenPasswordSendMailViewController *controller = [[self multiTargetManager] forgottenPasswordSendMailViewControllerWithMail: [[[FZTargetManager sharedInstance] model] mailForStartForgottenPassword]];
    
    UINavigationController *navigCtrler = [[FZPortraitNavigationController alloc]initWithRootViewController:controller];
    [navigCtrler setNavigationBarHidden:YES];
    
    [initialViewController presentViewController:navigCtrler animated:NO completion:^{}];
    
    [navigCtrler release];
    [[[FZTargetManager sharedInstance] model] setStartForgottenPassword:NO];
    [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
    [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
}

+ (void)launchForgottenPasswordFromAnswer {
    [self cleanSession];
    
    UIViewController *initialViewController = [[[FZTargetManager sharedInstance] facade]appController];
    
    ForgottenPasswordSecretAnswerViewController *controller = [[self multiTargetManager] forgottenPasswordSecretAnswerViewControllerWithToken: [[[FZTargetManager sharedInstance] model] tokenFromLaunchUrl]];
    [controller setDelegate:[[FZTargetManager sharedInstance] delegate]];
    
    UINavigationController *navigCtrler = [[UINavigationController alloc]initWithRootViewController:controller];
    [navigCtrler setNavigationBarHidden:YES];
    
    [initialViewController presentViewController:navigCtrler animated:YES completion:^{}];
    
    [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
    [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
    
    [navigCtrler release];
}

+ (void)launchForgottenPasswordFromNewPassword {
    [self cleanSession];
    
    UIViewController *initialViewController = [[[FZTargetManager sharedInstance] facade]appController];
    
    ForgottenPasswordNewPasswordViewController *controller = [[self multiTargetManager] forgottenPasswordNewPasswordViewControllerWithToken: [[[FZTargetManager sharedInstance] model] tokenFromLaunchUrl]];
    [controller setDelegate:[[FZTargetManager sharedInstance] delegate]];
    
    UINavigationController *navigCtrler = [[FZPortraitNavigationController alloc]initWithRootViewController:controller];
    [navigCtrler setNavigationBarHidden:YES];
    
    [initialViewController presentViewController:navigCtrler animated:YES completion:^{}];
    
    [[[FZTargetManager sharedInstance] model] setTokenFromLaunchUrl:nil];
    [[[FZTargetManager sharedInstance] model] setModeAdminFromLaunchUrl:NO];
    
    [navigCtrler release];
}

+ (void)backToTheHostApplicationWithUserkey:(NSString *)aUserKey {
    
    //NSLog(@"Back to the host application with userkey: %@ and environment: %@",aUserKey,[[UserSession currentSession] shortEnvironmentValue]);
    
    if([[FZTargetManager sharedInstance] customerUrlScheme]) {
        [SDKProxyHelper backToTheHostApplicationWithCustomerUrlScheme:[[FZTargetManager sharedInstance] customerUrlScheme]
                                                              userKey:aUserKey
                                                          environment:[[UserSession currentSession] shortEnvironmentValue]];
    }
}


+ (void)cleanSession {
    UserSession *userSession = [UserSession currentSession];
    [userSession storeUserKey:@""];
    [userSession setConnected:NO];
}

#pragma mark - Private

+ (FZDefaultMultiTargetManager *)multiTargetManager {
    return [[FZTargetManager sharedInstance] multiTarget];
}

@end
