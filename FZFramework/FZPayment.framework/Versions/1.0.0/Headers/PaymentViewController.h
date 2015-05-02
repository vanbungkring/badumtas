//
//  PaymentViewController.h
//  iMobey
//
//  Created by Fabrice Dewasmes on 19/8/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FZBlackBox/PaymentViewControllerBB.h>

@class ScanPayViewController;

#import "PaymentCheckViewController.h"

//ScannerViewController
#import "ScannerViewController.h"

//Custom button
#import <FZBlackBox/FZButton.h>

@interface PaymentViewController : PaymentViewControllerBB <PaymentCheckViewControllerDelegate, ScannerViewControllerDelegate>
{
    
}

@property (assign, nonatomic) id<PaymentViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIView *viewAccountBanner;
@property (retain, nonatomic) IBOutlet UIImageView *imageMask;
@property (retain, nonatomic) IBOutlet UIImageView *imageScanCheck;
@property (retain, nonatomic) IBOutlet UIView *viewBackgroundAddCreditCard;
@property (retain, nonatomic) IBOutlet UIView *viewBackgroundSetUserInfos;
@property (retain, nonatomic) IBOutlet FZButton *btnSetUserInfos;
@property (retain, nonatomic) IBOutlet FZButton *btnAddCreditCard;

@property (retain, nonatomic) PaymentCheckViewController *paymentCheckViewController;


- (void)forceStopRunning;

@end
