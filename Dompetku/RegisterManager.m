//
//  RegisterManager.m
//  Dompetku
//
//  Created by Indosat on 1/23/15.
//
//

#import "RegisterManager.h"
#import "NetraApiManager.h"
#import "NetraUserProfile.h"
#import "NetraCommonFunction.h"
@implementation RegisterManager
+ (NSURLSessionDataTask *)registerParams:(NSDictionary *)params registerManager:(void (^)(NSArray *posts, NSError *error))block{
    [NetraApiManager sharedClient].requestSerializer=[AFHTTPRequestSerializer serializer];
    [NetraApiManager sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    [[NetraApiManager sharedClient].responseSerializer setAcceptableContentTypes:[[NetraApiManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"]];
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@/register",indosatApiUrl] parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSDictionary *postsFromResponse =JSON;
         NSLog(@"post from response->%@",postsFromResponse);
        NSMutableArray *mutablePosts = [[NSMutableArray alloc]init];
        [mutablePosts addObject:postsFromResponse];
        //// save it into model
        NSLog(@"post from response->%@",postsFromResponse);
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
        
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            NSLog(@"task response->%@",task.response);
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            block([NSArray array], error);
        }
    }];
}
@end
