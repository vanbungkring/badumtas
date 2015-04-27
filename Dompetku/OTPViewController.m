//
//  OTPViewController.m
//  Dompetku
//
//  Created by Indosat on 1/11/15.
//
//

#import "OTPViewController.h"
#import "NetraUserProfile.h"
#import "Config.h"
#import "OTPDetail.h"
#import <MBProgressHUD.h>
@interface OTPViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *verifikasiNumber;

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Verifikasi Nomor";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_verifikasiNumber
                                                  withColor:ORANGE_BORDER_COLOR
                                           withCornerRadius:20
                                            withBorderWidth:2];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _verifikasiNumber.leftView = paddingView;
    _verifikasiNumber.delegate =self;
    _verifikasiNumber.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:doubleTap];
    
    // Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view])
        return NO;
    return YES;
}
-(void)handleDoubleTap:(id)sender{
    [_verifikasiNumber resignFirstResponder];
    
}

- (IBAction)submitToServer:(id)sender {
    [_verifikasiNumber resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params =@{@"mode":@"request",
                            @"msisdn":_verifikasiNumber.text};
    [NetraUserProfile otpSend:params login:^(NSArray *posts, NSError *error) {
        if(!error){
            if(posts.count>0){
                if([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==0){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    OTPDetail *detail =[s instantiateViewControllerWithIdentifier:@"OTPDetail"];
                    detail.msisdn = _verifikasiNumber.text;
                    self.title =@"";
                    [self.navigationController pushViewController:detail animated:YES];
                }
                else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }
            else{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
