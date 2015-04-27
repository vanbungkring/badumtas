//
//  LoyaltyCoupon.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

typedef enum couponType{
    COUPON_TYPE_CASH = 0,
    COUPON_TYPE_PERCENT = 1
}CouponType;

@interface NSString (EnumParser)
- (CouponType)couponTypeEnumFromString;
@end

/**
 @brief Class that represent a loyalty coupon that you can earn when paying with flashiz using fidelitiz
 */
@interface LoyaltyCoupon : FlashizObject <NSCopying>

@property (nonatomic) double amount; //amount of the coupon
@property (copy, nonatomic) NSString *currency; //currency
@property (copy, nonatomic) NSString *couponId; //unique ID
@property (nonatomic) CouponType couponType; //the type
@property (copy, nonatomic) NSString *fidelitizId; //the fidelitiz id of the coupon owner
@property (copy, nonatomic) NSString *loyaltyCardId; //the id of the loyalty card associated to this coupon
@property (copy, nonatomic) NSString *loyaltyProgramId; //the id of the program that generated this coupon
@property (copy, nonatomic) NSDate *validityEndDate; //the date at which the coupon is no longer valid

/**
 @brief Generate a LoyaltyCoupon object with the given NSDictionary. This parameter should be a JSON FLASHiZ server response decoded into a NSDictionary object. If the NSDictionary does not contain needed keys the function will return nil and the given Error object will be filled with the error.
 @param user The decoded JSON FLASHiZ server response
 @param error An error object that will be filled if the given dictionary does not contain all the needed keys to create a LoyaltyCoupon object with
 @return A LoyaltyCoupon object
 */
+ (void)loyaltyCouponWithDictionary:(NSDictionary *)coupon successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;;

/*
 Return YES if the coupon's type is cash else return NO
 */
+ (BOOL)isCouponTypeCash:(LoyaltyCoupon *)aLoyaltyCoupon;

@end
