//
//  PaymentSummary.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

/**
 @brief Class that represent the summary of a payment. Obtained when paying an invoice.
 */
@interface PaymentSummary : FlashizObject

@property (nonatomic) double newBalance; //the new balance of the user who paid
@property (nonatomic) int nbCouponsGenerated; //the number of coupons that the transaction generated
@property (copy, nonatomic) NSString *currency; //the currency of the transaction
@property (copy, nonatomic) NSString *couponType; //the type of coupons
@property (nonatomic) double couponAmount; //the amount associated to coupons generated
@property (nonatomic) int nbGeneratedPoints; //the number of points generate by the transaction
@property (nonatomic) int nbPointsToGetACoupon; //the number of points to get a coupon
@property (nonatomic) int nbPointsOnLoyaltyCard; //the number of points on the loyalty card before the payment

/**
 @brief Generate an Account object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a an account object with
 @return An Account object containing user flashiz account information or nil if the dictionary does not contain all the needed keys
 */
+ (void)paymentSummaryWithDictionary:(NSDictionary *)paymentSummary successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end