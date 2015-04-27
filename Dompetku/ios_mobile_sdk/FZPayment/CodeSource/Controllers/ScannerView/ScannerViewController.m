//
//  ScannerViewController.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 26/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "ScannerViewController.h"

//NPQRCodeScannerViewController
#import <FZBlackBox/NPQRCodeScannerView.h>

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Sound
#import <AudioToolbox/AudioToolbox.h>

//Util
#import <FZBlackBox/ODDeviceUtil.h>

@interface ScannerViewController ()


@property (nonatomic, retain) NPQRCodeScannerView *qrCodeScannerView;

@end

@implementation ScannerViewController {
    SystemSoundID soundID;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeSubviews];
        [self initializeProperties];
    }
    return self;
}

#pragma mark - initialize methods

- (void)initializeProperties {
    CFURLRef ref = CFBundleCopyResourceURL(CFBundleGetBundleWithIdentifier((CFStringRef)[BundleHelper retrieveBundleName:FZBundleFlashiz]), (CFStringRef)@"beep-beep.aiff", NULL, NULL);
    AudioServicesCreateSystemSoundID(ref, &soundID);
}

- (void)initializeSubviews {
    
    UIView *currentView = [self view];
    
    _qrCodeScannerView = [[NPQRCodeScannerView alloc] initWithFrame:[currentView bounds]];
    [_qrCodeScannerView setDelegate:(id<NPQRCodeScannerViewDelegate>)self];
    [_qrCodeScannerView setAutoresizingMask:[currentView autoresizingMask]];
    [_qrCodeScannerView setRectOfInterest:CGRectMake(0.1, 0.1, 0.8, 0.8)];
    

    [currentView addSubview:_qrCodeScannerView];

}

#pragma mark - Private methods

- (BOOL)isRunningOniOS7 {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}

- (void)vibrateAndPlaySound {
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)forceVideoQuality {
    ODDeviceModel currentDeviceModel = [ODDeviceUtil currentDeviceModel];
    
    if(currentDeviceModel == ODDeviceModeliPhone3GS) {
        [self setVideoQuality:ScannerViewVideoQualityLow];
    }
    else if(currentDeviceModel == ODDeviceModeliPhone4) {
        [self setVideoQuality:ScannerViewVideoQualityMedium];
    }
    else {
        [self setVideoQuality:ScannerViewVideoQualityHigh];
    }
}

#pragma mark - Lifecycle methods

- (void)loadView {
    //TODO: hardcoded frame
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 640.0)];
    [aView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    
    [self setView:aView];
    [aView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)forceStartRunning {
    [_qrCodeScannerView startRunning];
}

- (void)forceStopRunning {
    [_qrCodeScannerView stopRunning];
}

- (void)setVideoQuality:(ScannerViewVideoQuality)videoQuality {
    _videoQuality = videoQuality;
    
    switch (_videoQuality) {
        case ScannerViewVideoQualityLow:
            [_qrCodeScannerView setVideoQuality:NPQRCodeScannerVideoQualityLow];
            break;
        case ScannerViewVideoQualityMedium:
            [_qrCodeScannerView setVideoQuality:NPQRCodeScannerVideoQualityMedium];
            break;
        case ScannerViewVideoQualityHigh:
            [_qrCodeScannerView setVideoQuality:NPQRCodeScannerVideoQualityHigh];
            break;
        default:
            [_qrCodeScannerView setVideoQuality:NPQRCodeScannerVideoQualityHigh];
            break;
    }
}

#pragma mark - NPQRCodeScannerView delegate method

- (void)didDetectQRCode:(NSString *)stringValue {
    [self vibrateAndPlaySound];
    
    if([_delegate respondsToSelector:@selector(didScanQRCode:)]) {
        [_delegate didScanQRCode:stringValue];
    }
    [self forceStopRunning];
}

#pragma mark - MM


- (void)dealloc
{    
    if(0!=soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
    }
    
    if(_qrCodeScannerView){
        // asynchronous cam kill - controller can ben desallocated before the camera
        //[_qrCodeScannerView release];
        //_qrCodeScannerView = nil;
    }
    
    [super dealloc];
}


@end
