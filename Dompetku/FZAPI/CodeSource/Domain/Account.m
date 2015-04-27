//
//  Account.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (void)accountWithDictionary:(NSDictionary *)account successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"id", @"balance", @"description", @"openingDate", @"tag", @"currency", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"accountId", @"", @"desc", @"", @"", @"", nil];
    
    //create and return the account object if it is the case
    
    Account *accountObject = [[Account alloc] init];
    
    /*
    [accountObject fillWithMatchingKeys:keysMatching
                                   keys:keysArray
                               fromJSON:account];
     */
    [accountObject fillWithMatchingKeys:keysMatching
                                   keys:keysArray
                               fromJSON:account
                           successBlock:^{
                               success([accountObject autorelease]);
                           } failureBlock:^(Error *error) {
                               failure(error);
                           }];
}

- (void)dealloc
{    
    [self setDesc:nil];
    [self setOpeningDate:nil];
    [self setTag:nil];
    [self setCurrency:nil];
    
    [super dealloc];
}

@end
