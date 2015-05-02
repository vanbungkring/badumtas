//
//  LoyaltyProgram.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

@interface LoyaltyProgram : FlashizObject <NSCopying>

@property (copy, nonatomic) NSString *affiliationId;
@property (copy, nonatomic) NSString *backgroundColor;
@property (copy, nonatomic) NSString *borderColor;
@property (nonatomic) double discountAmount;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSDate *endDate;
@property (copy, nonatomic) NSString *expenseType;
@property (copy, nonatomic) NSString *fidelitizId;
@property (nonatomic) BOOL hasLoyaltyCard;
@property (copy, nonatomic) NSString *individualId;
@property (nonatomic,assign) BOOL isPrivate;
@property (copy, nonatomic) NSString *label;
@property (copy, nonatomic) NSArray *logo;
@property (copy, nonatomic) NSString *loyaltyProgramId;
@property (copy, nonatomic) NSString *loyaltyProgramOwnerBrand;
@property (copy, nonatomic) NSString *loyaltyProgramOwnerCompanyName;
@property (copy, nonatomic) NSString *loyaltyProgramOwnerEmail;
@property (copy, nonatomic) NSString *loyaltyProgramOwnerId;
@property (copy, nonatomic) NSString *loyaltyProgramType;
@property (nonatomic) int monthNumberValidity;
@property (nonatomic) double permanentPercentageDiscount;
@property (nonatomic) double minTransAmountForDiscount;
@property (nonatomic) double maxDiscountAmount;
@property (nonatomic) int pointAmountForCoupon;
@property (nonatomic) int pointPerExpense;
@property (copy, nonatomic) NSString *rewardType;
@property (copy, nonatomic) NSDate *startDate;

/**
 @brief Generate a LoyaltyProgram object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a LoyaltyProgram object with
 @return A LoyaltyProgram object
 */
+ (void)loyaltyProgramWithDictionary:(NSDictionary *)program  successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

+ (LoyaltyProgram *)emptyLoyaltyProgram;

@end
