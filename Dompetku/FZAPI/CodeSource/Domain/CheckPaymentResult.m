//
//  paymentObjectPaymentResult.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "CheckPaymentResult.h"
#import "Error.h"

@implementation CheckPaymentResult

+ (void)checkPaymentResultWithDictionary:(NSDictionary *)check successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure
{
    //This function is different from others similar ones because the checkPayment webservices does not work in the same way as other. If the invoice you check is not paid you got a result="NOK" in your json. But a "NOK" result will make the Services function to return a nil value (as any error which could happen). So the "check" parameter here can be nil and in all cases (NOK or another error) we will consider that payment just did not procedeed.
    if(check == nil){
        
        CheckPaymentResult *checkObject = [[CheckPaymentResult alloc] init];
        checkObject.isPaid = NO;
        success([checkObject autorelease]);
    }
    else{
        
        //create the array of which keys we need to have to create the account object
        NSArray *keysArray = [NSArray arrayWithObjects:@"balance", @"username", @"user", @"currency", nil];
        
        NSMutableArray *keysMatchingArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
        
        //define a missing keys array to know which one was missing if its the case
        
        CheckPaymentResult *checkObject = [[[CheckPaymentResult alloc] init] autorelease];
        
        [checkObject fillWithMatchingKeys:keysMatchingArray
                                     keys:keysArray
                                 fromJSON:check
                             successBlock:^{
                                 NSString *status = [check objectForKey:@"status"];
                                 
                                 [checkObject setIsPaid:[status isEqualToString:@"EXE"]];
                                 
                                 success(checkObject);
                             } failureBlock:^(Error *error) {
                                 failure(error);
                             }];
    }    
}

- (void)dealloc
{
    [self setCurrency:nil];
    [self setUsername:nil];
    [self setUser:nil];
    
    [super dealloc];
}

@end
