//
//  LoyaltyProgramDetailsViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 19/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "LoyaltyProgramDetailsViewController.h"

//Network
#import <FZAPI/RewardsServices.h>

//Fidelitiz rules engine
#import "RewardsRulesEngine.h"

//User session
#import <FZAPI/UserSession.h>

//Language
#import <FZBlackBox/LocalizationHelper.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//Color
#import <FZBlackBox/ColorHelper.h> 

//Constants
#import <FZBlackBox/FontHelper.h>

//Custom button
#import <FZBlackBox/FZButton.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

//Manager
#import <FZBlackBox/FZTargetManager.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

//Utils
#import <FZBlackBox/ODDeviceUtil.h>

//NSString
#import <FZBlackBox/NSStringFontSize.h>


//Manager

@interface LoyaltyProgramDetailsViewController () <UIAlertViewDelegate> {
    
}

//private properties
@property (retain, nonatomic) IBOutlet UILabel *lblMerchantName;
@property (retain, nonatomic) IBOutlet UILabel *lblRule;
@property (retain, nonatomic) IBOutlet FZButton *btnSuscribe;
@property (retain, nonatomic) IBOutlet UIImageView *imageMerchantPicture;
@property (retain, nonatomic) IBOutlet UIView *viewRule;

//private actions
- (IBAction)subcribeToTheLoyaltyProgram:(id)sender;


//Model
@property (retain, nonatomic) LoyaltyProgram * program;

@end

@implementation LoyaltyProgramDetailsViewController {
    
}
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"LoyaltyProgramDetailsViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    if (self) {
        _program = [[LoyaltyProgram alloc] init];
    }
    return self;
}

- (id)initWithProgram:(LoyaltyProgram *)program {
    self = [super initWithNibName:@"LoyaltyProgramDetailsViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    
    _program = [program retain];
    
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

    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start rewards program details ViewController"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Close rewards program details ViewController"];
}

#pragma mark - Setup view

