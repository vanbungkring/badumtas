//
//  ForgotPinController.h
//  Dompetku
//
//  Created by iMac on 11/14/14.
//
//

#import <UIKit/UIKit.h>

@interface ForgotPinController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtAccNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgRequest;


- (IBAction)backgroundTap:(id)sender;

@end
