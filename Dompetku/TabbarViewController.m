//
//  TabbarViewController.m
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import "TabbarViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    netraUserModel *modelUser = [netraUserModel getUserProfile];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotificationWithString)
     name:@"gotoHome"
     object:nil];
}
-(void)useNotificationWithString{
    NSLog(@"HOME-> GOTO HOME");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
 
     [self setSelectedIndex:[_state integerValue]-1];
    self.tabBarController.delegate = self;

    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetTab" object:self];
    NSLog(@"reseted");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
