//
//  TipViewController.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 8/11/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/HeaderViewController.h>
#import "FZTipModel.h"

@protocol FZTipViewControllerDelegate

- (void)backToPaymentWithTipAmount:(double)tipAmount;
- (void)cancelTip;

@end

@interface FZTipViewController : HeaderViewController

@property (assign, nonatomic) id<FZTipViewControllerDelegate> delegate;

- (id)initWithInvoice:(Invoice *)invoice andTipAmount:(double)tipAmount;

@end
