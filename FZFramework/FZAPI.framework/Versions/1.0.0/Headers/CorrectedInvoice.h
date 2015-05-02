//
//  CorrectedInvoice.h
//  iMobey
//
//  Created by Neopixl on 22/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "Invoice.h"

@interface CorrectedInvoice : Invoice <NSMutableCopying>
@property (nonatomic) double amountOfRefill;
@property (nonatomic) double discount;

+(id)correctedInvoiceWithInvoice:(Invoice *)invoice;

@end
