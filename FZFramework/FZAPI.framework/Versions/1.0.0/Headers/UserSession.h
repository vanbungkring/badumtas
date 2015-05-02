//
//  UserSession.h
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "User.h"


#define kAvatarLoadedNotification @"kAvatarLoadedNotification"

#define kITEnvironmentKey @"flashizit."
#define kTestEnvironmentKey @"flashizdev."
#define kQatEnvironmentKey @"flashizqat."
#define kIntegrationEnvironmentKey @"flashizint."
#define kSandboxEnvironmentKey @"flashizsb."
#define kUatEnvironmentKey @"flashizuat."
#define kProdEnvironmentKey @""

#define kTestKey @"test"
#define kIntKey @"int"
#define kSandboxKey @"sb"
#define kUatKey @"uat"
#define kQatKey @"qat"
#define kITKey @"it"
#define kProdKey @""

extern NSString * const environmentKeyPath;
extern NSString * const userConnected;

@interface UserSession : NSObject

+ (UserSession *)currentSession;

@property (nonatomic, copy) NSString *userKey;
@property (nonatomic, assign) BOOL isAcceptedEula;
@property (nonatomic, assign) BOOL isInBankSdk;

@property (nonatomic, retain) User *user;

@property (nonatomic, retain) NSMutableArray *fidelitizBlackList;
@property (nonatomic, retain) NSMutableArray *validUrls;

@property (nonatomic, assign, getter = isThreeDSRunning) BOOL threeDSRunning;
@property (nonatomic, assign, getter = isCardCreationInProgress) BOOL cardCreationInProgress;
@property (nonatomic, assign, getter = isSdkEngagedTopup) BOOL sdkTopupEngage;
@property (nonatomic, assign, getter = isUserConnected) BOOL connected;
@property (nonatomic, assign, getter = isFlashizLocked) BOOL locked;

@property (nonatomic, assign, getter = isUserAccessToTabBar) BOOL tabBar;
@property (nonatomic, assign, getter = isUserAccessToRewards) BOOL rewards;
@property (nonatomic, assign, getter = isUserAccessToP2PReceive) BOOL receive;
@property (nonatomic, assign, getter = isUserAccessToP2PSend) BOOL send;
@property (nonatomic, assign, getter = isUserAccessToAccountBanner) BOOL accountBanner;
@property (nonatomic, assign, getter = isUserAccessToMenu) BOOL menu;

@property (nonatomic, assign, getter = isLinkWithFlashizProcess) BOOL linkWithFlashiz;

@property (nonatomic, readonly) int timeout;

- (void)storeUserKey:(NSString *)userKey;
- (void)storeAcceptedEula:(BOOL)storeEula;
- (void)storeTimeout:(int)timeout;

- (NSString *)retrieveUserKeyFromPrefs;
- (void)storeEnvironment:(NSString *)environment;
- (NSString *)emailAfterStoredEnvironmentWithTypedEmail:(NSString *)email;
- (void)storeEnvironmentWithEnvironment:(NSString *)environment;

- (void)addProgramIdToFidelitizBlackList:(NSString *)programId;
- (void)deleteProgramIdFromFidelitizBlackList:(NSString *)programId;
- (void)clearFidelitizBlackList;

- (NSString *)shortEnvironmentValue;
- (NSString*)environment;

- (UIImage *)avatarWithDefaultImage:(UIImage *)defaultImage;
- (void) reloadAvatarWithDefaultImage:(UIImage *)defaultImage;

@end
