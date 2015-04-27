
//
//  PaymentViewController.m
//  iMobey
//
//  Created by Fabrice Dewasmes on 19/8/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "PaymentViewController.h"

#import <FZPayment/PaymentCheckViewController.h>

//Helper
#import <FZBlackBox/LocalizationHelper.h>
#import <FZBlackBox/ColorHelper.h>
#import <FZBlackBox/FontHelper.h>
#import <FZBlackBox/BundleHelper.h>
#import "InvoiceHelper.h"

//Services
#import <FZAPI/CreditCardServices.h>
#import <FZAPI/ConnectionServices.h>

//View controller
#import "HistoryViewController.h"
#import "AccountBannerViewController.h"
#import "PaymentCheckViewController.h"
// TODO : need refactor

#import <FZBlackBox/CreateCardViewControllerDelegate.h>
#import <FZBlackBox/CreateCardWithBraintreeViewControllerDelegate.h>
#import <FZBlackBox/UserInformationViewControllerDelegate.h>

//Color
#import <FZBlackBox/ColorHelper.h>

#import <FZBlackBox/CoreMultiTargetManager.h>
#import <FZBlackBox/FZTargetManager.h>

#import <FZBlackBox/Constants.h>

#import <FZBlackBox/SDKProxyHelper.h>

//Domain
#import <FZAPI/UserSession.h>
#import <FZAPI/CreditCard.h>

//Util
#import <FZBlackBox/ODDeviceUtil.h>
#import <FZBlackBox/ODCustomAlertView.h>
#import <FZBlackBox/FZUIImageWithImage.h>

//AVFoundation
#import <AVFoundation/AVFoundation.h>

//Sound
#import <AudioToolbox/AudioToolbox.h>

//CustomTabBarViewController
#import <FZBlackBox/CustomTabBarViewController.h>
#import <FZBlackBox/CustomNavigationHeaderViewController.h>
#import <FZBlackBox/FZPortraitNavigationController.h>
#import <FZBlackBox/CustomNavigationViewController.h>

//Manager
#import <FZBlackBox/FZDefaultMultiTargetManager.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

#define kAlertNotFlashizInvoice 0
#define kAlertFlashizNotUgradedAccount 1
#define kAlertFlashizNotValidatedAccount 2
#define kAlertFlashizNoBraintreeForNow 3
#define kAlertIncorrectFlashizInvoice 4
#define kAlertFlashizInfo 909999


@interface PaymentViewController ()<AccountBannerViewControllerDelegate,UIAlertViewDelegate,CreateCardViewControllerDelegate,CreateCardWithBraintreeViewControllerDelegate,UserInformationViewControllerDelegate,CustomNavigationHeaderViewControllerDelegate,PaymentCheckViewControllerDelegate>
{
    
}

//private properties
@property (retain, nonatomic) IBOutlet UIView *viewLoadingBolt;
@property (retain, nonatomic) UIImageView *bolt;

@property (retain, nonatomic) IBOutlet UIView *viewZXingWidget;

@property (retain, nonatomic) IBOutlet UILabel *lblSetUserInfos;

@property (retain, nonatomic) IBOutlet UILabel *lblAddCreditCard;

@property (retain, nonatomic) IBOutlet UIButton *btnFlash;
@property (retain, nonatomic) IBOutlet UIImageView *poweredByFlashiz;

@property (retain, nonatomic) ScannerViewController *scannerViewController;

@property (retain, nonatomic) NSString *redirectUrl;
@property (nonatomic) BOOL hasAnyCreditCards;
@property (nonatomic,assign) BOOL firstLaunch;

@property (assign, nonatomic) NSTimer *timerCamera;

@property (assign, nonatomic) BOOL isProcessing;
@end

@implementation PaymentViewController {
    
    SystemSoundID soundID;
    
    BOOL isForceStartingScan_;
}
@synthesize btnAddCreditCard;
@synthesize btnSetUserInfos;
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"PaymentViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if (self) {
        
        [self setTitleHeader:[LocalizationHelper stringForKey:@"paymentHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundlePayment]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] paymentViewController_header_backgroundColor]];
        
        //comment
        _hasAnyCreditCards = NO;
        _firstLaunch = YES;
    }
    return self;
}

