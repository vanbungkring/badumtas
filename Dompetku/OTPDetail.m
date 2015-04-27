//
//  OTPDetail.m
//  Dompetku
//
//  Created by Indosat on 1/15/15.
//
//

#import "OTPDetail.h"
#import "Config.h"
#import "NetraUserProfile.h"
#import "NewRegistrationViewController.h"
#import <MBProgressHUD.h>
@interface OTPDetail ()<UITextFieldDelegate>{
    NSTimer *timer;
    int currMinute;
    int currSeconds;
}
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextField *otpTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (strong, nonatomic) IBOutlet UILabel *labelAnouncment;

@end

@implementation OTPDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Kode Verifikasi";
    [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_otpTextField
                                                  withColor:ORANGE_BORDER_COLOR
                                           withCornerRadius:20
                                            withBorderWidth:2];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _otpTextField.leftView = paddingView;
    _otpTextField.delegate =self;
    _otpTextField.leftViewMode = UITextFieldViewModeAlways;
    [self setTimer];
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
    [_otpTextField resignFirstResponder];
    
}
-(void)setTimer{
    currMinute=5;
    currSeconds=00;
    [self start];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [_progress startAnimating];
    _progress.hidden = NO;
    _labelAnouncment.text = @"Mohon Tunggu Kode Verifikasi Anda";
    [_labelAnouncment setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    
    
}
-(void)resetTimer{
    [timer invalidate];
    currMinute=5;
    currSeconds=00;
    [self start];
    
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [_timeLabel setText:[NSString stringWithFormat:@"%d:%d",currMinute,currSeconds]];
    }
    else
    {
        NSLog(@"waktu abis");
        _labelAnouncment.text = @"Sistem kami tidak dapat mendeteksi Kode Verifikasi dari HP Anda. Silakan klik Resend untuk kirim ulang kode verifikasi atau masukkan manual Kode Verifikasi. Pastikan nomor HP yang Anda masukkan benar.";
        _labelAnouncment.numberOfLines = 0;
        [_labelAnouncment sizeToFit];
        [_labelAnouncment setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        _progress.hidden = YES;
        [_timeLabel setText:@"DONE"];
        [timer invalidate];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resendButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params =@{@"mode":@"request",
                            @"msisdn":_msisdn};
    [NetraUserProfile otpSend:params login:^(NSArray *posts, NSError *error) {
        if(!error){
            if([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==0){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            [timer invalidate];
            [self setTimer];
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }
    }];
}

- (IBAction)submitToServer:(id)sender {
    if(!_otpTextField.text.length){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Anda Harus Memasukkan Kode Verifikasi Dari SMS"];
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params =@{@"mode":@"confirm",
                                @"msisdn":_msisdn,
                                @"code":_otpTextField.text};
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [NetraUserProfile otpSend:params login:^(NSArray *posts, NSError *error) {
            if(!error){
                NSLog(@"post->%@",posts);
                if(posts.count>0){
                    if([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==0){
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        //            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        // saving an NSString
                        [prefs setBool:1 forKey:@"isOTP"];
                        [prefs setObject:_msisdn forKey:@"msisdn"];
                        [prefs synchronize];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        
                    }
                    else if ([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==-11){
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [prefs setBool:1 forKey:@"isOTP"];
                        [prefs setObject:_msisdn forKey:@"msisdn"];
                        [prefs synchronize];
                        [timer invalidate];
                        NewRegistrationViewController *otp = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRegistrationViewController"];
                        [self.navigationController pushViewController:otp animated:YES];
                        
                    }
                    else if ([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==-98){
                        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Koneksi ke server gagal. Silakan coba kembali"];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                    else{
                        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[[posts objectAtIndex:0]objectForKey:@"msg"]];
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