- (void)setUpView {
		
	//merchant name
	if([[_program loyaltyProgramOwnerCompanyName] isEqualToString:@""] || [_program loyaltyProgramOwnerCompanyName]==nil){
		[_lblMerchantName setText:[_program label]];
	}else{
		[_lblMerchantName setText:[_program loyaltyProgramOwnerCompanyName]];
	}
	
	[_imageMerchantPicture setImage:[FZUIImageWithImage imageNamed:@"rewards" inBundle:FZBundleRewards]];
    
    //TODO: hotfix, manage the view in the xib seems don't work...
    if (![ODDeviceUtil isAnIphoneFive] && [[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) { //manage for the BankSDK, maybe useful for the app, to be test
        CGRect imageMerchantPictureFrame = [_imageMerchantPicture frame];
        imageMerchantPictureFrame.origin.y = [_viewRule frame].origin.y + [_viewRule frame].size.height + 50;
        [_imageMerchantPicture setFrame:imageMerchantPictureFrame];
    }
    
    [self setUpBtnSuscribe];
    
    //set the rewards rules
    NSArray *rules = [RewardsRulesEngine rulesEngine:_program Currency:[_program currency]];
    
    [_lblRule setText:[rules[0] uppercaseString]];
	

	[_lblRule setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:13.0f]];
    
    NSString *rule2 = [rules[1] uppercaseString];
    if ([rule2 length] > 0) {
        [_lblRule setText:[NSString stringWithFormat:@"%@\n%@",[rules[0] uppercaseString],rule2]];
    } else {
        [_lblRule setText:[NSString stringWithFormat:@"%@",[rules[0] uppercaseString]]];
    }
    
	[[self lblRule] setAdjustsFontSizeToFitWidth:YES];
}

- (void)setUpBtnSuscribe {
    [_btnSuscribe setTitle:[[LocalizationHelper stringForKey:@"loyaltyProgramDetailsViewController_btnSuscribe" withComment:@"LoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards] uppercaseString] forState:UIControlStateNormal];
    
    UIImage *imgButton = [FZUIImageWithImage imageNamed:@"icon_check" inBundle:FZBundleBlackBox];
    UIImageView *imgButtonView = [[UIImageView alloc] initWithImage:imgButton];
    [imgButtonView setFrame:CGRectMake(12.0, 4.0, imgButton.size.width, imgButton.size.height)];
    [_btnSuscribe addSubview:imgButtonView];
    [imgButtonView release];
    
    [[_btnSuscribe layer] setCornerRadius:4.0];
    
    [_btnSuscribe setBackgroundNormalColor:[_btnSuscribe backgroundColor]];
    [_btnSuscribe setBackgroundHighlightedColor:[[ColorHelper sharedInstance] loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor]];
    
    //center the text into the button
    CGRect titleFrame = [[_btnSuscribe titleLabel] frame];
    CGRect btnSuscribeFrame = [_btnSuscribe frame];
    
    CGFloat leftEdge = imgButton.size.width + (btnSuscribeFrame.size.width-imgButton.size.width-titleFrame.size.width)/2;
    [_btnSuscribe setContentEdgeInsets:UIEdgeInsetsMake(0, leftEdge, 0, 0)];
}

#pragma mark - Delegates

- (void)alertView:(ODCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput){
        if(buttonIndex==1){
            [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"LoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleBlackBox]];
            
            [RewardsServices createFidelitizCard:[NSString stringWithFormat:@"%@",[[[UserSession currentSession] user] fidelitizId]] AffiliatedToTheProgramId:[_program loyaltyProgramId] PrivateReference:[[alertView textFieldAtIndex:0] text] withSuccessBlock:^(id context) {
                
                
                if ([delegate respondsToSelector:@selector(showYourProgramsWithAddedProgram:)]) {
                    [delegate showYourProgramsWithAddedProgram:[self program]];
                }
                
                if ([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
                    if([[self delegate] respondsToSelector:@selector(didGoBackFromYourDetails)]) {
                        [[self delegate] didGoBackFromYourDetails];
                        [[self navigationController]popToRootViewControllerAnimated:YES];
                    }else{
                        [[[self parentViewController]navigationController]popToRootViewControllerAnimated:YES];
                    }
                }else{
                    [[[self parentViewController]navigationController]popToRootViewControllerAnimated:YES];
                }
                
                
            } failureBlock:^(Error *error) {
                
                [self hideWaitingView];
                
                if([error errorCode]==0){
                    //WA - error not managed on the server
                    NSString *title = [LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment];
                    
                    NSString *cancelButtonTitle = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                    
                    ODCustomAlertView *alertView = [[[ODCustomAlertView alloc] initWithTitle:title
                                                                                    message:[LocalizationHelper stringForKey:@"loyaltyProgramDetailsViewController_bad_password" withComment:@"LoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:cancelButtonTitle
                                                                          otherButtonTitles:nil]autorelease];
                    [alertView setTag:kAlertViewError];
                    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                    [alertView show];

                }else{
                    [self displayAlertForError:error];
                }
            }];
        }
    }
}

#pragma mark - Actions

- (IBAction)subcribeToTheLoyaltyProgram:(id)sender {
    if(![_program isPrivate]){//the program is not private
        
        [[StatisticsFactory sharedInstance] checkPointRewardsAllProgramsDetailJoin];
        [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"AllLoyaltyPrograms" inDefaultBundle:FZBundleBlackBox] inViewController:[self navigationController]];
        
        [RewardsServices createFidelitizCard:[NSString stringWithFormat:@"%@",[[[UserSession currentSession] user] fidelitizId]] AffiliatedToTheProgramId:[_program loyaltyProgramId] withSuccessBlock:^(id context) {
            
            if ([delegate respondsToSelector:@selector(showYourProgramsWithAddedProgram:)]) {
                [delegate showYourProgramsWithAddedProgram:[self program]];
            }
            
            if ([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
                if([[self delegate] respondsToSelector:@selector(didGoBackFromYourDetails)]) {
                    [[self delegate] didGoBackFromYourDetails];
                    [[self navigationController]popToRootViewControllerAnimated:YES];
                }
                else{
                    [[[self parentViewController]navigationController]popToRootViewControllerAnimated:YES];
                }
            }
            else{
                [[[self parentViewController]navigationController]popToRootViewControllerAnimated:YES];
            }
            

            if(_fromAllPrograms) {
                // TODO: need refactor
               // [TestFlightHelper passRewardsShowSuscribedProgramDetails];
            }
            
            [self hideWaitingView];
            
        } failureBlock:^(Error *error) {
            [self hideWaitingView];
            [self displayAlertForError:error];
        }];
    } else {//the program is private
        ODCustomAlertView * alert = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"loyaltyProgramDetailsViewController_alert_title_private_code" withComment:@"LoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleRewards]
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:[LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                               otherButtonTitles:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox], nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
        [alert show];
        [alert release];
    }
}

#pragma mark - CustomNavigationViewControllerAction

-(void)didGoBack:(CustomNavigationViewController *)controller {
    
    [[StatisticsFactory sharedInstance] checkPointRewardsAllProgramsDetailQuit];

    if ([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        if([[self delegate] respondsToSelector:@selector(didGoBackFromYourDetails)]) {
            [[self delegate] didGoBackFromYourDetails];
        }
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didClose:(CustomNavigationViewController *)controller {
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblMerchantName release];
    [_lblRule release];
    [_btnSuscribe release];
    [_imageMerchantPicture release];
    [_program release];
    [_viewRule release];
    [super dealloc];
}
@end
