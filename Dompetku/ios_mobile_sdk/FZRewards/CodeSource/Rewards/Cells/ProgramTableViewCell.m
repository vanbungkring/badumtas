//
//  ProgramTableViewCell.m
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "ProgramTableViewCell.h"


//Domain
#import <FZAPI/LoyaltyProgram.h>
#import <FZAPI/UserSession.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//Utils
#import <FZBlackBox/FZUIImageWithImage.h>

//Helper
#import <FZBlackBox/ColorHelper.h>
#import <FZBlackBox/LocalizationHelper.h>
#import <FZBlackBox/FontHelper.h>

//Target manager
#import <FZBlackBox/FZTargetManager.h>

@interface ProgramTableViewCell() {

}

//private properties
@property (retain, nonatomic) IBOutlet UIImageView *imageLogo;
@property (retain, nonatomic) IBOutlet UIImageView *imageMaskLogo;
@property (retain, nonatomic) IBOutlet UILabel *lblProgramName;
@property (retain, nonatomic) IBOutlet UILabel *lblMerchantName;

//indications views
@property (retain, nonatomic) IBOutlet UIView *viewIndications;

@property (retain, nonatomic) IBOutlet UIView *viewIndicationsNear;
@property (retain, nonatomic) IBOutlet UILabel *lblDistance;

@property (retain, nonatomic) IBOutlet UIView *viewIndicationsPointsAndPercent;
@property (retain, nonatomic) IBOutlet UILabel *lblPointsAndPercent;
@property (retain, nonatomic) IBOutlet UILabel *lblTotalPointsAndPercent;

@property (retain, nonatomic) IBOutlet UIView *viewIndicationsCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblAmountOfACoupons;
@property (retain, nonatomic) IBOutlet UIImageView *imageCoupons;

@property (retain, nonatomic) IBOutlet UIView *viewIndicationsCouponsIndo;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfCouponsIndo;
@property (retain, nonatomic) IBOutlet UILabel *lblAmountOfACouponsIndo;

@property (retain, nonatomic) IBOutlet UIView *viewIndicationsSuggested;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfPurchases;
@property (retain, nonatomic) IBOutlet UILabel *lblPurchases;


@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//private actions

@end

@implementation ProgramTableViewCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Cycle life

- (void)prepareForReuse {
    [super prepareForReuse];
    [_viewIndicationsCoupons removeFromSuperview];
    [_viewIndicationsNear removeFromSuperview];
    [_viewIndicationsPointsAndPercent removeFromSuperview];
    [_viewIndicationsSuggested removeFromSuperview];
    [_viewIndicationsCouponsIndo removeFromSuperview];
    [_lblPointsAndPercent setText:@""];
    [_lblDistance setText:@""];
    [_lblNumberOfCoupons setText:@""];
    [_lblAmountOfACoupons setText:@""];
    [_lblNumberOfPurchases setText:@""];
    [_lblPurchases setText:[LocalizationHelper stringForKey:@"purchases" withComment:@"ProgramTableViewCell" inDefaultBundle:FZBundleRewards]];
    [_imageLogo setImage:nil];
    
    [_activityIndicator startAnimating];
}


