//
//  UserSession.m
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "UserSession.h"

//Services
#import "AvatarServices.h"
#import "FlashizUrlBuilder.h"

//Avatar
#import "FZUIImageWithFZBinaryArray.h"

static UserSession *currentSession = nil;

NSString * const environmentKeyPath = @"environment";
NSString * const userConnected = @"connected";

static NSString * const USER_KEY = @"user_key";
static NSString * const INDONESIA_DID_ACCEPT_EULA = @"indonesia_did_accept_eula";
static NSString * const TIMEOUT = @"timeout";
static NSString * const ENVIRONMENT = @"environment";

//fidelitiz black list
static NSString * const FIDELITIZ_BLACKLIST = @"fidelitiz_blacklist";

//avatar
static NSString * const AVATAR_TIMESTAMP = @"timestamp";
static int const AVATAR_TIME_LIFE = 3600*6; //in second => 6 hours
static NSString * const AVATAR_FILENAME = @"avatar";

@interface UserSession ()

@property (nonatomic, assign) int timeout;

@end

@implementation UserSession

+ (UserSession *)currentSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentSession = [[UserSession alloc] init];
    });
    
    return currentSession;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //user key
        [self setUserKey:[userDefaults valueForKey:USER_KEY]];
        //timeout
        int timeout = (int)[userDefaults integerForKey:TIMEOUT];
        
        if (timeout==0) {
            timeout = 2;//default
        }
        [self setTimeout:timeout];

        //environment
        NSMutableArray *blacklist = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:FIDELITIZ_BLACKLIST]];
        if(blacklist != nil){
            [self setFidelitizBlackList:blacklist];
        }
        
        //indonesia : accepted eula
        if([[userDefaults valueForKey:INDONESIA_DID_ACCEPT_EULA] isEqualToString:@"YES"]){
            [self setIsAcceptedEula:YES];
        }else{
            [self setIsAcceptedEula:NO];
        }
        
        //valid Urls
        [self setValidUrls:nil];
        
        //linkWithFlashiz process
        [self setLinkWithFlashiz:NO];
        
        [self addObserver:self forKeyPath:userConnected options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:userConnected];
    
    [self setValidUrls:nil];
    [self setUserKey:nil];
    [self setUser:nil];
    [super dealloc];
}

#pragma mark - Observing method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //In case the user has been disconnected we delete the avatar in cache.
    if([keyPath isEqualToString:userConnected]) {
        BOOL isConnected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];

        if(!isConnected){
            // TODO : wtf if user in on pin code, the avatar is deleted.....
            [self deleteAvatar];
        }
    }
}

#pragma mark - Private methods

- (void)storeAvatarTimestamp:(int)timestamp {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:timestamp forKey:AVATAR_TIMESTAMP];
    [userDefaults synchronize];
    
}

- (int)storedAvatarTimestamp {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[userDefaults integerForKey:AVATAR_TIMESTAMP];
}

- (void)storeFidelitizBlackList:(NSMutableArray *)blacklist {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:blacklist forKey:FIDELITIZ_BLACKLIST];
    [userDefaults synchronize];
    
    [self setFidelitizBlackList:blacklist];
}

- (void)clearFidelitizBlackList {
    [self storeFidelitizBlackList:nil];
}

- (void)deleteAvatar{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",AVATAR_FILENAME];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
    }
}

#pragma mark - Public methods

- (NSString *)retrieveUserKeyFromPrefs {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:USER_KEY];
}

- (void)storeUserKey:(NSString *)userKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userKey forKey:USER_KEY];
    [userDefaults synchronize];
    
    [self setUserKey:userKey];
}

-(void)storeAcceptedEula:(BOOL)storeEula
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:storeEula?@"YES":@"NO" forKey:INDONESIA_DID_ACCEPT_EULA];
    [userDefaults synchronize];
    [self setIsAcceptedEula:storeEula];
}


- (void)storeTimeout:(int)timeout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:timeout forKey:TIMEOUT];
    [userDefaults synchronize];
    
    [self setTimeout:timeout];
}

-(NSString*)environment
{
    //Override accessor !
    return [[NSUserDefaults standardUserDefaults] objectForKey:ENVIRONMENT];
}


- (void)storeEnvironment:(NSString *)environment {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:environment forKey:ENVIRONMENT];
    [userDefaults synchronize];
}

