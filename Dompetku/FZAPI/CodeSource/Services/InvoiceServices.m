//
//  InvoiceServices.m
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "InvoiceServices.h"

#import "FlashizUrlBuilder.h"

#import "Error.h"

//Model
#import "Transaction.h"
#import "Invoice.h"
#import "PaymentSummary.h"
#import "CheckPaymentResult.h"
#import "UrlList.h"

static NSString * const transactionsHistoryServiceDescription = @"transaction";
static NSString * const readInvoiceServiceDescription = @"read invoice";
static NSString * const payInvoiceServiceDescription = @"pay invoice";
static NSString * const createInvoiceServiceDescription = @"create invoice";
static NSString * const cancelInvoiceServiceDescription = @"cancel invoice";
static NSString * const createCreditServiceDescription = @"create credit";
static NSString * const checkPaymentServiceDescription = @"check payment";
static NSString * const urlListServiceDescription = @"get url list";

@implementation InvoiceServices

+ (void)getTransactionsHistory:(NSString *)userKey
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock {
    return [InvoiceServices getTransactionsHistory:userKey
                                              from:nil
                                                to:nil
                                      successBlock:successBlock
                                      failureBlock:failureBlock];
}

+ (void)getTransactionsHistory:(NSString *)userKey
                          from:(NSString *)from
                            to:(NSString *)to
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:@"true" forKey:@"hidewithdrawals"];
    if (from){
        [params setObject:from forKey:@"from"];
    }
    if (to){
        [params setObject:to forKey:@"to"];
    }
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder listTransactionsUrlWithParameters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:transactionsHistoryServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       // FIXME : not good place to parse
                       NSObject *transactions = [context objectForKey:@"transactions"];
                       
                       if(transactions != nil && [transactions.class isSubclassOfClass:NSArray.class]){
                           
                           NSMutableArray *arrayResult = [[NSMutableArray alloc] init];
                           
                           NSEnumerator *enumerator = [(NSArray *)transactions reverseObjectEnumerator];
                           
                           for(NSDictionary *transaction in enumerator){
                               NSString *fullName = (NSString *)[transaction objectForKey:@"fullName"];
                               
                               NSString *creditorUsername = (NSString *)[transaction objectForKey:@"creditor"];
                               NSString *debitorUsername = (NSString *)[transaction objectForKey:@"debitor"];
                               
                               //Transaction *object = [Transaction transactionWithDictionary:[transaction objectForKey:@"transaction"] error:error];
                               [Transaction transactionWithDictionary:[transaction objectForKey:@"transaction"] successBlock:^(id object) {
                                   [(Transaction *)object setFullName:fullName];
                                   
                                   if(creditorUsername.length > 0) {
                                       [object setCreditorUsername:creditorUsername];
                                       [object setDebitorUsername:nil];
                                   } else if(debitorUsername.length > 0) {
                                       [object setDebitorUsername:debitorUsername];
                                       [object setCreditorUsername:nil];
                                   } else {
                                       [object setDebitorUsername:nil];
                                       [object setCreditorUsername:nil];
                                   }

                                   [arrayResult addObject:object];

                               } failureBlock:^(Error *error) {
                                   NSLog(@"do not add the malformed Transaction to the array");
                                   //do not add the malformed Transaction to the array
                               }];
                           }
                           
                           successBlock(arrayResult);
                           
                           [arrayResult release];
                           
                       } else {
                           
                           Error *error = [[Error alloc] initWithRequest:nil
                                                                response:nil
                                                               timestamp:[NSDate date]
                                                             messageCode:FZ_INVALID_JSON_MISSING_KEYS
                                                                  detail:[NSString stringWithFormat:@"%@ : %@", FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, @"transactions (not exist or is not an array)"]
                                                                    code:FZ_INVALID_JSON_ERROR_CODE
                                                     andRequestErrorCode:FZ_INVALID_JSON_ERROR_CODE];
                           successBlock(error);
                       }
                   } failureBlock:failureBlock];
}

