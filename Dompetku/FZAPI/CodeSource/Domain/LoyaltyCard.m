//
//  LoyaltyCard.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "LoyaltyCard.h"
#import "FlashizDictionary.h"
#import "Error.h"

@implementation LoyaltyCard

+ (void)loyaltyProgramWithDictionary:(NSDictionary *)program successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
   
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"balance", @"coupons", @"discountAmount", @"expenseType", @"fidelitizId", @"loyaltyCardId", @"loyaltyProgramId", @"loyaltyProgramLabel", @"loyaltyProgramType", @"monthNumberValidity", @"ownerBrand", @"ownerCompanyName", @"ownerEmail", @"permanentPercentageDiscount", @"pointAmountForCoupon", @"pointPerExpense", @"reference", @"rewardType", nil];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *missingKeysArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    FlashizDictionary *programDictionary = [FlashizDictionary dictionaryWithDictionary:program];
    
    //test if dictionary contains all our needed keys
    if ([programDictionary containsKeys:keysArray missingKeys:missingKeysArray]) {
        
        //create and return the account object if it is the case
        LoyaltyCard *cardObject = [[LoyaltyCard alloc] init];
        
        [cardObject fillWithMatchingKeys:missingKeysArray keys:keysArray fromJSON:program successBlock:^{
            if([program objectForKey:@"leavable"]){
                [cardObject setLeavable:[[program objectForKey:@"leavable"] boolValue]];
            } else {
                //TODO: force to be not leavable. Waiting for the server to be ready
                [cardObject setLeavable:YES];
            }
            
            success([cardObject autorelease]);
        } failureBlock:^(Error *error) {
            failure(error);
        }];
   } else {
       
       //else, if error parameter is not nil we fill it with all the keys that was missing
       Error *error = [[[Error alloc] initWithRequest:nil response:program.description timestamp:[NSDate date] messageCode:[NSString stringWithFormat:@"%d",FZ_INVALID_JSON_MISSING_KEYS] detail:[NSString stringWithFormat:@"%@ : %@",FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, missingKeysArray.description] code:FZ_JSON_MISSING_KEYS_ERROR_CODE andRequestErrorCode:-1] autorelease];
       
       failure(error);
   }

}

- (void)dealloc
{
    [_coupons release], _coupons = nil;
    
    [_expenseType release], _expenseType = nil;
    [_fidelitizId release], _fidelitizId = nil;
    [_loyaltyCardId release], _loyaltyCardId = nil;
    [_loyaltyProgramId release], _loyaltyProgramId = nil;
    [_loyaltyProgramLabel release], _loyaltyProgramLabel = nil;
    [_loyaltyProgramType release], _loyaltyProgramType = nil;
    [_ownerBrand release], _ownerBrand = nil;
    [_ownerCompanyName release], _ownerCompanyName = nil;
    [_ownerEmail release], _ownerEmail = nil;
    [_reference release], _reference = nil;
    [_rewardType release], _rewardType = nil;
    
    [super dealloc];
}

@end
