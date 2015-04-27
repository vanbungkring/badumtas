//
//  Wallet.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "Wallet.h"
#import "Error.h"

@implementation Wallet

+ (void)walletWithDictionary:(NSDictionary *)wallet successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"redirecturl", @"creditcardid", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"redirectUrl",@"creditCardId", nil];
        
    Wallet *walletObject = [[Wallet alloc] init];
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
    [self setRedirectUrl:nil];
    [self setCreditCardId:nil];
    
    [super dealloc];
}

@end
