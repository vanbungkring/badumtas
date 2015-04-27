//
//  AllLoyaltyProgramsNavBarViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "AllLoyaltyProgramsNavBarViewController.h"

//Util
#import <FZBlackBox/FZUIImageWithImage.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

@interface AllLoyaltyProgramsNavBarViewController ()
{
    
}

//private properties
@property (retain, nonatomic) IBOutlet UIButton *btnSearchPrograms;

//private actions
- (IBAction)showNearPrograms:(id)sender;
- (IBAction)showSuggestedPrograms:(id)sender;
- (IBAction)showSearchTextField:(id)sender;

@end

@implementation AllLoyaltyProgramsNavBarViewController

//public properties
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"AllLoyaltyProgramsNavBarViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    if (self) {
        
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setAutoresizesSubviews:YES];
    [self setUpView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Setup view

- (void)setUpView {
    
    [_btnNearPrograms setImage:[FZUIImageWithImage imageNamed:@"btn_program_around_off" inBundle:FZBundleRewards] forState:UIControlStateNormal];
    
    [_btnSuggestedPrograms setImage:[FZUIImageWithImage imageNamed:@"btn_program_mystore_off" inBundle: FZBundleRewards] forState:UIControlStateNormal];
    
    [_btnSearchPrograms setImage:[FZUIImageWithImage imageNamed:@"btn_program_search_off" inBundle:FZBundleRewards] forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)showNearPrograms:(id)sender {
    if ([delegate respondsToSelector:@selector(showNearPrograms)]) {
        [delegate showNearPrograms];
    }
}

- (IBAction)showSuggestedPrograms:(id)sender {
    if ([delegate respondsToSelector:@selector(showSuggestedPrograms)]) {
        [delegate showSuggestedPrograms];
    }
}

- (IBAction)showSearchTextField:(id)sender {
    if ([delegate respondsToSelector:@selector(showSearchTextField)]) {
        [delegate showSearchTextField];
    }
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnNearPrograms release];
    [_btnSuggestedPrograms release];
    [_btnSearchPrograms release];
    [super dealloc];
}


@end
