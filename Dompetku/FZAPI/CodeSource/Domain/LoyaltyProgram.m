//
//  LoyaltyProgram.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "LoyaltyProgram.h"
#import "Error.h"

@implementation LoyaltyProgram

+ (LoyaltyProgram *)emptyLoyaltyProgram {
    return [[[LoyaltyProgram alloc] init] autorelease];
}

+ (void)loyaltyProgramWithDictionary:(NSDictionary *)program successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"affiliationId", @"backgroundColor", @"borderColor", @"discountAmount", @"currency", @"endDate", @"expenseType", @"fidelitizId", @"hasLoyaltyCard", @"individualId", @"isPrivate", @"label", @"logo", @"loyaltyProgramId", @"loyaltyProgramOwnerBrand", @"loyaltyProgramOwnerCompanyName", @"loyaltyProgramOwnerEmail", @"loyaltyProgramOwnerId", @"loyaltyProgramType", @"monthNumberValidity", @"permanentPercentageDiscount", @"pointAmountForCoupon", @"pointPerExpense", @"rewardType", @"startDate",@"minTransAmountForDiscount",@"maxDiscountAmount",nil];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *missingKeysArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
        
    //create and return the account object if it is the case
    LoyaltyProgram *programObject = [[LoyaltyProgram alloc] init];
    
    [programObject fillWithMatchingKeys:missingKeysArray
                                   keys:keysArray
                               fromJSON:program
                           successBlock:^{
                               success([programObject autorelease]);
                           } failureBlock:^(Error *error) {
                               failure(error);
                           }];
}

-(id)copyWithZone:(NSZone *)zone{
    LoyaltyProgram *copy = [[LoyaltyProgram allocWithZone:zone] init];
    [copy setAffiliationId:self.affiliationId];
    [copy setBackgroundColor:self.backgroundColor];
    [copy setBorderColor:self.borderColor];
    [copy setDiscountAmount:self.discountAmount];
    [copy setCurrency:self.currency];
    [copy setEndDate:self.endDate];
    [copy setExpenseType:self.expenseType];
    [copy setFidelitizId:self.fidelitizId];
    [copy setHasLoyaltyCard:self.hasLoyaltyCard];
    [copy setIndividualId:self.individualId];
    [copy setIsPrivate:self.isPrivate];
    [copy setLabel:self.label];
    [copy setLogo:self.logo];
    [copy setLoyaltyProgramId:self.loyaltyProgramId];
    [copy setLoyaltyProgramOwnerBrand:self.loyaltyProgramOwnerBrand];
    [copy setLoyaltyProgramOwnerCompanyName:self.loyaltyProgramOwnerCompanyName];
    [copy setLoyaltyProgramOwnerEmail:self.loyaltyProgramOwnerEmail];
    [copy setLoyaltyProgramOwnerId:self.loyaltyProgramOwnerId];
    [copy setLoyaltyProgramType:self.loyaltyProgramType];
    [copy setMonthNumberValidity:self.monthNumberValidity];
    [copy setPermanentPercentageDiscount:self.permanentPercentageDiscount];
    [copy setPointAmountForCoupon:self.pointAmountForCoupon];
    [copy setPointPerExpense:self.pointPerExpense];
    [copy setRewardType:self.rewardType];
    [copy setStartDate:self.startDate];
    return copy;
}

- (void)dealloc
{
   [self setAffiliationId:nil];
   [self setBackgroundColor:nil];
   [self setBorderColor:nil];
   [self setCurrency:nil];
   [self setEndDate:nil];
   [self setExpenseType:nil];
   [self setFidelitizId:nil];
   [self setIndividualId:nil];
   [self setLabel:nil];
   [self setLogo:nil];
   [self setLoyaltyProgramId:nil];
   [self setLoyaltyProgramOwnerBrand:nil];
   [self setLoyaltyProgramOwnerEmail:nil];
   [self setLoyaltyProgramOwnerId:nil];
   [self setLoyaltyProgramType:nil];
   [self setRewardType:nil];
   [self setStartDate:nil];

   [super dealloc];
}

@end
