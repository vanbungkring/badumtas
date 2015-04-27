//
//  TransferReceiveStep1ViewController.m
//  iMobey
//
//  Created by Yvan Moté on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FZTransferReceiveStep1ViewController.h"

//Controller
#import "TransferReceiveStep2ViewController.h"

// TODO : need refactor
//#import "UserInformationViewController.h"

//Constants
#import <FZBlackBox/Constants.h>

//Session
#import <FZAPI/UserSession.h>

//Service
#import <FZAPI/InvoiceServices.h>
#import <FZAPI/ConnectionServices.h>


//Currency
#import <FZAPI/CurrenciesManager.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Constants
#import <FZBlackBox/FontHelper.h>

//Custom AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//AmountHelper
#import "FZAmountHelper.h"

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

//Target
#import <FZBlackBox/FZTargetManager.h>

#define kAlertFlashizNotUgradedAccount 1
#define kAlertFlashizNotValidatedAccount 2

@interface FZTransferReceiveStep1ViewController () <UIAlertViewDelegate>
{
    
}

//View
@property (retain, nonatomic) IBOutlet UILabel *lblYourbalance;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel *lblAmount;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrencyBefore;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrencyAfter;

@property (assign, nonatomic) BOOL isEditingAmount;
@property (retain, nonatomic) UIToolbar *inputAccessoryView;

@end

@implementation FZTransferReceiveStep1ViewController
@synthesize viewAmount;
@synthesize lblDescription;
@synthesize viewDescription;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"FZTransferReceiveStep1ViewController" bundle:[BundleHelper retrieveBundle:FZBundleP2P]];
    if (self) {
        [self setTitleHeader:[LocalizationHelper stringForKey:@"transferHomeViewController_receiveButton" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_header_backgroundColor]];
        [self setCanDisplayMenu:NO];
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowMenu:)
                                                 name:willShowMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideMenu:)
                                                 name:willHideMenuNotification
                                               object:nil];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_amountTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Setup view

- (void)setUpView {
    //Backgroud
    [viewDescription setBackgroundColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_viewDescription_backgroundColor]];
    
    //Your balance
    [_lblYourbalance setText:[[LocalizationHelper stringForKey:@"transferReceiveStep1ViewController_your_balance" withComment:@"FZTransferReceiveStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [_lblYourbalance setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18]];
    [_lblYourbalance setTextColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_lblYourBalance_textColor]];
    
    [_lblBalance setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[[[[UserSession currentSession] user] account] balance]] currency:[[[[UserSession currentSession] user] account] currency]]];
    [_lblBalance setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18]];
    [_lblBalance setTextColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_lblBalance_textColor]];
    
    //Select an amount
    [_lblAmount setText:[[LocalizationHelper stringForKey:@"transferReceiveStep1ViewController_amount" withComment:@"FZTransferReceiveStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [_lblAmount setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20]];
    [_lblAmount setTextColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_lblAmount_textColor]];
    
    [_lblCurrencyBefore setText:[[CurrenciesManager currentManager] currencySymbols:[[CurrenciesManager currentManager] defaultCurrency]][0]];
    [_lblCurrencyBefore setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20]];
    [_lblCurrencyBefore setTextColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_lblCurrencyBefore_textColor]];
    
    [_amountTextField setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20]];
    [_amountTextField setTextColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_amountTextField_textColor]];
    [_amountTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [_amountTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_amountTextField setTintColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_amountTextField_textColor]];
    
    [_lblCurrencyAfter setText:[[CurrenciesManager currentManager] currencySymbols:[[CurrenciesManager currentManager] defaultCurrency]][1]];
    [_lblCurrencyAfter setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20]];
    [_lblCurrencyAfter setTextColor:[[ColorHelper sharedInstance] transferReceiveStep1ViewController_lblCurrencyAfter_textColor]];
    
    //Description
    [lblDescription setText:[[LocalizationHelper stringForKey:@"transferReceiveStep1ViewController_description" withComment:@"FZTransferReceiveStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [lblDescription setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:16]];
    [lblDescription setTextColor:[[[ColorHelper sharedInstance] transferReceiveStep1ViewController_lblDescription_textColor] colorWithAlphaComponent:0.6f]];
    
    [self addsOnSetupView];
}

- (void)addsOnSetupView {
    //do nothing for Flashiz
}

-(UIToolbar*)createInputAccessoryView {
    
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[UIToolbar alloc] init];
        [_inputAccessoryView setBarStyle:UIBarStyleBlackTranslucent];
        [_inputAccessoryView sizeToFit];
        
        _inputAccessoryView.frame = CGRectMake(0,44, 44, 44);
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside]; //adding action
        button.frame = CGRectMake(0 ,0,100,35);
        [button setTitle:[[LocalizationHelper stringForKey:@"app_validate" withComment:@"global" inDefaultBundle:FZBundleBlackBox]uppercaseString] forState:UIControlStateNormal];
        
        [button setTitleColor:[[ColorHelper sharedInstance] whiteColor] forState:UIControlStateNormal];
        
        [button.titleLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20]];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        NSArray *items = [NSArray arrayWithObjects:flexItem,barButton, nil];
        
        [flexItem release];
        [barButton release];
        [_inputAccessoryView setItems:items animated:YES];
    }
    
    return _inputAccessoryView;
}


