//
//  RewardsHomeViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "RewardsHomeViewController.h"

//Network
#import <FZAPI/RewardsServices.h>
#import <FZAPI/ConnectionServices.h>

//Domain
#import <FZAPI/UserSession.h>

//Account banner
#import <FZPayment/AccountBannerViewController.h>

//Fidelitiz
#import "RewardsTermsOfUseViewController.h"
#import "YourLoyaltyProgramsViewController.h"
#import "AllLoyaltyProgramsViewController.h"
#import "YourLoyaltyProgramDetailsViewController.h"

//Historic
#import <FZPayment/HistoryViewController.h>

//Color
#import <FZBlackBox/FZUIColorCreateMethods.h>
#import <FZBlackBox/ColorHelper.h>
#import <FZBlackBox/ColorsConstants.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Popup
#import <FZBlackBox/ODCustomAlertView.h>

//Util
#import <FZBlackBox/ODDeviceUtil.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

//Manager
#import <FZBlackBox/FZTargetManager.h>

//Facade
#import <FZBlackBox/FlashizFacade.h>

#define kAlertFlashizNotUgradedAccount 1
#define kAlertFlashizNotValidatedAccount 2

@interface RewardsHomeViewController () <RewardsTermsOfUseViewControllerDelegate,AllLoyaltyProgramsViewControllerDelegate,YourLoyaltyProgramsViewControllerDelegate,AccountBannerViewControllerDelegate,UIAlertViewDelegate> {
    
}

//private properties
@property (retain, nonatomic) IBOutlet UIView *viewAccountBanner;
@property (retain, nonatomic) IBOutlet UIView *viewButtonsBar;
@property (retain, nonatomic) IBOutlet UIView *viewPrograms;

@property (retain, nonatomic) IBOutlet UIButton *allProgramsButton;
@property (retain, nonatomic) IBOutlet UIButton *yourProgramsButton;

@property (retain, nonatomic) RewardsTermsOfUseViewController *fidelitizTermsOfUsed;

@property (assign, nonatomic) IBOutlet UIButton *lastSender;

@property (assign, nonatomic) BOOL needRefreshAllPrograms;
@property (assign, nonatomic) BOOL shouldEmptyLogoCache;

//private actions
- (IBAction)switchYourOrAllPrograms:(id)sender;

@end

