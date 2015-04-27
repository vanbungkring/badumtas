//
//  PaymentCheckViewController.m
//  iMobey
//
//  Created by Fabrice Dewasmes on 19/8/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//
//  A bit of explanation here is not that bad.
//  Invoice detail is queried from the server first. Then several things can happen.
// 1. The invoice object can contain a currentLoyaltyProgram is the current user is not already registered for this program.
//    Beware that a program can be private in which case, it is not offered to the user.
// 2. If a user is already registered in the program, a program can be *either* (and can never be a mix of these):
//    a. A permanent percent discount (sometimes abbreviated in PPD
//    b. A coupon which it turns can be of two distinct type
//         i. A percent discount coupon
//         ii. a cash coupon
// 3. A user can
//    a. have no fidelitiz account. In this case, it is offered to him to create an account and immediately subscribe to the program
//    b. Have a fidelitiz account but not subscribed to this program yet which means he has no loyalty card for this program. In this case we offer the user to subscribe to this program. In case of a new subscription, the loyalty card is said to be 'live' which means that the invoice doesn't know that the user has a loyalty card (so the hasLoyaltyCard property is set to NO) but the real value is YES (this is computed by the fidelitiz engine (see below)
// 4. when it's a PPD it's automatically applied and the amount displayed on the view shall reflect it. When it's a coupon, only one can be used if it's a percent, several can be used if it's a cash coupon. Each time a coupon is used a computing has to be made in the class FidelitizEngine that will compute a corrected amount. This is mainly because with coupons you balance can become negative to pay the invoice unless you use coupons. So the user account is first credited with coupons and only then is the new invoice amount computed.
// 5. It can happen that the invoice amount is greater that the user's balance. In this case, if one card is configured for auto refill, we simply inform user of the refill. If not we have to offer a refill.

#import "PaymentCheckViewController.h"

//Service
#import <FZAPI/InvoiceServices.h>
#import <FZAPI/RewardsServices.h>
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/IndonesiaBankSdkServices.h>

//Domain
#import <FZAPI/UserSession.h>
#import <FZAPI/Invoice.h>
#import <FZAPI/CorrectedInvoice.h>
#import <FZAPI/LoyaltyProgram.h>
#import <FZAPI/LoyaltyCoupon.h>
#import <FZAPI/IndonesianInvoiceStatus.h>

//Engine

#import <FZBlackBox/RewardsEngine.h>
#import <FZAPI/InvoiceCorrectedParameters.h>

//Currency Manager
#import <FZAPI/CurrenciesManager.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//ActionSuccessfulAfterPayment
#import "ActionSuccessfulAfterPaymentViewController.h"

//Map
@class ProximityMapViewController;

//Account banner
#import "AccountBannerViewController.h"

//CoreTextArcView
#import <FZBlackBox/CoreTextArcView.h>

//Draw
#import <FZBlackBox/CircleProgress.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Fonts
#import <FZBlackBox/FontHelper.h>

//SDKProxyHelper
#import <FZBlackBox/SDKProxyHelper.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

//Targets manager
#import <FZBlackBox/FZTargetManager.h>

//Protocol
#import <FZBlackBox/FlashizFacadeDelegate.h>
#import <FZBlackBox/FlashizFacade.h>

//rewards
#import <FZBlackBox/LoyaltyProgramDetailsViewControllerDelegate.h>

#import <objc/message.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

//Utils
#import <FZBlackBox/ODDeviceUtil.h>

//Tipping
#import "FZTipViewController.h"
#import "FZTippingEngine.h"
#import "FZTipModel.h"

//Rounding
#import <math.h>


#define COUPON_WIDTH 60.0
#define COUPON_MARGIN 5.0
#define COUPON_MARGIN_INDO 20.0
#define COUPON_HEIGHT 60.0
#define COUPON_SPACE 5.0

#define kAlertViewCreateFidelitizAccount 100001
#define kAlertViewRegisterToLoyaltyCard 200002
#define TAG_DELTA 100
#define kGradientLayername @"gradientLayer"

//BankSDK
#define MINIMUM_TIME_BETWEEN_EACH_POLL 0.5
#define MINIMUM_TIME_BEFORE_FIRST_POLL_CALL 1.0

#define kBankSDKStatusAvailableForPayment @"AVAILABLE_FOR_PAYMENT"
#define kBankSDKStatusPaid @"PAID"
#define kBankSDKStatusPaidAndChecked @"PAID_AND_CHECKED"
#define kBankSDKStatusCancelled @"CANCELLED"
#define kBankSDKStatusErrorDuringGetInvoice @"ERROR_DURING_GET_INVOICE"
#define kBankSDKStatusOutdated @"OUTDATED"

@class SDKFlashizFacade;

@interface PaymentCheckViewController () <LoyaltyProgramDetailsViewControllerDelegate>

//View
@property (retain, nonatomic) IBOutlet UIImageView *receiverIcon;
@property (retain, nonatomic) IBOutlet UIView *viewAmountAndDescription;
@property (retain, nonatomic) IBOutlet UIImageView *receiverIconSmall;
@property (retain, nonatomic) IBOutlet UILabel *receiver;
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UIScrollView *couponsScrollView;

@property (retain, nonatomic) IBOutlet UIButton *tipsButton;
@property (retain, nonatomic) IBOutlet UIButton *tipsLabelButton;

@property (retain, nonatomic) IBOutlet UIButton *cancelLabelButton;

@property (retain, nonatomic) IBOutlet UILabel *lblPercentageDiscount;

@property (retain, nonatomic) IBOutlet UIView *viewAccountBanner;

@property (retain, nonatomic) IBOutlet UILabel *bonsLabel;

@property (retain, nonatomic) CircleProgress *cpBackground;
@property (retain, nonatomic) CAShapeLayer *arc;

@property (retain, nonatomic) IBOutlet CoreTextArcView *tipsCoreTextArcView;
@property (retain, nonatomic) IBOutlet UIView *tipsView;
@property (retain, nonatomic) IBOutlet UIButton *btnClose;
@property (assign, nonatomic) IBOutlet ODCustomAlertView *myAlertViewRewards;
@property (retain, nonatomic) IBOutlet UILabel *lblIncludeRewardsAndTip;

//ViewBankSdk
@property (retain, nonatomic) IBOutlet UIButton *btnPayTextBankSdk;

@property (retain, nonatomic) IBOutlet UIView *viewCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblNbOfCoupons;

- (IBAction)cancelTransaction:(id)sender;

//Model
@property (assign, nonatomic) FZTarget currentTarget;

@property (retain, nonatomic) Invoice *originalInvoice;
@property (retain, nonatomic) CorrectedInvoice *correctedInvoice;
@property (retain, nonatomic) NSMutableArray *selectedCoupons;

@property (nonatomic, assign) BOOL isCouponsListScrollViewAnimationDone;
@property (nonatomic, retain) NSMutableArray *couponList;

@property (nonatomic, assign) BOOL invoiceAlreadyPaid;
@property (nonatomic, assign) BOOL errorAlreadyDisplayed;
@property (nonatomic, assign) BOOL noLoadingView;
@property (nonatomic, assign) BOOL isTippingActivated;

//Util
@property (nonatomic, assign) NSInteger nbOptimalOfUsableCoupons;
@property (nonatomic, assign) double tipAmount;

@property (nonatomic, retain) UIAlertView *alertViewError;

//BankSDK properties
@property (nonatomic, assign) BOOL paymentChecked;
@property (nonatomic, assign) BOOL requestIsRunning;
@property (nonatomic) double timeBetweenEachPollCall;
@property (nonatomic) double timeBeforeFirstPollCall;
@property (assign, nonatomic) NSTimer *timerBeforeStartingPoll;
@property (assign, nonatomic) NSTimer *timerPayInvoicePoll;

@property (assign, nonatomic) int nbOfUsedCoupons;
#define couponShift 5;

#warning TODO: to be opimized -> check the workflow to know how this boolean is needed
@property (assign,nonatomic) BOOL boltAdded;

@end

@implementation PaymentCheckViewController

@synthesize payButton;
@synthesize payButtonBankSDK;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"PaymentCheckViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if (self) {
        
        _currentTarget = [[FZTargetManager sharedInstance] mainTarget];
        
        if (_currentTarget != FZBankSDKTarget) {
            _accountBanner = [[[self multiTargetManager] accountBannerViewController] retain];
            [[_accountBanner btnGoToOrCloseHistoric] setHidden:YES];
            
            //add a white transparent view to the account banner
            UIView *whiteView = [[UIView alloc] init];
            [whiteView setFrame:[[_accountBanner view] frame]];
            [whiteView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.75f]];
            
            [[_accountBanner view] addSubview:whiteView];
            
            [whiteView release];
            
            [self addChildViewController:_accountBanner];
        }
        
        _nbOptimalOfUsableCoupons = 0;
        _isCouponsListScrollViewAnimationDone = NO;
        _couponList = [[NSMutableArray alloc] init];
        _invoiceAlreadyPaid = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        //bankSDK
        _paymentChecked = NO;
        _requestIsRunning = NO;
        
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        //Manage timers
        if([facade respondsToSelector:@selector(timeBetweenEachPollCall)]){
            if(([facade timeBetweenEachPollCall]/1000) >= MINIMUM_TIME_BETWEEN_EACH_POLL){
                [self setTimeBetweenEachPollCall:([facade timeBetweenEachPollCall]/1000)];
            }
            else{
                [self setTimeBetweenEachPollCall:MINIMUM_TIME_BETWEEN_EACH_POLL];
            }
        }
        if([facade respondsToSelector:@selector(timeBeforeStartingPoll)]){
            if(([facade timeBeforeStartingPoll]/1000) >= MINIMUM_TIME_BEFORE_FIRST_POLL_CALL){
                [self setTimeBeforeFirstPollCall:([facade timeBeforeStartingPoll]/1000)];
            }
            else{
                [self setTimeBeforeFirstPollCall:MINIMUM_TIME_BEFORE_FIRST_POLL_CALL];
            }
        }
        [self setCanDisplayMenu:NO];
    }
    return self;
}

