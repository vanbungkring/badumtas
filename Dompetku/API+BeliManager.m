//
//  API+BeliManager.m
//  Dompetku
//
//  Created by Indosat on 1/9/15.
//
//

#import "API+BeliManager.h"
#import "NetraApiManager.h"
#import "NetraCommonFunction.h"
@implementation API_BeliManager
+ (NSURLSessionDataTask *)urlparams:(NSString *)postParams param:(NSDictionary *)parameters postParams:(void (^)(NSArray *posts, NSError *error))block{
    NSLog(@"params->%@",parameters);
    [NetraApiManager sharedClient].requestSerializer=[AFHTTPRequestSerializer serializer];
    return [[NetraApiManager sharedClient] POST:postParams parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"Response Transfer Inquiry%@",JSON);
        
        NSDictionary *postsFromResponse =JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        if ([[postsFromResponse objectForKey:@"status"] integerValue]==0) {
            [mutablePosts addObject:postsFromResponse];
            NSLog(@"post from response->%@",postsFromResponse);
            if (block) {
                block([NSArray arrayWithArray:mutablePosts], nil);
            }
        }
        else{
            /*
             1011 PIN atau agen tidak ditemukan atau salah
             1012 PIN error, percobaan melebihi batas
             1013 PIN sudah kadaluarsa
             1014 PIN salah
             1015 Penggantian PIN – PIN baru sama dengan PIN lama
             1016 Penggantian PIN – PIN sudah dipakai sebelumnya
             */
            NSString *message;
            if([[postsFromResponse objectForKey:@"msg"] isEqualToString:@"UNKNOW ERROR"])
            {
                message = @"Transaksi Gagal";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1001){
                message = @"Saldo Anda tidak mencukupi untuk melakukan transaksi ini";
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
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==23){
                message = @"Jumlah uang yang ditransfer kurang dari jumlah minimum  transaksi";
            }
            else if([[JSON objectForKey:@"msg"] isEqualToString:@"Auth Retry Exceed"]){
                message = @"PIN anda Telah diblokir. Silahkan Menghubungi Customer Service Indosat di 100/111";
            }
            else if ([[postsFromResponse objectForKey:@"status"] integerValue]==1099){
                message = @"Transaksi Gagal";
            }
            else{
                message =@"Transaksi Gagal";
            }
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:message];
            block([NSArray arrayWithArray:nil], nil);
        }
        
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            NSLog(@"session task->%@",task.response);
            block([NSArray array], error);
        }
    }];
}


@end
