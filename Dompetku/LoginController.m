//
//  LoginController.m
//  Dompetku
//
//  Created by iMac on 11/8/14.
//
//

#import "LoginController.h"
#import "ModelBeli+Bayar.h"
#import "ModelBayar.h"
#import "NetraUserModel.h"
#import "NetraDataManager.h"
#import "NetraUserProfile.h"
#import "transactionMapping.h"
#import "fieldTransaction.h"
#import "NetraUserProfile.h"
#import <MBProgressHUD.h>
#import "Config.h"
#import "OTPViewController.h"
#import "GuidesViewController.h"

@interface LoginController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UITextField *usrNumber;
@property (strong, nonatomic) IBOutlet UITextField *usrPin;
@property (strong, nonatomic)  MBProgressHUD *progressHud;
@property (strong, nonatomic) IBOutlet UIView *registrationContainer;
@property (strong, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) IBOutlet UIButton *lupaPin;


@end

@implementation LoginController

CGFloat screenWidth, screenHeight;


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag==2){
        NSUInteger oldLength = [_usrPin.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= MAXLENGTH || returnKey;
    }
    else{
        return YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _usrPin.tag = 2;
    
    for (int i=1; i<5; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:ORANGE_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.delegate =self;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Registrasi"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    NSMutableAttributedString *lupaPinText = [[NSMutableAttributedString alloc] initWithString:@"Lupa Pin"];
    [lupaPinText addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInt:1]
                        range:(NSRange){0,[lupaPinText length]}];
    //detect screen size
    
    _registrationButton.titleLabel.attributedText = [attributeString copy];
    
    _lupaPin.titleLabel.attributedText = [lupaPinText copy];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeView) name:@"CloseLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dismissHud)
     name:@"errorFetch"
     object:nil];
    
}


-(void)dismissHud{
    [_progressHud hide:YES afterDelay:1];
}
- (void)viewWillAppear:(BOOL)animated{
    //hide navigation bar
    _usrNumber.userInteractionEnabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    CGRect frame = _registrationContainer.frame;
    frame.origin.y = self.view.frame.size.height-100;
    _registrationContainer.frame = frame;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(![[prefs objectForKey:@"isOTP"]boolValue]){
        OTPViewController *otp = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
        [self.navigationController pushViewController:otp animated:YES];
    }
    else{
        _userNumber= [prefs stringForKey:@"msisdn"];
        _usrNumber.text =_userNumber;
    }
    
    
}
-(void)closeView{
    ///show guide first
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(![[prefs objectForKey:@"isGuide"]boolValue]){
        GuidesViewController *otp = [[GuidesViewController alloc]init];
        [self.navigationController pushViewController:otp animated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)loginPressed:(id)sender {
    
    if(_usrNumber.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Username"];
    }
    
    else if(_usrPin.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN"];
    }
    else{
        ////
        // Do any additional setup after loading the view.
        _progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _progressHud.labelText = @"Login";
        _progressHud.detailsLabelText = @"Contacting Dompetku Server";
        [NetraUserProfile login:@{@"userNumber":_usrNumber.text,@"pin":_usrPin.text}];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)ForgotPassword:(id)sender {
    NSLog(@"frgotPassword");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle: nil];
    forgotPin = (ForgotPinController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ForgotPin"];
    [self.navigationController pushViewController:forgotPin animated:YES];
}



@end