- (void) isOdd{
    [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    [_lblProgramName setTextColor:[[ColorHelper sharedInstance] programTableViewCell_lblProgramName_odd_textColor]];
    [_lblProgramName setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblProgramName_odd_backgroundColor]];
    [_lblMerchantName setTextColor:[[ColorHelper sharedInstance] programTableViewCell_lblMerchantName_odd_textColor]];
    [_lblMerchantName setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblMerchantName_odd_backgroundColor]];
    
    [self manageImageCouponDisplayIfItIsOdd:YES];

    [_imageLogo setBackgroundColor:[UIColor whiteColor]];
    
    [_lblNumberOfCoupons setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
    [_lblNumberOfCoupons setBackgroundColor:[UIColor whiteColor]];
    [_lblAmountOfACoupons setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
    [_lblAmountOfACoupons setBackgroundColor:[UIColor whiteColor]];
    
    [_lblNumberOfCouponsIndo setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
    [_lblNumberOfCouponsIndo setBackgroundColor:[UIColor whiteColor]];
    [_lblAmountOfACouponsIndo setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
    [_lblAmountOfACouponsIndo setBackgroundColor:[UIColor whiteColor]];
    
    [_lblPointsAndPercent setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
    [_lblTotalPointsAndPercent setTextColor:[[ColorHelper sharedInstance] rewardsThreeColor]];
    
    [_imageMaskLogo setImage:[FZUIImageWithImage imageNamed:@"mask_program_list_white" inBundle:FZBundleRewards]];
    
    [_viewIndicationsPointsAndPercent setBackgroundColor:[UIColor whiteColor]];
    [_viewIndicationsCoupons setBackgroundColor:[UIColor whiteColor]];
    [_viewIndicationsCouponsIndo setBackgroundColor:[UIColor whiteColor]];
}
- (void) isEven{
    [[self contentView] setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_contentView_even_backgroundColor]];
    [_lblProgramName setTextColor:[[ColorHelper sharedInstance] programTableViewCell_lblProgramName_even_textColor]];
    [_lblProgramName setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblProgramName_even_backgroundColor]];
    [_lblMerchantName setTextColor:[[[ColorHelper sharedInstance] programTableViewCell_lblMerchantName_even_textColor] colorWithAlphaComponent:0.75f]];
    [_lblMerchantName setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblMerchantName_even_backgroundColor]];
    
    [self manageImageCouponDisplayIfItIsOdd:NO];
    
    [_imageLogo setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_imageLogo_even_backgroundColor]];
    
    [_lblNumberOfCoupons setTextColor:[UIColor whiteColor]];
    [_lblNumberOfCoupons setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblNumberOfCoupons_even_backgroundColor]];
    [_lblAmountOfACoupons setTextColor:[UIColor whiteColor]];
    [_lblAmountOfACoupons setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblAmountOfACoupons_even_backgroundColor]];
   
    [_lblNumberOfCouponsIndo setTextColor:[UIColor whiteColor]];
    [_lblNumberOfCouponsIndo setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblNumberOfCoupons_even_backgroundColor]];
    [_lblAmountOfACouponsIndo setTextColor:[UIColor whiteColor]];
    [_lblAmountOfACouponsIndo setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_lblAmountOfACoupons_even_backgroundColor]];
    
    [_lblPointsAndPercent setTextColor:[UIColor whiteColor]];
    [_lblTotalPointsAndPercent setTextColor:[UIColor whiteColor]];
    
    [_imageMaskLogo setImage:[FZUIImageWithImage imageNamed:@"mask_program_list_green" inBundle:FZBundleRewards]];
    
    [_viewIndicationsPointsAndPercent setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor]];
    [_viewIndicationsCoupons setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_viewIndicationsCoupons_even_backgroundColor]];
    [_viewIndicationsCouponsIndo setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_viewIndicationsCoupons_even_backgroundColor]];
}

- (void)manageImageCouponDisplayIfItIsOdd:(BOOL)isOdd {
    if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) { //round coupons
        if (isOdd) {
            [_imageCoupons setImage:[FZUIImageWithImage imageNamed:@"circle_fidelitiz_green" inBundle:FZBundleRewards]];
            [_imageCoupons setBackgroundColor:[UIColor whiteColor]];
        } else {
            [_imageCoupons setImage:[FZUIImageWithImage imageNamed:@"circle_fidelitiz_white" inBundle:FZBundleRewards]];
            [_imageCoupons setBackgroundColor:[[ColorHelper sharedInstance] programTableViewCell_imageCoupons_even_bacgroundColor]];
        }
    } else { //square coupons
        [_imageCoupons setImage:nil];
        
        CGRect lblAmountOfACouponsFrame = [_lblAmountOfACouponsIndo frame];
        lblAmountOfACouponsFrame.size.width = [[_lblAmountOfACouponsIndo text] length]*8.0 + 18.0;
        
        float rightX = [_viewIndicationsCouponsIndo frame].size.width - lblAmountOfACouponsFrame.size.width;
        lblAmountOfACouponsFrame.origin.x = rightX;
        
        [_lblAmountOfACouponsIndo setFrame:lblAmountOfACouponsFrame];
        
        [[_lblAmountOfACouponsIndo layer] setBorderWidth:1.0];
        [[_lblAmountOfACouponsIndo layer] setCornerRadius:2.0];

        if (isOdd) {
            [[_lblAmountOfACouponsIndo layer] setBorderColor:[[ColorHelper sharedInstance] rewardsThreeColor].CGColor];
        } else {
            [[_lblAmountOfACouponsIndo layer] setBorderColor:[UIColor whiteColor].CGColor];
        }
    }
}

