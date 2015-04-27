//
//  Tip.m
//  FZAPI
//
//  Created by Matthieu Barile on 29/10/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "Tip.h"
#import "Error.h"

@implementation Tip

+ (void)tipWithDictionary:(NSDictionary *)tip successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"suggestedAmount", @"firstProposition", @"secondProposition", nil];
    
    NSMutableArray *keysMatchingArray = [NSMutableArray arrayWithObjects:@"", @"", @"", nil];
    
    //create and return the country object if it is the case
    Tip *tipObj = [[Tip alloc] init];
    
    [tipObj fillWithMatchingKeys:keysMatchingArray
                                keys:keysArray
                            fromJSON:tip
                        successBlock:^{
                            success([tipObj autorelease]);
                        } failureBlock:^(Error *error) {
                            failure(error);
                        }];
}

-(id)copyWithZone:(NSZone *)zone{
    Tip *copy = [[Tip allocWithZone:zone] init];
    [copy setSuggestedAmount:self.suggestedAmount];
    [copy setFirstProposition:self.firstProposition];
    [copy setSuggestedAmount:self.secondProposition];
    return copy;
}

@end
