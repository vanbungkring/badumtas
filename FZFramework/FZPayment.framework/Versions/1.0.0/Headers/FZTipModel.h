//
//  FZTipModel.h
//  FZPayment
//
//  Created by OlivierDemolliens on 8/12/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FZAPI/Invoice.h>

@interface FZTipModel : NSObject

@property (assign, nonatomic) double invoiceAmountWithTipInside;
@property (assign, nonatomic) double initialInvoiceAmount;
@property (assign, nonatomic) int firstRange;
@property (assign, nonatomic) int secondRange;
@property (retain, nonatomic) NSString *currency;

- (id)initWithInvoice:(Invoice *)invoice andTipAmount:(double)tipAmount;

@end