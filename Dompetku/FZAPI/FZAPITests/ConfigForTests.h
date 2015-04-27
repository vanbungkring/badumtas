//
//  ConfigForTests.h
//  FZAPI
//
//  Created by Matthieu Barile on 09/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigForTests : NSObject

@property (nonatomic, retain) NSString *userkeyClient;
@property (nonatomic, retain) NSString *userkeyMerchant;

+ (ConfigForTests *)sharedInstance;

+ (NSString *)serverUsed;

- (NSString *)emailClientUsed;

- (NSString *)passwordClientUsed;

- (NSString *)emailMerchantUsed;

- (NSString *)passwordMerchantUsed;

@end
