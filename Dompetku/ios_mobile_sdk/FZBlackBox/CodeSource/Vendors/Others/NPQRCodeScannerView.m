//
//  BarReaderView.m
//  TestLibrary_iOS
//
//  Created by Yvan Moté on 06/11/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "NPQRCodeScannerView.h"

#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>
#import "ODDeviceUtil.h"

#define ksAVMetadataObjectTypeQRCode @"org.iso.QRCode"
#warning hardcoded event !!!!

@interface NPQRCodeScannerView ()

@property (nonatomic, retain) AVCaptureDevice *backCamera;
@property (nonatomic, assign, getter = isSessionRunning) BOOL sessionRunning;

@end

@implementation NPQRCodeScannerView {
    AVCaptureSession *_session;
    
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    CALayer *_aLayer;
    
    CALayer *_flashLayer;
    
    AVCaptureMetadataOutput *_metaDataoutput;
    
    NSMutableArray *_lastQRCodeValues;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeProperties];
        [self initializeTouch];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initializeProperties];
        [self initializeTouch];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*if(![_session isRunning]) {
        [self startRunning];
    }*/
}

- (void)dealloc
{
    [_lastQRCodeValues release], _lastQRCodeValues = nil,
    
    [_session stopRunning];
    [_session release], _session = nil;
    
    _sessionRunning = NO;
    
    [_metaDataoutput release], _metaDataoutput = nil;
    
    [_previewLayer removeFromSuperlayer];
    [_previewLayer release];
    
    if (_aLayer) {
        [_aLayer removeFromSuperlayer];
        [_aLayer release];
    }
    
    [super dealloc];
}

#pragma mark - Initialize method

