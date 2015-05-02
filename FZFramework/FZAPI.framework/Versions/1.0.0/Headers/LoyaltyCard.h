//
//  LoyaltyCard.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

@interface LoyaltyCard : FlashizObject

@property (nonatomic) double balance;
@property (copy, nonatomic) NSArray *coupons;
@property (nonatomic) double discountAmount;
@property (copy, nonatomic) NSString * expenseType;
@property (copy, nonatomic) NSString * fidelitizId;
@property (copy, nonatomic) NSString * loyaltyCardId;
@property (copy, nonatomic) NSString * loyaltyProgramId;
@property (copy, nonatomic) NSString * loyaltyProgramLabel;
@property (copy, nonatomic) NSString * loyaltyProgramType;
@property (nonatomic) int monthNumberValidity;
@property (copy, nonatomic) NSString * ownerBrand;
@property (copy, nonatomic) NSString * ownerCompanyName;
@property (copy, nonatomic) NSString * ownerEmail;
@property (nonatomic) double permanentPercentageDiscount;
@property (nonatomic) int pointAmountForCoupon;
@property (nonatomic) int pointPerExpense;
@property (copy, nonatomic) NSString * reference;
@property (copy, nonatomic) NSString * rewardType;

@property (nonatomic,assign ) BOOL leavable;

+ (void)loyaltyProgramWithDictionary:(NSDictionary *)program successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
