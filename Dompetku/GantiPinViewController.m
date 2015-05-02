//
//  GantiPinViewController.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "GantiPinViewController.h"
#import "NetraCommonFunction.h"
#import "NetraUserModel.h"
#import "GantiPin.h"
#import "NRealmSingleton.h"
#import "HomeViewController.h"
#import <MBProgressHUD.h>
#import <FZBlackBox/SWRevealViewController.h>
@interface GantiPinViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldPin;
@property (strong, nonatomic) IBOutlet UITextField *pinRequest;
@property (strong, nonatomic) IBOutlet UITextField *pinRequestRepeat;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) netraUserModel *activeUser;


@end

@implementation GantiPinViewController

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(_oldPin ||_pinRequest||_pinRequestRepeat){
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
    for (int i=1; i<5; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:ORANGE_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
        
    }
    
    
    
    for(UIView *v in [_scroller subviews])
    {
        if([v isKindOfClass:[UITextField class]])
        {
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            ((UITextField*)v).leftView = paddingView;;
            ((UITextField*)v).secureTextEntry = YES;
            ((UITextField*)v).delegate = self;
            ((UITextField*)v).leftViewMode = UITextFieldViewModeAlways;
        }
    }
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:doubleTap];
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view])
        return NO;
    return YES;
}
-(void)handleDoubleTap:(id)sender{
    [self.view endEditing:YES];
    
}
- (IBAction)sendToServer:(id)sender {
    _activeUser = [netraUserModel getUserProfile];
    
    if(_oldPin.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN Lama"];
    }
    else if(_pinRequest.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN Baru"];
    }
    else if(_pinRequestRepeat.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Konfirmasi Pin Baru"];
    }
    else if (![_pinRequest.text isEqualToString:_pinRequestRepeat.text]){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Pin baru tidak sama dengan Konfirmasi PIN baru"];
    }
    else if ([_oldPin.text isEqualToString:_pinRequestRepeat.text]){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"PIN lama & PIN Baru tidak boleh sama"];
    }
    else{
        ///161002
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params = @{@"pin":_pinRequest.text,@"signature":[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_oldPin.text]};
        [GantiPin changePin:params login:^(NSArray *posts, NSError *error) {
            if(!error){
                if(posts.count<1){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
                else{
                    [[NRealmSingleton sharedMORealmSingleton]deleteRealm];
                    UIStoryboard *storyboard;
                    UINavigationController *nav = (UINavigationController *) self.revealViewController.frontViewController;
                    // Get the storyboard named secondStoryBoard from the main bundle:
                    NSLog(@"dipanggil");
                    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"resetSideMenu" object:nil];
                   
                    // Then push the new view controller in the usual way:
                    
                    HomeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    
                    nav.viewControllers = [NSArray arrayWithObjects:controller, nil];

                    [self.revealViewController pushFrontViewController:nav animated:YES];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                
                }
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
