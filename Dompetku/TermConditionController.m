//
//  TermConditionController.m
//  Dompetku
//
//  Created by iMac on 11/17/14.
//
//

#import "TermConditionController.h"

@interface TermConditionController ()

@end

@implementation TermConditionController

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

- (void)viewWillAppear:(BOOL)animated{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Term Condition", nil);
    
}

@end