#pragma mark - Cycle life

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Account banner
    if([[UserSession currentSession]isUserAccessToAccountBanner]){
        //account banner
        AccountBannerViewController *accountBanner = [[self multiTargetManager] accountBannerViewController];
        [accountBanner setDelegate:self];
        [accountBanner setChangeAvatarRules:YES];
        
        [[self viewAccountBanner] addSubview:[accountBanner view]];
        [self addChildViewController:accountBanner];
        
        if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget || [[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
            [[accountBanner btnGoToOrCloseHistoric] setHidden:YES];
            //add a white transparent view to the account banner
            UIView *whiteView = [[UIView alloc] init];
            [whiteView setFrame:[[self viewAccountBanner] frame]];
            [whiteView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.75f]];
            
            [[self viewAccountBanner] addSubview:whiteView];
            
            [whiteView release];
        }
        
    } else {
        [[self viewAccountBanner] setHidden:YES];
    }
    
    //Menu
    if([[UserSession currentSession]isUserAccessToMenu]){
        //add observer to start/stop the camera while displaying/hiding the side menu
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willShowMenu:)
                                                     name:willShowMenuNotification
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didHideMenu:)
                                                     name:didHideMenuNotification
                                                   object:nil];
    }
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget || [[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        [[UserSession currentSession] addObserver:self forKeyPath:userConnected options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [self setupView];
    
    //BankSDK
    if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        UIImage *image = [FZUIImageWithImage imageNamed:@"powered_by_flashiz" inBundle:FZBundleBlackBox];
        [[self poweredByFlashiz] setImage:image];
        [[self poweredByFlashiz] setHidden:NO];
    } else{
        [[self poweredByFlashiz] setHidden:YES];
    }
    
    //Camera
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (![device hasTorch]){
        [_btnFlash setHidden:YES];
    }
    
    _scannerViewController = [[ScannerViewController alloc] init];
    [_scannerViewController setDelegate:self];
    
    [self addChildViewController:_scannerViewController];
    
    [[self viewZXingWidget] addSubview:[_scannerViewController view]];
    
    [self forceVideoQuality];
    
    
    
    [[self imageScanCheck] setAutoresizesSubviews:YES];
    [[self imageMask] setAutoresizesSubviews:YES];
    [_viewZXingWidget setAutoresizesSubviews:YES];
    [[self view]setAutoresizesSubviews:YES];
    
    _isProcessing = NO;
    
    [[self imageMask] setImage:[FZUIImageWithImage imageNamed:@"layer_scan" inBundle:FZBundlePayment]];
    
    [[self imageMask] setContentMode:UIViewContentModeScaleAspectFill];
    [[self imageScanCheck] setImage:[FZUIImageWithImage imageNamed:@"layer_scan_check" inBundle:FZBundlePayment]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self imageScanCheck] setHidden:YES];
    [[self imageMask] setHidden:YES];
    [_viewZXingWidget setHidden:YES];
}

