//
//  Invoice.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 07/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"
#import "Tip.h"

@class LoyaltyProgram;
@class Error;

@interface Invoice : FlashizObject <NSMutableCopying>

//Common
@property (copy, nonatomic) NSString *invoiceId;
@property (nonatomic) double amount;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *comment;

//European only
@property (nonatomic) BOOL isCredit;
@property (nonatomic) BOOL withRefill;
@property (nonatomic) double newBalanceWithRefill;
@property (nonatomic) double newBalanceWithoutRefill;

// Tipping
@property (nonatomic) BOOL tipEnabled;
@property (copy, nonatomic) Tip *tip;

@property (nonatomic) int numberOfRefill;
@property (nonatomic) double takenAmount;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *otherMail;
@property (copy, nonatomic) NSString *otherName;

//fidelitiz part
//Common
@property (nonatomic) BOOL hasLoyaltyCard;
@property (nonatomic) double permanentPercentageDiscount;
@property (nonatomic) double correctedInvoiceAmountWithPercentage;
@property (copy, nonatomic) NSArray *couponList;
@property (retain, nonatomic) LoyaltyProgram *currentLoyaltyProgram;

//European only
@property (nonatomic) double balance;


//Indonesian only
//@property (copy, nonatomic) NSString *receiver;
@property (copy, nonatomic) NSString *status;
//fidelitiz part
//Indonesian only
@property (copy, nonatomic) NSNumber *fidelitizId;

/**
 @brief Generate an Invoice object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a invoice object with
 @return An Invoice object containing user flashiz account information or nil if the dictionary does not contain all the needed keys
 */
+ (void)invoiceWithDictionary:(NSDictionary *)invoice successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end