//
//  RequestToken.m
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import "RequestToken.h"
#import "NetraApiManager.h"
#import "netraGlobalVariable.h"
#import "NetraCommonFunction.h"

@implementation RequestToken
+ (NSURLSessionDataTask *)requestToken:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block{
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@create_coupon?signature=%@&userid=%@",indosatApiUrl,[params objectForKey:@"signature"],userID] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSDictionary *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        if ([[postsFromResponse objectForKey:@"status"] integerValue]==0) {
            [mutablePosts addObject:postsFromResponse];
            //// save it into model
            if (block) {
                block([NSArray arrayWithArray:mutablePosts], nil);
            }
        }
        else{
            NSString *message;
            if([[postsFromResponse objectForKey:@"msg"] isEqualToString:@"UNKNOW ERROR"])
            {
                message = @"Mohon pastikan anda terkoneksi ke internet";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1014){
                message = @"Pin Salah, Mohon periksa kembali PIN Anda";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1014){
                message = @"Pin Salah, Mohon periksa kembali PIN Anda";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1011){
                message = @"PIN atau agen tidak ditemukan atau salah";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1012){
                message = @"PIN error, percobaan melebihi batas";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1013){
                message = @"PIN sudah kadaluarsa";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1015){
                message = @"Penggantian PIN – PIN baru sama dengan PIN lama";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1016){
                message = @"Penggantian PIN – PIN sudah dipakai sebelumnya";
            }
            else{
                message =[postsFromResponse objectForKey:@"msg"];
            }
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:message];
            block([NSArray arrayWithArray:nil], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
