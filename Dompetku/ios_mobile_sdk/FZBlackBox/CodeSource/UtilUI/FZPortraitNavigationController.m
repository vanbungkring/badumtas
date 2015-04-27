//
//  PortraitNavigationControllerViewController.m
//  flashiz_ios_sdk
//
//  Created by Yvan Moté on 10/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "FZPortraitNavigationController.h"

@interface FZPortraitNavigationController ()

@end

@implementation FZPortraitNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)dealloc {
    [super dealloc];
}

@end
