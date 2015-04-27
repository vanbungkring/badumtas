//
//  TransactionServices.m
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "TransactionServices.h"
#import "FlashizUrlBuilder.h"

//Model
#import "PendingTransaction.h"
#import "Invoice.h"
#import "PaymentSummary.h"
#import "CheckPaymentResult.h"
#import "Error.h"

NSString * const TransactionsTypeMail = @"mail";

static NSString * const transfertMoneyServiceDescription = @"transfer money";
static NSString * const queuedTransactionsServiceDescription = @"queued transactions";
static NSString * const executeTransactionServiceDescription = @"execute transaction";
static NSString * const cancelTransactionsServiceDescription = @"cancel transactions";

@implementation TransactionServices


+ (void)transfertMoney:(NSString *)amount
           withComment:(NSString *)comment
               forUser:(NSString *)reciver
              fromUser:(NSString *)userKey
              withType:(NSString *)type
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:@"expe"];
    [params setObject:comment forKey:@"desc"];
    [params setObject:reciver forKey:@"dest"];
    [params setObject:amount forKey:@"amount"];
    [params setObject:type forKey:@"type"];
    
    NSURLRequest *request = [TransactionServices requestGetForUrl:[FlashizUrlBuilder transfertMoneyUrlWithParameters:params]];
    [params release];
    
    [TransactionServices executeRequest:request
                             forService:transfertMoneyServiceDescription
                       withSuccessBlock:^(id context) {
                           
                           id newBalance = [context objectForKey:@"DebitorBalance"];
                           
                           if(newBalance == nil){
                               successBlock(nil);
                           }
                           else{
                               successBlock([NSDecimalNumber numberWithDouble:[newBalance doubleValue]]);
                           }
                           
                       } failureBlock:failureBlock];
}

+ (void)executeTransactionsWithId:(NSString *)idTransaction
                          forUser:(NSString *)userKey
                     successBlock:(NetworkSuccessBlock)successBlock
                     failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:idTransaction forKey:@"transaction"];
    
    NSURLRequest *request = [TransactionServices requestGetForUrl:[FlashizUrlBuilder executeTransactionsUrlWithParameters:params]];
    
    [params release];
    
    [TransactionServices executeRequest:request
                             forService:executeTransactionServiceDescription
                       withSuccessBlock:^(id context) {
                           
                           id newBalance = [context objectForKey:@"balance"];
                           
                           if (newBalance == nil) {
                               
                               Error *error = [[Error alloc] initWithRequest:nil
                                                                    response:nil
                                                                   timestamp:[NSDate date]
                                                                 messageCode:FZ_INVALID_JSON_MISSING_KEYS
                                                                      detail:[NSString stringWithFormat:@"%@ : lastAddedUserkey",FZ_JSON_MISSING_KEYS_ERROR_MESSAGE]
                                                                        code:FZ_INVALID_JSON_ERROR_CODE
                                                         andRequestErrorCode:FZ_INVALID_JSON_ERROR_CODE];
                               
                               failureBlock(error);
                           } else {
                               successBlock([NSDecimalNumber numberWithDouble:[newBalance doubleValue]]);
                           }
                       } failureBlock:failureBlock];
    
}

+ (void)cancelTransactionsWithId:(NSString *)idTransaction
                         forUser:(NSString *)userKey
                         andSide:(NSString *)side
                    successBlock:(NetworkSuccessBlock)successBlock
                    failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userKey forKey:userKeyParameter];
    [params setObject:idTransaction forKey:@"transaction"];
    [params setObject:side forKey:@"side"];
    
    NSURLRequest *request = [TransactionServices requestGetForUrl:[FlashizUrlBuilder cancelTransactionsUrlWithParameters:params]];
    
    [params release];
    
    [TransactionServices executeRequest:request
                             forService:cancelTransactionsServiceDescription
                       withSuccessBlock:^(id context) {
                           
                           id newBalance = [context objectForKey:@"balance"]; //not sure about the key
                           
                           if(newBalance == nil){
                               Error *error = [[Error alloc] initWithRequest:nil
                                                                    response:nil
                                                                   timestamp:[NSDate date]
                                                                 messageCode:FZ_INVALID_JSON_MISSING_KEYS
                                                                      detail:[NSString stringWithFormat:@"%@ : lastAddedUserkey",FZ_JSON_MISSING_KEYS_ERROR_MESSAGE]
                                                                        code:FZ_INVALID_JSON_ERROR_CODE
                                                         andRequestErrorCode:FZ_INVALID_JSON_ERROR_CODE];
                                               
                               
                               
                               failureBlock(error);
                           } else {
                               successBlock([NSDecimalNumber numberWithDouble:[newBalance doubleValue]]);
                           }
                       } failureBlock:failureBlock];
}

@end
