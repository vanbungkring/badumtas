//
//  ConnectionServices.m
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "ConnectionServices.h"

#import "FlashizUrlBuilder.h"

//Model
#import "Account.h"
#import "User.h"
#import "SecretQuestion.h"
#import "ChangePassword.h"
#import "UserSession.h"


static const BOOL debugAssertionEnabled = NO;
static NSString * const connectionServiceDescription = @"connection";
static NSString * const disconnectionServiceDescription = @"deconnection";
static NSString * const retrieveAccountServiceDescription = @"account information";
static NSString * const retrieveUserInformationServiceDescription = @"user information";
static NSString * const sendPinServiceDescription = @"send pin";
static NSString * const checkPinServiceDescription = @"check pin";
static NSString * const changePinServiceDescription = @"change pin";
static NSString * const forgottenPasswordServiceDescription = @"forgotten password";
//static NSString * const secretAnswerServiceDescription = @"secret answer";
//static NSString * const confirmSecretAnswerServiceDescription = @"confirm secret answer";
//static NSString * const changePasswordServiceDescription = @"change password";


@implementation ConnectionServices

+ (void)connect:(NSString *)theUser
       password:(NSString *)pwd
      firstTime:(BOOL)firstTime
     withDevice:(NSString *)device
 withDeviceName:(NSString *)name
   successBlock:(NetworkSuccessBlock)successBlock
   failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSAssert(!(debugAssertionEnabled && [theUser length]==0), @"user name is empty.");
    NSAssert(!(debugAssertionEnabled && [pwd length]==0), @"password is empty.");
    NSAssert(!(debugAssertionEnabled && [device length]==0), @"device is empty.");
    NSAssert(!(debugAssertionEnabled && [name length]==0), @"device name is empty.");
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:theUser forKey:@"username"];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:[NSString stringWithFormat:@"%i", firstTime] forKey:@"keyrequest"];
    [params setObject:device forKey:@"device"];
    [params setObject:name forKey:@"devicename"];
    
    NSURLRequest *request = [ConnectionServices requestPostForUrl:[FlashizUrlBuilder connectionUrl] withParameters:params];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:connectionServiceDescription
                      withSuccessBlock:^(id context) {
                          NSString *userkey = [context objectForKey:@"LastAddedUserKey"];
                          
                          successBlock(userkey);
                      } failureBlock:failureBlock];
    
}

+ (void)connectWithKey:(NSString *)userKey
                andPin:(NSString *)pin
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:pin forKey:@"pin"];
    
    NSURLRequest *request = [self requestGetForUrl:[FlashizUrlBuilder connectionUrlWithGetParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:connectionServiceDescription
                      withSuccessBlock:^(id context) {
                          NSString *result = [context objectForKey:@"result"];
                          
                          successBlock(result);
                          
                      }
                          failureBlock:failureBlock];
}

+ (void)disconnect:(NSString *)userkey
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:userKeyParameter];
    
    NSURLRequest *request = [self requestGetForUrl:[FlashizUrlBuilder disconnectionUrlWithParameters:params]];
    [params release];
    
    [self executeRequest:request
              forService:disconnectionServiceDescription
        withSuccessBlock:successBlock
            failureBlock:failureBlock];
}


+ (void)retrieveAccount:(NSString *)userKey
           successBlock:(NetworkSuccessBlock)successBlock
           failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(nil!=userKey) {
        [params setObject:userKey forKey:userKeyParameter];
    }
    
    NSURLRequest *request = [ConnectionServices requestGetForUrl:[FlashizUrlBuilder accountUrlWithParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:retrieveAccountServiceDescription
                      withSuccessBlock:^(id context) {
                          //Account *account = [Account accountWithDictionary:[context objectForKey:@"account"]];
                          [Account accountWithDictionary:[context objectForKey:@"account"] successBlock:^(id object) {
                              successBlock((Account *)object);
                              
                          } failureBlock:^(Error *error) {
                              failureBlock(error);
                          }];
                          
                      }
                          failureBlock:failureBlock];
}

+ (void)retrieveUserInfos:(NSString *)userKey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"lang"];
    
    NSURLRequest *request = [ConnectionServices requestGetForUrl:[FlashizUrlBuilder userAccountUrlWithParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:retrieveUserInformationServiceDescription
                      withSuccessBlock:^(id context) {
                          //User *user = [User userWithInformationDictionary:context];
                          [User userWithInformationDictionary:context successBlock:^(id object) {
                              successBlock((User *)object);
                          } failureBlock:^(Error *error) {
                              failureBlock(error);
                          }];
                      } failureBlock:failureBlock];
}

