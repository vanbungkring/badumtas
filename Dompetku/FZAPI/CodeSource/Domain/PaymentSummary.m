//
//  PaymentSummary.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "PaymentSummary.h"
#import "Error.h"

#import "FlashizDictionary.h"

@implementation PaymentSummary

+ (void)paymentSummaryWithDictionary:(NSDictionary *)paymentSummary successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the invoice object
    NSArray *keysArray = [NSArray arrayWithObjects:@"newBalance", @"currency", @"couponAmount", @"couponType",@"nbCouponsGenerated", @"couponAmount",@"nbGeneratedPoints", @"nbPointsToGetACoupon", @"nbPointsOnLoyaltyCard", nil];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *missingKeysArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"",@"", @"",@"", @"", @"", nil];
    
    FlashizDictionary *paymentSummaryDictionary = [FlashizDictionary dictionaryWithDictionary:paymentSummary];
    
    //test if dictionary contains all our needed keys
    if ([paymentSummaryDictionary containsKeys:keysArray missingKeys:missingKeysArray]) {
        
        //create and return the invoice object if it is the case
        PaymentSummary *paymentObject = [[PaymentSummary alloc] init];
              
        [paymentObject fillWithMatchingKeys:missingKeysArray
                                       keys:keysArray
                                   fromJSON:paymentSummary
                               successBlock:^{
                                   success([paymentObject autorelease]);
                               } failureBlock:^(Error *error) {
                                   failure(error);
                               }];
    } else {
        
        //else, if error parameter is not nil we fill it with all the keys that was missing
        Error *error = [[[Error alloc] initWithRequest:nil response:paymentSummary.description timestamp:[NSDate date] messageCode:FZ_INVALID_JSON_ERROR_MESSAGE detail:[NSString stringWithFormat:@"%@ : %@", FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, missingKeysArray.description] code:-1 andRequestErrorCode:-1] autorelease];
        
        failure(error);
    }
}

- (void)dealloc
{    
    [self setCurrency:nil];
    [self setCouponType:nil];
    
    [super dealloc];
}

@end
