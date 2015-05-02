//
//  IndonesiaBankSdkServices.h
//  FZAPI
//
//  Created by julian Clémot on 12/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "FlashizServices.h"

//Must be refactor
@interface IndonesiaBankSdkServices : FlashizServices

+ (void) createWithSwift:(NSString *)swift successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
+ (void) payInvoice:(NSString *)userKey invoiceId:(NSString *)invoiceId bankRef:(NSString *)bankRef successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
+ (void) getMerchantApiKeyWithMail:(NSString *)mail andPassword:(NSString *)password successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
+ (void) payInvoice:(NSString *)userKey invoiceId:(NSString *)invoiceId bankRef:(NSString *)bankRef discountAmount:(double)discountAmount nbOfCoupons:(int)aNbOfCoupons successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
+ (void) payInvoiceStatus:(NSString *)userKey invoiceId:(NSString *)invoiceId successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;

+ (void) readInvoice:(NSString *)userKey invoiceId:(NSString *)invoiceId successBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock;
@end