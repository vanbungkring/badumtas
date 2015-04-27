//
//  LoyaltyAffiliateProgram.m
//  iMobey
//
//  Created by Yvan Moté on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "LoyaltyAffiliateProgram.h"
#import "FlashizDictionary.h"
#import "Error.h"

@implementation LoyaltyAffiliateProgram

+ (void)loyaltyAffiliateProgramvWithDictionary:(NSDictionary *)program successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    NSArray *keysArray = [NSArray arrayWithObjects:@"affiliationId", @"date", @"guestBrand", @"guestCity", @"guestCompanyName", @"guestEmail", @"guestStreet", @"guestZipCode", @"loyaltyProgramGuestId", @"loyaltyProgramId", @"loyaltyProgramOwnerId", @"ownerBrand", @"ownerCompanyName", @"ownerEmail", @"programLabel", @"responseDate", @"status", nil];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *missingKeysArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    FlashizDictionary *programDictionary = [FlashizDictionary dictionaryWithDictionary:program];
    
    //test if dictionary contains all our needed keys
    if([programDictionary containsKeys:keysArray missingKeys:missingKeysArray]){
        
        //create and return the account object if it is the case
        LoyaltyAffiliateProgram *programObject = [[LoyaltyAffiliateProgram alloc] init];
        
        
        [programObject fillWithMatchingKeys:missingKeysArray
                                       keys:keysArray
                                   fromJSON:program
                               successBlock:^{
                                   success([programObject autorelease]);
                               } failureBlock:^(Error *error) {
                                   failure(error);
                               }];
    } else{
        
        //else, if error parameter is not nil we fill it with all the keys that was missing
        Error *error = [[[Error alloc] initWithRequest:nil response:program.description timestamp:[NSDate date] messageCode:FZ_INVALID_JSON_ERROR_MESSAGE detail:[NSString stringWithFormat:@"%@ : %@", FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, missingKeysArray.description] code:-1 andRequestErrorCode:-1] autorelease];
        
        failure(error);
    }
}

- (void)dealloc
{
    [self setAffiliationId:nil];
    [self setDate:nil];
    [self setGuestBrand:nil];
    [self setGuestCity:nil];
    [self setGuestCompanyName:nil];
    [self setGuestEmail:nil];
    [self setGuestStreet:nil];
    [self setGuestZipCode:nil];
    [self setLoyaltyProgramGuestId:nil];
    [self setLoyaltyProgramId:nil];
    [self setLoyaltyProgramOwnerId:nil];
    [self setOwnerBrand:nil];
    [self setOwnerCompanyName:nil];
    [self setOwnerEmail:nil];
    [self setProgramLabel:nil];
    [self setResponseDate:nil];
    [self setStatus:nil];
    
    [super dealloc];
}


@end
