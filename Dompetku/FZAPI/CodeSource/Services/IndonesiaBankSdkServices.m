//
//  IndonesiaBankSdkServices.m
//  FZAPI
//
//  Created by julian Clémot on 12/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "IndonesiaBankSdkServices.h"

#import "FlashizUrlBuilder.h"

#import "Error.h"

#import "Invoice.h"
#import "IndonesianInvoiceStatus.h"


#import "FlashizUrlBuilder.h"

static NSString * const createUserServiceDescription = @"createUserMiddleWare";
static NSString * const payInvoiceServiceDescription = @"payInvoiceMiddleWare";
static NSString * const getMerchantApiKeyServiceDescription = @"getMerchantApiKeyMiddleWare";
static NSString * const readInvoiceIndonesiaServiceDescription = @"readInvoiceBankSdk";
static NSString * const payInvoiceStatusIndonesiaServiceDescription = @"payInvoiceStatusBankSdk";

@implementation IndonesiaBankSdkServices


+ (void) createWithSwift:(NSString *)swift successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    NSString *data = [NSString stringWithFormat:@"{\"bankSwift\":\"%@\"}",swift];
    
    NSURLRequest *request = [IndonesiaBankSdkServices requestPostForUrl:[FlashizUrlBuilder middleWareIndonesiaCreateUser]withJsonData:data];
    [params release];
    
    [IndonesiaBankSdkServices executeRequest:request
                            forService:createUserServiceDescription
                      withSuccessBlock:^(id context) {
                          NSString *userkey =  [[context objectForKey:@"content"] objectForKey:@"userKey"];
                          
                          successBlock(userkey);
                      } failureBlock:failureBlock];
}

+ (void) payInvoice:(NSString *)userKey invoiceId:(NSString *)invoiceId bankRef:(NSString *)bankRef discountAmount:(double)discountAmount nbOfCoupons:(int)aNbOfCoupons successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
     NSString *data = [NSString stringWithFormat:@"{\"invoiceId\":\"%@\",\"correctedInvoiceAmount\":\"%f\",\"nbCoupons\":\"%d\",\"userKey\":\"%@\",\"bankSwift\":\"%@\"}",invoiceId,discountAmount,aNbOfCoupons,userKey,bankRef];
    
    NSURLRequest *request = [IndonesiaBankSdkServices requestPostForUrl:[FlashizUrlBuilder middleWareIndonesiaPayInvoice]withJsonData:data];
    [params release];
    
    [IndonesiaBankSdkServices executeRequest:request
                                  forService:payInvoiceServiceDescription
                            withSuccessBlock:^(id context) {
                                successBlock(context);
                            } failureBlock:failureBlock];
}

+ (void) getMerchantApiKeyWithMail:(NSString *)mail andPassword:(NSString *)password successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //TODO : params en json, plus createpostrequest en json
    /*	params.put("mail", email);
     params.put("pwd", password);
     params.put("pinCode", 1234);
     params.put("deviceModel", "MiddleWareTestsDevice");
     params.put("deviceName", "MiddleWareTestsDevice");
     */
    
    NSURLRequest *request = [IndonesiaBankSdkServices requestPostForUrl:[FlashizUrlBuilder middleWareIndonesiaGenerateApiKey]];
    [params release];
    
    [IndonesiaBankSdkServices executeRequest:request
                                  forService:getMerchantApiKeyServiceDescription
                            withSuccessBlock:^(id context) {
                                NSString *userkey = [context objectForKey:@"apiKey"];
                                
                                successBlock(userkey);
                            } failureBlock:failureBlock];
}

+ (void) readInvoice:(NSString *)userKey invoiceId:(NSString *)invoiceId apiVersion:(NSString *)apiVersion successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:@"userkey"];
    [params setObject:invoiceId forKey:@"invoiceId"];
	if(apiVersion!=nil){
		[params setObject:apiVersion forKey:@"version"];
	}
	
    NSLog(@"params : %@",params);
        
    NSURLRequest *request = [IndonesiaBankSdkServices requestPostForUrl:[FlashizUrlBuilder indonesianGetInvoice]withParameters:params];
    [params release];
    
    [IndonesiaBankSdkServices executeRequest:request
                                  forService:readInvoiceIndonesiaServiceDescription
                            withSuccessBlock:^(id context) {
                                
                                //Invoice *invoice = [Invoice invoiceWithDictionary:context error:error];
                                
                                [Invoice invoiceWithDictionary:context successBlock:^(id object) {
                                    successBlock((Invoice *)object);
                                } failureBlock:^(Error *error) {
                                    failureBlock(error);
                                }];
                                
                            } failureBlock:failureBlock];
}

+ (void) payInvoiceStatus:(NSString *)userKey invoiceId:(NSString *)invoiceId successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:@"userkey"];
    [params setObject:invoiceId forKey:@"invoiceId"];
    
    NSURLRequest *request = [IndonesiaBankSdkServices requestPostForUrl:[FlashizUrlBuilder indonesianStatusPayInvoice]withParameters:params];
    [params release];
    
    [IndonesiaBankSdkServices executeRequest:request
                                  forService:payInvoiceStatusIndonesiaServiceDescription
                            withSuccessBlock:^(id context) {
                                //IndonesianInvoiceStatus *result = [IndonesianInvoiceStatus indonesianInvoiceStatusWithDictionary:context error:error];
                                [IndonesianInvoiceStatus indonesianInvoiceStatusWithDictionary:context successBlock:^(id object) {
                                    successBlock((IndonesianInvoiceStatus *)object);
                                } failureBlock:^(Error *error) {
                                    failureBlock(error);
                                }];
                            } failureBlock:failureBlock];
}

@end
