//
//  NetraUserProfile.m
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import "NetraUserProfile.h"
#import "GTMBase64.h"
#import "NetraApiManager.h"
#import "netraGlobalVariable.h"
#import "netraUserModel.h"
#import "NetraUserInquiry.h"
#import "ModelBeli+Bayar.h"
#import "NetraDataManager.h"
#import "NRealmSingleton.h"
#import "transactionMapping.h"
#import "ModelBayar.h"
@implementation NetraUserProfile
/*
 @property (nonatomic, assign) BOOL billpayQueryState;
 @property (nonatomic, assign) BOOL billpayState;
 @property (nonatomic, strong) NSString *status;
 @property (nonatomic, strong) NSString *trxid;
 @property (nonatomic, strong) NSString *msg;
 @property (nonatomic, strong) NSString *mimage;
 */
- (instancetype)initWithUserBasicAttribute:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.billpayQueryState = [[attributes objectForKey:@"billpayQueryState"]boolValue];
    self.billpayState = [[attributes objectForKey:@"self.billpayState"]boolValue];
    self.status = [[attributes valueForKeyPath:@"status"]stringValue];
    self.trxid = [attributes objectForKey:@"trxid"];
    self.msg = [attributes valueForKeyPath:@"msg"];
    
    
    return self;
}
- (instancetype)initWithUserInquiryAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.billpayQueryState = [[attributes objectForKey:@"billpayQueryState"]boolValue];
    self.billpayState = [[attributes objectForKey:@"self.billpayState"]boolValue];
    self.status = [[attributes valueForKeyPath:@"status"]stringValue];
    self.trxid = [attributes objectForKey:@"trxid"];
    self.msg = [attributes valueForKeyPath:@"msg"];
    self.balance = [attributes valueForKey:@"balance"];
    self.name = [attributes valueForKey:@"name"];
    
    return self;
}
- (instancetype)initWithUserHistoryAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.date = [attributes valueForKeyPath:@"date"];
    self.transid = [[attributes objectForKey:@"transid"]stringValue];
    self.type = [attributes valueForKeyPath:@"type"];
    self.amount = [[attributes valueForKey:@"amount"]stringValue];
    self.agent = [attributes valueForKey:@"agent"];
    
    return self;
}

+(void)login:(NSDictionary *)params{
    netraUserModel *user = [[netraUserModel alloc]init];
    
    NSString *secretKey = [NSString stringWithFormat:@"%@%@|%@|%@",
                           TimeStamp,
                           [params objectForKey:@"pin"],
                           [NetraUserProfile reversedString:[params objectForKey:@"pin"]],
                           [params objectForKey:@"userNumber"]];
    NSLog(@"secretKye->%@",secretKey);
    
    [NetraUserProfile login:params login:^(NSArray *posts, NSError *error) {
        
        if (!error) {
            
            if(posts.count>0){
                NetraUserProfile *p=[posts objectAtIndex:0];
                user.trxid =p.trxid;
                user.status =p.status;
                user.billpayQueryState = p.billpayQueryState;
                user.billpayState=p.billpayState;
                user.msg=p.msg;
                user.userNumber = [params objectForKey:@"userNumber"];
                user.pin = [params objectForKey:@"pin"];
                user.tripleDes = [NetraUserProfile TripleDES:secretKey encryptOrDecrypt:kCCEncrypt key:secretKeyGlobal];
                [netraUserModel save:user withRevision:YES];
                [NetraUserProfile getUserInquiry];
            }
            else{
                NSLog(@"post count->%lu",(unsigned long)posts.count);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
            }
        }
        else{
            NSLog(@"error->%@",error);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
            
        }
    }];
}

