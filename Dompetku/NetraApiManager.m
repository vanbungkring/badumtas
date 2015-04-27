//
//  NetraApiManager.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "NetraApiManager.h"


@implementation NetraApiManager

+ (instancetype)sharedClient {
    static NetraApiManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetraApiManager alloc] initWithBaseURL:[NSURL URLWithString:elasitasApiUrl]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        [_sharedClient.responseSerializer setAcceptableContentTypes:[_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
        [_sharedClient.responseSerializer setAcceptableContentTypes:[_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"]];
        [_sharedClient.responseSerializer setAcceptableContentTypes:[_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"]];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    
    return _sharedClient;
}

@end