+ (void)retrieveUserInfosLight:(NSString *)userKey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:@"light" forKey:@"mode"];
    
    NSURLRequest *request = [ConnectionServices requestGetForUrl:[FlashizUrlBuilder userAccountUrlWithParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:retrieveUserInformationServiceDescription
                      withSuccessBlock:^(id context) {
                          //User *user = [User userWithDictionary:context];
                          [User userWithDictionary:context successBlock:^(id object) {
                              successBlock((User *)object);
                          } failureBlock:^(Error *error) {
                              failureBlock(error);
                          }];
                      } failureBlock:failureBlock];
}

#pragma mark - Pin code management

+ (void)sendPIN:(NSString *)PIN
    withUserKey:(NSString *)userKey
      withToken:(NSString *)token
   successBlock:(NetworkSuccessBlock)successBlock
   failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:PIN forKey:@"pin"];
    [params setObject:token forKey:@"token"];
    
    NSURLRequest *request = [ConnectionServices requestGetForUrl:[FlashizUrlBuilder sendPinUrlWithParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:sendPinServiceDescription
                      withSuccessBlock:^(id context) {
                          successBlock(context);
                      }
                          failureBlock:failureBlock];
}

+ (void)checkPIN:(NSString *)PIN
     withUserKey:(NSString *)userKey
    successBlock:(NetworkSuccessBlock)successBlock
    failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:PIN forKey:@"pin"];
    
    NSURLRequest *request = [ConnectionServices requestGetForUrl:[FlashizUrlBuilder checkPinUrlWithParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:checkPinServiceDescription
                      withSuccessBlock:successBlock
                      failureBlock:failureBlock];
}

+ (void)changePIN:(NSString *)oldPIN
         toNewPIN:(NSString *)newPIN
      withUserKey:(NSString *)userKey
     successBlock:(NetworkSuccessBlock)successBlock
     failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:oldPIN forKey:@"pin"];
    [params setObject:newPIN forKey:@"newpin"];
    
    NSURLRequest *request = [ConnectionServices requestGetForUrl: [FlashizUrlBuilder changePinUrlWithParameters:params]];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:changePinServiceDescription
                      withSuccessBlock:successBlock
                          failureBlock:failureBlock];
    
}

#pragma mark - Forgotten password

+ (void)forgottenPassword:(NSString *)email
     successBlock:(NetworkSuccessBlock)successBlock
     failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    
    NSURLRequest *request = [ConnectionServices requestPostForUrl:[FlashizUrlBuilder forgottenPassword] withParameters:params];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:forgottenPasswordServiceDescription
                      withSuccessBlock:successBlock
                          failureBlock:failureBlock];
}

+ (void)secretQuestion:(NSString *)token
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    
    NSURLRequest *request = [ConnectionServices requestPostForUrl:[FlashizUrlBuilder secretQuestion] withParameters:params];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:forgottenPasswordServiceDescription
                      withSuccessBlock:^(id context) {
                          //SecretQuestion *question = [SecretQuestion secretQuestionWithDictionary:context error:error];
                          [SecretQuestion secretQuestionWithDictionary:context successBlock:^(id object) {
                              successBlock((SecretQuestion *)object);
                          } failureBlock:^(Error *error) {
                              failureBlock(error);
                          }];
                      } failureBlock:failureBlock];
}

+ (void)confirmSecretAnswer:(NSString *)token
               secretAnswer:(NSString *)secretAnswer
               successBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [params setObject:secretAnswer forKey:@"secretAnswer"];
    
    NSURLRequest *request = [ConnectionServices requestPostForUrl:[FlashizUrlBuilder confirmSecretAnswer] withParameters:params];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:forgottenPasswordServiceDescription
                      withSuccessBlock:successBlock failureBlock:failureBlock];
}

+ (void)changePassword:(NSString *)password
                 token:(NSString *)token
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:password forKey:@"password"];
    [params setObject:token forKey:@"token"];
    
    NSURLRequest *request = [ConnectionServices requestPostForUrl:[FlashizUrlBuilder changePassword] withParameters:params];
    [params release];
    
    [ConnectionServices executeRequest:request
                            forService:forgottenPasswordServiceDescription
                      withSuccessBlock:^(id context) {
                          //ChangePassword *changePwd = [ChangePassword changePasswordWithDictionary:context error:error];
                          [ChangePassword changePasswordWithDictionary:context successBlock:^(id object) {
                              successBlock((ChangePassword *)object);
                          } failureBlock:^(Error *error) {
                              failureBlock(error);
                          }];
                      } failureBlock:failureBlock];
}

#pragma mark - update trial status

+ (void)updateIfStillTrial {
    [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
        [[UserSession currentSession] setUser:context];
        if(![[[UserSession currentSession] user] isTrial]){
            //NSLog(@"User is not trial anymore");
        } else {
            //NSLog(@"User is still trial");
        }
    } failureBlock:^(Error *error) {
        //NSLog(@"Failed to retrieve if user is trial or not");
    }];
}

@end
