//
//  UrlList.m
//  flashiz_ios_api
//
//  Created by Matthieu Barile on 02/04/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "UrlList.h"

@implementation UrlList

+ (void)urlListWithDictionary:(NSDictionary *)urlList successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create and return the account object if it is the case
    UrlList *urlListObject = [[UrlList alloc] init];
    
    id contentKey = @"content";
    
    NSDictionary *content = [urlList objectForKey:contentKey];
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"urls", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"urls", nil];
    
    /*
    [urlListObject fillWithMatchingKeys:keysMatching
                                   keys:keysArray
                               fromJSON:content];
     */
    
    [urlListObject fillWithMatchingKeys:keysMatching
                                   keys:keysArray
                               fromJSON:content
                           successBlock:^{
                               success([urlListObject autorelease]);
                           } failureBlock:^(Error *error) {
                               failure(error);
                           }];
}

- (void)dealloc
{
    [self setUrls:nil];
    [super dealloc];
}

@end
