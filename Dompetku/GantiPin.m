//
//  GantiPin.m
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import "GantiPin.h"
#import "NetraApiManager.h"
#import "NetraUserModel.h"
#import "netraGlobalVariable.h"
#import "NetraCommonFunction.h"
#import "NetraUserProfile.h"

@implementation GantiPin
+ (NSURLSessionDataTask *)changePin:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block{
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@change_pin?signature=%@&userid=%@&pin=%@",indosatApiUrl,[params objectForKey:@"signature"],userID,[params objectForKey:@"pin"]] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSDictionary *postsFromResponse = JSON;
        NSLog(@"hson=>%@",JSON);
        NSLog(@"hson=>%@",params);
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        if ([[postsFromResponse objectForKey:@"status"] integerValue]==0) {
            [mutablePosts addObject:postsFromResponse];
            if (block) {
                netraUserModel *modelUser = [netraUserModel getUserProfile];
                NSLog(@"model User-->%@",modelUser);
                
                
                NSString *secretKey = [NSString stringWithFormat:@"%@%@|%@|%@",
                                       TimeStamp,
                                       [params objectForKey:@"pin"],
                                       [NetraUserProfile reversedString:[params objectForKey:@"pin"]],
                                       modelUser.userNumber];
                NSLog(@"secretKye->%@",secretKey);
                modelUser.guid = modelUser.guid;
                modelUser.updatedAt  = [NSDate date];
                modelUser.userNumber = modelUser.userNumber;
                modelUser.pin = [params objectForKey:@"pin"];
                modelUser.billpayQueryState = [[postsFromResponse objectForKey:@"billpayQueryState"]integerValue];
                modelUser.billpayState  =[[postsFromResponse objectForKey:@"billpayState"]integerValue];
                modelUser.status = 0;
                modelUser.trxid = 0;
                modelUser.msg = @"success";
                modelUser.tripleDes = [NetraUserProfile TripleDES:secretKey encryptOrDecrypt:kCCEncrypt key:secretKeyGlobal];
                
                [netraUserModel save:modelUser withRevision:YES];
                NSLog(@"model User-->%@",modelUser);
                block([NSArray arrayWithArray:mutablePosts], nil);
            }
        }
        else{
            NSString *message;
            if([[postsFromResponse objectForKey:@"msg"] isEqualToString:@"UNKNOWN ERROR"])
            {
                message = @"Mohon pastikan anda terkoneksi ke internet";
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
            else if([[JSON objectForKey:@"msg"] isEqualToString:@"Auth Retry Exceed"]){
                message = @"PIN anda Telah diblokir. Silahkan Menghubungi Customer Service Indosat di 100/111";
            }
            else{
                message =[postsFromResponse objectForKey:@"msg"];
            }
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:message];
            
            if (block) {
                block([NSArray arrayWithArray:nil], nil);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
        }
    }];
}
@end
