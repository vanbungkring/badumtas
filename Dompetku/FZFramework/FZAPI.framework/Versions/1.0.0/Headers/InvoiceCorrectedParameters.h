//
//  InvoiceCorrectedParameters.h
//  iMobey
//
//  Created by Matthieu Barile on 22/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

@class Invoice;

#import <Foundation/Foundation.h>

@interface InvoiceCorrectedParameters : NSObject

@property (nonatomic) BOOL newWithRefill;
@property (nonatomic) double correctedInvoiceAmount;
@property (nonatomic) double newBalanceWithRefill;
@property (nonatomic) NSInteger nbOfRefill;
@property (nonatomic) double amountOfRefill;
@property (nonatomic) double discount;
@property (nonatomic) BOOL hasLoyaltyCard;

// TODO : static instanciation method can't be start with init
+ (InvoiceCorrectedParameters *)initWithInvoice:(Invoice *)invoice __attribute__((deprecated));

@end
