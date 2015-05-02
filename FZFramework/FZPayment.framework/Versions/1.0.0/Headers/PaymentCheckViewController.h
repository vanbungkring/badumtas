//
//  PaymentCheckViewController.h
//  iMobey
//
//  Created by Fabrice Dewasmes on 19/8/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import <FZAPI/Invoice.h>
#import <FZAPI/PaymentSummary.h>
#import <FZBlackBox/PaymentCheckViewControllerBB.h>
#import "ActionSuccessfulAfterPaymentViewController.h"
#import "FZTipViewController.h"

@class AccountBannerViewController;
@class ActionSuccessfullDelegate;

@interface PaymentCheckViewController : PaymentCheckViewControllerBB <UIAlertViewDelegate, ActionSuccessfullDelegate, FZTipViewControllerDelegate>
{

}

@property (nonatomic, retain) NSString *invoiceId;
@property (retain, nonatomic) AccountBannerViewController *accountBanner;
@property (retain, nonatomic) IBOutlet UIView *viewDetails;
@property (retain, nonatomic) IBOutlet UILabel *refillLabel;
@property (retain, nonatomic) IBOutlet UIButton *payButton;
@property (retain, nonatomic) IBOutlet UIButton *payButtonBankSDK;

//useful for the SDK to know if we had previously an invoiceId or not
@property (assign, nonatomic) BOOL comeFromScanner;

@property (nonatomic, assign) id<PaymentCheckViewControllerDelegate> delegate;

- (void)getInvoiceDetailsPreProcessing:(BOOL)animated;
- (void)manageAutoTopUpDisplay;
- (void)startTopUpProcess;
- (void)getInvoiceDetails;
- (void)showPaymentSummary:(PaymentSummary *) paymentSummary;
- (CGPoint)customCenterOrCenter:(CGPoint)center;
- (UIColor *)payButtonGradientTwoWithAlpha;

- (void)stopPolling;

@end