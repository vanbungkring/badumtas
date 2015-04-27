//
//  ConfigForTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 09/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "ConfigForTests.h"

#import "UserSession.h"


@implementation ConfigForTests

static ConfigForTests *sharedInstance = nil;
	

+ (ConfigForTests *)sharedInstance {
	static dispatch_once_t onceBundleHelper;
	dispatch_once(&onceBundleHelper, ^{
		sharedInstance = [[ConfigForTests alloc] init];
		//Set the environment
		[[UserSession currentSession] storeEnvironment:[ConfigForTests serverUsed]];
	});
	
	return [[sharedInstance retain] autorelease];
}


+ (NSString *)serverUsed {
    return kQatEnvironmentKey;
}

- (NSString *)emailClientUsed {
    return @"flashizunittestsclient@yopmail.com";
}

- (NSString *)passwordClientUsed {
    return @"azer1234";
}

- (NSString *)emailMerchantUsed {
    return @"flashizunittestsmerchant@yopmail.com";
}

- (NSString *)passwordMerchantUsed {
    return @"azer1234";
}


@end