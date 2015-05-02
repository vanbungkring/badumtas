//
//  FZTippingAmount.h
//  FZPayment
//
//  Created by OlivierDemolliens on 8/12/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZTippingEngine : NSObject

+ (double)addAmount:(double)amount toInvoiceAmount:(double)invoiceAmount;

+ (double)retrieveTipAmountWithCurrentInvoiceAmount:(double)invoiceAmountWithTipInside andInitialInvoiceAmount:(double)initialInvoiceAmount;

+ (double)computePercentageOfInvoice:(double)invoiceAmount regardingTipAmount:(double)tipAmount;

@end