//
//  FlashizObject.h
//  flashiz_ios_api
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Error;

typedef void(^ParseSuccessBlock)(id object);
typedef void(^ParseFailureBlock)(Error *error);
typedef void(^FillObjectSuccessBlock)();
typedef void(^FillObjectFailureBlock)(Error *error);

@interface FlashizObject : NSObject

- (void)fillWithMatchingKeys:(NSArray *)matchingKeys
                        keys:(NSArray *)keys
                    fromJSON:(NSDictionary *)JSON
                successBlock:(FillObjectSuccessBlock)success
                failureBlock:(FillObjectFailureBlock)failure;

@end