- (NSString *)emailAfterStoredEnvironmentWithTypedEmail:(NSString *)email {
    NSArray* splitEmail = [email componentsSeparatedByString: @"."];
    NSString* prefix = [NSString stringWithFormat:@"%@%@",[splitEmail firstObject],@"."];
        
    if (prefix && [FlashizUrlBuilder isValidEnvironment:prefix]) {
        [self storeEnvironment:prefix];
        return [email stringByReplacingOccurrencesOfString:prefix withString:@""];
    } else {
        [self storeEnvironment:kProdEnvironmentKey];
        return email;
    }
}

- (void)storeEnvironmentWithEnvironment:(NSString *)environment {
    if([FlashizUrlBuilder isValidEnvironment:environment]) {
        [self storeEnvironment:environment];
    } else {
        [self storeEnvironment:kProdEnvironmentKey];
    }
}

- (void)addProgramIdToFidelitizBlackList:(NSString *)programId{
    NSMutableArray *blacklist = [self fidelitizBlackList];
    if(blacklist == nil){
        blacklist = [[[NSMutableArray alloc] initWithObjects:programId, nil] autorelease];
    }
    else if(![blacklist containsObject:programId]){
      [blacklist addObject:programId];
    }
    [self storeFidelitizBlackList:blacklist];
}


- (void)deleteProgramIdFromFidelitizBlackList:(NSString *)programId{
    NSMutableArray *blacklist = [self fidelitizBlackList];
    if(blacklist != nil){
        if([blacklist containsObject:programId]){
            [blacklist removeObject:programId];
            [self storeFidelitizBlackList:blacklist];
        }
    }
}

-(void) reloadAvatarWithDefaultImage:(UIImage *)defaultImage
{
    [self deleteAvatar];
    [self storeAvatarTimestamp:0];
    [self avatarWithDefaultImage:defaultImage];
}

- (UIImage *)avatarWithDefaultImage:(UIImage *)defaultImage {
    
    NSString *fileName = [NSString stringWithFormat:@"%@.png",AVATAR_FILENAME];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    int currentTimestamp = (int)[[NSDate date] timeIntervalSince1970];
    
    int maxTimestamp = [self storedAvatarTimestamp] + AVATAR_TIME_LIFE;
    
    //check if a local copy exists and the current timestamp is earlier than the last modification (
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && currentTimestamp < maxTimestamp){ //if yes
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            return [UIImage imageWithContentsOfFile:filePath]; //retrun the image store in cache
        }else{
             //If user hasn't define avatar
            return nil;
        }
        
    } else { //if no local copy exists
        
        if([[self user] email] != nil){
            
            [AvatarServices avatarWithMail:[[self user] email] successBlock:^(id context) {
                
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                    [self deleteAvatar];
                }
                
                //the server return NSArray
                NSArray* arrayImage = (NSArray *)context;
                
                NSData * dataImage = [NSKeyedArchiver archivedDataWithRootObject:arrayImage];
                
                //convert it to UIImage
                FZUIImageWithFZBinaryArray *avatarFromTheServer = [FZUIImageWithFZBinaryArray imageFromBinaryArray:arrayImage withDefautImage:nil];
                
                //Store the image in a file (cache)
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createFileAtPath:filePath contents:dataImage attributes:nil];
                
                //store the curent timestamp
                [self storeAvatarTimestamp:currentTimestamp];
                
                //post notification
                [[NSNotificationCenter defaultCenter] postNotificationName:kAvatarLoadedNotification object:avatarFromTheServer];
                
            } failureBlock:^(Error *error) {
                NSLog(@"fail to load avatar");
                
            }];
        }
        return nil;
    }
}

- (NSString *)shortEnvironmentValue {
    
    NSString *env = [self environment];
    
    if([env isEqualToString:kTestEnvironmentKey]){
        return kTestKey;
    } else if([env isEqualToString:kQatEnvironmentKey]){
        return kQatKey;
    } else if([env isEqualToString:kSandboxEnvironmentKey]){
        return kSandboxKey;
    } else if([env isEqualToString:kUatEnvironmentKey]){
        return kUatKey;
    } else if([env isEqualToString:kITEnvironmentKey]){
        return kITKey;
    } else if([env isEqualToString:kIntegrationEnvironmentKey]){
        return kIntKey;
    } else {
        return kProdKey;
    }
}

@end