- (void)manageTopUpFromSdk {
    //is sdk calls top up process ?
    if([[UserSession currentSession] isSdkEngagedTopup]){
        [[UserSession currentSession] setSdkTopupEngage:NO];
        
        FZDefaultMultiTargetManager *multiTarget = [self multiTargetManager];
        
        PaymentTopupViewController *paymentTopUp = (PaymentTopupViewController *)[multiTarget paymentTopupViewControllerWithDelegate:self];
        
        CustomNavigationViewController *navigCtrler = [multiTarget customNavigationViewControllerWithController:(HeaderViewController *)paymentTopUp andMode:CustomNavigationModeClose];
        
        [self presentViewController:navigCtrler animated:YES completion:^{}];
    } else {
        [[UserSession currentSession] setSdkTopupEngage:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopAnimateBolt];
}

- (void)viewDidLayoutSubviews
{
    if([[UserSession currentSession] isUserAccessToTabBar]){
        CGRect frame = [[[[self parentViewController] parentViewController] viewShowed] frame];
        
        [[self view] setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self manageTopUpFromSdk];    
    
    if([[UserSession currentSession]isUserConnected]){
        NSLog(@"connected");
        
        [[self imageMask] setAutoresizesSubviews:YES];
        [[self imageScanCheck] setAutoresizesSubviews:YES];
        
        if(![ODDeviceUtil isAnIphoneFive] && [[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) { //adjust the position of the layer_scan image for Flashiz for iPhone with a 3,5" inch screen
            CGRect imageMaskFrame = [[self imageMask] frame];
            imageMaskFrame.origin.y = [[self viewAccountBanner] frame].origin.y + [[self viewAccountBanner] frame].size.height - 45;
            [[self imageMask] setFrame:imageMaskFrame];
            
            CGRect imageScanCheckFrame = [[self imageScanCheck] frame];
            imageScanCheckFrame.origin.y = [[self viewAccountBanner] frame].origin.y + [[self viewAccountBanner] frame].size.height + [_viewZXingWidget frame].size.height/2 - [[self imageScanCheck] frame].size.height/2;
            [[self imageScanCheck] setFrame:imageMaskFrame];
        }
        
        [_viewZXingWidget setHidden:NO];
        [[self imageMask] setHidden:NO];
        
        //Start loading animation
        [self animateBolt];
        
        //Reset flash button
        [_btnFlash setImage:[FZUIImageWithImage imageNamed:@"btn_torch_off" inBundle:FZBundlePayment] forState:UIControlStateNormal];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self dispatchCameraLoading:YES];
        }
        
        [self refresh];
        
        //TODO: not compile
        /*
        CustomTabBarViewController *controller = [[[FZTargetManager sharedInstance]facade]tabBarController];
        
        if(controller){
            [controller forceRiddles];
        }
         */
        
        _isProcessing = NO;
    }else{
        NSLog(@"no connect, no loading");
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_viewBackgroundAddCreditCard setHidden:YES];
    [_viewBackgroundSetUserInfos setHidden:YES];
    [self turnTorchOn:NO];
    
    [self forceStopRunning];
}

-(void)willEnterBackground
{
    if(_timerCamera){
        [_timerCamera invalidate], _timerCamera = nil;
    }
    [self forceStopRunning];
}

- (void)willEnterForeground {
    
}

-(void) dispatchCameraLoading:(BOOL)timer {
    
    isForceStartingScan_ = NO;
    
    if (timer) {
        if (_timerCamera) {
            [_timerCamera invalidate], _timerCamera = nil;
        }
        _timerCamera = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(forceStart)
                                                      userInfo:nil
                                                       repeats:YES];
    } else {
        [self forceStart];
    }
}

#pragma mark - Setup view

-(void)setupView {
    [self setTitle:[LocalizationHelper stringForKey:@"paymentHomeViewController_navigation_title" withComment:@"PaymentHomeViewController" inDefaultBundle:FZBundlePayment]];
    
    //set user info banner
    [_viewBackgroundSetUserInfos setBackgroundColor:[[ColorHelper sharedInstance] paymentViewController_viewBackgroundSetUserInfos_backgroundColor]];
    
    [_lblSetUserInfos setText:[[LocalizationHelper stringForKey:@"paymentViewController_lbl_setUserInfos" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    [_lblSetUserInfos setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:11]];
    [_lblSetUserInfos setTextColor:[[ColorHelper sharedInstance] whiteColor]];
    
    [btnSetUserInfos setBackgroundNormalColor:[[ColorHelper sharedInstance] paymentViewController_btnSetUserInfos_backgroundColor]];
    [btnSetUserInfos setBackgroundHighlightedColor:[[ColorHelper sharedInstance] paymentViewController_btnSetUserInfos_backgroundColor]];
    
    [btnSetUserInfos setTitle:[[LocalizationHelper stringForKey:@"paymentViewController_btn_setUserInfos" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [btnSetUserInfos setTitle:[[LocalizationHelper stringForKey:@"paymentViewController_btn_setUserInfos" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateHighlighted];
    [btnSetUserInfos setTitleColor:[[ColorHelper sharedInstance] paymentViewController_btnSetUserInfos_titleColor] forState:UIControlStateNormal];
    [btnSetUserInfos setTitleColor:[[ColorHelper sharedInstance] paymentViewController_btnSetUserInfos_titleColor] forState:UIControlStateHighlighted];
    
    [[btnSetUserInfos titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:11]];
    [[btnSetUserInfos layer] setBorderWidth:1.0];
    [btnSetUserInfos setBorderNormalColor:[[ColorHelper sharedInstance] whiteColor]];
    btnSetUserInfos.layer.cornerRadius = 2;
    
    //add credit card banner
    [_viewBackgroundAddCreditCard setBackgroundColor:[[ColorHelper sharedInstance] paymentViewController_viewBackgroundAddCreditCard_backgroundColor]];
    
    [_lblAddCreditCard setText:[[LocalizationHelper stringForKey:@"paymentViewController_lbl_addCreditCard" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    [_lblAddCreditCard setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:11]];
    [_lblAddCreditCard setTextColor:[[ColorHelper sharedInstance] whiteColor]];
    
    [btnAddCreditCard setBackgroundNormalColor:[[ColorHelper sharedInstance] paymentViewController_btnAddCreditCard_backgroundColor]];
    [btnAddCreditCard setBackgroundHighlightedColor:[[ColorHelper sharedInstance] paymentViewController_btnAddCreditCard_backgroundColor]];
    
    [btnAddCreditCard setTitleColor:[[ColorHelper sharedInstance] paymentViewController_btnAddCreditCard_titleColor] forState:UIControlStateNormal];
    [btnAddCreditCard setTitleColor:[[ColorHelper sharedInstance] paymentViewController_btnAddCreditCard_titleColor] forState:UIControlStateHighlighted];
    
    [btnAddCreditCard setTitle:[[LocalizationHelper stringForKey:@"paymentViewController_btn_addCreditCard" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[btnAddCreditCard titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:11]];
    [[btnAddCreditCard titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[btnAddCreditCard titleLabel] setMinimumScaleFactor:0.5];
    [[btnAddCreditCard layer] setBorderWidth:1.0];
    [btnAddCreditCard setBorderNormalColor:[[ColorHelper sharedInstance] whiteColor]];
    btnAddCreditCard.layer.cornerRadius = 2;
}

- (void)customSetupView {
    [btnSetUserInfos setBorderHighlightedColor:[[ColorHelper sharedInstance] mainOneColor]];
    [btnAddCreditCard setBorderHighlightedColor:[[ColorHelper sharedInstance] mainOneColor]];
}

#pragma mark - Custom animation

- (void) animateBolt {
    [_viewLoadingBolt setBackgroundColor:[UIColor whiteColor]];
    
    _bolt = [[UIImageView alloc] initWithImage:[FZUIImageWithImage imageNamed:@"flashiz_blue" inBundle:FZBundlePayment]];
    
    [_viewLoadingBolt addSubview:_bolt];
    
    [_bolt setCenter:[_viewLoadingBolt center]];
    _bolt.alpha = 1.0;
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationCurveEaseInOut)
                     animations:^{
                         _bolt.transform = CGAffineTransformMakeScale(1.8, 1.8);
                         _bolt.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)stopAnimateBolt {
    
    [_viewLoadingBolt setBackgroundColor:[UIColor clearColor]];
    [_bolt removeFromSuperview];
    
}

#pragma mark - Private method

- (void)forceVideoQuality {
    
    ODDeviceModel currentDeviceModel = [ODDeviceUtil currentDeviceModel];
    
    if(currentDeviceModel == ODDeviceModeliPhone3GS) {
        [_scannerViewController setVideoQuality:ScannerViewVideoQualityLow];
    }
    else if(currentDeviceModel == ODDeviceModeliPhone4) {
        [_scannerViewController setVideoQuality:ScannerViewVideoQualityLow];
    }
    else {
        [_scannerViewController setVideoQuality:ScannerViewVideoQualityHigh];
    }
    
}

- (void)useScanResult:(NSString *)scanResult {
    BOOL isUserTrial = [[[UserSession currentSession] user] isTrial];
    
    if([[FZTargetManager sharedInstance]mainTarget]==FZBankSDKTarget){
        isUserTrial = NO;
    }else{
        [ConnectionServices updateIfStillTrial];
        isUserTrial = [[[UserSession currentSession] user] isTrial];
    }
    
    if(!isUserTrial) {
        if([InvoiceHelper isInvoiceUrlValid:scanResult validUrls:[[UserSession currentSession] validUrls]]) {
            
            NSURL *invoiceURL = [NSURL URLWithString:scanResult];
            NSString *invoiceId = [invoiceURL lastPathComponent];
            
            if([invoiceId length]==0) {
                ODCustomAlertView *alertView = [[ ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] message:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_message_default" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment] delegate:nil cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] otherButtonTitles: nil];
                
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView setTag:kAlertIncorrectFlashizInvoice];
                [alertView setDelegate:self];
                [alertView show];
                [alertView release];
                
            } else {
                //display check imaged
                [[self imageScanCheck] setHidden:NO];
                
				_paymentCheckViewController = [[self multiTargetManager] paymentCheckViewController];
				[_paymentCheckViewController setDelegate:self];
				[_paymentCheckViewController setInvoiceId:invoiceId];
				[_paymentCheckViewController setComeFromScanner:YES];

				
				CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:_paymentCheckViewController andMode:CustomNavigationModeClose];
				
				//TODO: Maybe we need to use FZNavigationBlaBla
                UINavigationController *navigationController = [[FZPortraitNavigationController alloc]initWithRootViewController:(UIViewController*)navigController];
                
                navigationController.navigationBarHidden = YES;
                
                [self presentViewController:(UIViewController*)navigationController animated:YES completion:nil];
                
                [navigationController release];
                _isProcessing = NO;
            }
        } else {
            FZPaymentLog(@"This is not a Flashiz invoice");
            _redirectUrl = [[NSString alloc] initWithString:scanResult];
            
            if([_redirectUrl hasPrefix:@"http://"] || [_redirectUrl hasPrefix:@"https://"]){
                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                                message:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_message" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                               delegate:self
                                                                      cancelButtonTitle:[LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                      otherButtonTitles:[LocalizationHelper stringForKey:@"app_confirm" withComment:@"Global" inDefaultBundle:FZBundleBlackBox], nil];
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView setTag:kAlertNotFlashizInvoice];
                [alertView show];
                [alertView release];
            }else{
                
                if([_redirectUrl hasPrefix:@"TEL"] || [_redirectUrl hasPrefix:@"SMSTO"]){
                    //Call || SMS
                    
                    ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                                    message:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_message_default" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                                   delegate:self
                                                                          cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                          otherButtonTitles:nil];
                    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                    [alertView setTag:kAlertNotFlashizInvoice];
                    [alertView show];
                    [alertView release];
                    
                }else{
                    
                    NSString *message = nil;
                    if([_redirectUrl hasPrefix:@"BEGIN:VCARD"]){
                        //VCARD
                        message = [LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_message_default" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment];
                    } else {
                        //Message
                        message = [NSString stringWithFormat:@"%@ %@",[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_message_not_url" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment],_redirectUrl];
                    }
                    
                    ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                                    message:message
                                                                                   delegate:self
                                                                          cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                          otherButtonTitles:nil];
                    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                    [alertView setTag:kAlertNotFlashizInvoice];
                    [alertView show];
                    [alertView release];
                }
            }
        }
    } else {
        if([[[UserSession currentSession] user] isUserUpgraded]) {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"registerCaptchaViewController_mail_notification" withComment:@"RegisterCaptchaViewController" inDefaultBundle:FZBundlePayment]
                                                                           delegate:self
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView setTag:kAlertFlashizNotValidatedAccount];
            [alertView show];
            [alertView release];
        } else {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_valid_account" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                           delegate:self
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView setTag:kAlertFlashizNotUgradedAccount];
            [alertView show];
            [alertView release];
        }
    }
}

#pragma mark - Actions
- (IBAction)flash:(id)sender {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([device isFlashActive]){
        
        [sender setImage:[FZUIImageWithImage imageNamed:@"btn_torch_off" inBundle:FZBundlePayment] forState:UIControlStateNormal];
        [self turnTorchOn:NO];
        
    }else{
        
        [sender setImage:[FZUIImageWithImage imageNamed:@"btn_torch_on" inBundle:FZBundlePayment] forState:UIControlStateNormal];
        [self turnTorchOn:YES];
        
    }
}

- (void) turnTorchOn: (bool) on {
    // TODO : WTF Reflexion ?
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device isFlashActive];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                //torchIsOn = YES; //define as a variable/property if you need to know status
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                //torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (IBAction)setUserInfos:(id)sender {
    // TODO : need refactor
    //[TestFlightHelper passPaymentFillIn];
    
    [[StatisticsFactory sharedInstance] checkPointScanAddInfo];
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
        [SDKProxyHelper openFillUserInformationsProcessWithUserKey:[[UserSession currentSession] userKey] environment:[[UserSession currentSession] shortEnvironmentValue]];
    } else {
        UIViewController *controller = [[self multiTargetManager] userInformationViewControllerWithDelegate:self];
        
        CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:(HeaderViewController *)controller andMode:CustomNavigationModeClose];
        
        [self presentViewController:(UIViewController *)navigController animated:YES completion:^{}];
    }
}

- (void)displayMessage {
    //display no mesage for flashiz
}

- (IBAction)addCreditCard:(id)sender {
    
    if([[[[[UserSession currentSession] user] account] currency] isEqualToString:@"EUR"]) {
        
        [[StatisticsFactory sharedInstance] checkPointScanAddCard];
        if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
            [SDKProxyHelper openAddCreditCardProcessWithUserKey:[[UserSession currentSession] userKey] environment:[[UserSession currentSession] shortEnvironmentValue]];
        } else {
            
            [self forceStopRunning];
            [self displayMessage];
            
            UIViewController *scanPayViewController = [[self multiTargetManager] scanPayViewControllerWithDelegate:self];
            
            // If you want to use your own color for set sight
            [scanPayViewController setSightColor:[UIColor colorWithRed:97 / 255.f green:170 / 255.f blue:219 / 255.f alpha:1.0]];
            
            [scanPayViewController startScannerWithViewController:[[[FZTargetManager sharedInstance]facade]tabBarController] success:^(SPCreditCard * card){
                
                // You will be notified of the user interaction through this block
                //NSLog(@"%@ Expire %@/%@ CVC: %@", card.number, card.month, card.year, card.cvc);
                
                [self scanPayViewControllerDidScanCard:card];
                
            } cancel:^{
                
                // You will be notified when the user has canceled through this block
                //NSLog(@"User cancel");
                
                [self scanCancelledByUser];
                
            }];
        }
        
    } else {
        ODCustomAlertView *alert = [[ODCustomAlertView alloc] initWithTitle:nil message:[LocalizationHelper stringForKey:@"createCardViewController_alert_refill_on_flashiz" withComment:@"CreateCardViewController" inDefaultBundle:FZBundlePayment] delegate:self cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] otherButtonTitles:nil, nil];
        
        [alert setTag:kAlertFlashizNoBraintreeForNow];
        [alert setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
        [alert show];
        [alert release];
    }
}

#pragma mark - Scanner view methods

- (void)forceStopRunning
{
    if(_timerCamera){
        if ([_timerCamera isValid]) {
            [_timerCamera invalidate], _timerCamera = nil;
        }
    }
    
    [_scannerViewController forceStopRunning];
}

- (void)forceStart {
    if(isForceStartingScan_) {
        return;
    }
    
    isForceStartingScan_ = YES;
    
    if([self isPaymentViewControllerVisible]) {
        
        if(_firstLaunch){
            _firstLaunch = NO;
            isForceStartingScan_ = NO;
        }else{
            [self reloadScannerView];
            isForceStartingScan_ = NO;
        }    }
}

- (void)unloadScannerView {
    
    //[[self viewZXingWidget]removeFromSuperview];
    
    if(_timerCamera){
        [_timerCamera invalidate], _timerCamera = nil;
    }
    [_scannerViewController forceStopRunning];
}

- (void)reloadScannerView {
    [_scannerViewController forceStartRunning];
    
    if(_timerCamera){
        [_timerCamera invalidate], _timerCamera = nil;
    }
    
    //Remove loading view here
    [self stopAnimateBolt];
}

#pragma mark - Menu observing methods

- (void)willShowMenu:(NSNotification *)notification {
    [self forceStopRunning];
    [self turnTorchOn:NO];
    [_btnFlash setImage:[FZUIImageWithImage imageNamed:@"btn_torch_off" inBundle:FZBundlePayment] forState:UIControlStateNormal];
}

- (void)didHideMenu:(NSNotification *)notification {
    [self dispatchCameraLoading:NO];
}

#pragma mark - User observing methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:userConnected]){
        BOOL isConnected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if(isConnected){
            [self refresh];
        }
    }
}

#pragma mark - PaymentViewControllerDelegate

- (void)didScanValidInvoice:(NSString *)invoiceId {
    if([delegate respondsToSelector:@selector(didScanValidInvoice:)]) {
        [(PaymentViewController *)delegate didScanValidInvoice:invoiceId];
    }
}

#pragma mark - Delegates

- (void)refresh {
    //Hide by default, enable if needed
    [_viewBackgroundAddCreditCard setHidden:YES];
    [_viewBackgroundSetUserInfos setHidden:YES];
    
    [_viewBackgroundAddCreditCard setAlpha:0];
    [_viewBackgroundSetUserInfos setAlpha:0];
    
    
    if(![[[UserSession currentSession] user] isUserUpgraded] && [[FZTargetManager sharedInstance]mainTarget]!=FZBankSDKTarget){
        [_viewBackgroundSetUserInfos setHidden:NO];
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        [_viewBackgroundSetUserInfos setAlpha:1];
        [UIView commitAnimations];
    }
    
    BOOL isUserTrial = [[[UserSession currentSession] user] isTrial];
    
    if(isUserTrial){
        if([[FZTargetManager sharedInstance]mainTarget]==FZBankSDKTarget){
            isUserTrial = NO;
        }else{
            [ConnectionServices updateIfStillTrial];
            isUserTrial = [[[UserSession currentSession] user] isTrial];
        }
    }
    
    if(!isUserTrial && [[FZTargetManager sharedInstance]mainTarget]!=FZBankSDKTarget) {
        [CreditCardServices registeredCards:[[UserSession currentSession] userKey] successBlock:^(id context) {
            _hasAnyCreditCards = [(NSMutableArray *)context count] > 0 ? YES : NO;
            
            if(!_hasAnyCreditCards){
                [_viewBackgroundAddCreditCard setHidden:NO];
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:0.5];
                [_viewBackgroundAddCreditCard setAlpha:1];
                [UIView commitAnimations];
            }
            
        } failureBlock:^(Error *error) {
            _hasAnyCreditCards = YES;
            if(_hasAnyCreditCards){
                [_viewBackgroundAddCreditCard setHidden:YES];
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:0.5];
                [_viewBackgroundAddCreditCard setAlpha:0];
                [UIView commitAnimations];
            }
        }];
    }

}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger alertViewTag = [alertView tag];
    
    if(alertViewTag == kAlertNotFlashizInvoice && buttonIndex == 1) {
        FZPaymentLog(@"Redirection...");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _redirectUrl]];
    } else if (alertViewTag == kAlertNotFlashizInvoice && buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self dispatchCameraLoading:NO];
        }
    } else if(alertViewTag == kAlertFlashizNotUgradedAccount) {
        [self setUserInfos:self];
    } else if(alertViewTag == kAlertFlashizNotValidatedAccount) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self dispatchCameraLoading:NO];
        }
    } else if(alertViewTag == kAlertIncorrectFlashizInvoice) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self dispatchCameraLoading:NO];
        }
    }
    _isProcessing = NO;
}

