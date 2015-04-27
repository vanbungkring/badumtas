//
//  PaymentViewControllerBB.h
//  FZBlackBox
//
//  Created by Matthieu Barile on 19/09/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HeaderViewController.h"

@protocol PaymentViewControllerDelegate <NSObject>

- (void)didScanValidInvoice:(NSString *)invoiceId;
- (void)didCancelScanInvoice;

@end

@interface PaymentViewControllerBB : HeaderViewController

@end
