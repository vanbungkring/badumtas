//
//  TransactionServicesTests.m
//  FZAPI
//
//  Created by Julian Clémot on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigForTests.h"
#import "FZResponseLoader.h"
#import "FZDataSource.h"
#import "ConnectionServices.h"
#import "User.h"

//Tested
#import "CreditCardServices.h"


@interface ConnectionServicesScenario : XCTestSuite

@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) NSString *cardName;
@property (nonatomic, retain) NSString *cardId;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, assign) NSString *limit;

@property (nonatomic, retain) NSDictionary *datasourceDict;

@property (nonatomic, assign) int result;

@end

@implementation ConnectionServicesScenario


@end