-(id<FlashizFacadeDelegate>)delegateFixMe
{
    return [[FZTargetManager sharedInstance] delegateSDK];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:[NSString stringWithFormat:@"time between first call is : %.f second(s)",_timeBeforeFirstPollCall]];
    [[[FZTargetManager sharedInstance] facade] showDebugLog:[NSString stringWithFormat:@"time between each call is : %.f second(s)",_timeBetweenEachPollCall]];
    
    [self setTitleHeader:[LocalizationHelper stringForKey:@"paymentHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundlePayment]];
    [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
    [self setBackgroundColor:[[ColorHelper sharedInstance] paymentCheckViewController_header_backgroundColor]];
    
    [self setSelectedCoupons:[NSMutableArray arrayWithCapacity:3]];
    
    [self setNoLoadingView:NO];
    
    [self getInvoiceDetailsPreProcessing:NO];
    
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Show pay invoice viewController"];
    
    if(!_noLoadingView) { //no need to setup again the view when we come back from edit tip
        [self setupView];
    }
}

- (void)getInvoiceDetailsPreProcessing:(BOOL)animated {
    [[_accountBanner btnGoToOrCloseHistoric] setHidden:YES];
    
    [self getInvoiceDetails];
}

#pragma mark - Notifications methods

//Used only with the SDK
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    
    //needed ? (remove to solve : FLI-659)
    /*
    if(_currentTarget == FZBankSDKTarget || _currentTarget == FZSDKTarget) {
        if (self.isViewLoaded && self.view.window) {
            [[self payButtonBankSDK] setImage:nil forState:UIControlStateNormal];
            _boltAdded = NO;
            [self startLoadingView];
            [self getInvoiceDetailsPreProcessing:YES];
        }
    }
     */
}

#pragma mark - Setup view

-(void)setupView {
    
    [[self amount] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:45.0f]];
    
    //account banner
    if(_currentTarget != FZBankSDKTarget) {
        [[self viewAccountBanner] addSubview:[_accountBanner view]];
        [self addChildViewController:_accountBanner];
    }
    
    //background color
    //set gradient color
    CAGradientLayer *grLayer = [CAGradientLayer layer];
    CGRect currentRect = [[[self viewDetails] layer] bounds];
    
    [grLayer setFrame:CGRectMake(currentRect.origin.x, currentRect.origin.y, currentRect.size.width, currentRect.size.height+50)];
    
    UIColor *color1     = [[ColorHelper sharedInstance] pinViewController_gradient_top];
    UIColor *color2     = [[ColorHelper sharedInstance] pinViewController_gradient_bottom];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)[color1 CGColor],(id)[color2 CGColor],nil];
    
    [grLayer setColors:colors];
    
    NSNumber *stop1  = [NSNumber numberWithFloat:0.2];
    NSNumber *stop2  = [NSNumber numberWithFloat:0.8];
    
    NSArray *locations = [NSArray arrayWithObjects:stop1,stop2,nil];
    
    [grLayer setLocations:locations];
    //assign gradient to the view
    [[[self viewDetails] layer] insertSublayer:grLayer atIndex:0];
    
    // set a background :D? Why are using a gradient :D?!!!
    
    //[[self viewDetails] setBackgroundColor:[[ColorHelper sharedInstance] paymentCheckViewController_view_backgroundColor]];
    
    //pay button, border and round
    [[payButton layer] setBorderColor:[[[ColorHelper sharedInstance] paymentCheckViewController_payButton_borderColor] CGColor]];
    [[payButton layer] setBorderWidth:5.0];
    [[payButton layer] setCornerRadius:payButton.frame.size.width/2];
    
    //prevent the case when the text is too long
    [[payButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[payButton titleLabel] setMinimumScaleFactor:0.5];
    [payButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    //cancel payment button
    [_btnClose setImage:[FZUIImageWithImage imageNamed:@"x_entoure" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
    
    if(_currentTarget != FZBankSDKTarget) {
        //round the scroll view
        [[_couponsScrollView layer] setCornerRadius:[self couponHeight]/2];
        [_couponsScrollView setHidden:NO];
        
        [_receiverIcon setImage:[FZUIImageWithImage imageNamed:@"icon_pin_receiver" inBundle:FZBundlePayment]];
        
    } else {//customized the view for the BankSDK
        //hide the scrollview
        [_couponsScrollView setHidden:YES];
        
        [_receiverIcon setImage:[FZUIImageWithImage imageNamed:@"icon_pin_receiver_big" inBundle:FZBundlePayment]];
        [_receiverIconSmall setImage:[FZUIImageWithImage imageNamed:@"icon_pin_receiver" inBundle:FZBundlePayment]];
        
        NSString *title = [LocalizationHelper stringForKey:@"paymentCheckViewController_pay" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
        
        [[self btnPayTextBankSdk] setTitle:[title uppercaseString] forState:UIControlStateNormal];
        [[[self btnPayTextBankSdk] titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:26.0f]];
        [[self btnPayTextBankSdk] setEnabled:NO];
        
        [[self receiver]setFont:[[FontHelper sharedInstance] fontHelveticaNeueLightWithSize:20.0f]];
        
        _nbOfUsedCoupons = 0;
    }
    
    //hide the couponsView an the number of coupons
    [_viewCoupons setHidden:YES];
    [_lblNbOfCoupons setHidden:YES];
    
    //Tips
    [_tipsButton setImage:[FZUIImageWithImage imageNamed:@"tip_button" inBundle:FZBundlePayment] forState:UIControlStateNormal];
    [[self tipsLabelButton] setTitle:[[LocalizationHelper stringForKey:@"paymentCheckViewController_btn_tip" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[[self tipsLabelButton] titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20.0f]];
    [[self tipsLabelButton] setEnabled:NO];
    
    //Cancel button
    [[self cancelLabelButton] setTitle:[[LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] uppercaseString] forState:UIControlStateNormal];
    [[[self cancelLabelButton] titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20.0f]];
    [[self cancelLabelButton] setEnabled:NO];
    
    //Include tip and rewards
    [[self lblIncludeRewardsAndTip] setNumberOfLines:2];
    [[self lblIncludeRewardsAndTip] setTextAlignment:NSTextAlignmentRight];
    [[self lblIncludeRewardsAndTip] setFont:[[FontHelper sharedInstance] fontHelveticaNeueLightWithSize:20.0f]];
    
    [self startLoadingView];
}

#pragma mark - Animations

- (void)startLoadingView {
    //hide text
    [payButton setTitle:@"" forState:UIControlStateNormal];
    
    //element to show when bill is loaded
    [_receiverIcon setHidden:YES];
    [_receiverIconSmall setHidden:YES];
    [_tipsView setHidden:YES];
    [_btnClose setEnabled:NO];
    [_tipsButton setEnabled:NO];
    
    CGPoint center = payButton.center;
    [self startLoadingAnimationAtPosition:center withBorderColor:[UIColor whiteColor]];
}

- (void)startLoadingAnimationAtPosition:(CGPoint)center withBorderColor:(UIColor *)borderColor {
    
    [payButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    //hide the bolt
    if (_currentTarget == FZBankSDKTarget) {
        [self hideBoltToPayButton];
    }
    
    //loader
    int strokeLine = 6;
    
    //draw progress points bar circle background
    [_cpBackground removeFromSuperlayer];
    [_cpBackground release];
    _cpBackground = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[borderColor colorWithAlphaComponent:0.7f] radius:payButton.frame.size.width/4-strokeLine/2 lineWidth:strokeLine];
    [_cpBackground drawCircleFromAngle:0 toAngle:360 withDuration:0 inLayer:[payButton layer]];
    
    //draw half arc
    [_arc removeFromSuperlayer];
    [_arc release];
    _arc = [[CAShapeLayer alloc] init];
    [_arc setPath:[UIBezierPath bezierPathWithArcCenter:center radius:payButton.frame.size.width/4-strokeLine/2 startAngle:0 endAngle:M_PI clockwise:NO].CGPath ];
    [_arc setFillColor:[[UIColor clearColor] CGColor]];
    [_arc setStrokeColor:[borderColor CGColor]];
    [_arc setLineWidth:strokeLine];
    
    CGRect arcBounds = CGPathGetBoundingBox(_arc.path);
    arcBounds.origin.x -= 25;
    arcBounds.origin.y -= 26;
    [_arc setBounds:arcBounds];
    
    [_arc setFrame:[payButton bounds]];
    
    //rotation
    float duration = 1.5;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:duration];
    [animation setRepeatCount:HUGE_VALF];
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:2 * M_PI]];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [_arc addAnimation:animation forKey:animation.keyPath];
    
    [[payButton layer] addSublayer:_arc];
}

- (CGPoint)customCenterOrCenter:(CGPoint)center {
    return center;
}

- (void) startPPDAnimation {
    if(!_noLoadingView /*&& _currentTarget != FZBankSDKTarget*/) { //no need to setup again the view when we come back from edit tip
        NSInteger strokeLine = 4;
        
        CGPoint center = _lblPercentageDiscount.center;
        
        if(_currentTarget != FZBankSDKTarget) {
            [_lblPercentageDiscount setFrame:CGRectMake(_lblPercentageDiscount.frame.origin.x, _amount.frame.origin.y + _amount.frame.size.height/4, _lblPercentageDiscount.frame.size.width, _lblPercentageDiscount.frame.size.height)];
        }
        
        // Make a circular shape
        CAShapeLayer *discountPercent = [[CAShapeLayer alloc] initWithLayer:[CALayer layer]];
        CGFloat radius = _amount.frame.size.height/1.5-strokeLine/2;
        
        discountPercent.path = [UIBezierPath bezierPathWithArcCenter: center radius:radius startAngle:0 endAngle:M_PI*360/180 clockwise:NO].CGPath;
        
        // Configure the apperence of the circle
        discountPercent.fillColor = [UIColor clearColor].CGColor;
        discountPercent.strokeColor = [UIColor whiteColor].CGColor;
        discountPercent.lineWidth = strokeLine;
        
        [discountPercent setBounds:CGPathGetBoundingBox(discountPercent.path)];
        
        if(_currentTarget == FZBankSDKTarget) {
          /*
            CGRect lblPercentageDiscountFrame = [_lblPercentageDiscount frame];
            lblPercentageDiscountFrame.origin.y = [payButtonBankSDK frame].origin.y - radius - 20 /*marge between PPD and the pay button;
            [_lblPercentageDiscount setFrame:lblPercentageDiscountFrame];*/
            
            [discountPercent setFrame:CGRectMake(_lblPercentageDiscount.frame.origin.x - 12.0, _lblPercentageDiscount.frame.origin.y - 20, radius, radius)];
        } else {
            [discountPercent setFrame:CGRectMake(_lblPercentageDiscount.frame.origin.x - 12.0, _amount.frame.origin.y + _amount.frame.size.height/2 - radius - 2.0, radius, radius)];
        }
        
        // Configure animation
        CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        drawAnimation.duration            = 0.5;
        drawAnimation.repeatCount         = 1.0;
        drawAnimation.removedOnCompletion = NO;
        
        // Animate from no part of the stroke being drawn to the entire stroke being drawn
        drawAnimation.fromValue = [NSNumber numberWithFloat:10.0f];
        drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
        drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [drawAnimation setValue:@"drawCirclePercentDiscountName" forKey:@"name"];
        drawAnimation.delegate = self;
        
        // Add the animation to the circle
        [discountPercent addAnimation:drawAnimation forKey:@"drawCirclePercentDiscount"];
        [[[_amount layer] superlayer] addSublayer:discountPercent];
        
        [discountPercent release];
    } else if (_currentTarget == FZBankSDKTarget) {
        [self displayInvoiceAmountForInvoice:[self correctedInvoice]];
    } else {
        //do nothing
    }
}

- (void)startCouponsListScrollViewAnimation {
    if(!_isCouponsListScrollViewAnimationDone && _currentTarget != FZBankSDKTarget) {
        [_couponsScrollView setContentOffset:CGPointMake([self couponWidth]*[[[self correctedInvoice] couponList] count],0)];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_couponsScrollView setContentOffset:CGPointMake(0,0)];
        } completion:^(BOOL finished){
            _isCouponsListScrollViewAnimationDone = YES;
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"name"] isEqualToString:@"drawCirclePercentDiscountName"]){
        [_lblPercentageDiscount setHidden:NO];
        [_lblPercentageDiscount setText:[[CurrenciesManager currentManager] formattedPercentLight:[NSString stringWithFormat:@"-%.2f",[[self currentInvoice] permanentPercentageDiscount]]]];
        
        [_lblPercentageDiscount setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:14.0f]];
        [_lblPercentageDiscount setTextColor:[UIColor whiteColor]];
        [_lblPercentageDiscount setBackgroundColor:[UIColor clearColor]];
        
        //clone the amount label for the animation
        UILabel *amountGhost = [[UILabel alloc] initWithFrame:_amount.frame];
        
        if(_currentTarget == FZBankSDKTarget) {
            [amountGhost setText:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%d",(int)roundf([(Invoice *)[self currentInvoice] amount])] currency:[[self currentInvoice] currency]]];
        } else {
            [amountGhost setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[(Invoice *)[self currentInvoice] amount]] currency:[[self currentInvoice] currency]]];
        }
        
        
        [amountGhost setTextAlignment:NSTextAlignmentCenter];
        [amountGhost setFont:[_amount font]];
        [amountGhost setTextColor:[_amount textColor]];
        [amountGhost setBackgroundColor:[UIColor clearColor]];
        [[_amount superview] addSubview:amountGhost];
        
        amountGhost.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [self displayInvoiceAmountForInvoice:[self correctedInvoice]];
        
        //animation scale and alpha
        [UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            amountGhost.transform = CGAffineTransformMakeScale(1.5, 1.5);
            amountGhost.alpha = 0;
        } completion:^(BOOL finished){
            [amountGhost removeFromSuperview];
            [amountGhost release];
        }];
    }
}

