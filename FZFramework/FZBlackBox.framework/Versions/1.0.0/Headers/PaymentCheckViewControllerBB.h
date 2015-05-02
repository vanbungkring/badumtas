//
//  PaymentCheckViewControllerBB.h
//  FZBlackBox
//
//  Created by Matthieu Barile on 19/09/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderViewController.h"

@class PaymentCheckViewController;

@protocol PaymentCheckViewControllerDelegate <NSObject>

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didValidatePaymentForInvoiceId:(NSString *)invoiceId;
- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didCancelPaymentForInvoiceId:(NSString *)invoiceId;
- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didFailPaymentForInvoiceId:(NSString *)invoiceId;
@optional
- (void)paymentCheckViewControllerSdkClose;

@end

@interface PaymentCheckViewControllerBB : HeaderViewController

@end