+(void)getUserInquiry{
    NetraUserInquiry *userInquiry = [[NetraUserInquiry alloc]init];
    //    netraUserModel *user = [[netraUserModel alloc]init];
    [NetraUserProfile userInquiry:^(NSArray *posts, NSError *error) {
        if(!error){
            NetraUserProfile *p=[posts objectAtIndex:0];
            NSLog(@"data-->%@",p.agentData);
            userInquiry.trxid =p.trxid;
            userInquiry.status =p.status;
            userInquiry.billpayQueryState = p.billpayQueryState;
            userInquiry.billpayState=p.billpayState;
            userInquiry.balance=p.balance;
            userInquiry.name = p.name;
            [NetraUserInquiry save:userInquiry withRevision:YES];
            [NetraUserProfile getUserHistory];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"renewTheBalance" object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
            //[[NRealmSingleton sharedMORealmSingleton]deleteRealm];
        }
    }];
}

+(void)getUserHistory{
    [NetraUserProfile userTransactionHistory:^(NSArray *posts, NSError *error) {
        if(!error){
            NSLog(@"post count->%lu",(unsigned long)posts.count);
            NSLog(@"post-->%@",posts);
            [transactionMapping sharedDataManager].historyTransaction = posts;
            //[ModelBayar fetchBayar];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseLogin" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"successFetch" object:nil];
        }
        else{
            NSLog(@"getUserHistory error-->%@",error);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
            //[[NRealmSingleton sharedMORealmSingleton]deleteRealm];
        }
    }];
}

+ (NSURLSessionDataTask *)login:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block {
    
    NSString *a = [NSString stringWithFormat:@"%@%@|%@|%@",
                   TimeStamp,
                   [params objectForKey:@"pin"],
                   [NetraUserProfile reversedString:[params objectForKey:@"pin"]],
                   [params objectForKey:@"userNumber"]];
    
    
    
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@/login?signature=%@&userid=%@",indosatApiUrl,[NetraUserProfile TripleDES:a encryptOrDecrypt:kCCEncrypt key:secretKeyGlobal],userID] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        if([[JSON objectForKey:@"msg"] isEqualToString:@"Success"]){
            NSLog(@"response object->%@",JSON);
            NSDictionary *postsFromResponse = JSON;
            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
            if (postsFromResponse) {
                NetraUserProfile *post = [[NetraUserProfile alloc]initWithUserInquiryAttributes:postsFromResponse];
                [mutablePosts addObject:post];
            }
            if (block) {
                block([NSArray arrayWithArray:mutablePosts], nil);
            }
        }
        else{
            if (block) {
                NSString *message;
                NSLog(@"JSON->%@",JSON);
                if([[JSON objectForKey:@"msg"] isEqualToString:@"UNKNOW ERROR"])
                {
                    message = @"Mohon pastikan anda terkoneksi ke internet";
                }
                else if ([[JSON objectForKey:@"status"] integerValue]==1014){
                    message = @"Pin Salah, Mohon periksa kembali PIN Anda";
                }
                else if ([[JSON objectForKey:@"status"] integerValue]==1011){
                    message = @"PIN atau agen tidak ditemukan atau salah";
                }
                else if ([[JSON objectForKey:@"status"] integerValue]==1012){
                    message = @"PIN error, percobaan melebihi batas";
                }
                else if ([[JSON objectForKey:@"status"] integerValue]==1013){
                    message = @"PIN sudah kadaluarsa";
                }
                else if ([[JSON objectForKey:@"status"] integerValue]==1015){
                    message = @"Penggantian PIN – PIN baru sama dengan PIN lama";
                }
                else if ([[JSON objectForKey:@"status"] integerValue]==1016){
                    message = @"Penggantian PIN – PIN sudah dipakai sebelumnya";
                }
                
                else if([[JSON objectForKey:@"msg"] isEqualToString:@"Auth Retry Exceed"]){
                        message = @"PIN anda Telah diblokir. Silahkan Menghubungi Customer Service Indosat di 100/111";
                }
                else{
                    message =[JSON objectForKey:@"msg"];
                }
                [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:message];
                block([NSArray arrayWithArray:nil], nil);
            }
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            block([NSArray array], error);
        }
    }];
}

