//
//  ActionSuccessfulAfterPaymentViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 16/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "ActionSuccessfulAfterPaymentViewController.h"

//Draw
#import <FZBlackBox/CircleProgress.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//User Session
#import <FZAPI/UserSession.h>

//UIButton
#import <FZBlackBox/FlashizButtonRiddleAnimation.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>


//Helpers
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FontHelper.h>
#import <FZBlackBox/ColorHelper.h>
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/LocalizationHelper.h>
#import <FZBlackBox/FZTargetManager.h>

//FW
#include <UIKit/UIColor.h>


#define xBackgroudPosition 13.0
#define yBackgroudPosition 31.0

@interface ActionSuccessfulAfterPaymentViewController ()  <CircleProgressDelegate> {
    
}

typedef enum {
    FZActionSuccessFullNoPointsNoCoupons,
    FZActionSuccessFullWithPoints,
    FZActionSuccessFullWithCoupons,
} FZActionSuccessFull;

//private properties
@property (retain, nonatomic) IBOutlet UIView *viewPopUpBackground;
@property (retain, nonatomic) IBOutlet UIView *viewMaskBottom;
@property (retain, nonatomic) IBOutlet UIButton *btnGoToMap;
@property (retain, nonatomic) IBOutlet UIButton *btnOk;

//After payment with no point and no coupon
@property (retain, nonatomic) IBOutlet UIView *viewBackground;
@property (retain, nonatomic) IBOutlet UILabel *lblValidate;
@property (retain, nonatomic) IBOutlet FlashizButtonRiddleAnimation *btnCheckRound;
@property (retain, nonatomic) NSString *customArrow;

//After payment with points
@property (retain, nonatomic) IBOutlet UIView *viewBackgroundPoints;
@property (retain, nonatomic) IBOutlet UILabel *lblThisPurchasePoints;
@property (retain, nonatomic) IBOutlet UILabel *lblNbOfPointsEarn;
@property (retain, nonatomic) IBOutlet UIView *viewProgressPoints;
@property (retain, nonatomic) IBOutlet UIView *viewProgressPointsBar;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfPointsBeforeACoupon;
@property (retain, nonatomic) IBOutlet UILabel *lblAmountOfACoupon;
@property (retain, nonatomic) IBOutlet UIView *bgAmountOfPoint;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfPoints;
@property (retain, nonatomic) IBOutlet UIImageView *imageCouponIndicator;

//After payment with coupons
@property (retain, nonatomic) IBOutlet UIView *viewBackgroundCoupons;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblThisPurchaseCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblNbOfCoupons;
@property (retain, nonatomic) IBOutlet UIView *viewProgressPointsForCoupons;
@property (retain, nonatomic) IBOutlet UIView *viewProgressPointsBarForCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblAmountOfACouponForCoupons;
@property (retain, nonatomic) IBOutlet UIView *bgAmountOfPointForCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfPointsForCoupons;
@property (retain, nonatomic) IBOutlet UIImageView *imageCouponIndicatorForCoupons;

@property (retain, nonatomic) IBOutlet UIImageView *iconPinUser;

@property (retain, nonatomic) IBOutlet UIView *rotatingViewPinUser;

@property (assign, nonatomic) FZActionSuccessFull mode;


@property (assign, nonatomic) NSInteger nbOfGeneratedPoints;
@property (assign, nonatomic) NSInteger nbOfPointsToGenerateACoupon;
@property (assign, nonatomic) NSInteger nbOfPointsOnTheLoyaltyCard;
@property (assign, nonatomic) double amountOfACoupon;

@property (retain,nonatomic) CircleProgress *cpBackgroundForCouponView;
@property (retain,nonatomic) CircleProgress *cpForCouponView;
@property (assign,nonatomic) int nbOfEarnCoupons;
@property (assign,nonatomic) double dividedOpacity;

//private actions
- (IBAction)goToMapView:(id)sender;
- (IBAction)validateAction:(id)sender;

