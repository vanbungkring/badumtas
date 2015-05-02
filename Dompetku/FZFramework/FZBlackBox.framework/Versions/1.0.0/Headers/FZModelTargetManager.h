//
//  FZModelTargetManager.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 4/25/14.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FZModelTargetManager : NSObject
{
    
}

@property (nonatomic, assign, getter = isModeAdmin) BOOL modeAdminFromLaunchUrl;
@property (nonatomic, retain) NSString *tokenFromLaunchUrl;

@property (nonatomic, assign, getter = shouldStartForgottenPassword) BOOL startForgottenPassword;
@property (nonatomic, retain) NSString *mailForStartForgottenPassword;

@property (nonatomic, assign, getter = shouldRegisterNewUser) BOOL registerNewUser;
@property (nonatomic, assign, getter = shouldLaunchForgottenPassword) BOOL forgottenPassword;
@property (nonatomic, assign, getter = shouldLaunchTopUp) BOOL topUp;
@property (nonatomic, retain) NSString *userKeyForTopUp;

@property (nonatomic, assign) BOOL isConnectionProccess;


- (FZModelTargetManager*)init;

@end