- (void)initializeProperties {
    
    _lastQRCodeValues = [[NSMutableArray alloc] init];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *currentBackCamera = nil;
    
    for (AVCaptureDevice *device in devices) {
        
        if([device position]==AVCaptureDevicePositionBack) {
            currentBackCamera = device;
        }
    }
    
    if(nil==currentBackCamera) {
        NSLog(@"No back camera available on this device");
        return;
    }
    
    [currentBackCamera lockForConfiguration:nil];
    [currentBackCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    
    if([currentBackCamera respondsToSelector:@selector(setSmoothAutoFocusEnabled:)]) {
        if([currentBackCamera isSmoothAutoFocusSupported]) {
            [currentBackCamera setSmoothAutoFocusEnabled:YES];
        }
    }
    
    [currentBackCamera unlockForConfiguration];
    
    
    [self setBackCamera:currentBackCamera];
    
    NSError *error;
    AVCaptureDeviceInput *inputCameraBack =  [AVCaptureDeviceInput deviceInputWithDevice:currentBackCamera error:&error];
    
    if (nil==inputCameraBack) {
        NSLog(@"Can't create an input camera back");
        
        if(nil!=error) {
            NSLog(@"error : %@",error);
        }
        
        return;
    }
    
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    [_session addInput:inputCameraBack];
    [_session commitConfiguration];
    
    
    _metaDataoutput = [[AVCaptureMetadataOutput alloc] init];
    
    //Must be done before the configuration
    [_session addOutput:_metaDataoutput];
    
    dispatch_queue_t queueMetadata = dispatch_queue_create("backgroundQueueMetadata", 0);
    
    [_metaDataoutput setMetadataObjectTypes:[NSArray arrayWithObjects:ksAVMetadataObjectTypeQRCode, nil]];
    [_metaDataoutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    dispatch_release(queueMetadata);
    
    [self updateVideoQuality];
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey]];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    dispatch_queue_t queue = dispatch_queue_create("backgroundQueue", 0);
    [videoDataOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    [videoDataOutput release];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [_previewLayer setFrame:[self bounds]];
    
    [[self layer] addSublayer:_previewLayer];
    
    _aLayer = [[CALayer layer] retain];
    [_aLayer setFrame:[self bounds]];
    _aLayer.affineTransform = CGAffineTransformMakeRotation(M_PI/2);
    
    [[self layer] addSublayer:_aLayer];
}

- (void)initializeTouch {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(didTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
}

#pragma mark - AVCaptureVideaDataOutput

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSMutableArray *tempLastQRCodeValues = [[NSMutableArray alloc] initWithArray:_lastQRCodeValues];
    
    [_lastQRCodeValues removeAllObjects];
    
    if(![self isSessionRunning]) {
        [tempLastQRCodeValues release];
        return;
    }
    
    for(AVMetadataMachineReadableCodeObject *readableObject in metadataObjects) {
        NSString *qrCodeStringValue = [readableObject stringValue];
        
        __block NSInteger indexFound = -1;
        
        [tempLastQRCodeValues enumerateObjectsUsingBlock:^(NSString *lastQRCodeValue, NSUInteger index, BOOL *stop) {
            if([qrCodeStringValue isEqualToString:lastQRCodeValue]) {
                *stop = YES;
                indexFound = index;
            }
        }];
        
        if(-1!=indexFound) {
            [tempLastQRCodeValues removeObjectAtIndex:indexFound];
        }
        
        if(qrCodeStringValue) { //match non empty QRCode
            [_lastQRCodeValues addObject:qrCodeStringValue];
        }
        
        if([_delegate respondsToSelector:@selector(didDetectQRCode:)] && -1==indexFound) {
            
            [_delegate didDetectQRCode:qrCodeStringValue];
        }
    }
    
    [tempLastQRCodeValues release];
    
    if([metadataObjects count]>0) {
        [self displayFlashOnCamera];
        if(_shouldStopWhenQRCodeIsDetected) {
            [self stopRunning];
        }
    }
}

#pragma mark - Gesture methods

- (void)didTap:(UIGestureRecognizer *)gestureRecognizer {
    NSError *error = nil;
    
    [_backCamera lockForConfiguration:&error];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    [_backCamera setFocusPointOfInterest:touchPoint];
    
    [_backCamera unlockForConfiguration];
}

#pragma mark - Private methods

- (void)displayFlashOnCamera {
    
    if(!_displayFlash) {
        return;
    }
    
    [_flashLayer removeAllAnimations];
    [_flashLayer removeFromSuperlayer];
    [_flashLayer release];
    _flashLayer = [CALayer layer];
    
    [_flashLayer setFrame:[_previewLayer bounds]];
    [_flashLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    [basicAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [basicAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
    [basicAnimation setDuration:0.4];
    [basicAnimation setFillMode:kCAFillModeForwards];
    [basicAnimation setRemovedOnCompletion:NO];
    [basicAnimation setDelegate:self];
    
    [_previewLayer addSublayer:_flashLayer];
    
    [_flashLayer addAnimation:basicAnimation forKey:@"flash"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_flashLayer removeFromSuperlayer];
    [_flashLayer release];
    
    _flashLayer = nil;
}

- (void)updateVideoQuality {
    switch(_videoQuality) {
        case NPQRCodeScannerVideoQualityLow:
            [_session setSessionPreset:AVCaptureSessionPreset352x288];
            break;
        case NPQRCodeScannerVideoQualityMedium:
            [_session setSessionPreset:AVCaptureSessionPreset640x480];
            break;
        case NPQRCodeScannerVideoQualityHigh:
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            break;
        default:
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            break;
    }
}

#pragma mark - Public methods

- (void)startRunning {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_session startRunning];
        [self setSessionRunning:YES];
    });
}

- (void)stopRunning {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_session stopRunning];
        [self setSessionRunning:NO];
    });
}

- (void)setRectOfInterest:(CGRect)rectOfInterest {
    [_metaDataoutput setRectOfInterest:rectOfInterest];
}

- (void)setVideoQuality:(NPQRCodeScannerVideoQuality)videoQuality {
    _videoQuality = videoQuality;
    
    [self updateVideoQuality];
}

@end
