//
//  YourLoyaltyProgramDetailsViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 19/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "YourLoyaltyProgramDetailsViewController.h"

//Fidelitiz Rules Engine
#import "RewardsRulesEngine.h"

//Progress points bar
#import <FZBlackBox/CircleProgress.h>

//Network
#import <FZAPI/RewardsServices.h>

//User session
#import <FZAPI/UserSession.h>

//Language
#import <FZBlackBox/LocalizationHelper.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Constants
#import <FZBlackBox/FontHelper.h>

//NSString
#import <FZBlackBox/NSStringFontSize.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

//Custom button
#import <FZBlackBox/FZButton.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//Manager
#import <FZBlackBox/FZTargetManager.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

//Util
#import <FZBlackBox/ODDeviceUtil.h>

@interface YourLoyaltyProgramDetailsViewController () <UIAlertViewDelegate> {
	
}

//private properties
@property (retain, nonatomic) IBOutlet UILabel *lblMerchantName;
@property (retain, nonatomic) IBOutlet FZButton *btnDeleteLoyaltyCard;
@property (retain, nonatomic) IBOutlet UILabel *lblRule;

@property (retain, nonatomic) IBOutlet UIView *viewNumberOfCoupons;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfCoupons;
@property (retain, nonatomic) IBOutlet UIView *bgCouponApp;
@property (retain, nonatomic) IBOutlet UIView *bgCouponBankSdk;

@property (retain, nonatomic) IBOutlet UILabel *lblAmountOfACouponTop;

@property (retain, nonatomic) IBOutlet UIImageView *imgBackgroung;
@property (retain, nonatomic) IBOutlet UIView *viewProgressPoints;
@property (retain, nonatomic) IBOutlet UIView *viewProgressPointsBar;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfPointsBeforeACoupon;
@property (retain, nonatomic) IBOutlet UILabel *lblAmountOfACoupon;
@property (retain, nonatomic) IBOutlet UIView *bgAmountOfPoint;
@property (retain, nonatomic) IBOutlet UILabel *lblNumberOfPoints;
@property (retain, nonatomic) IBOutlet UIImageView *imageCouponIndicator;

@property (retain, nonatomic) IBOutlet UIView *bgAmountSaved;
@property (retain, nonatomic) IBOutlet UILabel *lblAmountSaved;

//private actions
- (IBAction)deleteLoyaltyCard:(id)sender;

//Model
@property (retain, nonatomic)LoyaltyProgram *yourProgram;
@property (retain, nonatomic) LoyaltyCard *yourCard;

@end

@implementation YourLoyaltyProgramDetailsViewController

@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"YourLoyaltyProgramDetailsViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    ;
    if (self) {
        [self setCanDisplayMenu:NO];
    }
    return self;
}

