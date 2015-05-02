//
//  BarReaderView.h
//  TestLibrary_iOS
//
//  Created by Yvan Moté on 06/11/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

typedef enum {
    NPQRCodeScannerVideoQualityLow,
    NPQRCodeScannerVideoQualityMedium,
    NPQRCodeScannerVideoQualityHigh
} NPQRCodeScannerVideoQuality;

@protocol NPQRCodeScannerViewDelegate <NSObject>

- (void)didDetectQRCode:(NSString *)stringValue;

@end

@interface NPQRCodeScannerView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) IBOutlet id<NPQRCodeScannerViewDelegate> delegate;
@property (nonatomic, assign) NPQRCodeScannerVideoQuality videoQuality;
@property (nonatomic, assign) BOOL shouldStopWhenQRCodeIsDetected;
@property (nonatomic, assign) BOOL displayFlash;

- (void)startRunning;
- (void)stopRunning;

- (void)setRectOfInterest:(CGRect)rectOfInterest;

@end