#pragma mark - Setup table call view

-(void)reset
{
    [_viewIndicationsNear setHidden:NO];
    [_viewIndicationsCoupons setHidden:NO];
    [_viewIndicationsSuggested setHidden:NO];
    [_viewIndicationsPointsAndPercent setHidden:NO];
}

- (void)setUpTableCellViewWithIndicationPointsAndPercent:(NSString*)pointsAndPercent{
    [_viewIndicationsNear setHidden:YES];
    [_viewIndicationsCoupons setHidden:YES];
    [_viewIndicationsSuggested setHidden:YES];
    [_viewIndicationsCouponsIndo setHidden:YES];
    
    if([pointsAndPercent rangeOfString:@"%"].location != NSNotFound){
        [_lblPointsAndPercent setText:@""];
        [_lblTotalPointsAndPercent setText:pointsAndPercent];
        [_lblTotalPointsAndPercent setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18]];
    } else {
        NSArray *pointsAndPercentageArray = [pointsAndPercent componentsSeparatedByString: @"/"];
        if([pointsAndPercentageArray count] > 1){
            NSString *value = [pointsAndPercentageArray objectAtIndex:0];
            NSString *total = [pointsAndPercentageArray objectAtIndex:1];
            [_lblPointsAndPercent setText:value];
            [_lblTotalPointsAndPercent setText:[NSString stringWithFormat:@"/ %@",total]];
            [_lblTotalPointsAndPercent setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12]];
        }
    }
    [_viewIndications addSubview:_viewIndicationsPointsAndPercent];
}

- (void)setUpTableCellViewWithIndicationNear:(NSString*)distance{
    [_viewIndicationsPointsAndPercent setHidden:YES];
    [_viewIndicationsCoupons setHidden:YES];
    [_viewIndicationsSuggested setHidden:YES];
    [_viewIndicationsCouponsIndo setHidden:YES];
    
    [_lblDistance setText:distance];
    [_viewIndications addSubview:_viewIndicationsNear];
}

- (void)setUpTableCellViewWithIndicationCoupons:(NSString*)numberOfCoupons :(NSString*)amountOfACoupon{
    [_viewIndicationsPointsAndPercent setHidden:YES];
    [_viewIndicationsNear setHidden:YES];
    [_viewIndicationsSuggested setHidden:YES];
    [_viewIndicationsCouponsIndo setHidden:YES];
    
    [_lblNumberOfCoupons setText:numberOfCoupons];
    [_lblNumberOfCouponsIndo setText:numberOfCoupons];
    
    if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) {
        [_lblAmountOfACoupons setText:[[CurrenciesManager currentManager] formattedAmountLight:amountOfACoupon currency:[[[[UserSession currentSession] user] account] currency]]];
        
        [_viewIndications addSubview:_viewIndicationsCoupons];
    } else {
        [_viewIndicationsCouponsIndo setHidden:NO];
        
        [_lblAmountOfACouponsIndo setText:[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:amountOfACoupon]];
        
        [_viewIndications addSubview:_viewIndicationsCouponsIndo];
    }
}

