//
//  CorrectedInvoice.m
//  iMobey
//
//  Created by Neopixl on 22/08/13.
//  correctedright (c) 2013 Neopixl. All rights reserved.
//

#import "CorrectedInvoice.h"

@implementation CorrectedInvoice

+(id)correctedInvoiceWithInvoice:(Invoice *)invoice{
    CorrectedInvoice *corrected = [[CorrectedInvoice alloc] init];
    
    // TODO : where is setDiscount?
    [corrected setInvoiceId:[invoice invoiceId]];
    [corrected setAmount:[invoice amount]];
    [corrected setCurrency:[invoice currency]];
    [corrected setOtherName:[invoice otherName]];
    [corrected setOtherMail:[invoice otherMail]];
    [corrected setIsCredit:[invoice isCredit]];
    [corrected setWithRefill:[invoice withRefill]];
    [corrected setNewBalanceWithoutRefill:[invoice newBalanceWithoutRefill]];
    [corrected setNewBalanceWithRefill:[invoice newBalanceWithRefill]];
    [corrected setNumberOfRefill:[invoice numberOfRefill]];
    [corrected setTakenAmount:[invoice takenAmount]];
    [corrected setComment:[invoice comment]];
    [corrected setType:[invoice type]];
    [corrected setAmountOfRefill:[invoice numberOfRefill]*[invoice takenAmount]];

    // Rewards
    [corrected setBalance:[invoice balance]];
    [corrected setHasLoyaltyCard:[invoice hasLoyaltyCard]];
    [corrected setPermanentPercentageDiscount:[invoice permanentPercentageDiscount]];
    [corrected setCorrectedInvoiceAmountWithPercentage:[invoice correctedInvoiceAmountWithPercentage]];
    
    NSArray *newArray = [[NSArray alloc] initWithArray:[invoice couponList] copyItems:YES];
    [corrected setCouponList:newArray];
    [newArray release];
    
    [corrected setCurrentLoyaltyProgram:[[[invoice currentLoyaltyProgram] copy] autorelease]];
    return [corrected autorelease];
}

-(id)mutablecorrectedWithZone:(NSZone *)zone{
    CorrectedInvoice *corrected = [[super mutableCopyWithZone:zone] autorelease];
    return corrected;
}

@end