#pragma mark - Account banner view controller

- (void)goToOrCloseHistoric{
    HistoryViewController *controller = [[self multiTargetManager] historyViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeBack];
    
    [[[[FZTargetManager sharedInstance]facade]tabBarControllerNavigation] pushViewController:(UIViewController*)navigController animated:YES];
}

- (void)willTakePicture:(AccountBannerViewController *)bannerViewController {
    //NSLog(@"willTakePicture");
}

- (void)showChoice:(AccountBannerViewController *)bannerViewController
{
    //NSLog(@"showChoice");
    [self forceStopRunning];
}

- (void)didTakePicture:(AccountBannerViewController *)bannerViewController {
    //NSLog(@"didTakePicture");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self dispatchCameraLoading:YES];
    }
}

- (void)didCancelTakePicture:(AccountBannerViewController *)bannerViewController {
    //NSLog(@"didCancelTakePicture");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self dispatchCameraLoading:YES];
    }
}

#pragma mark - SDK Delegate

- (void)paymentCheckViewControllerSdkClose {
    if ([[FZTargetManager sharedInstance] isApplicationUsingSDK]) {
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        if ([facade respondsToSelector:@selector(didClose:)]) {
            [facade didClose:nil];
        }
    }
}

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didFailPaymentForInvoiceId:(NSString *)invoiceId {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didCancelPaymentForInvoiceId:(NSString *)invoiceId {
    
    if([delegate respondsToSelector:@selector(paymentCanceledForInvoice:)]) {
        [(FZFlashizFacade *)delegate paymentCanceledForInvoice:invoiceId];
    }
}

- (void)paymentCheckViewController:(PaymentCheckViewController *)paymentCheckViewController didValidatePaymentForInvoiceId:(NSString *)invoiceId {
    
    FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
    
    if([facade respondsToSelector:@selector(paymentAcceptedForInvoice:)]) {
        [facade paymentAcceptedForInvoice:invoiceId];
    }
}

#pragma mark - ScanPay delegate

- (void)scanPayViewControllerDidScanCard:(id)card {
    NSString *cardNumber = [card valueForKey:@"number"];
    NSString *month = [card  valueForKey:@"month"];
    NSString *year = [card  valueForKey:@"year"];
    NSString *cvc = [card  valueForKey:@"cvc"];
    
    CreditCard *creditCard = [[CreditCard alloc] init];
    [creditCard setCreditCardId:cardNumber];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:[month integerValue]];
    [dateComponents setYear:[year integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    [dateComponents release];
    [gregorian release];
    
    [creditCard setExpirationDate:date];
    [creditCard setPan:cvc];
    
    if([[[[[UserSession currentSession] user] account] currency] isEqualToString:@"EUR"]) {
        
        UIViewController *controller = [[self multiTargetManager]createCardViewControllerFromPaymentView:YES andDelegate:self andFreshCreditCard:creditCard];
        
        CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeClose];
        
        [[[[FZTargetManager sharedInstance]facade]tabBarController]presentViewController:(UIViewController*)navigController animated:YES completion:^{}];
        
    } else {
        /*
         CreateCardWithBraintreeViewController *controller = [[self multiTargetManager] createCardWithBraintreeViewController];
         [controller setFromPaymentView:YES];
         [controller setDelegate:self];
         [controller setFreshCreditCard:creditCard];
         [self pushFromCustomNavigationControllerWithCustomHeaderController:controller andMode:CustomNavigationModeBack animated:YES];
         */
        //ELSE = NOTHING?! TODO SOMETHING
    }
    
    [creditCard release];
}

- (void)scanPayViewController:(ScanPayViewController *)scanPayViewController failedToScanWithError:(NSError *)error {
    // TODO : nothing to do?
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self dispatchCameraLoading:YES];
    }
}

