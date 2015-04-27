//
//  FZTipModel.m
//  FZPayment
//
//  Created by OlivierDemolliens on 8/12/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "FZTipModel.h"

@implementation FZTipModel

- (id)initWithInvoice:(Invoice *)invoice andTipAmount:(double)tipAmount{
    self = [self init];
    if (self) {
        if (invoice) {
            [self setInvoiceAmountWithTipInside:[invoice amount] + tipAmount];
            [self setInitialInvoiceAmount:[invoice amount]];
            [self setFirstRange:[[invoice tip] firstProposition]];
            [self setSecondRange:[[invoice tip] secondProposition]];
            [self setCurrency:[invoice currency]];
        }
    }
    return self;
}

@end
