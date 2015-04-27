//
//  MintaTokenViewController.m
//  Dompetku
//
//  Created by Indosat on 11/26/14.
//
//

#import "MintaTokenViewController.h"
#import "NetraUserModel.h"
#import "Log.h"
#import "RequestToken.h"
#import <MBProgressHud.h>
#import "NetraCommonFunction.h"
@interface MintaTokenViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) netraUserModel *activeUser;
@property (strong, nonatomic) Log *logInbox;
@property (strong, nonatomic) IBOutlet UITextField *PIN;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@end

@implementation MintaTokenViewController

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag==1){
        NSUInteger oldLength = [textField.text length];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    _PIN.delegate = self;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, _backButton, nil] animated:NO];
    for (int i=1; i<5; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:ORANGE_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
        
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"Minta Token";
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    // Do any additional setup after loading the view.
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.keyboardType == UIKeyboardTypeNumberPad){
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)]; UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoubleTap:)]; [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1; } return YES; }
-(void)handleDoubleTap:(id)sender{
    [_PIN resignFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    // not supported on iOS4
    UITabBar *tabBar = [self.tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        NSLog(@"keen update");
        // set it just for this instance
        [tabBar setBackgroundImage:[UIImage imageNamed:@"token-state"]];
        
        // set for all
        // [[UITabBar appearance] setBackgroundImage: ...
    }
    else
    {
        // ios 4 code here
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)mintaTokenKirim:(id)sender {
    _activeUser = [netraUserModel getUserProfile];
    [_PIN resignFirstResponder];
    if(_PIN.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN"];
        
    }
    else{
        NSDictionary *params = @{@"signature":[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_PIN.text]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RequestToken requestToken:params login:^(NSArray *posts, NSError *error) {
            if (!error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(posts.count!=0){
                    NSDate* sourceDate = [NSDate date];
                    
                    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
                    
                    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
                    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
                    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
                    
                    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
                    
                    //set 1 hour active
                    
                    NSDate* newDate = [destinationDate dateByAddingTimeInterval:(60*60)];
                    ;
                    [[NetraCommonFunction sharedCommonFunction]setAlert:@"Informasi" message:[NSString stringWithFormat:@"Token anda: %@ akan kadaluarsa pada %@ \n RefID: %@",[[posts objectAtIndex:0]objectForKey:@"couponId"],[[NSString stringWithFormat:@"%@",newDate]stringByReplacingOccurrencesOfString:@"+0000" withString:@""],[[posts objectAtIndex:0]objectForKey:@"trxid"]]];
                    
                    _logInbox = [[Log alloc]init];
                    _logInbox.actionName = @"Minta Token";
                    _logInbox.token =[[posts objectAtIndex:0]objectForKey:@"couponId"];
                    _logInbox.expired =newDate;
                    _logInbox.refId =[[posts objectAtIndex:0]objectForKey:@"trxid"];
                    [Log save:_logInbox withRevision:YES];
                    [_PIN resignFirstResponder];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                }
                
            }
            else{
                [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Error"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
    
}
- (IBAction)backButton:(id)sender {
    NSLog(@"123");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
