//
//  CreditCardRule.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "CreditCardRule.h"
#import "Error.h"

@implementation CreditCardRule

+ (void)creditCardRuleWithDictionary:(NSDictionary *)cardRule successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"takenAmount", @"currency", @"creditCardId", @"expirationDate",@"PAN", nil];
    
#pragma warning - remove the following line (when currency and else when server will be ready)
    keysArray = [NSArray arrayWithObjects:@"takenAmount", @"creditCardId", @"expirationDate",@"PAN", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"", @"", @"", @"",@"pan", nil];
#pragma warning - remove the following line (when currency and else when server will be ready)
    keysMatching = [NSArray arrayWithObjects:@"", @"", @"",@"pan", nil];
    
    //create and return the account object if it is the case
    CreditCardRule *cardRuleObject = [[[CreditCardRule alloc] init] autorelease];
    
    /*
    [cardRuleObject fillWithMatchingKeys:keysMatching
                                    keys:keysArray
                                fromJSON:cardRule];
     */
    
    [cardRuleObject fillWithMatchingKeys:keysMatching
                                    keys:keysArray
                                fromJSON:cardRule successBlock:^{
                                    success(cardRuleObject);
                                } failureBlock:^(Error *error) {
                                    failure(error);
                                }];
}

- (void)dealloc
{
    [self setPan:nil];
    [self setCurrency:nil];
    [self setCreditCardId:nil];
    [self setExpirationDate:nil];
    
    [super dealloc];
}

@end
