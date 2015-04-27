//
//  FidelitizTermsOfUseViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "RewardsTermsOfUseViewController.h"

#import <FZBlackBox/TermsOfUseViewController.h>
#import <FZAPI/FlashizUrlBuilder.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

#import <FZBlackBox/CGUUrlUtil.h>

//Helper
#import <FZBlackBox/BundleHelper.h>


@interface RewardsTermsOfUseViewController ()
{
    
}

//private properties
@property (retain, nonatomic) IBOutlet UILabel *lblStartUseFid;
@property (retain, nonatomic) IBOutlet UILabel *lblAddFirstPorgram;
@property (retain, nonatomic) IBOutlet UIButton *btnAcceptCGUAndCreateFidAccount;
@property (retain, nonatomic) IBOutlet UIButton *btnReadCGU;

//private actions
- (IBAction)acceptCGUAndCreateFidelitizAccount:(id)sender;
- (IBAction)readCGU:(id)sender;

@end

@implementation RewardsTermsOfUseViewController
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"RewardsTermsOfUseViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];

    if (self) {
        
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_lblStartUseFid setText:[[LocalizationHelper stringForKey:@"FidelitizTermsOfUseViewController_start_use" withComment:@"RewardsTermsOfUseViewController" inDefaultBundle:FZBundleRewards] uppercaseString]];
    
    [_lblStartUseFid  setAdjustsFontSizeToFitWidth:YES];
    [_lblStartUseFid setMinimumScaleFactor:0.5];
    
    
    [_btnReadCGU setTitle:[[LocalizationHelper stringForKey:@"FidelitizTermsOfUseViewController_term_button" withComment:@"RewardsTermsOfUseViewController" inDefaultBundle:FZBundleRewards] uppercaseString] forState:UIControlStateNormal];
    
    [[_btnReadCGU titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[_btnReadCGU titleLabel] setMinimumScaleFactor:0.5];
        
    [_btnAcceptCGUAndCreateFidAccount setTitle:[[LocalizationHelper stringForKey:@"accept" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    
    [_lblAddFirstPorgram setText:[[LocalizationHelper stringForKey:@"FidelitizTermsOfUseViewController_add_programs" withComment:@"RewardsTermsOfUseViewController" inDefaultBundle:FZBundleRewards] uppercaseString]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Actions

- (IBAction)acceptCGUAndCreateFidelitizAccount:(id)sender {
    if ([delegate respondsToSelector:@selector(acceptCGUAndCreateFidelitizAccount)]) {
        [delegate acceptCGUAndCreateFidelitizAccount];
    }
}

- (IBAction)readCGU:(id)sender {
    TermsOfUseViewController *controller = [[self multiTargetManager] termsOfUseViewControllerWithUrl:[CGUUrlUtil localizedCGURewardsUrl]];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller
                                                                                                                      andMode:CustomNavigationModeClose];
    
    [self presentViewController:navigController animated:YES completion:^{}];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblStartUseFid release];
    [_lblAddFirstPorgram release];
    [_btnAcceptCGUAndCreateFidAccount release];
    [_btnReadCGU release];
    [super dealloc];
}
@end
