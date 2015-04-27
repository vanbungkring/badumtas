//
//  LoyaltycheckObject.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "LoyaltyCoupon.h"
#import "Error.h"
#import "FlashizDictionary.h"

@implementation NSString (EnumParser)
- (CouponType)couponTypeEnumFromString{
    NSDictionary *couponTypes = [NSDictionary dictionaryWithObjectsAndKeys:
    						[NSNumber numberWithInteger:COUPON_TYPE_CASH], @"CASH",
    						[NSNumber numberWithInteger:COUPON_TYPE_PERCENT], @"PERCENT",
    						nil
    						];
    return (CouponType)[[couponTypes objectForKey:self] intValue];
}
@end


@implementation LoyaltyCoupon

+ (void)loyaltyCouponWithDictionary:(NSDictionary *)coupon successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [[[NSArray alloc] initWithObjects:@"amount", @"couponId", @"couponType", @"fidelitizId", @"loyaltyCardId", @"loyaltyProgramId", @"validityEndDate", nil] autorelease];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *missingKeysArray = nil;
    
    FlashizDictionary *couponDictionary = [FlashizDictionary dictionaryWithDictionary:coupon];
    
    //test if dictionary contains all our needed keys
    if([couponDictionary containsKeys:keysArray missingKeys:missingKeysArray]){
        
        //create and return the account object if it is the case
        LoyaltyCoupon *couponObject = [[[LoyaltyCoupon alloc] init] autorelease];
        couponObject.amount = [[coupon objectForKey:[keysArray objectAtIndex:0]] doubleValue];
        //couponObject.currency = [coupon objectForKey:[keysArray objectAtIndex:1]];
        couponObject.couponId = [coupon objectForKey:[keysArray objectAtIndex:1]];
        couponObject.couponType = [[coupon objectForKey:[keysArray objectAtIndex:2]] couponTypeEnumFromString];
        couponObject.fidelitizId = [coupon objectForKey:[keysArray objectAtIndex:3]];
        couponObject.loyaltyCardId = [coupon objectForKey:[keysArray objectAtIndex:4]];
        couponObject.loyaltyProgramId = [coupon objectForKey:[keysArray objectAtIndex:5]];
        
        
        couponObject.validityEndDate = [coupon objectForKey:[keysArray objectAtIndex:6]];
        
        NSString *cur = [coupon objectForKey:@"currency"];
        if (cur != nil){
            couponObject.currency = cur;
        }
        //NSLog(@"couponObject %@",couponObject);
        success(couponObject);
        
    } else {
        
        //else, if error parameter is not nil we fill it with all the keys that was missing
        Error *error = [[[Error alloc] initWithRequest:nil response:coupon.description timestamp:[NSDate date] messageCode:FZ_INVALID_JSON_ERROR_MESSAGE detail:[NSString stringWithFormat:@"%@ : %@", FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, missingKeysArray.description] code:-1 andRequestErrorCode:-1] autorelease];
        
        failure(error);
    }
}

#pragma mark - methods

+ (BOOL)isCouponTypeCash:(LoyaltyCoupon *)aLoyaltyCoupon {
    return [aLoyaltyCoupon couponType] == COUPON_TYPE_CASH;
}

#pragma mark - copy

-(id)copyWithZone:(NSZone *)zone{
    LoyaltyCoupon *copy = [[LoyaltyCoupon allocWithZone:zone] init];
    [copy setAmount:self.amount]; //amount of the coupon
    [copy setCurrency:self.currency]; //currency
    [copy setCouponId:self.couponId]; //unique ID
    [copy setCouponType:self.couponType]; //the type
    [copy setFidelitizId:self.fidelitizId]; //the fidelitiz id of the coupon owner
    [copy setLoyaltyCardId:self.loyaltyCardId]; //the id of the loyalty card associated to this coupon
    [copy setLoyaltyProgramId:self.loyaltyProgramId]; //the id of the program that generated this coupon
    [copy setValidityEndDate:self.validityEndDate];
    return copy;
}

#pragma mark - MM

- (void)dealloc
{
    [_currency release], _currency = nil;
    [_couponId release], _couponId = nil;
    [_fidelitizId release], _fidelitizId = nil;
    [_loyaltyCardId release], _loyaltyCardId = nil;
    [_loyaltyProgramId release], _loyaltyProgramId = nil;
    [_validityEndDate release], _validityEndDate = nil;
    
    [super dealloc];
}

@end
