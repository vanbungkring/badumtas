//
//  GuidesViewController.m
//  Dompetku
//
//  Created by Indosat on 1/11/15.
//
//

#import "GuidesViewController.h"
#import "Config.h"
@interface GuidesViewController ()

@end

@implementation GuidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = self.view.bounds;
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    if (IS_IPHONE5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guides5"]];
    }
    else{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guides4"]];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)close{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:1 forKey:@"isGuide"];
    [prefs synchronize];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
