//
//  QRViewController.m
//  Dompetku
//
//  Created by Arie Prasetyo on 4/14/15.
//
//

#import "QRViewController.h"
#import <FZBlackBox/SWRevealViewController.h>
#import <FZSDK/BankSDKMultiTargetManager.h>
#import "QrcodePresentViewController.h"
@interface QRViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageResult;
@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultNavigationBar];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
   

    
   
}
-(BOOL)isClosingSdkAfterInvalidQrCode{
    return YES;
}
-(BOOL)isClosingSdkAfterPaymentFailedOrSucceeded{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scan:(id)sender{

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
