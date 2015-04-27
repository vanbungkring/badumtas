//
//  WalletBraintree.m
//  iMobey
//
//  Created by Matthieu Barile on 05/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "WalletBraintree.h"
#import "Error.h"

@implementation WalletBraintree

+ (void)walletBraintreeWithDictionary:(NSDictionary *)wallet successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
        
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"actionFormUrl", @"trData", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"actionFormUrl",@"trData", nil];
    
    WalletBraintree *walletObject = [[WalletBraintree alloc] init];
    /*
    [walletObject fillWithMatchingKeys:keysMatching
                                  keys:keysArray
                              fromJSON:wallet];
     */
    [walletObject fillWithMatchingKeys:keysMatching
                                  keys:keysArray
                              fromJSON:wallet
                          successBlock:^{
                              success([walletObject autorelease]);
                          } failureBlock:^(Error *error) {
                              failure(error);
                          }];
}

- (void)dealloc
{
    [self setActionFormUrl:nil];
    [self setTrData:nil];
    
    [super dealloc];
}

@end
