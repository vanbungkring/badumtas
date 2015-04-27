//
//  FZTippingAmount.m
//  FZPayment
//
//  Created by OlivierDemolliens on 8/12/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "FZTippingEngine.h"

@implementation FZTippingEngine


+ (double)addAmount:(double)amount toInvoiceAmount:(double)invoiceAmount {
    return invoiceAmount + amount;
}

+ (double)retrieveTipAmountWithCurrentInvoiceAmount:(double)invoiceAmountWithTipInside andInitialInvoiceAmount:(double)initialInvoiceAmount {
    double tipAmount = invoiceAmountWithTipInside - initialInvoiceAmount;
    
    if (tipAmount < 0) {
        tipAmount = 0;
    }
    
    return tipAmount;
}

+ (double)computePercentageOfInvoice:(double)invoiceAmount regardingTipAmount:(double)tipAmount {
    
    if (invoiceAmount == 0) {
        return 0;
    }
    
    return (tipAmount*100)/invoiceAmount;
}

@end
