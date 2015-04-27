//
//  Country.m
//  iMobey
//
//  Created by Neopixl on 29/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "Country.h"
#import "Error.h"

@implementation Country

+ (void)countryWithDictionary:(NSDictionary *)country successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"code", @"name", @"phone_prefix", @"reference", nil];
    
    NSMutableArray *keysMatchingArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    
    //create and return the country object if it is the case
    Country *countryObj = [[Country alloc] init];
    
    [countryObj fillWithMatchingKeys:keysMatchingArray
                                keys:keysArray
                            fromJSON:country
                        successBlock:^{
                            success([countryObj autorelease]);
                        } failureBlock:^(Error *error) {
                            failure(error);
                        }];
}

- (void)dealloc
{    
    [self setCode:nil];
    [self setName:nil];
    [self setPhone_prefix:nil];
    [self setReference:nil];
    
    [super dealloc];
}

@end
