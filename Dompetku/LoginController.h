//
//  LoginController.h
//  Dompetku
//
//  Created by iMac on 11/8/14.
//
//

#import <UIKit/UIKit.h>
#import "ForgotPinController.h"
#import "RegistrationController.h"

@interface LoginController : UIViewController {
    ForgotPinController *forgotPin;
    RegistrationController *registration;
}
@property (weak, nonatomic) IBOutlet UITextField *txtAccNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogin;
@property (weak, nonatomic) IBOutlet UIView *Background;
@property (strong, nonatomic) NSString *userNumber;

- (IBAction)backgroundTap:(id)sender;


@end