-(void) stopLoadingAnimation {
    //remove loader
    [_arc removeFromSuperlayer];
    [_arc release];
    _arc = nil;
    [_cpBackground removeFromSuperlayer];
    [_cpBackground release];
    _cpBackground = nil;
    
    //show text
    // Toggle pay button label
    if(![[self currentInvoice] isCredit]) {
        if ([self shouldRefill]){
            NSString *title = [LocalizationHelper stringForKey:@"paymentCheckViewController_refill" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
            [[self payButton] setTitle:[title uppercaseString] forState:UIControlStateNormal];
            
            [[payButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
        } else {
            if(_currentTarget == FZBankSDKTarget){ //add bolt for bankSDK
                [self addBoltToPayButton];
            } else {
                NSString *title = [LocalizationHelper stringForKey:@"paymentCheckViewController_pay" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
                
                [payButton setTitle:[title uppercaseString] forState:UIControlStateNormal];
                [[payButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:22.0f]];
            }
        }
    } else {
        NSString *title = [LocalizationHelper stringForKey:@"accept" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment];
        
        [payButton setTitle:[title uppercaseString] forState:UIControlStateNormal];
        
        [[payButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
    }
    
    //show hidden element
    [_receiverIcon setHidden:NO];
    [_receiverIconSmall setHidden:NO];
    [_btnClose setEnabled:YES];
    [_tipsButton setEnabled:YES];
    
    NSString *tipsTextMessage = [LocalizationHelper stringForKey:@"paymentCheckViewController_tips" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
    
    [_tipsCoreTextArcView setShiftV:10.0];
    [_tipsCoreTextArcView setShiftH:-1.5];
    [_tipsCoreTextArcView setArcSize:[tipsTextMessage length]*(50/3)];
    [_tipsCoreTextArcView setRadius:18.5];
    
    [_tipsCoreTextArcView setFont:[[FontHelper sharedInstance] fontHelveticaNeueLightWithSize:10.0f]];
    [_tipsCoreTextArcView setColor:[UIColor whiteColor]];
    [_tipsCoreTextArcView setText:tipsTextMessage];
    
    [payButton setTitleColor:[[ColorHelper sharedInstance] paymentCheckViewController_payButton_titleColor] forState:UIControlStateNormal];
}

- (void)stopLoadingView {
    
    [self stopLoadingAnimation];
    
    [self addGradientToPayButton];
    
}

- (UIColor *)payButtonGradientTwoWithAlpha {
    return [[ColorHelper sharedInstance] payButtonGradientTwoWithAlpha:0.4f];
}

- (void)payButtonCustomColor {
    //do nothing for Flashiz
}

- (void)addGradientToPayButton {
    //wave animation for pay button
    CAGradientLayer *layer = [CAGradientLayer layer];
    [layer setFrame:payButton.layer.bounds];
    
    UIColor *color1     = [[ColorHelper sharedInstance] payButtonGradientOne];
    UIColor *color2     = [self payButtonGradientTwoWithAlpha];
    UIColor *color3     = [[ColorHelper sharedInstance] payButtonGradientThree];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)[color1 CGColor],(id)[color2 CGColor],(id)[color3 CGColor],nil];
    NSArray *colors3 =  [[colors reverseObjectEnumerator] allObjects];
    
    [layer setColors:colors];
    
    NSNumber *stop1  = [NSNumber numberWithFloat:0.0];
    NSNumber *stop2  = [NSNumber numberWithFloat:0.5];
    NSNumber *stop3  = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stop1,stop2,stop3,nil];
    
    [layer setLocations:locations];
    [layer setCornerRadius:payButton.frame.size.width/2];
    
    float duration = 1.5;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setAutoreverses:YES];
    [animation setFromValue:colors];
    [animation setToValue:colors3];
    [animation setDuration:duration];
    [animation setRemovedOnCompletion:NO];
    [animation setRepeatCount:HUGE_VALF];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [layer addAnimation:animation forKey:@"animateGradient"];
    
    [layer setName:kGradientLayername];
    
    [[[self payButton] layer] insertSublayer:layer atIndex:0];
}

- (void)addBoltToPayButton {
    
    if(!_boltAdded) {
        
        [payButtonBankSDK setImage:[FZUIImageWithImage imageNamed:@"bolt_white" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
        [payButtonBankSDK setImageEdgeInsets:UIEdgeInsetsMake(20, 35, 20, 35)];
        
        [payButton setTitle:@"" forState:UIControlStateNormal];
        
        
        payButtonBankSDK.transform = CGAffineTransformMakeScale(2.0, 2.0);
        payButtonBankSDK.alpha = 0.0;
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             payButtonBankSDK.transform = CGAffineTransformMakeScale(0.8, 0.8);
                             payButtonBankSDK.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             
                             payButtonBankSDK.alpha = 1.0;
                             [UIView animateWithDuration:0.2
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  payButtonBankSDK.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              } completion:^(BOOL finished) {
                                                  
                                              }];
                         }];
        
        [self addGradientToPayButton];
        
        _boltAdded = YES;
    }
}

- (void)hideBoltToPayButton {
    [payButtonBankSDK setImage:nil forState:UIControlStateNormal];
    _boltAdded = NO;
}

- (void)closeAnimationBoltPayButton {
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         payButtonBankSDK.transform = CGAffineTransformMakeRotation(3.0);
                         payButtonBankSDK.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Maintain view state

- (void)addCouponsWithCouponList:(NSArray *)aCouponList {
    //clean coupons
    [[[self couponsScrollView] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [[[self viewCoupons] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // add coupons
    if ([aCouponList count] > 0){
        //coupons
        
        NSString *labelText = [LocalizationHelper stringForKey:@"paymentCheckViewController_use_bon" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
        
        [[self bonsLabel] setText:[labelText uppercaseString]];
        
        [[self bonsLabel] setAdjustsFontSizeToFitWidth:YES];
        [[self bonsLabel] setMinimumScaleFactor:0.5];
        
        
        LoyaltyCoupon *sampleCoupon = [aCouponList objectAtIndex:0];
        
        if ([LoyaltyCoupon isCouponTypeCash:sampleCoupon]){
            [self displayCoupons:YES withCouponList:aCouponList];
        } else {
            [self displayCoupons:NO withCouponList:aCouponList];
        }
    }
    
    //Debug
    //[[self viewCoupons] setBackgroundColor:[UIColor yellowColor]];
    //[[self couponsScrollView] setBackgroundColor:[UIColor greenColor]];
}

- (NSArray *)currentCouponList {
    return [[self correctedInvoice] couponList];
}

-(void)refreshFields{
    if ([self correctedInvoice]){
        
        if(_currentTarget == FZSDKTarget) {
            // refresh account
            [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
                [[UserSession currentSession] setUser:context];
            } failureBlock:^(Error *error) {
                FZPaymentLog(@"error while retrieving user infos");
                
                if(_currentTarget != FZBankSDKTarget) {
                    UIAlertView *alertView = [self displayAlertForError:error];
                    [alertView setDelegate:self];
                } else {
                    if([error errorCode] == 1000) {
                        [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
                    }
                    
                    [self presentActionViewControllerWithTitle:[error localizedError] andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
                }
            }];
        }
        
        // update UI
        
        //set merchant name
        [[self receiver] setText:[[self correctedInvoice] otherName]];
        
        if (_currentTarget == FZBankSDKTarget) {
            //adjust the label
            [[self receiver] sizeToFit];
            //center the label into the view
            //get the frame
            CGRect receiverFrame = [[self receiver] frame];
            //get the screen width
            CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
            //adjust the frame
            receiverFrame.origin.x = screenWidth/2 - receiverFrame.size.width/2;
            //set the new frame
            [[self receiver] setFrame:receiverFrame];
            
            //put the receiver icon next to the merchant name if the screen has a 3,5" size
            /*if (![ODDeviceUtil isAnIphoneFive]) {
                //raise the viewAmountAndDescription
                //get the frame
                CGRect viewAmountAndDescriptionFrame = [[self viewAmountAndDescription] frame];
                //adjust the frame
                viewAmountAndDescriptionFrame.origin.y = 35;
                //set the frame
                [[self viewAmountAndDescription] setFrame:viewAmountAndDescriptionFrame];
                
                //hide the big icon
                [[self receiverIcon] setImage:nil];
                
                //put the icon next to the merchant name
                //get the frame
                CGRect receiverSmallFrame = [[self receiverIconSmall] frame];
                CGRect newReceiverFrame = [[self receiver] frame];
                //adjust the frame
                float spaceBetweenMerchantNameAndIcon = 11.0; //space between the merchant name and the icon
                float receiverSmallFrameX = newReceiverFrame.origin.x - receiverSmallFrame.size.width - spaceBetweenMerchantNameAndIcon;
                receiverSmallFrame.origin.x = (receiverSmallFrameX > 20.0) ? receiverSmallFrameX : 20.0;
                receiverSmallFrame.origin.y = newReceiverFrame.origin.y + [self receiver].font.ascender - receiverSmallFrame.size.height;
                //set the new frame
                [[self receiverIconSmall] setFrame:receiverSmallFrame];
                
                //adjust the brand name according to the icon
                receiverFrame = [_receiver frame];
                receiverFrame.origin.x = receiverSmallFrame.origin.x + receiverSmallFrame.size.width + spaceBetweenMerchantNameAndIcon;
                receiverFrame.size.width = screenWidth - receiverFrame.origin.x - 20;
                [_receiver setFrame:receiverFrame];
                
                [_receiver setAdjustsFontSizeToFitWidth:YES];
                [_receiver setMinimumScaleFactor:0.5];
                
            } else {*/
                //hide the small icon
                [[self receiverIconSmall] setImage:nil];
            /*}*/
        }
		
        if([[self currentInvoice] permanentPercentageDiscount] > 0 && [[self correctedInvoice] hasLoyaltyCard] && ([[self originalInvoice] amount] >=[[[self originalInvoice]currentLoyaltyProgram]minTransAmountForDiscount])){
            
            [self displayInvoiceAmountForInvoice:[self currentInvoice]];
            
            [self startPPDAnimation];
        } else {
            [_lblPercentageDiscount setHidden:YES];
            
            [self displayInvoiceAmountForInvoice:[self correctedInvoice]];
        }
        
        [self manageAutoTopUpDisplay];
        
        // add coupons and nbOfCoupons' label
        if(_currentTarget == FZBankSDKTarget && [[self currentCouponList] count] > 0) {
            
            [_bonsLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20.0]];
            
	    [[self bonsLabel] setAdjustsFontSizeToFitWidth:YES];
            CGRect viewCouponFrame = [_viewCoupons frame];
            CGRect bonsLabelFrame = [_bonsLabel frame];
            viewCouponFrame.size.height = bonsLabelFrame.size.height + couponShift;
            viewCouponFrame.origin.y = bonsLabelFrame.origin.y - couponShift;
            
            [_viewCoupons setFrame:viewCouponFrame];
            [_viewCoupons setBackgroundColor:[UIColor clearColor]];
            
            [_viewCoupons setHidden:NO];
            
            int nbOfCouponsAvailable = (int)[[[self correctedInvoice] couponList] count];
            if(nbOfCouponsAvailable > 1) {
                CGRect lblNbOfCouponsFrame = [_lblNbOfCoupons frame];
                CGRect viewCouponsFrameTwo = [_viewCoupons frame];
                lblNbOfCouponsFrame.origin.y = viewCouponsFrameTwo.origin.y + viewCouponsFrameTwo.size.height - lblNbOfCouponsFrame.size.height + 2 + couponShift;
                lblNbOfCouponsFrame.origin.x = viewCouponsFrameTwo.origin.x + viewCouponsFrameTwo.size.width + 10;
                [_lblNbOfCoupons setFrame:lblNbOfCouponsFrame];
                
                [_lblNbOfCoupons setText:[NSString stringWithFormat:@"X %d",nbOfCouponsAvailable]];
                [_lblNbOfCoupons setHidden:NO];
            } else {
                [_lblNbOfCoupons setHidden:YES];
            }
        }
        
        [self addCouponsWithCouponList:[self currentCouponList]];
        
        // Toggle pay button label
        if ([self shouldRefill]){
            
            NSString *payButtonText = [LocalizationHelper stringForKey:@"paymentCheckViewController_refill" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
            
            [payButton setTitle:[payButtonText uppercaseString] forState:UIControlStateNormal];
            
            [[payButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
        } else {
            if(_currentTarget == FZBankSDKTarget){ //add bolt for bankSDK
                [self addBoltToPayButton];
            } else {
                NSString *payButtonText = [LocalizationHelper stringForKey:@"paymentCheckViewController_pay" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
                
                [payButton setTitle:[payButtonText uppercaseString] forState:UIControlStateNormal];
                [[payButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:22.0f]];
            }
        }
    } else if([[self currentInvoice] isCredit]) {
        [self stopLoadingAnimation];
        
        // update UI
        self.receiver.text = [[self currentInvoice] otherName];
        
        [_lblPercentageDiscount setHidden:YES];
        
        self.amount.text = [NSString stringWithFormat:@"+ %@",[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[(Invoice *)[self currentInvoice] amount]] currency:[[self correctedInvoice] currency]]];
        
        NSString *payButtonText = [LocalizationHelper stringForKey:@"accept" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment];
        
        [payButton setTitle:[payButtonText uppercaseString] forState:UIControlStateNormal];
        
        [[payButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
    }
    FZPaymentLog(@"Refresh done");
}

- (void)displayInvoiceAmountForInvoice:(Invoice *)anInvoice {
    
    //Add Tip to the invoice amount
    double invoiceAmountWithTipInside = [anInvoice amount] + _tipAmount;
    
    NSString *currency = [anInvoice currency];
    
    //Display the amount
    if(_currentTarget != FZBankSDKTarget) {
        [[self amount] setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",invoiceAmountWithTipInside] currency:currency]];
    } else {
        [[self amount] setText:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%d",(int)roundf(invoiceAmountWithTipInside)] currency:currency]];
    }
    
    //adjust the label
    [[self amount] sizeToFit];
    //center the label into the view
    //get the frame
    CGRect amountFrame = [[self amount] frame];
    //get the screen width
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    //adjust the frame
    amountFrame.origin.x = screenWidth/2 - amountFrame.size.width/2;
    //set the new frame
    [[self amount] setFrame:amountFrame];
    
    //update rewards and tip
    [self updateRewards:[[self correctedInvoice] discount] andTipDisplay:_tipAmount];
}

- (void)manageAutoTopUpDisplay {
    if([[self correctedInvoice] withRefill] && [[self correctedInvoice] numberOfRefill] > 0 ){
        
        float refillAmount = [[self correctedInvoice] amountOfRefill];
        
        NSString *refillAmountString = [[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",refillAmount] currency:[[self correctedInvoice] currency]];
        
        [_refillLabel setText:[NSString stringWithFormat:[LocalizationHelper stringForKey:@"paymentCheckViewController_autorefill_of" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment], refillAmountString]];
        
        [_refillLabel setHidden:NO];
    } else{
        [_refillLabel setHidden:YES];
    }
}

/*
 Display the coupons in the scrollview or in the viewCoupons (for the BankSDK)
 */
- (void)displayCoupons:(BOOL)all withCouponList:(NSArray *)aCouponList{
    
    if (all){ //COUPON_TYPE_CASH (add all coupons)
        
        [[self couponsScrollView] setContentSize:CGSizeMake([aCouponList count]*[self couponWidth] + [aCouponList count]*[self margin], [self couponHeight])];
        
        [aCouponList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            LoyaltyCoupon *coupon = (LoyaltyCoupon *)obj;
            
            float x = idx*[self couponWidth] + [self margin]*idx;
            UIButton *couponButton = [self couponButtonWithCoupon:coupon frame:CGRectMake(x, 0.0, [self couponWidth], [self couponHeight]) andTag:[self customTagFromTag:idx]];
            
            [_couponList addObject:couponButton];
            [self addCoupons:couponButton];
        }];
    } else { //COUPON_TYPE_PERCENT (add only the first)
        
        [[self couponsScrollView] setContentSize:CGSizeMake([self couponWidth], [self couponHeight])];
        LoyaltyCoupon *coupon = [aCouponList objectAtIndex:0];
        
        UIButton *couponButton = [self couponButtonWithCoupon:coupon frame:CGRectMake([self couponWidth], 0.0, [self couponWidth], [self couponHeight]) andTag:0];
        [couponButton setTag:[self customTagFromTag:0]];
        
        [self addCoupons:couponButton];
    }
    [self startCouponsListScrollViewAnimation];
}

/*
 Add the coupons in the scrollview or in the viewCoupons (for the BankSDK)
 */
- (void)addCoupons:(UIButton *)couponButton {
    
    if(_currentTarget != FZBankSDKTarget) { //add into the scrollview
        [[self couponsScrollView] addSubview:couponButton];
    } else {
        //design the button here
        
        CGRect viewCouponFrame = [_viewCoupons frame];
        CGRect couponButtonFrame = CGRectMake(0,0,viewCouponFrame.size.width, viewCouponFrame.size.height);
        
        if([_couponList count] > 1 && [self tagFromCustomTag:[couponButton tag]] != 0 ) {
            couponButtonFrame.origin.x += couponShift;
            couponButtonFrame.origin.y += couponShift;
        }
        
        [couponButton setFrame:couponButtonFrame];
        [couponButton setTitleColor:[[ColorHelper sharedInstance] mainOneColor] forState:UIControlStateNormal];//xxx
        
        [couponButton setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];//xxx
        
        [[couponButton layer] setCornerRadius:5.0];
        [[couponButton layer] setBorderWidth:1.0];
        //TODO: get the right border color
        [[couponButton layer] setBorderColor:[[ColorHelper sharedInstance] mainOneColor].CGColor];//xxx
        
        if ([self tagFromCustomTag:[couponButton tag]] != 0) { //clean background button's text
            [couponButton setTitle:@"" forState:UIControlStateNormal];
        } else { //keep the text of the first coupon
            [couponButton setTitle:[[couponButton titleLabel] text] forState:UIControlStateNormal];
        }
        
        [[couponButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:20.0]];
        
        if([[_viewCoupons subviews] count] > 0) {
            [_viewCoupons insertSubview:couponButton belowSubview:[[_viewCoupons subviews] lastObject]];
        } else {
            [_viewCoupons addSubview:couponButton];
        }
    }
}

-(UIButton *) couponButtonWithCoupon:(LoyaltyCoupon *)coupon frame:(CGRect)frame andTag:(NSInteger)tag{
    
    UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponButton addTarget:self action:@selector(didTapCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
    [couponButton setTag:tag];
    
    if(_currentTarget != FZBankSDKTarget){
        
        if ([coupon couponType] == COUPON_TYPE_CASH){
            
            [couponButton setTitle:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.2f",[coupon amount]] currency:[coupon currency]] forState:UIControlStateNormal];
        } else {
            
            [couponButton setTitle:[[CurrenciesManager currentManager] formattedPercentLight:[NSString stringWithFormat:@"%.2f",[coupon amount]]] forState:UIControlStateNormal];
        }
        [couponButton setFrame:frame];
        
        [[couponButton layer] setCornerRadius:couponButton.frame.size.width/2];
    } else {
        
        if ([coupon couponType] == COUPON_TYPE_CASH){
            
            [couponButton setTitle: [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.2f",[coupon amount]]] forState:UIControlStateNormal];
        } else {
            
            [couponButton setTitle:[[CurrenciesManager currentManager] formattedPercentLight:[NSString stringWithFormat:@"%.2f",[coupon amount]]] forState:UIControlStateNormal];
        }
    }
    
    [[couponButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:16.0f]];
    
    return couponButton;
}

-(void)didTapCoupon:(id)sender{
    
    [self startLoadingAnimationAtPosition:payButton.center withBorderColor:[UIColor whiteColor]];
    
    UIButton *couponButton = (UIButton *)sender;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{//animation pop coupon
        if(_currentTarget != FZBankSDKTarget) { //animate only if your not in the BankSDK
            couponButton.transform = CGAffineTransformMakeScale(0, 0);
            couponButton.alpha = 0;
        }
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{//animation translate coupons
            if(_currentTarget != FZBankSDKTarget) { //animate only if your not in the BankSDK
                for(UIButton *couponButtonInTheList in _couponList){
                    if([couponButtonInTheList tag] > [((UIButton *) sender) tag]){
                        couponButtonInTheList.transform = CGAffineTransformMakeTranslation(-([self couponWidth] + [self margin]),0);
                    }
                }
            }
        } completion:^(BOOL finished) {
            //clone the amount label for the animation
            UILabel *amountGhost = [[UILabel alloc] initWithFrame:_amount.frame];
            [amountGhost setText:[_amount text]];
            [amountGhost setTextAlignment:NSTextAlignmentLeft];
            [amountGhost setFont:[_amount font]];
            [amountGhost setTextColor:[_amount textColor]];
            [amountGhost setBackgroundColor:[UIColor clearColor]];
            [[_amount superview] addSubview:amountGhost];
            
            amountGhost.layer.anchorPoint = CGPointMake(0.5, 0.5);
            
            //animation scale and alpha
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                amountGhost.transform = CGAffineTransformMakeScale(1.5, 1.5);
                amountGhost.alpha = 0;
            } completion:^(BOOL finished){
                [amountGhost removeFromSuperview];
                [amountGhost release];
            }];
            
            NSInteger tag = [couponButton tag];
            
            //NSLog(@"[self currentCouponList] : %@",[self currentCouponList]);
            //NSLog(@"couponType : %@",[[[self currentCouponList] objectAtIndex:[self tagFromCustomTag:tag]] couponType]);
            
            LoyaltyCoupon *selectedCoupon = [[self currentCouponList] objectAtIndex:[self tagFromCustomTag:tag]];
            [[self selectedCoupons] addObject:selectedCoupon];
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:[self currentCouponList]];
            [mArray removeObjectAtIndex:[self tagFromCustomTag:tag]];
            [[StatisticsFactory sharedInstance] checkPointPaymentUseCoupons];
            [[self correctedInvoice] setCouponList:[NSArray arrayWithArray:mArray]];
            
            [couponButton removeFromSuperview];
            
            [self computeCorrectedInvoiceAmount];
            
            [self stopLoadingView];
        }];
    }];
}

#pragma mark - UX

- (double)margin {
    if(_currentTarget == FZBankSDKTarget) {
        return COUPON_MARGIN_INDO;
    } else {
        return COUPON_MARGIN;
    }
}

- (double)couponWidth {
    if(_currentTarget == FZBankSDKTarget) {
        if([[self currentCouponList] count] > 0){
            LoyaltyCoupon *aCoupon = [[self currentCouponList] objectAtIndex:0];
            NSString *amount = [NSString stringWithFormat:@"%.0f",[aCoupon amount]];
            
            double size = 0;
            
            for (NSInteger i = 0; i < [amount length]; i++) {
                size += 8.0;
            }
            
            return size;
            
        } else {
            return COUPON_WIDTH;
        }
    } else {
        return COUPON_WIDTH;
    }
}

- (double)couponHeight {
    if(_currentTarget == FZBankSDKTarget) {
        return [[self bonsLabel] frame].size.height + COUPON_SPACE;
    } else {
        return COUPON_HEIGHT;
    }
}

- (void)showYourProgramsWithAddedProgram:(LoyaltyProgram *)loyaltyProgram {
    //not used
}

- (void)updateRewards:(double)rewardsAmount andTipDisplay:(double)tipAmount {
    
    double tipPercentOfInvoice = [FZTippingEngine computePercentageOfInvoice:[(Invoice *)[self currentInvoice] amount] regardingTipAmount:tipAmount];
    
    NSString *rewardsString = @"";
    NSString *tipString = @"";
    NSString *rewardsAmountFormatted = @"";
    NSString *tipAmountFormatted = @"";
    
    if (_currentTarget != FZBankSDKTarget) {
        rewardsAmountFormatted = [[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",rewardsAmount]currency:[[self currentInvoice] currency]];
        
        tipAmountFormatted = [[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",tipAmount]currency:[[self currentInvoice] currency]];
    } else {
        rewardsAmountFormatted = [[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.0f",rewardsAmount]currency:[[self currentInvoice] currency]];
        
        tipAmountFormatted = [[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.0f",tipAmount]currency:[[self currentInvoice] currency]];
    }
    
    rewardsString = [NSString stringWithFormat:@"%@%@",[LocalizationHelper stringForKey:@"paymentCheckViewController_included_rewards" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment],rewardsAmountFormatted];

    //manage the tip percentage display
    if (tipPercentOfInvoice >= 1) {
        tipString = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:[LocalizationHelper stringForKey:@"paymentCheckViewController_included_tip_int" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment],tipPercentOfInvoice],tipAmountFormatted];
    } else {
        tipString = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:[LocalizationHelper stringForKey:@"paymentCheckViewController_included_tip" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment],tipPercentOfInvoice],tipAmountFormatted];
        tipString = [tipString stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    
    
    NSString *lblRewardsAndTip = @"";
    
    if (rewardsAmount > 0) {
        lblRewardsAndTip = [NSString stringWithFormat:@"%@",rewardsString];
    }
    
    if (_isTippingActivated) {
        lblRewardsAndTip = [NSString stringWithFormat:@"%@\n%@",lblRewardsAndTip, tipString];
    }
    
    [[self lblIncludeRewardsAndTip] setText:lblRewardsAndTip];
    
    //Debug
    //[[self amount] setBackgroundColor:[UIColor yellowColor]];
    //[[self lblIncludeRewardsAndTip] setBackgroundColor:[UIColor greenColor]];
}

#pragma mark - Logic

-(BOOL)shouldRefill{
    if(_currentTarget == FZBankSDKTarget){
        return NO;
    } else {
        if([[self correctedInvoice] takenAmount] > 0) {
            return ([[self correctedInvoice] newBalanceWithRefill] < 0);
        } else {
            return ([[self correctedInvoice] newBalanceWithoutRefill] < 0);
        }
    }
}

- (NSNumber *)fidelitizId {
    if(_currentTarget == FZBankSDKTarget){
        return [(Invoice *)[self currentInvoice] fidelitizId];
    } else {
        return [[[UserSession currentSession] user] fidelitizId];
    }
}

-(void)fidelitizPreProcessing{
    
    BOOL isCompany = [[[UserSession currentSession] user] isCompany];
    
    NSNumber *fidelitizId = [self fidelitizId];
    
	NSArray *fidelitizBlackList = [[UserSession currentSession] fidelitizBlackList];
	
	BOOL isBankSDK = _currentTarget == FZBankSDKTarget;
	
    if(!isCompany){
		
        if(([[self currentInvoice] currentLoyaltyProgram] != nil && !isBankSDK) || ([[self currentInvoice] currentLoyaltyProgram] != nil && ![[self currentInvoice] hasLoyaltyCard] && isBankSDK)){
            if ([[[self currentInvoice] currentLoyaltyProgram] isPrivate]){
                // the program is private, don't offer to register
                FZPaymentLog(@"Loyalty program is private");
                [self computeCorrectedInvoiceAmount];
                [self stopLoadingView];
                return;
            }
            
            // Does the user have a fidelitiz account?
            if (fidelitizId == nil && !isBankSDK){
                // No, offer to create fidelitiz account and register for loyalty program
                FZPaymentLog(@"User doesn't have a fidelitiz account, offer to create one");
                
                NSString *title = [LocalizationHelper stringForKey:@"paymentCheckViewController_fidelitiz_title" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
                
                NSString *message = [LocalizationHelper stringForKey:@"paymentCheckViewController_fidelitiz_create" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
                
                NSString *cancelButtonTitle = [LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                NSString *otherButtonTitle = [LocalizationHelper stringForKey:@"app_confirm" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                
                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView setTag:kAlertViewCreateFidelitizAccount];
                [alertView show];
                [alertView release];
                
            }
            //check if the program is not blacklisted
            else if(![fidelitizBlackList containsObject:[[[self currentInvoice] currentLoyaltyProgram] loyaltyProgramId]]) {
                // Yes, Does the user already have a loyalty card for this program?
                if ([(Invoice *)[self currentInvoice] hasLoyaltyCard]){
                    // Yes, we're done
                    FZPaymentLog(@"User already has a loyalty card for this program");
                } else {
                    // No, Create a Loyalty card
                    FZPaymentLog(@"User doesn't have a loyalty card for this program, offer to create one");
                    
                    NSString *title = [LocalizationHelper stringForKey:@"paymentCheckViewController_fidelitiz_title" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
                    
                    NSString *message = [LocalizationHelper stringForKey:@"paymentCheckViewController_fidelitiz_register" withComment:@"PaymentCheckViewController" inDefaultBundle:FZBundlePayment];
                    
                    NSString *cancelButtonTitle = [LocalizationHelper stringForKey:@"app_confirm" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                    NSString *otherButtonTitle = [LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                    NSString *moreButtonTitle = [LocalizationHelper stringForKey:@"app_more" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                    
                    if (_myAlertViewRewards==nil) {
                        
                        if (isBankSDK) {
                            _myAlertViewRewards = [[ODCustomAlertView alloc] initWithTitle:title
                                                                                   message:message
                                                                                  delegate:self cancelButtonTitle:cancelButtonTitle
                                                                         otherButtonTitles:otherButtonTitle,moreButtonTitle, nil];
                        } else {
                            _myAlertViewRewards = [[ODCustomAlertView alloc] initWithTitle:title
                                                                                   message:message
                                                                                  delegate:self cancelButtonTitle:cancelButtonTitle
                                                                         otherButtonTitles:otherButtonTitle, nil];
                        }
                        
                        [_myAlertViewRewards setTag:kAlertViewRegisterToLoyaltyCard];
                        [_myAlertViewRewards setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                    }
                    
                    [_myAlertViewRewards show];
                }
            } else {
                [self refreshFields];
            }
        } else {
            [self computeCorrectedInvoiceAmount];
        }
    } else {
        [self refreshFields];
    }
    
    [self stopLoadingView];
}

-(void)createLoyaltyCard{
    NSNumber *fidelitizId = [self fidelitizId];
    
    [RewardsServices createFidelitizCard:[NSString stringWithFormat:@"%d",[fidelitizId intValue]] AffiliatedToTheProgramId:[[[self currentInvoice] currentLoyaltyProgram] loyaltyProgramId] withSuccessBlock:^(id context) {
        FZPaymentLog(@"Loyalty card successfully created");
        
        
        //trick for indonesian amount (very large), we move the label of the amount to fit in with the discount
        
        [self getInvoiceDetailsPreProcessing:YES];
        //[self computeCorrectedInvoiceAmount];
        
    } failureBlock:^(Error *error) {
        FZPaymentLog(@"Loyalty card creation failed");
        
        if(_currentTarget == FZBankSDKTarget) {
            
            if([error errorCode] == 1000) {
                [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
            }
            
            NSString *title = [error localizedError];
            
            [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
            
        } else {
            UIAlertView *alertView = [self displayAlertForError:error];
            [alertView setDelegate:self];
        }
    }];
}

-(void)createFidelizAccount{
    [RewardsServices createFidelitizAccountWithSuccessBlock:^(id context) {
        FZPaymentLog(@"Fidelitiz account created successfully");
        
        NSString *currentUserKey = [[UserSession currentSession] userKey];
        NSNumber *fidelitizId = [self fidelitizId];
        
        // refresh account
        [ConnectionServices retrieveUserInfosLight:currentUserKey successBlock:^(id context) {
            
            [[UserSession currentSession] setUser:context];
            FZPaymentLog(@"new fid id : %@",fidelitizId);
        } failureBlock:^(Error *error) {
            FZPaymentLog(@"failed while retrieving user infos");
            if(_currentTarget == FZBankSDKTarget) {
                
                if([error errorCode] == 1000) {
                    [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
                }
                
                NSString *title = [error localizedError];
                
                [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
                
            } else {
                UIAlertView *alertView = [self displayAlertForError:error];
                [alertView setDelegate:self];
            }
        }];
        [self createLoyaltyCard];
    } failureBlock:^(Error *error) {
        FZPaymentLog(@"Fidelitiz account creation failed");
        if(_currentTarget == FZBankSDKTarget) {
            
            if([error errorCode] == 1000) {
                [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
            }
            
            NSString *title = [error localizedError];
            
            [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
            
        } else {
            UIAlertView *alertView = [self displayAlertForError:error];
            [alertView setDelegate:self];
        }
    }];
}

#pragma mark - Alertview Delegate

-(void)alertView:(ODCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    BOOL isBankSDK = _currentTarget == FZBankSDKTarget;
    
    NSInteger alertViewTag = [alertView tag];
    
    if (alertViewTag == kAlertViewCreateFidelitizAccount && !isBankSDK){
        if (buttonIndex == 0){
            // Cancel
            [self refreshFields];
        } else {
            [self createFidelizAccount];
        }
    } else if (alertViewTag == kAlertViewRegisterToLoyaltyCard || isBankSDK){
        //NSLog(@"button index : %d",buttonIndex);
        if (buttonIndex == 1){
            // Cancel
            
            [[UserSession currentSession] addProgramIdToFidelitizBlackList:[[[self currentInvoice] currentLoyaltyProgram] loyaltyProgramId]];
            [self refreshFields];
        } else if (buttonIndex == 2) {
            //show details
            LoyaltyProgramDetailsViewController *loyaltyProgramDetailsViewController = [[self multiTargetManager] loyaltyProgramDetailsViewControllerWithProgram:[[self originalInvoice] currentLoyaltyProgram]];
            
            [loyaltyProgramDetailsViewController setDelegate:self];
            
            [loyaltyProgramDetailsViewController setCustomNavigationController:[self customNavigationController]];
            
            CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:loyaltyProgramDetailsViewController andMode:CustomNavigationModeBack];
            
            [[self navigationController] pushViewController:navigController
                                                   animated:YES];
            
            [self hideBoltToPayButton];
        } else {
            [self createLoyaltyCard];
        }
    }
    else if(alertViewTag == kAlertViewError) {
        
        _errorAlreadyDisplayed = NO;
        
        [self setAlertViewError:nil];
        
        if(_currentTarget == FZSDKTarget){
            [self dismissViewControllerAnimated:YES completion:^{
                FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
                
                if ([facade respondsToSelector:@selector(didClose:)]) {
                    [facade didClose:self];
                }
            }];
        }
        
        if([_delegate respondsToSelector:@selector(paymentCheckViewController:didFailPaymentForInvoiceId:)]) {
            [_delegate paymentCheckViewController:self
                       didFailPaymentForInvoiceId:[self invoiceId]];
        }
        
    }
}

#pragma mark - Service calls

- (void)payInvoiceIndonesia {

    NSString *typeOfDiscount = @"";
    if([[self originalInvoice] permanentPercentageDiscount] >0){
		typeOfDiscount = @"PERMANENT_PERCENTAGE";
		double value = round([[self correctedInvoice] amount]);
		[[self correctedInvoice] setAmount:value];
    }
    else {
        if([[self selectedCoupons] count] >0){
            if([[[self selectedCoupons] objectAtIndex:0] couponType] == COUPON_TYPE_CASH){
                typeOfDiscount = @"COUPON_CASH";
            }else{
                typeOfDiscount = @"COUPON_PERCENTAGE";
				
			
				double value = round([[self correctedInvoice] amount]);
				[[self correctedInvoice] setAmount:value];
            }
        }
        else{
            typeOfDiscount = nil;
        }
    }
    
    [self setTimerBeforeStartingPoll:[NSTimer timerWithTimeInterval:[self timeBeforeFirstPollCall]
                                                             target:self
                                                           selector:@selector(payInvoicePoll)
                                                           userInfo:nil
                                                            repeats:NO]];
    
    //[NSRunLoop mainRunLoop] manage the timer memory itself
    [[NSRunLoop mainRunLoop] addTimer:[self timerBeforeStartingPoll] forMode:NSDefaultRunLoopMode];
	
    //callback to FZViewController for payInvoice indonesia (BankSDK)
NSString *loyaltyProgramName;
	double amountOfDiscount=[[self originalInvoice] amount] - [[self correctedInvoice] amount];
	
	if([[self originalInvoice] currentLoyaltyProgram]!=nil){
		loyaltyProgramName =[[[self originalInvoice] currentLoyaltyProgram] label];
	}else{
		loyaltyProgramName =@"";
	}
	
	NSInteger couponsSelected=0;
	if([self selectedCoupons]!=nil){
		couponsSelected=[[self selectedCoupons] count];
	}else{
		couponsSelected=0;
	}
    if ([[[FZTargetManager sharedInstance] delegateSDK]respondsToSelector:@selector(payInvoice:withOriginalAmount:andDiscountedAmount:andMerchantName:andNbOfCoupons:andTypeOfDiscount:andLoyaltyProgramName:andDiscountAmount:)]) {
        [[[FZTargetManager sharedInstance] delegateSDK] payInvoice:[self invoiceId] withOriginalAmount:[[self originalInvoice] amount] andDiscountedAmount:[[self correctedInvoice] amount] andMerchantName:[[self correctedInvoice] otherName] andNbOfCoupons:couponsSelected andTypeOfDiscount:typeOfDiscount andLoyaltyProgramName:loyaltyProgramName andDiscountAmount:amountOfDiscount];
    }
}

- (IBAction)payInvoice:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointPaymentValidate];
    
    [_tipsButton setEnabled:NO];
    [_btnClose setEnabled:NO];
    
    if(_currentTarget != FZBankSDKTarget){ //Application & SDK
        if (![self shouldRefill]){ //NO refill is needed
            [payButton setEnabled:NO];
            
            [self hideCloseButton];
            
            [_couponsScrollView setUserInteractionEnabled:NO];
            
            [self startLoadingAnimationAtPosition:payButton.center withBorderColor:[UIColor whiteColor]];
            
            [self payButtonCustomColor];
            
            UserSession *userSession = [UserSession currentSession];
            
            NSString *currentUserKey = [userSession userKey];
            
            NSInteger numberOfCoupons = [[self selectedCoupons] count];
            
            NSString *invoiceToPay;
            
            if([[self currentInvoice] isCredit]){
                invoiceToPay = [[self currentInvoice] invoiceId];
            } else {
                invoiceToPay = [[self correctedInvoice] invoiceId];
            }
            
            [InvoiceServices payInvoice:invoiceToPay userKey:currentUserKey hasLoyaltyCard:[[self correctedInvoice] hasLoyaltyCard] correctedInvoiceAmount:[[self correctedInvoice] amount] nbCoupons:numberOfCoupons successBlock:^(id context) {
                
                PaymentSummary * paymentSummary = context;
                
                [self showCloseButton];
                
                // refresh account
                [ConnectionServices retrieveUserInfosLight:currentUserKey successBlock:^(id context) {
                    [[UserSession currentSession] setUser:context];
                } failureBlock:^(Error *error) {
                    FZPaymentLog(@"error while retrieving user infos");
                    if(_currentTarget == FZBankSDKTarget) {
                        
                        if([error errorCode] == 1000) {
                            [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
                        }
                        
                        NSString *title = [error localizedError];
                        
                        [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
                        
                    } else {
                        UIAlertView *alertView = [self displayAlertForError:error];
                        [alertView setDelegate:self];
                    }
                }];
                
                [self stopLoadingAnimation];
                
                [self showPaymentSummary:paymentSummary];
                
                [self deleteInvoice];
                
            } failureBlock:^(Error *error) {
                FZPaymentLog(@"Payment failed");
                
                [payButton setEnabled:YES];
                
                [self showCloseButton];
                
                [self stopLoadingAnimation];
                
                if(_currentTarget == FZBankSDKTarget) {
                    
                    if([error errorCode] == 1000) {
                        [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
                    }
                    
                    NSString *title = [error localizedError];
                    
                    [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
                    
                } else {
                    UIAlertView *alertView = [self displayAlertForError:error];
                    [alertView setDelegate:self];
                }
            }];
        } else { //Refill is needed
            [self startTopUpProcess];
        }
    } else { //BankSDK
        [payButton setEnabled:NO];
        
        [self closeAnimationBoltPayButton];
        
        [self hideCloseButton];
        
        [_couponsScrollView setUserInteractionEnabled:NO];
        
        [self startLoadingAnimationAtPosition:payButton.center withBorderColor:[UIColor whiteColor]];
        
        [self payButtonCustomColor];
        
        //Manage callback (isForcingCancelTransaction)
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        if ([facade respondsToSelector:@selector(isForcingCancelTransaction)]) {
            if ([facade isForcingCancelTransaction]) {
                [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Force transaction failed is ON"];
                
                Error *defaultError = [[Error alloc] init];
                [defaultError setErrorCode:4000];
                
                NSString *title = [LocalizationHelper errorForKey:[NSString stringWithFormat:@"%ld",(long)[defaultError errorCode]] withComment:@"Error" inDefaultBundle:FZBundleAPI];
                
                [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:defaultError];
            } else {
                [self payInvoiceIndonesia];
            }
        } else {
            [self payInvoiceIndonesia];
        }
    }
}

- (void) payInvoicePoll {
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Pay invoice - start poll"];
    
    if(![self paymentChecked]){ //not payed yet
        [self setTimerPayInvoicePoll:[NSTimer timerWithTimeInterval:[self timeBetweenEachPollCall]
                                                             target:self
                                                           selector:@selector(indonesianServicesPayInvoiceStatus)
                                                           userInfo:nil
                                                            repeats:YES]];
        
        [[NSRunLoop mainRunLoop] addTimer:[self timerPayInvoicePoll] forMode:NSDefaultRunLoopMode];
        
        [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Transaction not yet payed"];
    }
}

- (void) indonesianServicesPayInvoiceStatus {
    if(![self requestIsRunning]){
        [self setRequestIsRunning:YES];
        [IndonesiaBankSdkServices payInvoiceStatus:[NSString stringWithString:[[UserSession currentSession] userKey]] invoiceId: [NSString stringWithString:[self invoiceId]]
                                      successBlock:^(id indonesianInvoiceStatusResult){
                                          
                                          IndonesianInvoiceStatus *indonesianInvoiceStatus = indonesianInvoiceStatusResult;
                                          
                                          NSLog(@"Pay Invoice Status SUCCESS:%@",[indonesianInvoiceStatus status]);
                                          
                                          //TODO handle rewards points
                                          
                                          if([[indonesianInvoiceStatus status] isEqualToString:kBankSDKStatusCancelled] ||
                                             [[indonesianInvoiceStatus status] isEqualToString:kBankSDKStatusOutdated] ||
                                             [[indonesianInvoiceStatus status] isEqualToString:kBankSDKStatusErrorDuringGetInvoice]) {
                                              
                                              [self setRequestIsRunning:NO];
                                              [self setPaymentChecked:YES];
                                              if([self timerPayInvoicePoll]) {
                                                  [[self timerPayInvoicePoll] invalidate],_timerPayInvoicePoll = nil;
                                              }
                                              
                                              
                                              //TODO: manage error for transaction cancelled ?
                                              NSString *title = [LocalizationHelper errorForKey:@"4000" withComment:@"Error" inDefaultBundle:FZBundleAPI];
                                              
                                              Error *error = [[Error alloc] init];
                                              [error setErrorCode:4000];
                                              
                                              [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
                                              
                                              [error release];
                                              
                                          } else if([[indonesianInvoiceStatus status] isEqualToString:kBankSDKStatusPaid] || [[indonesianInvoiceStatus status] isEqualToString:kBankSDKStatusPaidAndChecked]){
                                              
                                              [self setRequestIsRunning:NO];
                                              [self setPaymentChecked:YES];
                                              if([self timerPayInvoicePoll]) {
                                                  [[self timerPayInvoicePoll] invalidate],_timerPayInvoicePoll = nil;
                                              }
                                              
                                              [self presentActionViewControllerWithNbOfGeneratedPoints:0 nbOfPointsToGenerateACoupon:0 nbOfPointsOnTheLoyaltyCard:0 amountOfACoupon:0.0 andDelegate:self];
                                              
                                              [self deleteInvoice];
                                          } else {
                                              // TODO: continue? how?
                                              [self setRequestIsRunning:NO];
                                              [self setPaymentChecked:NO];
                                          }
                                      } failureBlock:^(Error *error) {
                                          
                                          //If NOK, stop the payment poll
                                          [self setRequestIsRunning:NO];
                                          [self setPaymentChecked:YES];
                                          
                                          if ( ([error messageCode] && [[error messageCode]isEqualToString:@"ERROR_DURING_GET_INVOICE"])
                                              || [error errorCode] == 10010 //no internet
                                              || [error errorCode] == 10000) //UNHANDLED_EXCEPTION
                                          {
                                              if([error errorCode] == 10000) {
                                                  [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
                                              }
                                          } else if ([error errorCode] == 5001) { //ERROR_MESSAGE_USER_NOT_PERMITTED If user trys to get status of invoice that was paid by other user
                                              //add something here if you want to handle this case - by default the default error will be displayed
                                          } else {//no error code
                                              [error setErrorCode:10000];
                                              [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
                                          }
                                          
                                          if([self timerPayInvoicePoll]) {
                                              [[self timerPayInvoicePoll] invalidate],_timerPayInvoicePoll = nil;
                                          }
                                          
                                          NSString *title = [error localizedError];
                                          
                                          [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
                                      }];
    }
}

- (void)showPaymentSummary:(PaymentSummary *) paymentSummary{
    //show rewards summary
    if(paymentSummary){
        [self presentActionViewControllerWithNbOfGeneratedPoints:[paymentSummary nbGeneratedPoints] nbOfPointsToGenerateACoupon:[paymentSummary nbPointsToGetACoupon] nbOfPointsOnTheLoyaltyCard:[paymentSummary nbPointsOnLoyaltyCard] amountOfACoupon:[paymentSummary couponAmount] andDelegate:self];
    } else {
        [self presentActionViewControllerWithNbOfGeneratedPoints:0 nbOfPointsToGenerateACoupon:0 nbOfPointsOnTheLoyaltyCard:0 amountOfACoupon:0.0 andDelegate:self];
    }
}

- (void)deleteInvoice {
    //prevent the reloading of the invoice if the view is reloaded
    _invoiceAlreadyPaid = YES;
    [self setOriginalInvoice:nil];
    [self setCorrectedInvoice:nil];
}


- (void)startTopUpProcess {
    
    if(_currentTarget == FZSDKTarget) {
        
        [SDKProxyHelper openTopupProcessWithUserKey:[[UserSession currentSession] userKey] environment:[[UserSession currentSession] shortEnvironmentValue]];
    } else {
        PaymentTopupViewController *paymentRefillVC = [objc_msgSend(NSClassFromString(@"PaymentTopupViewController"), @selector(alloc)) init];
        
        [paymentRefillVC setDelegate:self];
        [paymentRefillVC setIsPaymentProcess:YES];
        
        [paymentRefillVC setCustomNavigationController:[self customNavigationController]];
        
        
        CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:paymentRefillVC andMode:CustomNavigationModeBack];
        
        [[self navigationController] pushViewController:navigController
                                               animated:YES];
    }
}

- (id)currentInvoice {
    return [self originalInvoice];
}

- (void)setCurrentInvoice:(Invoice *)anInvoice {
    [self setOriginalInvoice:anInvoice];
}

- (void)computeCorrectedInvoiceAmount{
    // call fidelitiz engine
    FZPaymentLog(@"FidelitizEngine's running...");
    
    double ppd = 0.0;
    
    if(![(Invoice *)[self currentInvoice] hasLoyaltyCard]){
        ppd = [[[self currentInvoice] currentLoyaltyProgram] permanentPercentageDiscount];
    }
    
    InvoiceCorrectedParameters *correctedParams = [RewardsEngine computeDiscountForInvoice:[self currentInvoice] AndNbOfUsedCoupons:[[self selectedCoupons] count] LivePPD:ppd];
    
    double correctedDiscount = [correctedParams discount];
    
    [[self correctedInvoice] setAmount:[correctedParams correctedInvoiceAmount]];
    [[self correctedInvoice] setNewBalanceWithRefill:[correctedParams newBalanceWithRefill]];
    [[self correctedInvoice] setNumberOfRefill:(double)[correctedParams nbOfRefill]];
    [[self correctedInvoice] setHasLoyaltyCard:[correctedParams hasLoyaltyCard]];
    [[self correctedInvoice] setDiscount:correctedDiscount];
    [[self correctedInvoice] setWithRefill:[correctedParams newWithRefill]];
    [[self correctedInvoice] setAmountOfRefill:[correctedParams amountOfRefill]];
    [[self correctedInvoice] setNewBalanceWithoutRefill:[_originalInvoice newBalanceWithoutRefill]+correctedDiscount];
    
    FZPaymentLog(@"FidelitizEngine done");
    
    [self refreshFields];
}

- (void)getInvoiceDetails {
    
    if(!_invoiceAlreadyPaid) {
        
        FZPaymentLog(@"Getting details for invoice id : %@",[self invoiceId]);
        
        UserSession *userSession = [UserSession currentSession];
        NSString *currentUserKey = [userSession userKey];
        
        if (_currentTarget != FZBankSDKTarget) {
			[InvoiceServices readInvoice:[self invoiceId] userKey:currentUserKey apiVersion:nil successBlock:^(id context) {
                
                //set the current invoice according to the server's response
                [self setCurrentInvoice:context];
                
                //set the original invoice of the invoice (useful in case of an cash desk tag)
                [self setInvoiceId:[[self currentInvoice] invoiceId]];
                
                [self getInvoiceDetailsSucceeded];
                
            } failureBlock:^(Error *error) {
                [self getInvoiceFailureBlock:error];
            }];
        } else {
            [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Read invoice"];
            
            [IndonesiaBankSdkServices readInvoice:currentUserKey invoiceId:[self invoiceId] apiVersion:@"2" successBlock:^(id context) {
                
                [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Read invoice has succeeded"];
                
                //set the current invoice according to the server's response
                [self setCurrentInvoice:context];
                
                //set the original invoice of the invoice (useful in case of an cash desk tag)
                [self setInvoiceId:[[self currentInvoice] invoiceId]];
                
                NSLog(@"current invoice : %@",[self currentInvoice]);
                
                [self getInvoiceDetailsSucceeded];
                
            } failureBlock:^(Error *error) {
                [self getInvoiceFailureBlock:error];
            }];
        }
    }
}

- (void)getInvoiceDetailsSucceeded {
    
    if(![[self currentInvoice] isCredit]){
        
        //Tip
        double suggestedTipAmount = [[[self currentInvoice] tip] suggestedAmount];
        _isTippingActivated = [[self currentInvoice] tipEnabled];
        
        if (_isTippingActivated) {
            
            [[self tipsButton] setHidden:NO];
            [[self tipsLabelButton] setHidden:NO];
            
            _tipAmount = suggestedTipAmount;
        } else {
            [[self tipsButton] setHidden:YES];
            [[self tipsLabelButton] setHidden:YES];
            [[self lblIncludeRewardsAndTip] setText:@""];
            [self setTipAmount:0.0];
        }
        
        //mise à jour du nombre de coupons utilisables
        if([[[self currentInvoice] couponList] count] > 0) {//si des coupons sont disponibles
            //calcul du nombre de coupons optimal (pour ne pas perdre de l'argent)
            
            _nbOptimalOfUsableCoupons = [RewardsEngine optimalNbOfCoupons:[self currentInvoice]];
            
            //check l'utilisation du nombre optimal de coupon permet de couvrir le montant de la facture. si non, on ajoute un coupon si disponible
            if([(Invoice *)[self currentInvoice] amount] - (_nbOptimalOfUsableCoupons * [(LoyaltyCoupon*)[[self currentInvoice] couponList][0] amount]) > 0 && (_nbOptimalOfUsableCoupons + 1) <= [[[self currentInvoice] couponList] count] && [(LoyaltyCoupon*)[[[self currentInvoice] couponList] objectAtIndex:0] couponType] != COUPON_TYPE_PERCENT) {
                _nbOptimalOfUsableCoupons++;
            }
        }
        
        FZPaymentLog(@"_nbOptimalOfUsableCoupons : %ld",(long)_nbOptimalOfUsableCoupons);
        //assign usable coupons
        NSMutableArray *optimalCouponsList = [[NSMutableArray alloc] initWithCapacity:_nbOptimalOfUsableCoupons];
        
        for (NSInteger i = 0; i < _nbOptimalOfUsableCoupons; i++) {
            optimalCouponsList[i] = [[self currentInvoice] couponList][i];
        }
        
        [[self currentInvoice] setCouponList:optimalCouponsList];
        [optimalCouponsList release];
        
        [self setCorrectedInvoice:[CorrectedInvoice correctedInvoiceWithInvoice:[self currentInvoice]]];
        
        [self fidelitizPreProcessing];
    } else {
        [self refreshFields];
    }
}

- (void)getInvoiceFailureBlock:(Error *)error {
    FZPaymentLog(@"Failed to get invoice detail Id : %@",[self invoiceId]);
    
    //emulate unknown error
    //[error setErrorCode:1000];
    
    [self stopLoadingAnimation];
    
    if(!_errorAlreadyDisplayed) {
        
        _errorAlreadyDisplayed = YES;
        
        if(_currentTarget == FZBankSDKTarget) {
            
            if([error errorCode] == 1000) {
                [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:YES];
            }
            
            [error setErrorCode:3010];
            
            NSString *title = [error localizedError];
            
            [self presentActionViewControllerWithTitle:title andBackgroundColor:[[ColorHelper sharedInstance] monochromeTwoColor] andArrowImage:[FZUIImageWithImage imageNamed:@"arrow_right_grey" inBundle:FZBundleBlackBox] andDelegate:self withCorrectiveDelta:0.0 andError:error];
            
        } else {
            //hide the view behind to have a visual clean view
            [[self payButton] setHidden:YES];
            [[self receiverIcon] setHidden:YES];
            [[self receiverIconSmall] setHidden:YES];
            
            UIAlertView *alertView = [self displayAlertForError:error];
            [alertView setDelegate:self];
        }
    }
}

#pragma mark - TopUp Delegate

- (void)paymentRefillDidFinish:(PaymentTopupViewController *)controller{
    [self getInvoiceDetailsPreProcessing:NO];
}

- (void)closeSDKWithFacade:(FZFlashizFacade *)facade {
    if ([_delegate respondsToSelector:@selector(paymentCheckViewControllerSdkClose)]) {
        [facade showDebugLog:@"close SDK"];
        [_delegate paymentCheckViewControllerSdkClose];
    }
}

#pragma mark - ActionSuccessful Delegate
/*
 * Tap the check image or the Ok button of the ActionSuccessfulAfterPaymentViewController
 */
- (void)didValidate:(id)controller {
    
    _errorAlreadyDisplayed = NO;
    
    FZTarget currentTarget = [[FZTargetManager sharedInstance] mainTarget];
    FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
    
    //if we are using the BankSDK
    if(currentTarget == FZBankSDKTarget){
        [facade showDebugLog:@"Invalid QRcode found"];
        
        //Manage callback (isClosingSdkAfterInvalidQrCode)
        if([facade respondsToSelector:@selector(isClosingSdkAfterInvalidQrCode)]) {
            if([facade isClosingSdkAfterInvalidQrCode]) {// if is On
                
                [self closeSDKWithFacade:facade];
                
                return;//We can stop here, we don't need to continue because the SDK is going to close
            }
        }
        
        //Manage callback (isClosingSdkAfterPaymentFailedOrSucceeded)
        if([facade respondsToSelector:@selector(isClosingSdkAfterPaymentFailedOrSucceeded)]) {
            if([facade isClosingSdkAfterPaymentFailedOrSucceeded]) {// if is On
                
                [self closeSDKWithFacade:facade];
                
                return;//We can stop here, we don't need to continue because the SDK is going to close
            }
        }
    }
    
    //The payment is successful
    if ([controller isMemberOfClass:[ActionSuccessfulAfterPaymentViewController class]]) {
        
        if (_delegate && ![[FZTargetManager sharedInstance] isApplicationUsingSDK]) { //Application
            
            if([_delegate respondsToSelector:@selector(paymentCheckViewController:didValidatePaymentForInvoiceId:)]) {
                
                //Dismiss the confirmation view (ActionSuccessfulAfterPaymentViewController)
                [self dismissViewControllerAnimated:YES completion:^{
                    //Broadcast to PaymentCheckViewController
                    [_delegate paymentCheckViewController:self didValidatePaymentForInvoiceId:_invoiceId];
                }];
            } else {
                NSLog(@"Navigation not managed");
            }
        } else { //SDK
            
            if ([facade respondsToSelector:@selector(paymentCheckViewController:didValidatePaymentForInvoiceId:)]) {
                                
                //Dismiss the confirmation view (ActionSuccessfulAfterPaymentViewController)
                [self dismissViewControllerAnimated:YES completion:^{
                    //Broadcast to FZFlashizFacade
                    [facade paymentCheckViewController:self didValidatePaymentForInvoiceId:_invoiceId];
                }];
            } else {
                NSLog(@"Navigation not managed");
            }
        }
    } else { //The payment has failed
        if (_delegate && ![[FZTargetManager sharedInstance] isApplicationUsingSDK]) { //Application
            
            if([_delegate respondsToSelector:@selector(paymentCheckViewController:didFailPaymentForInvoiceId:)]) {
                
                //Dismiss the confirmation view (ActionSuccessfulAfterPaymentViewController)
                [self dismissViewControllerAnimated:YES completion:^{
                    //Broadcast to PaymentCheckViewController
                    [_delegate paymentCheckViewController:self didFailPaymentForInvoiceId:_invoiceId];
                }];
            } else {
                NSLog(@"Navigation not managed");
            }
        } else { //SDK
            
            if ([facade respondsToSelector:@selector(paymentCheckViewController:didFailPaymentForInvoiceId:)]) {
                
                //Dismiss the confirmation view (ActionSuccessfulAfterPaymentViewController)
                [self dismissViewControllerAnimated:YES completion:^{
                    //Broadcast to FZFlashizFacade
                    [facade paymentCheckViewController:self didFailPaymentForInvoiceId:_invoiceId];
                }];
            } else {
                NSLog(@"Navigation not managed");
            }
        }
    }
}

- (void)didGoToMap:(ActionSuccessfulAfterPaymentViewController *)controller {
    
    //show map
    ProximityMapViewController *map = [[self multiTargetManager] proximityMapViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:map andMode:CustomNavigationModeClose];
    
    [self presentViewController:navigController animated:YES completion:^{}];
}


- (IBAction)cancelTransaction:(id)sender {
    
    if([_delegate respondsToSelector:@selector(paymentCheckViewController:didCancelPaymentForInvoiceId:)]) {
        [_delegate paymentCheckViewController:self didCancelPaymentForInvoiceId:[self invoiceId]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    if(_currentTarget == FZBankSDKTarget){
        
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        //Manage callback (isClosingSdkAfterUserCancelTransaction)
        if ([facade respondsToSelector:@selector(isClosingSdkAfterUserCancelTransaction)]) {
            if ([facade isClosingSdkAfterUserCancelTransaction]) {
                if ([_delegate respondsToSelector:@selector(paymentCheckViewControllerSdkClose)]) {
                    [facade showDebugLog:@"close SDK"];
                    [_delegate paymentCheckViewControllerSdkClose];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - CardListViewController delegate methods

- (void)cardListDidFinish:(CardListViewController *)controller {
    [self getInvoiceDetailsPreProcessing:NO];
}

#pragma mark - CustomNavigationViewControllerAction

-(void)didGoBack:(CustomNavigationViewController *)controller {
   
}

- (void)didClose:(CustomNavigationViewController *)controller {
    [[StatisticsFactory sharedInstance] checkPointPaymentQuit];
        
    if(_currentTarget == FZBankSDKTarget){//if BankSDK
        
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        if ([facade respondsToSelector:@selector(isClosingSdkAfterUserCancelTransaction)]) {
            if ([facade isClosingSdkAfterUserCancelTransaction]) {
                if ([_delegate respondsToSelector:@selector(paymentCheckViewControllerSdkClose)]) {
                    [facade showDebugLog:@"close SDK"];
                    [_delegate paymentCheckViewControllerSdkClose];
                    
                    return;//We can stop here, we don't need to continue because the SDK is going to close
                }
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_currentTarget == FZSDKTarget && !_comeFromScanner) {
            FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
            
            if ([facade respondsToSelector:@selector(didClose:)]) {
                [facade didClose:self];
            }
        }
    }];
}

#pragma mark - LoyaltyProgramDetailsViewDelegate

-(void)didGoBackFromYourDetails{
    [self setBoltAdded:NO];
    [self getInvoiceDetailsPreProcessing:NO];
}

#pragma mark - Close SDK

- (void)paymentCheckViewControllerSdkClose {
    if ([_delegate respondsToSelector:@selector(paymentCheckViewControllerSdkClose)]) {
        [[[FZTargetManager sharedInstance] facade] showDebugLog:@"close SDK"];
        [_delegate paymentCheckViewControllerSdkClose];
    }
}

#pragma mark - helper tag

- (NSInteger)customTagFromTag:(NSInteger)tag {
    return tag + TAG_DELTA;
}

- (NSInteger)tagFromCustomTag:(NSInteger)customTag {
    return customTag - TAG_DELTA;
}

#pragma mark - force stop SDK

- (void)stopPolling {
    
    if (_currentTarget == FZBankSDKTarget) {
        [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Stop polling the server (payInvoice)"];
    }
    
    if (_timerPayInvoicePoll != nil && [_timerPayInvoicePoll isValid]) {
        [_timerPayInvoicePoll invalidate], _timerPayInvoicePoll = nil;
    } else {
        _timerPayInvoicePoll = nil;
    }
    
    //[NSRunLoop mainRunLoop] manage the timer memory itself
    if (_timerBeforeStartingPoll != nil) {
        _timerBeforeStartingPoll = nil;
    }
}

#pragma mark - Tipping

- (IBAction)goTipping:(id)sender {
    [self setNoLoadingView:YES];
    
    FZTipViewController *tipViewController = [[self multiTargetManager] tipViewControllerWithInvoice:[self currentInvoice] andTipAmount:_tipAmount];
    
    [tipViewController setDelegate:self];
    
    [tipViewController setCustomNavigationController:[self customNavigationController]];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:tipViewController andMode:CustomNavigationModeClose];
    
    [self presentViewController:navigController animated:YES completion:nil];
}

- (void)backToPaymentWithTipAmount:(double)tipAmount {
    [self cancelTip];
    
    [self computeTippingAndRefresh:tipAmount];
    [self setNoLoadingView:YES];
}

- (void)computeTippingAndRefresh:(double)tipAmount {
    [self setTipAmount:tipAmount];
    [self refreshFields];
}

- (void)cancelTip {
    //Dismiss the tip view (FZTipViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self stopPolling];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    [_receiverIcon release], _receiverIcon = nil;
    [_tipsButton release], _tipsButton = nil;
    [_cancelLabelButton release], _cancelLabelButton = nil;
    [_accountBanner release];
    [_bonsLabel release];
    [_viewAccountBanner release];
    [_receiver release];
    [_amount release];
    [_originalInvoice release];
    [_correctedInvoice release];
    [_refillLabel release];
    [_couponsScrollView release];
    [payButton release];
    [_cpBackground release];
    [_arc release];
    [_lblPercentageDiscount release];
    [_tipsCoreTextArcView release];
    [_tipsView release];
    [_couponList release];
    [_viewDetails release];
    
    [_invoiceId release], _invoiceId = nil;
    
    [self setSelectedCoupons:nil];
    
    [_btnClose release];
    [payButtonBankSDK release];
    [_btnPayTextBankSdk release];
    [_viewCoupons release];
    [_lblNbOfCoupons release];
    [_lblIncludeRewardsAndTip release];
    [_receiverIconSmall release];
    [_viewAmountAndDescription release];
    [super dealloc];
}

@end
