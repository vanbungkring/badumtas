//
//  Transaction.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "PendingTransaction.h"
#import "FlashizDictionary.h"
#import "Error.h"

@implementation PendingTransaction

+ (void)transactionWithDictionary:(NSDictionary *)transaction successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the Transaction object
    NSArray *keysArray = [NSArray arrayWithObjects:@"id", @"balance", @"description", @"openingDate", @"tag", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"pendingTransactionId", @"", @"", @"", @"", nil];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *missingKeysArray = nil;
    
    FlashizDictionary *transactionDictionary = [FlashizDictionary dictionaryWithDictionary:transaction];
    
    //test if dictionary contains all our needed keys
    if([transactionDictionary containsKeys:keysArray missingKeys:missingKeysArray]){
        
        //create and return the Transaction object if it is the case
        PendingTransaction *transactionObject = [[PendingTransaction alloc] init];
        /*
        [transactionObject fillWithMatchingKeys:keysMatching
                                           keys:keysArray
                                       fromJSON:transaction];
         */
        [transactionObject fillWithMatchingKeys:keysMatching
                                           keys:keysArray
                                       fromJSON:transaction
                                   successBlock:^{
                                       success([transactionObject autorelease]);
                                   } failureBlock:^(Error *error) {
                                       failure(error);
                                   }];
    } else {
        
        //else, if error parameter is not nil we fill it with all the keys that was missing
        Error *error = [[[Error alloc] initWithRequest:nil response:transaction.description timestamp:[NSDate date] messageCode:FZ_INVALID_JSON_ERROR_MESSAGE detail:[NSString stringWithFormat:@"%@ : %@", FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, missingKeysArray.description] code:-1 andRequestErrorCode:-1] autorelease];
                
        failure(error);
    }
}

- (void)dealloc
{
    [self setCurrency:nil];
    [self setExecutionDate:nil];
    [self setCreationDate:nil];
    [self setTiers:nil];
    [self setComment:nil];
    [self setStatus:nil];
    [self setReceiverInfo:nil];
    [self setWaitingUser:nil];
    
    [super dealloc];
}

@end
