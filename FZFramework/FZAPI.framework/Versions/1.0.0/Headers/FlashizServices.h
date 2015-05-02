//
//  FlashizServices.h
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

//Domain
#import "Error.h"

typedef enum {
    FlashizErrorResultNotOk,
    FlashizErrorUnavailableService,
    FlashizErrorServer,
    FlashizErrorTimeOut
} FlashizError;

typedef void(^NetworkSuccessBlock)(id context);
typedef void(^NetworkFailureBlock)(Error *error);

extern NSString * const userKeyParameter;

@interface FlashizServices : NSObject

+ (NSURLRequest *)requestPostForUrl:(NSURL *)url
                     withParameters:(NSDictionary *)parameters;

+ (NSURLRequest *)requestPostForUrl:(NSURL *)url
                             withJsonData:(NSString *)data;

+ (NSURLRequest *)requestPostCustomForUrl:(NSURL *)url
                           withParameters:(NSDictionary *)parameters;

+ (NSURLRequest *)requestGetForUrl:(NSURL *)url;

+ (void)executeRequest:(NSURLRequest *)urlrequest
            forService:(NSString *)serviceDescription
      withSuccessBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock;

+ (BOOL)isResultValidForContextDictionary:(NSDictionary *)context;


+(Error*)retrieveErrorWith:(int)requestStatusCode and:(int)requestErrorCode forService:(NSString *)serviceDescription;

+(Error *)errorWithMessage:(NSString *)message code:(FlashizError)code andRequestCode:(int)rCode;

@end