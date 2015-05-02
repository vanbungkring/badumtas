//
//  Transaction.h
//  iMobey
//
//  Created by Neopixl on 21/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

@interface Transaction : FlashizObject

@property (copy, nonatomic) NSString *transactionId;
@property (retain, nonatomic) NSNumber *amount;
@property (retain, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *comment;
@property (copy, nonatomic) NSString *receiverInfo;
@property (retain, nonatomic) NSDate *executionDate;
@property (retain, nonatomic) NSString *status;
@property (retain, nonatomic) NSString *fullName;
@property (retain, nonatomic) NSString *creditorUsername;
@property (retain, nonatomic) NSString *debitorUsername;
@property (nonatomic) int creditor;
@property (nonatomic) int debitor;
@property (nonatomic) BOOL pending;

/*
 * TODO doc
 */
+ (void)transactionWithDictionary:(NSDictionary *)transaction successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

-(BOOL) isCanceled;
-(BOOL) isRefused;

@end