+ (void)readInvoice:(NSString *)invoiceId
            userKey:(NSString *)userKey
			apiVersion:(NSString *)apiVersion
       successBlock:(NetworkSuccessBlock)successBlock
       failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:invoiceId forKey:@"invoiceId"];
	if(apiVersion!=nil){
		 [params setObject:apiVersion forKey:@"version"];
	}
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder invoiceUrlWithParameters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:readInvoiceServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       [Invoice invoiceWithDictionary:context successBlock:^(id object) {
                           successBlock((Invoice *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   }
                       failureBlock:failureBlock];
}

+ (void)payInvoice:(NSString *)invoiceId
           userKey:(NSString *)userKey
    hasLoyaltyCard:(BOOL)hasLoyaltyCard
correctedInvoiceAmount:(double)correctedInvoiceAmount
         nbCoupons:(NSInteger)nbCoupons
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock {
    
    if([invoiceId length]==0) {

        NSString *errorMessage = [NSString stringWithFormat:@"Error: invoice id is empty."];
        Error *error = [FlashizServices errorWithMessage:errorMessage
                                                      code:FZ_INVALID_SERVICE_OR_PARAMETERS_ERROR_CODE andRequestCode:-1];
        
        failureBlock(error);
        
        return;
    }
    
    if([userKey length]==0) {

        NSString *errorMessage = [NSString stringWithFormat:@"Error: user key is empty."];
        Error *error = [FlashizServices errorWithMessage:errorMessage
                                                      code:FZ_INVALID_SERVICE_OR_PARAMETERS_ERROR_CODE andRequestCode:-1];
        
        failureBlock(error);
        
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:invoiceId forKey:@"invoiceId"];
    [params setObject:hasLoyaltyCard?@"TRUE":@"FALSE" forKey:@"hasLoyaltyCard"];
    [params setObject:[NSNumber numberWithDouble:correctedInvoiceAmount] forKey:@"correctedInvoiceAmount"];
    [params setObject:[NSNumber numberWithInteger:nbCoupons] forKey:@"nbCoupons"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder payInvoiceUrlWithParemeters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:payInvoiceServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       //PaymentSummary *payment = [PaymentSummary paymentSummaryWithDictionary:context error:error];
                       [PaymentSummary paymentSummaryWithDictionary:context successBlock:^(id object) {
                           successBlock((PaymentSummary *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

+ (void)createInvoice:(NSString *)userKey
               amount:(NSString *)amount
         successBlock:(NetworkSuccessBlock)successBlock
         failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:amount forKey:@"amount"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder createInvoiceUrlWithParameters:params]];
    
    [params release];
    
    
    [FlashizServices executeRequest:request
                         forService:createInvoiceServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       NSString *url = [context objectForKey:@"url"];
                       
                       if(url == nil){
                           Error *error = [FlashizServices errorWithMessage:@"invoice can't be created" code:FZ_INVALID_SERVICE_OR_PARAMETERS_ERROR_CODE andRequestCode:-1];
                           
                           failureBlock(error);
                           
                       }
                       
                       successBlock(url);
                       
                       
                   } failureBlock:failureBlock];
    
    
}


+ (void)cancelInvoice:(NSString *)invoiceId
              userKey:(NSString *)userKey
         successBlock:(NetworkSuccessBlock)successBlock
         failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:invoiceId forKey:@"invoiceId"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder cancelInvoiceUrlWithParameters:params]];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:cancelInvoiceServiceDescription
                   withSuccessBlock:^(id context) {
                       BOOL result = context!=nil;
                       
                       successBlock([NSNumber numberWithBool:result]);
                   } failureBlock:failureBlock];
    
}



+ (void)createCredit:(NSString *)userKey
              amount:(NSString *)amount
        successBlock:(NetworkSuccessBlock)successBlock
        failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:@"apiKey"];
    [params setObject:amount forKey:@"amount"];
    
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder createCreditUrlWithParameters:params]];
    
    [params release];
    
    
    [FlashizServices executeRequest:request
                         forService:createCreditServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       NSString *url = [context objectForKey:@"url"];
                       NSString *urlLastPathComponent = [url lastPathComponent];
                       
                       if(url == nil){
                           #warning undefined read error ?!!!!
                           /*
                            Error *error = [[Error alloc] initWithRequest:nil response:context.description timestamp:[NSDate date] message:INVALID_JSON_MISSING_KEYS detail:[NSString stringWithFormat:@"%@ : url",JSON_MISSING_KEYS_ERROR_MESSAGE]];
                            [ErrorManager addError:error];
                            */
                           //return nil;
                       }
                       else{
                           
                           //return [[url componentsSeparatedByString:@"/"] lastObject];
                       }
                       
                       successBlock(urlLastPathComponent);
                       
                       
                   } failureBlock:failureBlock];
    
}


+ (void)checkPayment:(NSString *)invoiceId
          forUserKey:(NSString *)userKey
        successBlock:(NetworkSuccessBlock)successBlock
        failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:invoiceId forKey:@"invoiceId"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder checkPaymentUrlWithParameters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:checkPaymentServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       //CheckPaymentResult *result = [CheckPaymentResult checkPaymentResultWithDictionary:context error:error];
                       [CheckPaymentResult checkPaymentResultWithDictionary:context successBlock:^(id object) {
                           successBlock((CheckPaymentResult *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

+ (void)urlListSuccessBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder urlList]];
    
    [FlashizServices executeRequest:request
                         forService:urlListServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       //UrlList *urlList = [UrlList urlListWithDictionary:context];
                       [UrlList urlListWithDictionary:context successBlock:^(id object) {
                           successBlock([(UrlList *)object urls]);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

@end
