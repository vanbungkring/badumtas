//
//  LoyaltyAffiliateProgram.h
//  iMobey
//
//  Created by Yvan Moté on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizObject.h"

@class Error;

@interface LoyaltyAffiliateProgram : FlashizObject

@property (nonatomic, copy) NSString *affiliationId;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *guestBrand;
@property (nonatomic, copy) NSString *guestCity;
@property (nonatomic, copy) NSString *guestCompanyName;
@property (nonatomic, copy) NSString *guestEmail;
@property (nonatomic, copy) NSString *guestStreet;
@property (nonatomic, copy) NSString *guestZipCode;
@property (nonatomic, copy) NSString *loyaltyProgramGuestId;
@property (nonatomic, copy) NSString *loyaltyProgramId;
@property (nonatomic, copy) NSString *loyaltyProgramOwnerId;
@property (nonatomic, copy) NSString *ownerBrand;
@property (nonatomic, copy) NSString *ownerCompanyName;
@property (nonatomic, copy) NSString *ownerEmail;
@property (nonatomic, copy) NSString *programLabel;
@property (nonatomic, copy) NSDate *responseDate;
@property (nonatomic, copy) NSString *status;

+ (void)loyaltyAffiliateProgramvWithDictionary:(NSDictionary *)program successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
