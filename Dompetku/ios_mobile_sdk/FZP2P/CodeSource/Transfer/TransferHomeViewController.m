//
//  TransferHomeViewController.m
//  iMobey
//
//  Created by Yvan Moté on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "TransferHomeViewController.h"

//Controller
#import <FZPayment/AccountBannerViewController.h>
#import <FZPayment/HistoryViewController.h>
#import "FZTransferReceiveStep1ViewController.h"
#import "TransferStep1ViewController.h"

//Session
#import <FZAPI/UserSession.h>

//Services
#import <FZAPI/AvatarServices.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Constants
#import <FZBlackBox/FontHelper.h>

//Setup model
#include <sys/types.h>
#include <sys/sysctl.h>

//Util
#import <FZBlackBox/FlashizButtonRiddleAnimation.h>

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

//Target
#import <FZBlackBox/FZTargetManager.h>

@interface TransferHomeViewController ()<AccountBannerViewControllerDelegate>
{
    
}

@property(nonatomic,assign)BOOL canBeAnimated;


//View


@property (retain, nonatomic) IBOutlet FlashizButtonRiddleAnimation *receiveButton;
@property (retain, nonatomic) IBOutlet FlashizButtonRiddleAnimation *sendButton;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewBackground;


@end

@implementation TransferHomeViewController

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"TransferHomeViewController" bundle:[BundleHelper retrieveBundle:FZBundleP2P]];
    if (self) {
        [self setTitleHeader:[LocalizationHelper stringForKey:@"transferHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]];
    }
    return self;
}

#pragma mark - View cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[self platform] isEqualToString:@"iPhone2,1"]){
        _canBeAnimated = NO;
    }else{
        _canBeAnimated = YES;
    }
    //showuser banner
    AccountBannerViewController *accountBanner = [[self multiTargetManager] accountBannerViewController];
    [accountBanner setDelegate:self];
    [accountBanner setChangeAvatarRules:YES];
    
    [[self view] addSubview:[accountBanner view]];
    [self addChildViewController:accountBanner];
    
    [self setupView];
}

-(void)setupView
{
    [[self view] setBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]];
    
    [self setTitle:[LocalizationHelper stringForKey:@"transferHomeViewController_navigation_title" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]];
    [_lblReceive setText:[[LocalizationHelper stringForKey:@"transferHomeViewController_receiveButton" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]uppercaseString]];
    [_lblSend setText:[[LocalizationHelper stringForKey:@"transferHomeViewController_sendButton" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]uppercaseString]];
    
    [_receiveButton setImage:[FZUIImageWithImage imageNamed:@"btn_receive" inBundle:FZBundleP2P] forState:UIControlStateNormal];
    
     [_sendButton setImage:[FZUIImageWithImage imageNamed:@"btn_give" inBundle:FZBundleP2P] forState:UIControlStateNormal];
    
    [_lblReceive setTextColor:[[ColorHelper sharedInstance] transferHomeViewController_lblReceive_textColor]];
    [_lblSend setTextColor:[[ColorHelper sharedInstance] transferHomeViewController_lblSend_textColor]];
    
    [_lblReceive setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:22]];
    [_lblReceive setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:22.0f]];
    [_lblSend setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:22]];
    
    [_imgViewBackground setImage:[FZUIImageWithImage imageNamed:@"transfert" inBundle:FZBundleP2P]];
}

- (NSString *) platform{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_canBeAnimated) {
        [[self sendButton] startWithNumberOfRiddles:2 direction:kFlashizRiddleAnimationDirectionExpand color:[UIColor whiteColor]];
        [[self receiveButton] startWithNumberOfRiddles:2 direction:kFlashizRiddleAnimationDirectionContract color:[UIColor whiteColor]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_canBeAnimated) {
        [[self sendButton] stopRiddles];
        [[self receiveButton] stopRiddles];
    }
}

#pragma mark - account banner view controller
- (void)goToOrCloseHistoric
{
    HistoryViewController *controller = [[self multiTargetManager] historyViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeBack];
    
    [[[[FZTargetManager sharedInstance]facade]tabBarControllerNavigation] pushViewController:navigController animated:YES];
}

#pragma mark - Action methods

- (IBAction)receiveAmount:(id)sender
{
    [[StatisticsFactory sharedInstance] checkPointTransferReceiveMoney];
    FZTransferReceiveStep1ViewController *controller = [[self multiTargetManager] transferReceiveStep1ViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeClose];
    
    //Maybe we need use FZNavigationBlaBla
    UINavigationController *navigationController = [[FZPortraitNavigationController alloc]initWithRootViewController:navigController];
    
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:^{}];
    
    [navigationController release];
}

- (IBAction)transferAmount:(id)sender
{
    [[StatisticsFactory sharedInstance] checkPointTransferSendMoney];
    TransferStep1ViewController *controller = [[self multiTargetManager] transferStep1ViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeClose];
    
    //Maybe we need use FZNavigationBlaBla
    UINavigationController *navigationController = [[FZPortraitNavigationController alloc]initWithRootViewController:navigController];
    
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:^{}];
    
    [navigationController release];
}

#pragma mark MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [_receiveButton release];
    [_sendButton release];
    [_receiveButton release];
    [_sendButton release];
    [_imgViewBackground release];
    [super dealloc];
}
@end
