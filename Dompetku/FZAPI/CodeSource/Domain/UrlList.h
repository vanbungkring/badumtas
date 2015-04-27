//
//  UrlList.h
//  flashiz_ios_api
//
//  Created by Matthieu Barile on 02/04/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "FlashizObject.h"

@interface UrlList : FlashizObject

@property (retain, nonatomic) NSArray *urls;

/*
 * TODO doc
 */
+ (void)urlListWithDictionary:(NSDictionary *)urlList successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end