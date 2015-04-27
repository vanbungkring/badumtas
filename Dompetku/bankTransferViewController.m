//
//  bankTransferViewController.m
//  Dompetku
//
//  Created by Indosat on 12/2/14.
//
//

#import "bankTransferViewController.h"
#import "searchBankTableViewController.h"
#import "NetraUserModel.h"
#import "API+BeliManager.h"
#import <MBProgressHUD.h>
@interface bankTransferViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UITextField *kodeBank;
@property (strong, nonatomic) IBOutlet UITextField *rekeningTujuan;
@property (strong, nonatomic) NSString *kodeBankString;
@property (strong, nonatomic) IBOutlet UITextField *PIN;
@property (strong, nonatomic) IBOutlet UITextField *jumlah;

@end

@implementation bankTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i=1; i<6; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:ORANGE_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    for (UIView *view in [_scroller subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.delegate = self;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setValueOfTextFields:)
     name:@"postBackBank"
     object:nil];
    // Do any additional setup after loading the view.
    //ny additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetTab)
     name:@"resetTab"
     object:nil];
    

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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.keyboardType == UIKeyboardTypeNumberPad){
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)]; UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoubleTap:)]; [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1; } return YES; }

-(void)handleDoubleTap:(id)sender{
    for (UIView *view in [_scroller subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
            // do something with textField
        }
    }
    
}
-(void)resetTab{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)setValueOfTextFields:(NSNotification *)notification{
    NSDictionary *dictionary = [notification userInfo];
    _kodeBankString= [dictionary objectForKeyedSubscript:@"key"];
    _kodeBank.text = [dictionary objectForKey:@"value"];
    
    
}
- (IBAction)openBank:(id)sender {
    searchBankTableViewController *vc = [[searchBankTableViewController alloc]init];
    vc.tagss=[NSString stringWithFormat:@"%ld",(long)[sender tag]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nav
                                            animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hitAPI:(id)sender {
    [self.view endEditing:YES];
    if(_kodeBank.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Kode Bank"];
    }
    else if(_rekeningTujuan.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Nomor Rekening"];
    }
    else if(_rekeningTujuan.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Jumlah"];
    }
    else if(_PIN.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN"];
    }
    //chekpin

    else{
       
        NSDictionary *params =@{ @"signature":[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_PIN.text],
                                 @"userid":userID,
                                 @"bankCode":_kodeBankString,
                                 @"bankAccNo":_rekeningTujuan.text,
                                 @"amount":_jumlah.text};
        NSString *url = [NSString stringWithFormat:@"%@bank_transfer",indosatApiUrl];
        NSLog(@"url->%@",url);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [API_BeliManager urlparams:url param:params postParams:^(NSArray *posts, NSError *error) {
            if(!error){
                if(posts.count>0){
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    // Anda akan menerima SMS berisi cara konfirmasi transfer ke rekening bank dari 789
                    NSString *message = [NSString stringWithFormat:@"Anda akan menerima SMS berisi cara konfirmasi transfer ke rekening bank dari 789"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sukses" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
                    [alertView show];
                    
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