- (void)scanCancelledByUser {
    // TODO : nothing to do?
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self dispatchCameraLoading:YES];
    }
}

#pragma mark - ScannerViewController delegate methods

- (void)didScanQRCode:(NSString *)qrCodeValue {
    if(!_isProcessing) {
        [self useScanResult:qrCodeValue];
        _isProcessing = YES;
    }
}

#pragma mark - CustomNavigationHeaderViewController delegate

- (void)didClose:(CustomNavigationHeaderViewController *)controller {
    
    //Dismiss the scan view (PaymentViewController)
    [self dismissViewControllerAnimated:YES completion:^{
        
        FZTarget currentTarget = [[FZTargetManager sharedInstance] mainTarget];
                
        if ([[FZTargetManager sharedInstance] isApplicationUsingSDK]) {
            FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
            
            if ([facade respondsToSelector:@selector(didClose:)]) {
                [facade didClose:controller];
            }
        }
        
        if (currentTarget == FZBankSDKTarget) {
            if ([[[FZTargetManager sharedInstance] facade] respondsToSelector:@selector(didCloseSdk)]) {
                [[[FZTargetManager sharedInstance] facade] didCloseSdk];
            }
        }
    }];
}

- (void)didGoBack:(CustomNavigationHeaderViewController *)controller {
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
        
    //Menu
    if([[UserSession currentSession]isUserAccessToMenu]){
        //remove observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:willShowMenuNotification
                                                      object:nil];
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:didHideMenuNotification
                                                      object:nil];
    }
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget || [[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        [[UserSession currentSession] removeObserver:self forKeyPath:userConnected];
    }
    
    AudioServicesDisposeSystemSoundID(soundID);
    
    [_scannerViewController removeFromParentViewController];
    [_scannerViewController release], _scannerViewController = nil;
    
    if(_viewAccountBanner){
        [_viewAccountBanner release], _viewAccountBanner = nil;
    }
    
    if (_viewZXingWidget) {
        [_viewZXingWidget release],_viewZXingWidget = nil;
    }
    
    if (_lblAddCreditCard) {
        [_lblAddCreditCard release],_lblAddCreditCard = nil;
    }
    
    if (_lblSetUserInfos) {
        [_lblSetUserInfos release],_lblSetUserInfos = nil;
    }
    
    if (_viewBackgroundAddCreditCard) {
        [_viewBackgroundAddCreditCard release],_viewBackgroundAddCreditCard = nil;
    }
    
    if (_viewBackgroundSetUserInfos) {
        [_viewBackgroundSetUserInfos release],_viewBackgroundSetUserInfos = nil;
    }
    
    if (_redirectUrl) {
        [_redirectUrl release],_redirectUrl = nil;
    }
    
    if ([self imageScanCheck]) {
        [[self imageScanCheck] release],_imageScanCheck = nil;
    }
    
    if ([self imageMask]) {
        [[self imageMask] release],_imageMask = nil;
    }
    
    if (btnSetUserInfos) {
        [btnSetUserInfos release],btnSetUserInfos = nil;
    }
    
    if (btnAddCreditCard) {
        [btnAddCreditCard release],btnAddCreditCard = nil;
    }
    
    if (_poweredByFlashiz) {
        [_poweredByFlashiz release],_poweredByFlashiz = nil;
    }
    
    if (_viewLoadingBolt) {
        [_viewLoadingBolt release],_viewLoadingBolt = nil;
    }
    
    if (_bolt) {
        [_bolt release],_bolt = nil;
    }
	
	if (_paymentCheckViewController) {
		[_paymentCheckViewController release],_paymentCheckViewController = nil;
	}

    [super dealloc];
}

@end
