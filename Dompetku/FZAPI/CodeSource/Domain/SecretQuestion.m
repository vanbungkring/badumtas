//
//  SecretQuestion.m
//  flashiz_ios_api
//
//  Created by Matthieu Barile on 22/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "SecretQuestion.h"

@implementation SecretQuestion

+ (void)secretQuestionWithDictionary:(NSDictionary *)secretQuestion successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"secretQuestion", nil];
    
    NSMutableArray *keysMatchingArray = [NSMutableArray arrayWithObjects:@"", nil];
    
    //create and return the country object if it is the case
    SecretQuestion *secretQuestionObj = [[SecretQuestion alloc] init];
    
    
    [secretQuestionObj fillWithMatchingKeys:keysMatchingArray
                                       keys:keysArray
                                   fromJSON:secretQuestion
                               successBlock:^{
                                   success([secretQuestionObj autorelease]);
                               } failureBlock:^(Error *error) {
                                   failure(error);
                               }];
}

- (void)dealloc
{
    [self setSecretQuestion:nil];
    [super dealloc];
}

@end