@end

@implementation ActionSuccessfulAfterPaymentViewController

@synthesize delegate = _delegate;

#pragma mark - Init

- (id)initWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon {
    self = [super initWithNibName:@"ActionSuccessfulAfterPaymentViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if(self) {
        _nbOfGeneratedPoints = nbOfGeneratedPoints;
        _nbOfPointsToGenerateACoupon = nbOfPointsToGenerateACoupon;
        _nbOfPointsOnTheLoyaltyCard = nbOfPointsOnTheLoyaltyCard;
        _amountOfACoupon = amountOfACoupon;
        [self setCustomArrow:nil];
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Setup view

- (void)setUpView {
    //background
    [self.view setBackgroundColor:[[ColorHelper sharedInstance] blackColorWithAlpha:0.7]];
    
    [_iconPinUser setHidden:YES];
    
    //display view points
    if(_nbOfPointsToGenerateACoupon != 0 && _nbOfGeneratedPoints != 0 && ((_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard) < _nbOfPointsToGenerateACoupon)) {
        
        _mode = FZActionSuccessFullWithPoints;
        
        [_imageCouponIndicator setImage:[FZUIImageWithImage imageNamed:@"indic" inBundle:FZBundlePayment]];
        
        //remove the others views and add the right view
        [_viewBackground removeFromSuperview];
        [_viewBackgroundCoupons removeFromSuperview];
        [_viewPopUpBackground insertSubview:_viewBackgroundPoints belowSubview:_viewMaskBottom];
        [_viewBackgroundPoints setFrame:CGRectMake(xBackgroudPosition, yBackgroudPosition, _viewBackgroundPoints.frame.size.width, _viewBackgroundPoints.frame.size.height)];
        
        //set background
        [_viewBackgroundPoints setBackgroundColor:[[ColorHelper sharedInstance] rewardsOneColor]];
        _viewBackgroundPoints.layer.cornerRadius = 5;
        [_viewMaskBottom setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        _viewMaskBottom.layer.cornerRadius = 5;
        
        //titles
        [_lblThisPurchasePoints setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblThisPurchasePoints" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        [_lblThisPurchasePoints setTextColor:[[ColorHelper sharedInstance] whiteColor]];
        [_lblThisPurchasePoints setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
        
        if(_nbOfGeneratedPoints > 1) {
            [_lblNbOfPointsEarn setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNbOfPointsEarn_s" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],_nbOfGeneratedPoints] uppercaseString]];
        } else {
            [_lblNbOfPointsEarn setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNbOfPointsEarn" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        }
        [_lblNbOfPointsEarn setTextColor:[[ColorHelper sharedInstance] whiteColor]];
        [_lblNbOfPointsEarn setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:28.0f]];
        
        //round
        [[_bgAmountOfPoint layer] setCornerRadius:_bgAmountOfPoint.frame.size.height/2];
        [_bgAmountOfPoint setBackgroundColor:[[ColorHelper sharedInstance] rewardsOneColor]];
        
        //set labels
        [_lblAmountOfACoupon setText:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.0f",_amountOfACoupon] currency:[[[[UserSession currentSession] user] account] currency]]];
        
        [_lblNumberOfPoints setTextColor:[[ColorHelper sharedInstance] whiteColor]];
        
        if(_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints > 1) {
            [_lblNumberOfPoints setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNumberOfPoints_s" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints] uppercaseString]];
        } else {
            [_lblNumberOfPoints setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNumberOfPoints" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        }
        
        [_lblNumberOfPointsBeforeACoupon setTextColor:[[ColorHelper sharedInstance] rewardsOneColor]];
        
        if(_nbOfPointsToGenerateACoupon - _nbOfPointsOnTheLoyaltyCard - _nbOfGeneratedPoints == 1) {
            [_lblNumberOfPointsBeforeACoupon setText:[[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPointsBeforeACoupon" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        } else {
            [_lblNumberOfPointsBeforeACoupon setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPointsBeforeACoupon_s" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],[NSString stringWithFormat:@"%i",(int)(_nbOfPointsToGenerateACoupon - _nbOfPointsOnTheLoyaltyCard - _nbOfGeneratedPoints)]]uppercaseString]];
        }
        
        //Animation
        float duration = 2.0;
        int startAngle = 90;
        int angleToEarnACoupon = startAngle + 270;
        
        int currentAngle = (int)(((angleToEarnACoupon - startAngle)/_nbOfPointsToGenerateACoupon)*(_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints));
        
        int stopAngle = startAngle + currentAngle;
        
        //progress points bar
        int strokeLine = 16;
        //CGPoint center = CGPointMake(_viewBackgroundPoints.frame.origin.x +  _viewProgressPoints.frame.origin.x + _viewProgressPointsBar.frame.origin.x + _viewProgressPointsBar.frame.size.width/2,_viewBackgroundPoints.frame.origin.y + _viewProgressPoints.frame.origin.y + _viewProgressPointsBar.frame.origin.y + _viewProgressPointsBar.frame.size.height/2);
        
        //draw progress points bar circle background
        CircleProgress* cpBackground = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[[ColorHelper sharedInstance] actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor] radius:_viewProgressPointsBar.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
        
        [cpBackground drawCircleFromAngle:startAngle
                                  toAngle:angleToEarnACoupon
                             withDuration:0 inLayer:[_viewProgressPointsBar layer]];
        
        
        //draw progress points bar circle
        CircleProgress* cp = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[[ColorHelper sharedInstance] rewardsOneColor] radius:_viewProgressPointsBar.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
        [cp drawCircleFromAngle:startAngle toAngle:stopAngle withDuration:duration inLayer:cpBackground];
        
        [cp release];
        [cpBackground release];
        
        //draw the cursor
        
        CAKeyframeAnimation *animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [animation setValues: [NSArray arrayWithObjects:[NSNumber numberWithFloat:startAngle * M_PI / 180], [NSNumber numberWithFloat:stopAngle * M_PI / 180], nil]];
        
        [animation setFillMode:kCAFillModeForwards];
        [animation setDuration:duration];
        [animation setRemovedOnCompletion:NO];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [_iconPinUser setHidden:NO];
        
        [[_rotatingViewPinUser layer] addAnimation:animation forKey:nil];
        
        //button ok
        [_btnOk setTitle:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_btnThanks" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
        [_btnOk setTitleColor:[[ColorHelper sharedInstance] whiteColor] forState:UIControlStateNormal];
        [_btnOk setTitleColor:[[ColorHelper sharedInstance] whiteColor] forState:UIControlStateHighlighted];
        [_btnOk setBackgroundColor:[[ColorHelper sharedInstance] rewardsOneColor]];
        [[_btnOk titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:12.0f]];
        [[_btnOk titleLabel] setTextAlignment: NSTextAlignmentCenter];
        
        [_btnOk setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [[_btnOk titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [[_btnOk titleLabel] setMinimumScaleFactor:0.5f];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[FZUIImageWithImage imageNamed:@"arrow_right_green" inBundle:FZBundleBlackBox]];
        [_btnOk addSubview:arrow];
        CGRect arrowFrame = [arrow frame];
        arrowFrame.origin.y = ([_btnOk bounds].size.height - [arrow frame].size.height)/2;
        arrowFrame.origin.x = [_btnOk bounds].size.width - [arrow frame].size.width;
        [arrow setFrame:arrowFrame];
        [arrow release];
        
        _btnOk.layer.cornerRadius = 2;
        
        //button map
        [_btnGoToMap setTitle:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_btn_map" withComment:@"ActionSuccessfulAfterPaymentViewController" inDefaultBundle:FZBundlePayment /*forceOverridable:YES*/ ] uppercaseString] forState:UIControlStateNormal];
        [_btnGoToMap setTitleColor:[[ColorHelper sharedInstance] rewardsOneColor] forState:UIControlStateNormal];
        [_btnGoToMap setTitleColor:[[ColorHelper sharedInstance] rewardsOneColor] forState:UIControlStateHighlighted];
        [_btnGoToMap setBackgroundColor:[[ColorHelper sharedInstance] whiteColorWithAlpha:0]];
        [[_btnGoToMap titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f]];
        [[_btnGoToMap titleLabel] setTextAlignment: NSTextAlignmentCenter];
        _btnGoToMap.layer.cornerRadius = 2;
        _btnGoToMap.layer.borderWidth = 2;
        
        _btnGoToMap.layer.borderColor = [[ColorHelper sharedInstance] rewardsOneColor].CGColor;
    }
    //display view coupons
    else if(_nbOfPointsToGenerateACoupon != 0 && _nbOfGeneratedPoints != 0 && ((_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard) >= _nbOfPointsToGenerateACoupon)) {
        
        _mode = FZActionSuccessFullWithCoupons;
        
        [_imageCouponIndicator setImage:[FZUIImageWithImage imageNamed:@"indic_white" inBundle:FZBundlePayment]];
        
        //remove the others views and add the right view
        [_viewBackground removeFromSuperview];
        [_viewBackgroundPoints removeFromSuperview];
        [_viewPopUpBackground insertSubview:_viewBackgroundCoupons belowSubview:_viewMaskBottom];
        [_viewBackgroundCoupons setFrame:CGRectMake(xBackgroudPosition, yBackgroudPosition, _viewBackgroundPoints.frame.size.width, _viewBackgroundPoints.frame.size.height)];
        
        
        //set background
        [_viewBackgroundCoupons setBackgroundColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
        _viewBackgroundCoupons.layer.cornerRadius = 5;
        [_viewMaskBottom setBackgroundColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
        _viewMaskBottom.layer.cornerRadius = 5;
        
#warning TODO set background image
        [_imageViewCoupons setImage:nil];
        [_imageViewCoupons setHidden:YES];
        
        //titles
        [_lblThisPurchaseCoupons setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblThisPurchaseCoupons" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        [_lblThisPurchaseCoupons setTextColor:[[ColorHelper sharedInstance] whiteColor]];
        [_lblThisPurchaseCoupons setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
        
        //earn coupon
        [self setNbOfEarnCoupons:(int)(_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard)/_nbOfPointsToGenerateACoupon];
        [self setDividedOpacity:1.0];
        
        if((_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard)/_nbOfPointsToGenerateACoupon > 1) {
            [_lblNbOfCoupons setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNbOfCoupons_s" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],(_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard)/_nbOfPointsToGenerateACoupon, [[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.2f",_amountOfACoupon] currency:[[[[UserSession currentSession] user] account] currency]]] uppercaseString]];
        } else {
            [_lblNbOfCoupons setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNbOfCoupons" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.2f",_amountOfACoupon] currency:[[[[UserSession currentSession] user] account] currency]]] uppercaseString]];
        }
        
        [_lblNbOfCoupons setTextColor:[[ColorHelper sharedInstance] whiteColor]];
        [_lblNbOfCoupons setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:28.0f]];
        [_lblNbOfCoupons setAdjustsFontSizeToFitWidth:YES];
        [_lblNbOfCoupons setMinimumScaleFactor:0.5];
        
        //round
        [[_bgAmountOfPointForCoupons layer] setCornerRadius:_bgAmountOfPoint.frame.size.height/2];
        [_bgAmountOfPointForCoupons setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
		
		[[self lblNbOfCoupons] setAdjustsFontSizeToFitWidth:YES];
        
        //set labels
        [_lblAmountOfACouponForCoupons setText:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.0f",_amountOfACoupon] currency:[[[[UserSession currentSession] user] account] currency]]];
        
        [_lblNumberOfPointsForCoupons setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
        
        int pointsOntheCard = (int)(_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints);
        
        if(_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints > 1) {
            
            //correct the nomber of points on the loyalty card
            if(pointsOntheCard > _nbOfPointsToGenerateACoupon) {
                pointsOntheCard = (int)(pointsOntheCard - ((_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard)/_nbOfPointsToGenerateACoupon)*_nbOfPointsToGenerateACoupon);
            }
            
            [_lblNumberOfPointsForCoupons setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNumberOfPoints_s" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],pointsOntheCard] uppercaseString]];
        } else {
            [_lblNumberOfPointsForCoupons setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNumberOfPoints" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        }
		
		[[self lblNumberOfPointsForCoupons] setAdjustsFontSizeToFitWidth:YES];
        
        //Animation
        float duration = 2.0;
        int startAngle = 90;
        int angleToEarnACoupon = startAngle + 270;
        
        double currentAngle = ((angleToEarnACoupon - startAngle)/((double)_nbOfPointsToGenerateACoupon))*pointsOntheCard;
        currentAngle = currentAngle<1.0?1.0:currentAngle;
        
        int stopAngle = startAngle + currentAngle;
        
        //progress points bar
        int strokeLine = 16;
        //CGPoint center = CGPointMake(_viewBackgroundCoupons.frame.origin.x +  _viewProgressPointsForCoupons.frame.origin.x + _viewProgressPointsBarForCoupons.frame.origin.x + _viewProgressPointsBarForCoupons.frame.size.width/2,_viewBackgroundCoupons.frame.origin.y + _viewProgressPointsForCoupons.frame.origin.y + _viewProgressPointsBarForCoupons.frame.origin.y + _viewProgressPointsBarForCoupons.frame.size.height/2);
               
        //draw progress points bar circle background
        _cpBackgroundForCouponView = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor] radius:_viewProgressPointsBarForCoupons.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
        [_cpBackgroundForCouponView drawCircleFromAngle:startAngle toAngle:angleToEarnACoupon withDuration:0 inLayer:[_viewProgressPointsBarForCoupons layer]];
        
        //draw progress points bar circle
        _cpForCouponView = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[[[ColorHelper sharedInstance] rewardsOneColor] colorWithAlphaComponent:_dividedOpacity] radius:_viewProgressPointsBarForCoupons.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
        [_cpForCouponView drawCircleFromAngle:startAngle toAngle:angleToEarnACoupon withDuration:duration inLayer:_cpBackgroundForCouponView];
        
        [_cpForCouponView setDelegate:self];
        
        //button ok
        [_btnOk setTitle:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_btnCongratulations" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
        [_btnOk setTitleColor:[[ColorHelper sharedInstance] rewardsThreeColor] forState:UIControlStateNormal];
        [_btnOk setTitleColor:[[ColorHelper sharedInstance] rewardsThreeColor] forState:UIControlStateHighlighted];
        [_btnOk setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        
        [_btnOk setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [[_btnOk titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:12.0f]];
        [[_btnOk titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [[_btnOk titleLabel] setMinimumScaleFactor:0.5f];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[FZUIImageWithImage imageNamed:@"arrow_right_green" inBundle:FZBundleBlackBox]];
        [_btnOk addSubview:arrow];
        CGRect arrowFrame = [arrow frame];
        arrowFrame.origin.y = ([_btnOk bounds].size.height - [arrow frame].size.height)/2;
        arrowFrame.origin.x = [_btnOk bounds].size.width - [arrow frame].size.width;
        [arrow setFrame:arrowFrame];
        [arrow release];
        
        _btnOk.layer.cornerRadius = 2;
        
        //button map
        [_btnGoToMap setTitle:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_btn_map" withComment:@"ActionSuccessfulAfterPaymentViewController" inDefaultBundle:FZBundlePayment /*forceOverridable:YES*/] uppercaseString] forState:UIControlStateNormal];
        [_btnGoToMap setTitleColor:[[ColorHelper sharedInstance] rewardsOneColor] forState:UIControlStateNormal];
        [_btnGoToMap setTitleColor:[[ColorHelper sharedInstance] rewardsOneColor] forState:UIControlStateHighlighted];
        [_btnGoToMap setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        [[_btnGoToMap titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f]];
        [[_btnGoToMap titleLabel] setTextAlignment: NSTextAlignmentCenter];
        _btnGoToMap.layer.cornerRadius = 2;
        _btnGoToMap.layer.borderWidth = 2;
        _btnGoToMap.layer.borderColor = [[ColorHelper sharedInstance] whiteColor].CGColor;
        
    }
    //display view no point, no coupon
    else {
        
        _mode = FZActionSuccessFullNoPointsNoCoupons;
        
        //remove the others views and add the right view
        [_viewBackgroundCoupons removeFromSuperview];
        [_viewBackgroundPoints removeFromSuperview];
        [_viewPopUpBackground insertSubview:_viewBackground belowSubview:_viewMaskBottom];
        
        //set Background
        if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
            [_viewBackground setBackgroundColor:[[ColorHelper sharedInstance] mainOneColor]];
            [_viewMaskBottom setBackgroundColor:[[ColorHelper sharedInstance] mainOneColor]];
        } else {
            [_viewBackground setBackgroundColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
            [_viewMaskBottom setBackgroundColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
        }
        
        _viewBackground.layer.cornerRadius = 5;
        _viewMaskBottom.layer.cornerRadius = 5;
        
        //titles
        [_lblValidate setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_label_success" withComment:@"ActionSuccessfulAfterPaymentViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
        [_lblValidate setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:28.0f]];
        
        //center check
        [_btnCheckRound startWithNumberOfRiddles:2 direction:kFlashizRiddleAnimationDirectionExpand color:[[ColorHelper sharedInstance] whiteColor]];
        
        //button ok
        [_btnOk setTitle:[[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] uppercaseString] forState:UIControlStateNormal];
        if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
            [_btnOk setTitleColor:[[ColorHelper sharedInstance] mainOneColor] forState:UIControlStateNormal];
            [_btnOk setTitleColor:[[ColorHelper sharedInstance] mainOneColor] forState:UIControlStateHighlighted];
        } else {
            [_btnOk setTitleColor:[[ColorHelper sharedInstance] rewardsThreeColor] forState:UIControlStateNormal];
            [_btnOk setTitleColor:[[ColorHelper sharedInstance] rewardsThreeColor] forState:UIControlStateHighlighted];
        }
        [_btnOk setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        [[_btnOk titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:16.0f]];
        
        [_btnOk setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [[_btnOk titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:16.0f]];
        [[_btnOk titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [[_btnOk titleLabel] setMinimumScaleFactor:0.5f];
        
        UIImageView *arrow = nil;
        
        //use custom arrow if needed
        if(_customArrow){
            arrow = [[UIImageView alloc] initWithImage:[FZUIImageWithImage imageNamed:_customArrow inBundle:FZBundleBlackBox]];
        } else {
            if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
                arrow = [[UIImageView alloc] initWithImage:[FZUIImageWithImage imageNamed:@"arrow_right_blue" inBundle:FZBundleBlackBox]];
            } else {
                arrow = [[UIImageView alloc] initWithImage:[FZUIImageWithImage imageNamed:@"arrow_right_green" inBundle:FZBundleBlackBox]];
            }
        }
        
        [_btnOk addSubview:arrow];
        CGRect arrowFrame = [arrow frame];
        arrowFrame.origin.y = ([_btnOk bounds].size.height - [arrow frame].size.height)/2;
        arrowFrame.origin.x = [_btnOk bounds].size.width - [arrow frame].size.width;
        [arrow setFrame:arrowFrame];
        [arrow release];
        
        _btnOk.layer.cornerRadius = 2;
        
        //button map
        [_btnGoToMap setTitle:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_btn_map" withComment:@"ActionSuccessfulAfterPaymentViewController" inDefaultBundle:FZBundlePayment /*forceOverridable:YES*/] uppercaseString] forState:UIControlStateNormal];
        [_btnGoToMap setTitleColor:[[ColorHelper sharedInstance] whiteColor] forState:UIControlStateNormal];
        [_btnGoToMap setTitleColor:[[ColorHelper sharedInstance] whiteColor] forState:UIControlStateHighlighted];
        [_btnGoToMap setBackgroundColor:[[ColorHelper sharedInstance] whiteColorWithAlpha:0.0f]];
        [[_btnGoToMap titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12.0f]];
        [[_btnGoToMap titleLabel] setTextAlignment: NSTextAlignmentCenter];
        _btnGoToMap.layer.cornerRadius = 2;
        _btnGoToMap.layer.borderWidth = 2;
        _btnGoToMap.layer.borderColor = [[ColorHelper sharedInstance] whiteColor].CGColor;
    }
    
    //_btnGoToMap can be hidden when no ProximityMapViewController
    Class proximityMapViewControllerClass = NSClassFromString(@"ProximityMapViewController");
    [_btnGoToMap setHidden:(nil==proximityMapViewControllerClass)];
}

- (void)viewDidLayoutSubviews {
    
    CGRect viewBackgroundPointsFrame = [_viewBackgroundPoints frame];
    viewBackgroundPointsFrame.size.height = [_btnOk center].y - [_viewBackgroundPoints frame].origin.y;
    [_viewBackgroundPoints setFrame:viewBackgroundPointsFrame];
    
    CGRect viewBackgroundFrame = [_viewBackground frame];
    viewBackgroundFrame.size.height = [_btnOk center].y - [_viewBackground frame].origin.y;
    [_viewBackground setFrame:viewBackgroundFrame];
    
    CGRect viewBackgroundCouponsFrame = [_viewBackgroundCoupons frame];
    viewBackgroundCouponsFrame.size.height = [_btnOk center].y - [_viewBackgroundCoupons frame].origin.y;
    [_viewBackgroundCoupons setFrame:viewBackgroundCouponsFrame];
    
    CGRect viewMaskButtonFrame = [_viewMaskBottom frame];
    viewMaskButtonFrame.origin.y = [_btnOk frame].origin.y;
    [_viewMaskBottom setFrame:viewMaskButtonFrame];
}

#pragma mark - private method

- (void)customArrow:(NSString *)imageName {
    [self setCustomArrow:imageName];
}

#pragma mark - Action method

- (IBAction)goToMapView:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointPaymentDoneSeeShops];
    if([_delegate respondsToSelector:@selector(didGoToMap:)]) {
        [_delegate didGoToMap:self];
    }
}

/*
 * tap the check image or the Ok button
 */
- (IBAction)validateAction:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointPaymentDone];
    if(![_btnCheckRound isHidden]){
        [_btnCheckRound stopRiddles];
    }
    
    if([_delegate respondsToSelector:@selector(didValidate:)]) {
        [_delegate didValidate:self];
    }
}

#pragma mark - CircleProgress delegate

- (void)progressBarDidLoad {
    
    int pointsOntheCard =(int)(_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints);
    
    if(_nbOfPointsOnTheLoyaltyCard + _nbOfGeneratedPoints > 1) {
        
        //correct the nomber of points on the loyalty card
        if(pointsOntheCard > _nbOfPointsToGenerateACoupon) {
            pointsOntheCard = pointsOntheCard - (int)(((_nbOfGeneratedPoints + _nbOfPointsOnTheLoyaltyCard)/_nbOfPointsToGenerateACoupon)*_nbOfPointsToGenerateACoupon);
        }
        
        [_lblNumberOfPointsForCoupons setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNumberOfPoints_s" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],pointsOntheCard] uppercaseString]];
    } else {
        [_lblNumberOfPointsForCoupons setText:[[LocalizationHelper stringForKey:@"actionSuccessfulAfterPaymentViewController_lblNumberOfPoints" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    }
    
    //Animation
    float duration = 2.0;
    int startAngle = 90;
    int angleToEarnACoupon = startAngle + 270;
    
    double currentAngle = ((angleToEarnACoupon - startAngle)/((double)_nbOfPointsToGenerateACoupon))*pointsOntheCard;
    currentAngle = currentAngle<1.0?1.0:currentAngle;
    
    int stopAngle = startAngle + currentAngle;
    
    //progress points bar
    int strokeLine = 16;
    
    if (_nbOfEarnCoupons > 1) {
        
        [UIView animateWithDuration:0.2f animations:^{
            _bgAmountOfPointForCoupons.transform = CGAffineTransformMakeScale(1.2, 1.2);
            _bgAmountOfPointForCoupons.alpha = 0.5;
        } completion:^(BOOL finished) {
            _bgAmountOfPointForCoupons.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _bgAmountOfPointForCoupons.alpha = 1;
            
            [_cpForCouponView removeFromSuperlayer];
            
            //draw progress points bar circle
            _cpForCouponView = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[[[ColorHelper sharedInstance] rewardsOneColor] colorWithAlphaComponent:_dividedOpacity] radius:_viewProgressPointsBarForCoupons.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
            [_cpForCouponView drawCircleFromAngle:startAngle toAngle:angleToEarnACoupon withDuration:duration inLayer:_cpBackgroundForCouponView];
            [_cpForCouponView setDelegate:self];
            
            _nbOfEarnCoupons--;
        }];
        
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            _bgAmountOfPointForCoupons.transform = CGAffineTransformMakeScale(1.2, 1.2);
            _bgAmountOfPointForCoupons.alpha = 0.5;
        } completion:^(BOOL finished) {
            _bgAmountOfPointForCoupons.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _bgAmountOfPointForCoupons.alpha = 1;

            
            [_cpForCouponView removeFromSuperlayer];
            
            _cpForCouponView = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[[[ColorHelper sharedInstance] rewardsOneColor] colorWithAlphaComponent:_dividedOpacity] radius:_viewProgressPointsBarForCoupons.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
            [_cpForCouponView drawCircleFromAngle:startAngle toAngle:stopAngle withDuration:duration inLayer:_cpBackgroundForCouponView];
        }];
    }
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewPopUpBackground release];
    [_btnGoToMap release];
    [_btnOk release];
    [_viewBackground release];
    [_lblValidate release];
    [_btnCheckRound release];
    [_lblThisPurchasePoints release];
    [_lblNbOfPointsEarn release];
    [_viewProgressPoints release];
    [_viewProgressPointsBar release];
    [_lblNumberOfPointsBeforeACoupon release];
    [_lblAmountOfACoupon release];
    [_bgAmountOfPoint release];
    [_lblNumberOfPoints release];
    [_imageCouponIndicator release];
    [_lblThisPurchaseCoupons release];
    [_lblNbOfCoupons release];
    [_viewProgressPointsForCoupons release];
    [_viewProgressPointsBarForCoupons release];
    [_lblAmountOfACouponForCoupons release];
    [_bgAmountOfPointForCoupons release];
    [_lblNumberOfPointsForCoupons release];
    [_imageCouponIndicatorForCoupons release];
    [_viewBackgroundPoints release];
    [_viewBackgroundCoupons release];
    [_imageViewCoupons release];
    [_viewMaskBottom release];
    [_iconPinUser release];
    [_rotatingViewPinUser release];
    [_customArrow release];
    [_cpBackgroundForCouponView release];
    [_cpForCouponView release];
    [super dealloc];
}
@end
