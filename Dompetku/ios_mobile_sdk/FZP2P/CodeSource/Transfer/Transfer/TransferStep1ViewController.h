//
//  TransferStep1ViewController.h
//  iMobey
//
//  Created by Yvan Moté on 20/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

//Util
#import <FZBlackBox/HeaderViewController.h>

//Framework
#import <AddressBookUI/AddressBookUI.h>

@class FZButton;

@interface TransferStep1ViewController : HeaderViewController <UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIView *viewMail;
@property (retain, nonatomic) IBOutlet UIView *viewSearchContact;
@property (retain, nonatomic) IBOutlet UIView *viewAmount;
@property (retain, nonatomic) IBOutlet UIView *viewAmountTop;
@property (retain, nonatomic) IBOutlet UIView *viewSearchValidate;
@property (retain, nonatomic) IBOutlet UILabel *searchFriendMailLabel;
@property (retain, nonatomic) IBOutlet FZButton *searchContactButton;
@property (retain, nonatomic) IBOutlet FZButton *validateButton;
@property (retain, nonatomic) IBOutlet UIButton *commentButton;
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;

- (CGFloat)traslateDeltaViewMail;
- (CGFloat)traslateDeltaViewAmount;

- (void)automaticRefillWithAmount:(NSString *)amount comment:(NSString *)comment forUser:(NSString *)forUser fromUser:(NSString *)fromUser andType:(NSString *)type;
- (void)refillWithAmount:(NSString *)amount comment:(NSString *)comment forUser:(NSString *)forUser fromUser:(NSString *)fromUser andType:(NSString *)type;

- (void)presentActionViewControllerWithAmount:(NSString *)amount;

- (IBAction)searchContact:(id)sender;
- (IBAction)validateSearch:(id)sender;

- (void)addsOnSetupView;

@end