#pragma mark - Observing methods

-(IBAction)dismissKeyBoard:(id)sender
{
    NSString *userKey = [[UserSession currentSession] userKey];
    
    NSString *amountText = [FZAmountHelper correctedAmountFromAmount:[_amountTextField text]];
    
    BOOL isUserTrial = [[[UserSession currentSession] user] isTrial];
    
    if(isUserTrial){
        [ConnectionServices updateIfStillTrial];
        isUserTrial = [[[UserSession currentSession] user] isTrial];
    }
    
    if(![amountText isEqualToString:@""] && ![amountText isEqualToString:@"0"] && ![amountText isEqualToString:@"0.0"] && ![amountText isEqualToString:@"0.00"] && !isUserTrial) {
        
        [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]];
        
        [InvoiceServices createInvoice:userKey
                                amount:amountText
                          successBlock:^(id context) {
                              
                              NSString *url = (NSString *)context;
                              
                              TransferReceiveStep2ViewController *controller = [[self multiTargetManager] transferReceiveStep2ViewControllerWithUrl:url
                                                                                                                                             amount:amountText                                                       currency:[[[[UserSession currentSession] user] account] currency]];
                              
                              CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:controller andMode:CustomNavigationModeBack];
                              
                              [[self navigationController] pushViewController:navigController animated:YES];
                              
                              
                              [self hideWaitingView];
                              
                          } failureBlock:^(Error *error) {
                              // FZP2PLog(@"error : %@",error);
                              [self hideWaitingView];
                              [self displayAlertForError:error];
                          }];
        
        [_amountTextField resignFirstResponder];
        _isEditingAmount = NO;
    } else {
        if (![[[UserSession currentSession] user] isUserUpgraded]){
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_valid_account" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                           delegate:self
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView setTag:kAlertFlashizNotUgradedAccount];
            [alertView show];
            [alertView release];
        } else if(![[[UserSession currentSession] user] isMailValidated]) {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"registerCaptchaViewController_mail_notification" withComment:@"RegisterCaptchaViewController" inDefaultBundle:FZBundleP2P]
                                                                           delegate:self
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView setTag:kAlertFlashizNotValidatedAccount];
            [alertView show];
            [alertView release];
        } else {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                            message:[LocalizationHelper stringForKey:@"transferStep1ViewController_EmptyAmount" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]
                                                                           delegate:nil
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView show];
            [alertView release];
            [_amountTextField setText:@""];
        }
    }
}

#pragma mark - Private methods

- (void)setUserInfos {
    UserInformationViewController *userInfo = [[self multiTargetManager] userInformationViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:userInfo andMode:CustomNavigationModeBack];
    
    [[self navigationController] pushViewController:navigController
                                           animated:YES];
}

#pragma mark - Observing methods

