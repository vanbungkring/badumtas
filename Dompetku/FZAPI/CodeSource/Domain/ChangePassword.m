//
//  ChangePassword.m
//  flashiz_ios_api
//
//  Created by Matthieu Barile on 22/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "ChangePassword.h"

@implementation ChangePassword

+ (void)changePasswordWithDictionary:(NSDictionary *)changePassword successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"email", nil];
    
    NSMutableArray *keysMatchingArray = [NSMutableArray arrayWithObjects:@"", nil];
    
    //create and return the country object if it is the case
    ChangePassword *changePasswordObj = [[ChangePassword alloc] init];
    
    [changePasswordObj fillWithMatchingKeys:keysMatchingArray
                                       keys:keysArray
                                   fromJSON:changePassword
                               successBlock:^{
                                   success([changePasswordObj autorelease]);
                               } failureBlock:^(Error *error) {
                                   failure(error);
                               }];
}

- (void)dealloc
{
    [self setEmail:nil];
    [super dealloc];
}

@end