- (void)setUpTableCellViewWithIndicationCouponsPercent:(NSString*)numberOfCoupons :(NSString*)amountOfACoupon{
    [_viewIndicationsPointsAndPercent setHidden:YES];
    [_viewIndicationsNear setHidden:YES];
    [_viewIndicationsSuggested setHidden:YES];
    [_viewIndicationsCouponsIndo setHidden:YES];
    
    [_lblNumberOfCoupons setText:numberOfCoupons];
	[_lblNumberOfCouponsIndo setText:numberOfCoupons];
	
	if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) {
		[_lblAmountOfACoupons setText:[[CurrenciesManager currentManager] formattedPercentLight:amountOfACoupon]];
		[_viewIndications addSubview:_viewIndicationsCoupons];
	}else{
		[_viewIndicationsCouponsIndo setHidden:NO];
        
        [_lblAmountOfACouponsIndo setText:[[CurrenciesManager currentManager] formattedPercentLight:amountOfACoupon]];
        
        [_viewIndications addSubview:_viewIndicationsCouponsIndo];
	}
    
    
}

- (void)setUpTableCellViewWithIndicationSuggested:(NSString*)numberOfPurchases{
    [_viewIndicationsPointsAndPercent setHidden:YES];
    [_viewIndicationsNear setHidden:YES];
    [_viewIndicationsCoupons setHidden:YES];
    [_viewIndicationsCouponsIndo setHidden:YES];
    
    [_lblNumberOfPurchases setText:numberOfPurchases];
    [_lblPurchases setText:[LocalizationHelper stringForKey:@"purchases" withComment:@"ProgramTableViewCell" inDefaultBundle:FZBundleRewards]];
    [_viewIndications addSubview:_viewIndicationsSuggested];
}

- (void)setUpTableCellViewForAllPrograms {
    
    float cellWidth = [self frame].size.width;
    
    CGRect lblProgramNameFrame = [_lblProgramName frame];
    lblProgramNameFrame.size.width = cellWidth - lblProgramNameFrame.origin.x;

    [_lblProgramName setFrame:lblProgramNameFrame];
    
    
    CGRect lblMerchantNameFrame = [_lblMerchantName frame];
    lblMerchantNameFrame.size.width = cellWidth - lblMerchantNameFrame.origin.x;
    
    [_lblMerchantName setFrame:lblMerchantNameFrame];
}

#pragma mark - Setters and Getters

- (void)setProgramName:(NSString*)programName {
    [_lblProgramName setText:programName];
    [_lblProgramName setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:15.0]];
}

- (void)setMerchantName:(NSString*)merchantName {
    [_lblMerchantName setText:merchantName];
    [_lblProgramName setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:15.0]];
}

-(void)setLogo:(UIImage *)image{
    [_activityIndicator stopAnimating];
    [_imageLogo setImage:image];
}

#pragma mark - MM

- (void)dealloc {
    
    [_imageLogo release], _imageLogo = nil;
    [_imageMaskLogo release], _imageMaskLogo = nil;
    [_lblProgramName release], _lblProgramName = nil;
    [_lblMerchantName release], _lblMerchantName = nil;
    
    [_viewIndications release], _viewIndications = nil;
    
    [_viewIndicationsNear release], _viewIndicationsNear = nil;
    [_lblDistance release], _lblDistance = nil;
    
    [_viewIndicationsPointsAndPercent release], _viewIndicationsPointsAndPercent = nil;
    [_lblPointsAndPercent release], _lblPointsAndPercent = nil;
    [_lblTotalPointsAndPercent release], _lblTotalPointsAndPercent = nil;
    
    [_viewIndicationsCoupons release], _viewIndicationsCoupons = nil;
    [_lblNumberOfCoupons release], _lblNumberOfCoupons = nil;
    [_lblAmountOfACoupons release], _lblAmountOfACoupons = nil;
    [_imageCoupons release], _imageCoupons = nil;
    
    [_viewIndicationsSuggested release], _viewIndicationsSuggested = nil;
    [_lblNumberOfPurchases release], _lblNumberOfPurchases = nil;
    [_lblPurchases release], _lblPurchases = nil;
    
    [_activityIndicator release], _activityIndicator = nil;
    
    [_viewIndicationsCouponsIndo release], _viewIndicationsCouponsIndo = nil;
    [_lblAmountOfACouponsIndo release], _lblAmountOfACouponsIndo = nil;
    [_lblNumberOfCouponsIndo release], _lblNumberOfCouponsIndo = nil;
    
    [super dealloc];
}
@end
