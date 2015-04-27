//
//  Transaction.m
//  iMobey
//
//  Created by Neopixl on 21/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "Transaction.h"

static NSDateFormatter *dateFormatter = nil;

@implementation Transaction

/*
 {
 amount = 200;
 comment = "Account refilling by credit card";
 creationDate = "2013-07-31T15:38:15Z";
 creditor =     {
 id = 747;
 };
 currency = EUR;
 debitor =     {
 id = 53;
 };
 executionDate = "2013-07-31T15:38:16Z";
 fidelitizTransactionId = "<null>";
 id = 13732;
 invoice =     {
 id = 25039;
 };
 isPaybackOf = "<null>";
 payments =     (
 {
 id = 50113;
 },
 {
 id = 50112;
 }
 );
 pending = 0;
 receiverInfo = "Your bank account";
 status = EXE;
 type =     {
 enumType = "com.flashiz.utils.Constant$TypesEnum";
 name = NULL;
 };
 validityDuration = 604800000;
 waitingUser = "<null>";
 }
*/

+ (void)transactionWithDictionary:(NSDictionary *)transaction successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the user object
    NSArray *keysArray = [NSArray arrayWithObjects:@"id",@"amount",@"currency", @"comment", @"receiverInfo", @"pending",@"status", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"transactionId",@"", @"", @"", @"", @"",@"", nil];
    
    //create and return the user object if it is the case
    Transaction *transactionObject = [[Transaction alloc] init];
    
    /*
    [transactionObject fillWithMatchingKeys:keysMatching
                                       keys:keysArray
                                   fromJSON:transaction];
     */
    
    [transactionObject fillWithMatchingKeys:keysMatching
                                       keys:keysArray
                                   fromJSON:transaction
                               successBlock:^{
                                   NSString *executionDateKey = @"executionDate";
                                   
                                   if (dateFormatter == nil) {
                                       dateFormatter = [[NSDateFormatter alloc]init];
                                       [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                                       NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                                       [dateFormatter setTimeZone: timeZone];
                                   }
                                   
                                   id valueDate = [transaction objectForKey:executionDateKey];
                                   if([NSNull null]!=valueDate) {
                                       NSDate *dArrivalDate = [dateFormatter dateFromString:valueDate];
                                       [transactionObject setValue:dArrivalDate forKey:executionDateKey];
                                   }
                                   
                                   NSString *creditorKey = @"creditor";
                                   
                                   id valueCreditor = [transaction objectForKey:creditorKey];
                                   if([NSNull null]!=valueCreditor) {
                                       [transactionObject setValue:[valueCreditor objectForKey:@"id"]
                                                            forKey:creditorKey];
                                   }    
                                   
                                   NSString *debitorKey = @"debitor";
                                   id valueDebitor = [transaction objectForKey:debitorKey];
                                   if([NSNull null]!=valueDebitor) {
                                       [transactionObject setValue:[valueDebitor objectForKey:@"id"]
                                                            forKey:debitorKey];
                                   }
                                   
                                   success([transactionObject autorelease]);
                               } failureBlock:^(Error *error) {
                                   failure(error);
                               }];
}

-(BOOL) isCanceled{
    return [[self status] isEqualToString:@"CAN"];
}

-(BOOL) isRefused{
    return [[self status] isEqualToString:@"REF"];
}

-(Transaction*)copyWithZone:(NSZone *)zone
{
    Transaction *transaction = [[Transaction allocWithZone:zone] init];
    [transaction setTransactionId:[self transactionId]];
    [transaction setAmount:[self amount]];
    [transaction setCurrency:[self currency]];
    [transaction setComment:[self comment]];
    [transaction setReceiverInfo:[self receiverInfo]];
    [transaction setExecutionDate:[self executionDate]];
    [transaction setStatus:[self status]];
    [transaction setCreditor:[self creditor]];
    [transaction setDebitor:[self debitor]];
    [transaction setPending:[self pending]];
    [transaction setFullName:[self fullName]];
    
    return transaction;
}

- (void)dealloc {
    
    [_transactionId release], _transactionId = nil;
    [_amount release], _amount = nil;
    [_currency release], _currency = nil;
    [_comment release], _comment = nil;
    [_receiverInfo release], _receiverInfo = nil;
    [_executionDate release], _executionDate = nil;
    [_status release], _status = nil;
    [_fullName release], _fullName = nil;
    [_creditorUsername release], _creditorUsername = nil;
    [_debitorUsername release], _debitorUsername = nil;
    
    [super dealloc];
}

@end
