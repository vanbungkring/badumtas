//
//  FidelitizEngine.h
//  iMobey
//
//  Created by Matthieu Barile on 21/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

//Domain
#import <FZAPI/Invoice.h>
#import <FZAPI/InvoiceCorrectedParameters.h>

@interface RewardsEngine : NSObject

+ (InvoiceCorrectedParameters*)computeDiscountForInvoice:(Invoice *)invoice AndNbOfUsedCoupons:(NSInteger)nbOfUsedCoupons LivePPD:(double)livePermanentPercentageDiscount;

+ (NSInteger)computeNbOfPointsEarnWithCorrectedInvoiceAmount:(double) amount andProgram:(LoyaltyProgram *) loyaltyProgram;

+ (NSInteger)optimalNbOfCoupons:(Invoice*)invoice;

@end