///user inquiry
+(NSURLSessionDataTask *)userInquiry:(void (^)(NSArray *, NSError *))block{
    netraUserModel *model =[netraUserModel getUserProfile];
    NSLog(@"url-->%@",[NSString stringWithFormat:@"%@/balance_check?userid=%@&to=%@",indosatApiUrl,userID,model.userNumber]);
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@/balance_check?&userid=%@&to=%@",indosatApiUrl,userID,model.userNumber] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"json--->%@",[[JSON objectForKey:@"agentData"]objectForKey:@"walletType"]);
        NSInteger wt=[[[JSON objectForKey:@"agentData"]objectForKey:@"walletType"]integerValue];
        if(wt==1){
            [[NetraDataManager sharedDataManager] setWalletType:@"Reguler"];
        }
        else{
            [[NetraDataManager sharedDataManager] setWalletType:@"Premium"];
        }
        
        NSDictionary *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        if (postsFromResponse) {
            NetraUserProfile *post = [[NetraUserProfile alloc]initWithUserInquiryAttributes:postsFromResponse];
            
            [mutablePosts addObject:post];
        }
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            block([NSArray array], error);
        }
    }];
    return nil;
    
}

+(NSURLSessionDataTask *)userTransactionHistory:(void (^)(NSArray *, NSError *))block{
    netraUserModel *model =[netraUserModel getUserProfile];
    NSLog(@"modell->%@",[NSString stringWithFormat:@"%@history_transaction?&userid=web_api_test&to=%@",indosatApiUrl,model.userNumber]);
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@history_transaction?signature=%@&userid=%@&to=%@&count=12",indosatApiUrl,model.tripleDes,userID,model.userNumber] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON objectForKey:@"trxList"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        if (postsFromResponse) {
            for (NSDictionary *attributes in postsFromResponse) {
                
                NetraUserProfile *post = [[NetraUserProfile alloc]initWithUserHistoryAttributes:attributes];
                [mutablePosts addObject:post];
            }
            
        }
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            block([NSArray array], error);
        }
    }];
    return nil;
    
}
+ (NSString *)reversedString:(NSString *)pin
{
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [pin length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[pin substringWithRange:subStrRange]];
    }
    
    return reversedString;
}
+ (NSData *)tripleDesEncryptData:(NSData *)inputData
                             key:(NSData *)keyData
                           error:(NSError **)error
{
    NSParameterAssert(inputData);
    NSParameterAssert(keyData);
    
    size_t outLength;
    
    NSAssert(keyData.length == kCCKeySize3DES, @"the keyData is an invalid size");
    
    NSMutableData *outputData = [NSMutableData dataWithLength:(inputData.length  +  kCCBlockSize3DES)];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kCCAlgorithm3DES, // Algorithm
                     0, // options
                     keyData.bytes, // key
                     keyData.length, // keylength
                     nil,// iv
                     inputData.bytes, // dataIn
                     inputData.length, // dataInLength,
                     outputData.mutableBytes, // dataOut
                     outputData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result != kCCSuccess) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.your_domain.your_project_name.your_class_name."
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    [outputData setLength:outLength];
    return outputData;
}

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result;
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    result = [GTMBase64 stringByEncodingData:myData];
    
    return result;
    
}
+ (NSURLSessionDataTask *)otpSend:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block{
    NSString *url =[NSString stringWithFormat:@"https://mapi.dompetku.com:8300/otp/"];
    return [[NetraApiManager sharedClient] GET:url parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSDictionary *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        NSLog(@"url->%@",url);
        NSLog(@"params->%@",params);
        NSLog(@"data-->%@",postsFromResponse);
        [mutablePosts addObject:postsFromResponse];
        NSLog(@"Post from response->%@",postsFromResponse);
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            
            NSLog(@"error->%@",error);
            NSLog(@"error->%@",task.response);
            NSLog(@"error->%@",task.currentRequest);
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            block([NSArray array], error);
        }
    }];
}
@end