- (void)willShowMenu:(NSNotification *)notification {
    _isEditingAmount = [_amountTextField isFirstResponder];
    
    [_amountTextField resignFirstResponder];
}

- (void)willHideMenu:(NSNotification *)notification {
    if(_isEditingAmount) {
        [_amountTextField becomeFirstResponder];
    }
}

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView tag] == kAlertFlashizNotUgradedAccount) {
        [self setUserInfos];
    }
}

#pragma mark - UITextfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:[self createInputAccessoryView]];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL asComma = [[textField text] rangeOfString:@","].location != NSNotFound;
    BOOL asMoreThanTwoDigitsAfterComma = NO;
    if(asComma) {
        NSString *afterComma = [[textField text] componentsSeparatedByString:@","][1];
        if([afterComma length] > 1) {
            asMoreThanTwoDigitsAfterComma = YES;
        }
    }
    
    if(asComma && asMoreThanTwoDigitsAfterComma && ([string length] > 0)) {
        
        return NO;
    } else {
        NSMutableString *newString = [[[NSMutableString alloc] initWithString:[textField text]] autorelease];
        
        [newString replaceCharactersInRange:range
                                 withString:string];
        
        if(textField==_amountTextField) {
            BOOL isValidAmount = [FZAmountHelper isValid:newString];
            
            if(!isValidAmount) {
                return NO;
            }
        }
        
        [self adjustTextField:textField inRange:range replacementString:string];
        
        return YES;
    }
}

- (void) adjustTextField:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string {
    NSString *aText = nil;
    
    BOOL increaseSizeYESifNOdecrease = YES;
    
    if([string length] > 0 && range.location >= [[textField text] length] - 1){//add char at the end of the string
        aText = [NSString stringWithFormat:@"%@%@",[textField text],string];
        increaseSizeYESifNOdecrease = YES;
    } else if([string length] > 0 && range.location < [[textField text] length] - 1) {//add char at the middle or begining of the string
        aText = [NSString stringWithFormat:@"%@%@%@",[[textField text] substringToIndex:range.location],string,[[textField text] substringFromIndex:range.location]];
        increaseSizeYESifNOdecrease = YES;
    } else if(range.location >= [[textField text] length] - 1){//remove last char of the string
        aText = [[textField text] substringToIndex:[[textField text] length] - 1];
        increaseSizeYESifNOdecrease = NO;
    } else {//remove a char at the middle of the string
        aText =[NSString stringWithFormat:@"%@%@",[[textField text] substringToIndex:range.location],[[textField text] substringFromIndex:range.location + 1]];
        increaseSizeYESifNOdecrease = NO;
    }
    
    CGRect textFieldFrame = [textField frame];
    CGRect lblCurrencyAfterFrame = [_lblCurrencyAfter frame];
    
    if (increaseSizeYESifNOdecrease && textFieldFrame.size.width < 100) {
        textFieldFrame.size.width += 8;
        lblCurrencyAfterFrame.origin.x += 8;
    } else if(textFieldFrame.size.width - 8 > 0) {
        textFieldFrame.size.width -= 8;
        lblCurrencyAfterFrame.origin.x -= 8;
    }
    
    [textField setFrame:textFieldFrame];
    [_lblCurrencyAfter setFrame:lblCurrencyAfterFrame];
}

#pragma mark - CustomNavigationViewControllerAction

-(void)didGoBack:(CustomNavigationViewController *)controller {
    
}

- (void)didClose:(CustomNavigationViewController *)controller {
    [[StatisticsFactory sharedInstance] checkPointReceiveQuit];
    if([[_amountTextField text] length]>0) {
        // TODO : refactor
        // [TestFlightHelper passTransferSendCancelEmailOrAmount];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_inputAccessoryView release];
    
    [_amountTextField release];
    [_lblCurrencyBefore release];
    [_lblCurrencyAfter release];
    [_lblYourbalance release];
    [_lblBalance release];
    [_lblAmount release];
    [lblDescription release];
    [viewDescription release];
    [viewAmount release];
    [super dealloc];
}
@end
