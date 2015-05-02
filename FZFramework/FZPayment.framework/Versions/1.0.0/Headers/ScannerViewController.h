//
//  ScannerViewController.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 26/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/ScannerViewControllerBB.h>

typedef enum {
    ScannerViewVideoQualityLow,
    ScannerViewVideoQualityMedium,
    ScannerViewVideoQualityHigh
} ScannerViewVideoQuality;

@protocol ScannerViewControllerDelegate <NSObject>

- (void)didScanQRCode:(NSString *)qrCodeValue;

@end

@interface ScannerViewController : ScannerViewControllerBB

@property (nonatomic, assign) id<ScannerViewControllerDelegate> delegate;
@property (nonatomic, assign) ScannerViewVideoQuality videoQuality;

- (void)forceStartRunning;
- (void)forceStopRunning;

@end
