//
//  InvoiceCorrectedParameters.m
//  iMobey
//
//  Created by Matthieu Barile on 22/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "InvoiceCorrectedParameters.h"

//Invoice
#import "Invoice.h"

@implementation InvoiceCorrectedParameters

+ (InvoiceCorrectedParameters *)initWithInvoice:(Invoice *)invoice {
    InvoiceCorrectedParameters *invoiceCorrectedParams = [[InvoiceCorrectedParameters alloc] init];
    
    [invoiceCorrectedParams setNewWithRefill:[invoice withRefill]];
    [invoiceCorrectedParams setCorrectedInvoiceAmount:[invoice amount]];
    [invoiceCorrectedParams setNewBalanceWithRefill:[invoice balance]];
    [invoiceCorrectedParams setNbOfRefill:[invoice numberOfRefill]];
    [invoiceCorrectedParams setAmountOfRefill:[invoice numberOfRefill]*[invoice takenAmount]];
    // TODO : why 0 ? No discount possible?
    [invoiceCorrectedParams setDiscount:0];
    [invoiceCorrectedParams setHasLoyaltyCard:[invoice hasLoyaltyCard]];
    
    return [invoiceCorrectedParams autorelease];
}

- (void)dealloc
{    
    [super dealloc];
}

@end