@implementation RewardsHomeViewController {
    YourLoyaltyProgramsViewController *yourLoyaltyProgramsViewController;
    AllLoyaltyProgramsViewController *allLoyaltyProgramsViewController;
}

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"RewardsHomeViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    if (self) {
        [self setTitleHeader:[LocalizationHelper stringForKey:@"fidelitizHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleRewards]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] rewardsOneColor]];
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set the title used in the tabbar
    [self setTitle:[LocalizationHelper stringForKey:@"fidelitizHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleRewards]];
    
    //load the accountBanner
    [self showAccountBanner];
    
    [self.view setAutoresizesSubviews:YES];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //check if the user has a fidelitiz acccount
    UserSession *userSession = [UserSession currentSession];
    
    FZRewardsLog(@"Fidelitiz_id : %@",[[userSession user] fidelitizId]);
    
    //bypass the BankSDK automatically creates a Rewards account to the anonymous user. So we hide the Terms of used
    if ([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        [self hideFidelitizTermsOfUsed];
    } else {
        
        if([[UserSession currentSession]isUserConnected]){
            NSLog(@"connected");
            if(([[[userSession user] fidelitizId] integerValue] > 0) && ![[userSession user] isTrial]) {
                FZRewardsLog(@"fidelitiz id found");
                [self hideFidelitizTermsOfUsed];
            } else {
                FZRewardsLog(@"no fidelitiz id");
                //display fidelitiz terms of used
                [self showFidelitizTermsOfUsed];
            }
        }else{
            NSLog(@"no connect, no loading");
        }
        
    }
}

- (void)viewDidLayoutSubviews
{
    CGRect frame = [[[[self parentViewController] parentViewController] viewShowed] frame];
    [[self view] setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start rewards home ViewController"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Close rewards home ViewController"];
}

#pragma mark - Setup view

-(void)setUpView {
    //set text
    [_yourProgramsButton setTitle:[[LocalizationHelper stringForKey:@"fidelitizHomeViewController_sgmCtrl_title_0" withComment:@"RewardsHomeViewController" inDefaultBundle:FZBundleRewards] uppercaseString] forState:UIControlStateNormal];
    [_allProgramsButton setTitle:[[LocalizationHelper stringForKey:@"fidelitizHomeViewController_sgmCtrl_title_1" withComment:@"RewardsHomeViewController" inDefaultBundle:FZBundleRewards] uppercaseString] forState:UIControlStateNormal];
    
    if (_lastSender) {
        [self switchYourOrAllPrograms:_lastSender];
    } else {
        [self switchYourOrAllPrograms:_yourProgramsButton];
    }
    
    [_viewPrograms setAutoresizesSubviews:YES];
}

#pragma mark - Actions

- (IBAction)switchYourOrAllPrograms:(id)sender {
    _lastSender = sender;
    
    NSString *fidelitizId = [[[UserSession currentSession] user] fidelitizId];
    
    if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        fidelitizId = @"";
    }
    
    if(sender == _yourProgramsButton && fidelitizId){
        [self showYourPrograms];
        
        [_yourProgramsButton setSelected:YES];
        [_yourProgramsButton setUserInteractionEnabled:NO];
        [_yourProgramsButton setBackgroundColor:[[[ColorHelper sharedInstance] rewardsHomeViewController_yourProgramsButton_selected_backgroundColor] colorWithAlphaComponent:0.5f]];
        
        [_allProgramsButton setSelected:NO];
        [_allProgramsButton setUserInteractionEnabled:YES];
        [_allProgramsButton setBackgroundColor:[[ColorHelper sharedInstance] rewardsHomeViewController_allProgramsButton_backgroundColor]];
    } else if (fidelitizId){
        [self showAllPrograms];
        
        [_allProgramsButton setSelected:YES];
        [_allProgramsButton setUserInteractionEnabled:NO];
        [_allProgramsButton setBackgroundColor:[[[ColorHelper sharedInstance] rewardsHomeViewController_allProgramsButton_selected_backgroundColor] colorWithAlphaComponent:0.5f]];
        
        [_yourProgramsButton setSelected:NO];
        [_yourProgramsButton setUserInteractionEnabled:YES];
        [_yourProgramsButton setBackgroundColor:[[ColorHelper sharedInstance] rewardsHomeViewController_yourProgramsButton_backgroundColor]];
    } else {
        //terms and conditions view is showed
    }
}

#pragma mark - Functions

//show the account banner
- (void)showAccountBanner {
    AccountBannerViewController *accountBanner = [[self multiTargetManager] accountBannerViewControllerLight];
    
    [accountBanner setDelegate:self];
    [accountBanner setChangeAvatarRules:NO];
    
    [_viewAccountBanner addSubview:accountBanner.view];
    
    [self addChildViewController:accountBanner];
    
    //override account banner balance text color
    [[accountBanner lblCurrentBalance] setTextColor:[[ColorHelper sharedInstance] rewardsHomeViewController_viewAccountBanner_textColor]];
}

//show the fidelitiz terms of use
- (void)showFidelitizTermsOfUsed {
    
    //We don't need to add _fidelitizTermsOfUsed in hierarchy view if it has already been added
    if([_fidelitizTermsOfUsed parentViewController]==self && [[_fidelitizTermsOfUsed view] superview]==[self view]) {
        return;
    }
    
    _fidelitizTermsOfUsed = [[[self multiTargetManager] rewardsTermsOfUserViewController] retain];
    
    [_fidelitizTermsOfUsed setDelegate:self];
    
    UIView *fidelitizTermsOfUsedView = _fidelitizTermsOfUsed.view;
    
    _fidelitizTermsOfUsed.view.frame = self.view.bounds;
    
    [self.view addSubview:fidelitizTermsOfUsedView];
    [self addChildViewController:_fidelitizTermsOfUsed];
}

- (void)hideFidelitizTermsOfUsed {
    if(_fidelitizTermsOfUsed){
        [[_fidelitizTermsOfUsed view] removeFromSuperview];
        [_fidelitizTermsOfUsed removeFromParentViewController];
        [_fidelitizTermsOfUsed release];
        _fidelitizTermsOfUsed = nil;
    }
}

//show your programs
- (void)showYourPrograms {
    if(nil==yourLoyaltyProgramsViewController) {
        yourLoyaltyProgramsViewController = [[[self multiTargetManager] yourLoyaltyProgramsViewController] retain];
        [self addChildViewController:yourLoyaltyProgramsViewController];
    }
    if(_shouldEmptyLogoCache){
        _shouldEmptyLogoCache = NO;
        [yourLoyaltyProgramsViewController emptyCacheList];
    }
    
    [yourLoyaltyProgramsViewController setDelegate:self];
    
    UIView *yourLoyaltyProgramsView = [yourLoyaltyProgramsViewController view];
    yourLoyaltyProgramsView.frame = _viewPrograms.bounds;
    
    [[_viewPrograms subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_viewPrograms addSubview:yourLoyaltyProgramsView];
}

//show all the programs
- (void)showAllPrograms {
    
    if(nil==allLoyaltyProgramsViewController) {
        allLoyaltyProgramsViewController = [[[self multiTargetManager] allLoyaltyProgramsViewController] retain];
        [self addChildViewController:allLoyaltyProgramsViewController];
    }
    
    
    [allLoyaltyProgramsViewController setDelegate:self];
    
    UIView *allLoyaltyProgramsView = [allLoyaltyProgramsViewController view];
    allLoyaltyProgramsView.frame = _viewPrograms.bounds;
    
    [[_viewPrograms subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_viewPrograms addSubview:allLoyaltyProgramsView];
    
    // TODO : need refactor
    //[TestFlightHelper passRewardsAllPrograms];
}

- (void)setUserInfos {
    UserInformationViewController *userInfo = [[self multiTargetManager] userInformationViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:userInfo andMode:CustomNavigationModeClose];
    
    [[self navigationController] pushViewController:navigController
                                                 animated:YES];
    
}

#pragma mark - Delegates

//terms of use
- (void)acceptCGUAndCreateFidelitizAccount{
    BOOL isUserTrial = [[[UserSession currentSession] user] isTrial];
    
    if(isUserTrial){
        [ConnectionServices updateIfStillTrial];
        isUserTrial = [[[UserSession currentSession] user] isTrial];
    } else if ([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
        isUserTrial = NO;
    }
    
    if(!isUserTrial) {
        [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleBlackBox] inViewController:[[[FZTargetManager sharedInstance]facade]tabBarController]];
        
        [RewardsServices createFidelitizAccountWithSuccessBlock:^(id context) {
            //updating the user infos
            [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
                
                [[UserSession currentSession] setUser:context];
                
                FZRewardsLog(@"new fid id : %@",[[[UserSession currentSession] user] fidelitizId]);
                
                [_fidelitizTermsOfUsed.view removeFromSuperview];
                
                [self showAllPrograms];
                
                [self hideWaitingView];
            } failureBlock:^(Error *error) {
                [self hideWaitingView];
                [self displayAlertForError:error];
            }];
        } failureBlock:^(Error *error) {
            [self hideWaitingView];
            [self displayAlertForError:error];
        }];
    } else {
        if([[[UserSession currentSession] user] isUserUpgraded]) {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"registerCaptchaViewController_mail_notification" withComment:@"RegisterCaptchaViewController" inDefaultBundle:FZBundleRewards]
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

- (void)setSgmCtrlProgramsToYourProgramsAndShowYourPrograms {
    //TODO : optimize this trick
    _shouldEmptyLogoCache = YES;
    [self switchYourOrAllPrograms:_yourProgramsButton];
}

- (void)setSgmCtrlProgramsToYourProgramsAndShowYourProgramsAndRefreshPrograms:(BOOL)needRefresh {
    
    _needRefreshAllPrograms = needRefresh;
    //TODO : optimize this trick
    _shouldEmptyLogoCache = YES;
    [self switchYourOrAllPrograms:_yourProgramsButton];
}

#pragma mark - Alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView tag] == kAlertFlashizNotUgradedAccount) {
        // TODO: need refactor
        //[self setUserInfos];
    } else if([alertView tag] == kAlertFlashizNotValidatedAccount) {
    }
}

#pragma mark - account banner view controller

- (void)goToOrCloseHistoric{
    HistoryViewController *controller = [[self multiTargetManager] historyViewController];
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeBack];
    [[[[FZTargetManager sharedInstance]facade]tabBarControllerNavigation] pushViewController:navigController animated:YES];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if(yourLoyaltyProgramsViewController){
        [yourLoyaltyProgramsViewController release], yourLoyaltyProgramsViewController = nil;
        
    }
    
    if(allLoyaltyProgramsViewController){
        [allLoyaltyProgramsViewController release], allLoyaltyProgramsViewController = nil;
    }
    
    if(_allProgramsButton){
        [_allProgramsButton release], _allProgramsButton = nil;
    }
    
    if(_yourProgramsButton){
        [_yourProgramsButton release], _yourProgramsButton = nil;
    }
    
    if(_lastSender){
        //assign
        _lastSender = nil;
    }
    
    if(_viewAccountBanner){
        [_viewAccountBanner release], _viewAccountBanner = nil;
    }
    
    if(_viewPrograms){
        [_viewPrograms release], _viewPrograms = nil;
    }
    
    if(_viewButtonsBar){
        [_viewButtonsBar release], _viewButtonsBar = nil;
    }
    
    [self hideFidelitizTermsOfUsed];
    
    [super dealloc];
}

@end
