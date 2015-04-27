//
//  TransferReceiveStep2ViewController.m
//  iMobey
//
//  Created by Yvan Moté on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "TransferReceiveStep2ViewController.h"

//QR Reader
#import <CoreImage/CoreImage.h>

//Services
#import <FZAPI/InvoiceServices.h>

//Domain
#import <FZAPI/UserSession.h>
#import <FZAPI/CheckPaymentResult.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Constants
#import <FZBlackBox/FontHelper.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>


//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

#define kBackgroundImageActionSuccessful @"thankyou"

@interface TransferReceiveStep2ViewController ()/*<ActionSuccessfulViewControllerDelegate>*/
{
    
}

//View
@property (retain, nonatomic) IBOutlet UIImageView *qrImageView;
@property (retain, nonatomic) IBOutlet UIView *viewAmount;
@property (retain, nonatomic) IBOutlet UILabel *flashAndPayLabel;
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;
@property (retain, nonatomic) NSTimer *checkPaymentTimer;

//Model
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, retain) NSString *invoiceId;

@end

@implementation TransferReceiveStep2ViewController

#pragma mark - Init

- (id)initWithURL:(NSString *)url amount:(NSString *)amount currency:(NSString *)currency {
    self = [super initWithNibName:@"TransferReceiveStep2ViewController" bundle:[BundleHelper retrieveBundle:FZBundleP2P]];
    if(self) {
        [self setUrl:url];
        [self setAmount:[[CurrenciesManager currentManager] formattedAmount:amount currency:currency]];
        [self setTitleHeader:[LocalizationHelper stringForKey:@"transferHomeViewController_receiveButton" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]];
        [self setCanDisplayMenu:NO];
    }
    return self;
}

#pragma mark - View cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setInvoiceId:[_url lastPathComponent]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [_url dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    [_qrImageView setImage:resized];
    
    CGImageRelease(cgImage);
    
    
    [self setUpView];
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self runCheckPaymentLoop];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_checkPaymentTimer invalidate];
    [_checkPaymentTimer release];
    _checkPaymentTimer = nil;
}

#pragma mark - Setup view

- (void)setUpView {
    //Amount view
    [_viewAmount setBackgroundColor:[[ColorHelper sharedInstance] transferReceiveStep2ViewController_header_backgroundColor]];
    
    //Amount of the QrCode
    [_flashAndPayLabel setText:[[LocalizationHelper stringForKey:@"transferReceiveStep2ViewController_flashAndPay" withComment:@"TransferReceiveStep2ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [_flashAndPayLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16]];
    
    [_amountLabel setText:_amount];
    [_amountLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:24]];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_qrImageView release];
    [_flashAndPayLabel release];
    [_amountLabel release];
    
    
    [self setUrl:nil];
    [self setAmount:nil];
    
    [self setInvoiceId:nil];
    
    [_viewAmount release];
    [super dealloc];
}

#pragma mark - Private method

- (void)runCheckPaymentLoop
{
    
    _checkPaymentTimer = [[NSTimer timerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(checkPaymentTimerRequest)
                                                userInfo:nil
                                                 repeats:YES] retain];
    
    [[NSRunLoop mainRunLoop] addTimer:_checkPaymentTimer forMode:NSDefaultRunLoopMode];
}

- (void)checkPaymentTimerRequest
{
    
    [InvoiceServices checkPayment:_invoiceId
                       forUserKey:[[UserSession currentSession] userKey]
                     successBlock:^(id context) {
                         
                         CheckPaymentResult *checkPaymentResult = (CheckPaymentResult *)context;
                         if([checkPaymentResult isPaid]) {
                             [_checkPaymentTimer invalidate];
                             [_checkPaymentTimer release];
                             _checkPaymentTimer = nil;
                             
                             [self presentActionViewController];
                         }
                     }
                     failureBlock:^(Error *error) {
                         // FZP2PLog(@"check payment error : %@",error);
                     }];
}

- (void)presentActionViewController {
    [self presentActionViewControllerWithTitle:[LocalizationHelper stringForKey:@"transferHomeViewController_deal_success" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]
                            andBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]
                        andBackgroundImageName:kBackgroundImageActionSuccessful
                                  inBundleName:FZBundleP2P
                                 andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_red" inBundle:FZBundleP2P]
                                   andDelegate:self withCorrectiveDelta:0.0];
}

#pragma mark - Action method

- (IBAction)cancelAction:(id)sender
{
    [self backToRootWithAnimation:YES];
}

#pragma mark - CustomNavigationHeaderViewController delegate methods

- (void)didClose:(CustomNavigationHeaderViewController *)_controller {
    // TODO : nothing to do, never used
    
}

- (void)didGoBack:(CustomNavigationHeaderViewController *)controller
{
    [[StatisticsFactory sharedInstance] checkPointReceiveQRCodeQuit];
    [[self navigationController]popViewControllerAnimated:YES];
}

#pragma mark ActionSuccessfulViewController delegate

- (void)didValidate:(ActionSuccessfulViewController *)controller
{
    [[StatisticsFactory sharedInstance] checkPointReceiveQRCodeDone];
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