- (id)initWithLoyaltyCard:(LoyaltyCard *)card AndProgram:(LoyaltyProgram *)program {
    self = [super initWithNibName:@"YourLoyaltyProgramDetailsViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    ;
    if (self) {
        [self setYourCard:card];
        [self setYourProgram:program];
        [self setCanDisplayMenu:NO];
    }
    
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	
	[self setTitleHeader:[LocalizationHelper stringForKey:@"fidelitizHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleRewards]];
	[self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
	[self setBackgroundColor:[[ColorHelper sharedInstance] rewardsOneColor]];
	
	[self setUpView];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//hide master navigationController
	//[[[self tabBarController] navigationController] setNavigationBarHidden:YES];
	//show fidelitiz navigation controller
	
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//show master navigation controller
	//[[[self tabBarController] navigationController] setNavigationBarHidden:NO];
	//hide fidelitiz navigation controller
	
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start rewards your program details ViewController"];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[[FZTargetManager sharedInstance] facade] showDebugLog:@"Close rewards your program details ViewController"];
}

#pragma mark - Setup view

- (void)setUpView {
    //Descope
    [_bgAmountSaved setHidden:YES];
    [_lblAmountSaved setHidden:YES];
    
    //set Delete loyalty card
    [_btnDeleteLoyaltyCard setTitle:[[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_btn_deleteCard" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards] uppercaseString] forState:UIControlStateNormal];
    [_btnDeleteLoyaltyCard setTitleColor:[[ColorHelper sharedInstance] monochromeTwoColor] forState:UIControlStateHighlighted];
    
    [_btnDeleteLoyaltyCard setBackgroundNormalColor:[_btnDeleteLoyaltyCard backgroundColor]];
    [_btnDeleteLoyaltyCard setBackgroundHighlightedColor:[[ColorHelper sharedInstance]yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor]];
    
    [_btnDeleteLoyaltyCard setHidden:![_yourCard leavable]];
    
    //merchant name
	if([[_yourProgram loyaltyProgramOwnerCompanyName] isEqualToString:@""] || [_yourProgram loyaltyProgramOwnerCompanyName]==nil){
		[_lblMerchantName setText:[_yourProgram label]];
	}else{
		[_lblMerchantName setText:[_yourProgram loyaltyProgramOwnerCompanyName]];
	}
	
	[_imgBackgroung setImage:[FZUIImageWithImage imageNamed:@"rewardscard" inBundle:FZBundleRewards]];
	
	UIImage *imgButton = [FZUIImageWithImage imageNamed:@"btn_circle_cross_grey" inBundle:FZBundleBlackBox];
	UIImageView *imgButtonView = [[UIImageView alloc] initWithImage:imgButton];
	[imgButtonView setFrame:CGRectMake(8.0, 6.0, imgButton.size.width, imgButton.size.height)];
	[_btnDeleteLoyaltyCard addSubview:imgButtonView];
	[imgButtonView release];
	
	[[_btnDeleteLoyaltyCard layer] setCornerRadius:4.0];
	
	//fidelitiz rules
	NSArray *rules = [RewardsRulesEngine rulesEngine:_yourProgram Currency:[_yourProgram currency]];
	
	[_lblRule setText:[rules[0] uppercaseString]];
		
	[_lblRule setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:13.0f]];
	
	[_lblRule setText:[NSString stringWithFormat:@"%@\n%@",[rules[0] uppercaseString],[rules[1] uppercaseString]]];
	
	[[self lblRule] setAdjustsFontSizeToFitWidth:YES];
	[_lblRule sizeToFit];
	
	[self setupBgCoupon];
	[[_bgAmountSaved layer] setCornerRadius:_bgAmountSaved.frame.size.height/2];
	[[_bgAmountOfPoint layer] setCornerRadius:_bgAmountOfPoint.frame.size.height/2];
	
	if([[_yourProgram loyaltyProgramType] isEqualToString:@"POINTS"]) {
		//hide unecessary view
		[_bgAmountSaved setHidden:YES];
		[_lblAmountSaved setHidden:YES];
		
		//set labels
		if ([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) {
			[_lblAmountOfACoupon setText:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]] currency:[_yourProgram currency]]];
		} else {
			if(![[_yourProgram rewardType] isEqualToString:@"CASH"]){
				[_lblAmountOfACoupon setText:[[CurrenciesManager currentManager] formattedPercentLight:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]]]];
			} else{
				[_lblAmountOfACoupon setText:[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]]]];
			}
		}
		
		if([_yourCard balance] > 1) {
			
			FZRewardsLog(@"points : %.2f",[_yourCard balance]);
			FZRewardsLog(@"test : %@",[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPoints_s"
																					  withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards],[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.0f",[_yourCard balance]] butWithCurrency:[_yourProgram currency]]]);
			
			
			
			[_lblNumberOfPoints setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPoints_s"
																						 withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards],[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.0f",[_yourCard balance]] butWithCurrency:[_yourProgram currency]]] uppercaseString]];
		} else {
			[_lblNumberOfPoints setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPoints"
																						 withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards],[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.0f",[_yourCard balance]] butWithCurrency:[_yourProgram currency]]] uppercaseString]];
		}
		
		if([_yourProgram pointAmountForCoupon] - [_yourCard balance] == 1) {
			[_lblNumberOfPointsBeforeACoupon setText:[[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPointsBeforeACoupon"
																		   withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
		} else {
			//[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]] currency:[_yourProgram currency]]
			//[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[_yourCard balance]] butWithCurrency:[_yourProgram currency]]
			[_lblNumberOfPointsBeforeACoupon setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfPointsBeforeACoupon_s"
																									  withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundlePayment],[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.0f",[_yourProgram pointAmountForCoupon] - [_yourCard balance]] butWithCurrency:[_yourProgram currency]]] uppercaseString]];
		}
		
		if([[_yourCard coupons] count] > 0 ){
			
			if([[_yourCard coupons] count] == 1 ){
				[_lblNumberOfCoupons setText:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfCoupons" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards]];
			} else {
				[_lblNumberOfCoupons setText:[[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblNumberOfCoupons_s"
																							  withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards],[NSString stringWithFormat:@"%lu",(unsigned long)[[_yourCard coupons] count]]] uppercaseString]];
			}
			
			if ([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) {
				[_lblAmountOfACouponTop setText:[[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]] currency:[_yourProgram currency]]];
			} else {
				if(![[_yourProgram rewardType] isEqualToString:@"CASH"]){
					[_lblAmountOfACouponTop setText:[[CurrenciesManager currentManager] formattedPercentLight:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]]]];
				} else{
					[_lblAmountOfACouponTop setText:[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%.0f",[_yourProgram discountAmount]]]];
				}
			}
			
		} else {
			[_viewNumberOfCoupons setHidden:YES];
			//move up progress view
			[_viewProgressPoints setFrame:CGRectMake(_viewProgressPoints.frame.origin.x, _viewProgressPoints.frame.origin.y-_viewNumberOfCoupons.frame.size.height, _viewProgressPoints.frame.size.width, _viewProgressPoints.frame.size.height + _viewNumberOfCoupons.frame.size.height)];
			
			[_imgBackgroung setFrame:[_viewProgressPoints frame]];
		}
		
		float duration = 2.0;
		double startAngle = 90;
		double angleToEarnACoupon = startAngle + 270;
		
		double currentAngle = ((angleToEarnACoupon - startAngle)/((double)[_yourProgram pointAmountForCoupon]))*[_yourCard balance];
		
		currentAngle = currentAngle<1.0?1.0:currentAngle;
		
		int stopAngle = startAngle + currentAngle;
		
		FZRewardsLog(@"pointAmountForCoupon : %d", [_yourProgram pointAmountForCoupon]);
		FZRewardsLog(@"balance : %f", [_yourCard balance]);
		FZRewardsLog(@"currenAngle : %f", currentAngle);
		        
		//progress points bar
		int strokeLine = 16;
        CGPoint center = CGPointMake(_viewProgressPoints.frame.origin.x + _viewProgressPointsBar.frame.origin.x + _viewProgressPointsBar.frame.size.width/2, _viewProgressPoints.frame.origin.y + _viewProgressPointsBar.frame.origin.y + _viewProgressPointsBar.frame.size.height/2);
		
		//draw progress points bar circle background
		CircleProgress *cpBackground = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor] radius:_viewProgressPointsBar.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
		
		[cpBackground drawCircleFromAngle:startAngle toAngle:angleToEarnACoupon withDuration:0 inLayer:_viewProgressPointsBar.layer];
		
		//[cpBackground drawCircleAtPosition:center FromAngle:startAngle ToAngle:angleToEarnACoupon WithDuration:0 InViewController:self Above:_viewProgressPointsBar.layer];
		
		//draw progress points bar circle
		CircleProgress *cp = [[CircleProgress alloc] initWithFillColor:[UIColor clearColor] strokeColor:[[ColorHelper sharedInstance] rewardsOneColor] radius:_viewProgressPointsBar.frame.size.width/2-strokeLine/2 lineWidth:strokeLine];
		
		[cp drawCircleFromAngle:startAngle toAngle:stopAngle withDuration:duration inLayer:cpBackground];
		
		[cp release];
		[cpBackground release];
		
		//draw the cursor
		
		UIImage *pinUserImage = [FZUIImageWithImage imageNamed:@"icon_pin_user_trick" inBundle:FZBundleRewards];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(center.x-pinUserImage.size.width/2, center.y-pinUserImage.size.height/2, pinUserImage.size.width, pinUserImage.size.height)];
		[imageView setImage:pinUserImage];
				
		//set the animation of the cursor
		//replace with key frame animation to avoid cursor taking the shortest way
		CALayer *imageLayer = [imageView layer];
		
		[imageLayer setAnchorPoint:CGPointMake(0.0, 0.5)];
		
		CAKeyframeAnimation *animation;
		animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		[animation setValues: [NSArray arrayWithObjects:[NSNumber numberWithFloat:startAngle * M_PI / 180], [NSNumber numberWithFloat:stopAngle * M_PI / 180], nil]];
		
		[animation setFillMode:kCAFillModeForwards];
		[animation setDuration:duration];
		[animation setRemovedOnCompletion:NO];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[imageLayer addAnimation:animation forKey:nil];
		
		[[[self view] layer] addSublayer:imageLayer];
		
		
		[imageView release];
		
	} else {
		//hide unecessary view
		[_viewProgressPoints setHidden:YES];
		[_viewNumberOfCoupons setHidden:YES];
		
		[_lblAmountSaved setText:[[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_lblAmountSaved" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards],@"99.0"] currency:[_yourProgram currency]] uppercaseString]];
		
		[_imgBackgroung setFrame:CGRectMake(_viewProgressPoints.frame.origin.x, _viewProgressPoints.frame.origin.y-_viewNumberOfCoupons.frame.size.height, _viewProgressPoints.frame.size.width, _viewProgressPoints.frame.size.height + _viewNumberOfCoupons.frame.size.height)];
	}
}

#pragma mark - Actions

- (IBAction)deleteLoyaltyCard:(id)sender {
	[[StatisticsFactory sharedInstance] checkPointRewardsMyProgramDetailStop];
	ODCustomAlertView * alert = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"yourLoyaltyProgramDetailsViewController_alertView_deleteCard" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards]
																 message:nil
																delegate:self
													   cancelButtonTitle:[LocalizationHelper stringForKey:@"app_no" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleBlackBox]
													   otherButtonTitles:[LocalizationHelper stringForKey:@"app_yes" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleBlackBox], nil];
	[alert setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
	[alert show];
	[alert release];
}

#pragma mark - Delegates

- (void)alertView:(ODCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleBlackBox]
                        inViewController:[self navigationController]];
        
        [RewardsServices deleteFidelitizCard:[NSString stringWithFormat:@"%@",[[[UserSession currentSession] user] fidelitizId]] CardId:[_yourCard loyaltyCardId] withSuccessBlock:^(id context) {
            
            
            if([delegate respondsToSelector:@selector(showYourProgramsAndRefreshAllPrograms:)]){
                [delegate showYourProgramsAndRefreshAllPrograms:YES];
            }
            
            [[[self parentViewController]navigationController]popToRootViewControllerAnimated:YES];
            
            [self hideWaitingView];
            
        } failureBlock:^(Error *error) {
            [self hideWaitingView];
            [self displayAlertForError:error];
        }];
    }
}

#pragma mark - BgCoupon getter & setup

- (UIView *) getBgCoupon {
	if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget){
		return [self bgCouponBankSdk];
	}else{
		return [self bgCouponApp];
	}
}

- (void) setupBgCoupon{
	//round
	if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget){
		[[self bgCouponApp] setHidden:NO];
		[[self bgCouponBankSdk] setHidden:YES];
	} else{
		[[self bgCouponApp] setHidden:YES];
		[[self bgCouponBankSdk] setHidden:NO];
	}
	if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget){
		[[[self getBgCoupon] layer] setCornerRadius:[self getBgCoupon].frame.size.height/2];
	} else {
		[[[self getBgCoupon] layer] setCornerRadius:5.0];
		
	}
}


#pragma mark - CustomNavigationHeaderViewController delegate methods

- (void)didClose:(CustomNavigationHeaderViewController *)_controller {
    // TODO : nothing to do, never used
}

- (void)didGoBack:(CustomNavigationHeaderViewController *)_controller {
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dealloc {
	
	[_lblMerchantName release], _lblMerchantName = nil;
	[_btnDeleteLoyaltyCard release], _btnDeleteLoyaltyCard = nil;
	[_lblRule release], _lblRule = nil;
	
	[_viewNumberOfCoupons release], _viewNumberOfCoupons = nil;
	[_lblNumberOfCoupons release], _lblNumberOfCoupons = nil;
	[_bgCouponApp release], _bgCouponApp = nil;
	[_lblAmountOfACouponTop release], _lblAmountOfACouponTop = nil;
	
	[_imgBackgroung release], _imgBackgroung = nil;
	[_viewProgressPoints release], _viewProgressPoints = nil;
	[_viewProgressPointsBar release], _viewProgressPointsBar = nil;
	[_lblNumberOfPointsBeforeACoupon release], _lblNumberOfPointsBeforeACoupon = nil;
	[_lblAmountOfACoupon release], _lblAmountOfACoupon = nil;
	[_bgAmountOfPoint release], _bgAmountOfPoint = nil;
	[_lblNumberOfPoints release], _lblNumberOfPoints = nil;
	[_imageCouponIndicator release], _imageCouponIndicator = nil;
	
	[_bgAmountSaved release], _bgAmountSaved = nil;
	[_lblAmountSaved release], _lblAmountSaved = nil;
	
	[_yourCard release], _yourCard = nil;
	[_yourProgram release], _yourProgram = nil;
	
	[_bgCouponBankSdk release],_bgCouponBankSdk = nil;;
	[super dealloc];
}
@end
