//
//  TransferStep1ViewController.m
//  iMobey
//
//  Created by Yvan Moté on 20/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "TransferStep1ViewController.h"

//Domaine
#import <FZAPI/UserSession.h>

//Service
#import <FZAPI/TransactionServices.h>
#import <FZAPI/ConnectionServices.h>

//Constants
#import <FZBlackBox/Constants.h>
#import <FZBlackBox/FontHelper.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//Util
#import <FZBlackBox/FZButton.h>
#import <FZBlackBox/FZUIImageWithImage.h>

//Controller
#import <FZPayment/ActionSuccessfulViewController.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Draw
#import <QuartzCore/QuartzCore.h>

// TODO : need refactor
//#import "UserInformationViewController.h"

//AmountHelper
#import "FZAmountHelper.h"

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>


#define kAlertFlashizNotUgradedAccount 1
#define kAlertFlashizNotValidatedAccount 2
#define kBackgroundImageActionSuccessful @"thankyou"

static const CGFloat yViewMailOrigin = 74.0;
static const CGFloat yViewAmountOrigin = 322.0;

@interface TransferStep1ViewController ()</*ActionSuccessfulViewControllerDelegate,*/ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate,UIAlertViewDelegate>
{
    
}

//View
@property (retain, nonatomic) IBOutlet UILabel *lblYourbalance;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel *toLabel;
@property (retain, nonatomic) IBOutlet UITextField *mailTextField;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrencyBefore;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrencyAfter;

//Model
@property (assign, nonatomic)BOOL isEditingMail;
@property (assign, nonatomic)BOOL isEditingAmount;
@property (retain, nonatomic)NSString *comment;

@end

@implementation TransferStep1ViewController
@synthesize viewMail;
@synthesize viewSearchContact;
@synthesize viewAmount;
@synthesize searchFriendMailLabel;
@synthesize searchContactButton;
@synthesize viewSearchValidate;
@synthesize commentButton;
@synthesize validateButton;
@synthesize amountLabel;
@synthesize amountTextField;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"TransferStep1ViewController" bundle:[BundleHelper retrieveBundle:FZBundleP2P]];
    if (self) {
        [self setTitleHeader:[LocalizationHelper stringForKey:@"transferHomeViewController_sendButton" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]];
        [self setCanDisplayMenu:NO];
    }
    return self;
}

#pragma mark - View cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setComment:@""];
    [viewAmount setHidden:YES];
    
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowMenu:)
                                                 name:willShowMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideMenu:)
                                                 name:willHideMenuNotification
                                               object:nil];
    [_mailTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Setup view

- (void)setUpView{
    //Your balance
    [_lblYourbalance setText:[[LocalizationHelper stringForKey:@"transferReceiveStep1ViewController_your_balance" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [_lblYourbalance setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18.0f]];
    
    [_lblYourbalance setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_lblYourbalance_textColor]];
    
    [_lblBalance setText:[[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[[[[UserSession currentSession] user] account] balance]] currency:[[[[UserSession currentSession] user] account] currency]] uppercaseString]];
    [_lblBalance setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18]];
    [_lblBalance setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_lblBalance_textColor]];
    
    //Mail
    [viewMail setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
    
    [_toLabel setText:[[LocalizationHelper stringForKey:@"transferStep1ViewController_To" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [_toLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18]];
    [_toLabel setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_toLabel_textColor]];
    
    [_mailTextField setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_mailTextField_textColor]];
    [_mailTextField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18]];
    
    //Search
    [viewSearchContact setBackgroundColor:[[ColorHelper sharedInstance] transferStep1ViewController_viewSearchContact_backgroundColor]];
    
    [searchFriendMailLabel setText:[[LocalizationHelper stringForKey:@"transferStep1ViewController_SearchEmailFriend" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [searchFriendMailLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:14]];
    [searchFriendMailLabel setTextColor:[[[ColorHelper sharedInstance] transferStep1ViewController_searchFriendMailLabel_backgroundColor] colorWithAlphaComponent:0.6f]];
    
    [searchContactButton setTitle:[[LocalizationHelper stringForKey:@"transferStep1ViewController_SearchInAdressBook" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString] forState:UIControlStateNormal];
    [[searchContactButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:12]];
    [[searchContactButton titleLabel] setTextColor:[[ColorHelper sharedInstance] whiteColor]];
    [searchContactButton setBackgroundHighlightedColor:[[ColorHelper sharedInstance] transferStep1ViewController_searchContactButton_highlighted_backgroundColor]];
    
    searchContactButton.layer.cornerRadius = 2;
    
    //Amount
    [amountLabel setText:[[LocalizationHelper stringForKey:@"transferStep1ViewController_Amount" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P] uppercaseString]];
    [amountLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16]];
    
    [amountTextField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16]];
    [amountTextField setDelegate:self];
    
    
    //Validate
    [validateButton setTitle:[[LocalizationHelper stringForKey:@"app_validate" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] uppercaseString] forState:UIControlStateNormal];
    [[validateButton titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16]];
    [[validateButton titleLabel] setTextColor:[[ColorHelper sharedInstance] whiteColor]];
    [validateButton setBackgroundHighlightedColor:[[ColorHelper sharedInstance] transferStep1ViewController_validateButton_highlighted_backgroundColor]];
    validateButton.layer.cornerRadius = 2;
    
    //Comment button
    
    [[self commentButton]setImage: [FZUIImageWithImage imageNamed:@"bulle_Flashiz_Empty" inBundle:FZBundleP2P] forState:UIControlStateNormal];
    [[[self commentButton] layer] setCornerRadius : 2];
    
    [self addsOnSetupView];
    
    //Currency
    [_lblCurrencyBefore setText:[[CurrenciesManager currentManager] currencySymbols:[[CurrenciesManager currentManager] defaultCurrency]][0]];
    [_lblCurrencyBefore setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16]];
    [_lblCurrencyBefore setTextColor:[amountTextField textColor]];
    
    [_lblCurrencyAfter setText:[[CurrenciesManager currentManager] currencySymbols:[[CurrenciesManager currentManager] defaultCurrency]][1]];
    [_lblCurrencyAfter setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16]];
    [_lblCurrencyAfter setTextColor:[amountTextField textColor]];
}

- (void)addsOnSetupView {
    //Amount
    [amountLabel setTextColor:[[ColorHelper sharedInstance] transferOneColor]];
    [amountTextField setTextColor:[[ColorHelper sharedInstance] transferOneColor]];
    
    //Search
    [searchContactButton setBackgroundNormalColor:[[[ColorHelper sharedInstance] transferStep1ViewController_searchContactButton_backgroundColor] colorWithAlphaComponent:0.4f]];
    [searchContactButton setTitleColor:[[ColorHelper sharedInstance] transferOneColor] forState:UIControlStateHighlighted];
    
    //Validate
    [viewSearchValidate setBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]];
    [validateButton setBackgroundNormalColor:[[[ColorHelper sharedInstance] transferStep1ViewController_validateButton_backgroundColor] colorWithAlphaComponent:0.4f]];
    [[self commentButton]setBackgroundColor:[[[ColorHelper sharedInstance] transferStep1ViewController_commentButton_backgroundColor] colorWithAlphaComponent:0.4f]];
}

#pragma mark - Private method

- (BOOL)isEmailValid:(NSString *)email {
    
    NSString *regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regEx];
    
    return [predicate evaluateWithObject:email];
}

- (void)animateToStep1 {
    [UIView animateWithDuration:0.4 animations:^{
        
        [viewMail setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
        [_toLabel setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_toLabel_textColor]];
        [_mailTextField setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_mailTextField_textColor]];
        
        [viewAmount setHidden:YES];
        
        [viewSearchContact setAlpha:1.0];
        
        [viewSearchValidate setHidden:YES];
    }];
    [amountTextField resignFirstResponder];
    [_mailTextField becomeFirstResponder];
}

- (void)animateToStep2 {
    [UIView animateWithDuration:0.4 animations:^{
        CGPoint centerViewMail = [viewMail center];
        
        centerViewMail.y=yViewMailOrigin-[self traslateDeltaViewMail];
        
        [viewMail setCenter:centerViewMail];
        [viewMail setBackgroundColor:[[ColorHelper sharedInstance] transferStep1ViewController_viewMail_backgroundColor]];
        [_toLabel setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_toLabel_after_textColor]];
        [_mailTextField setTextColor:[[ColorHelper sharedInstance] transferStep1ViewController_mailTextField_after_textColor]];
        
        CGPoint centerViewAmount = [viewAmount center];
        
        centerViewAmount.y=yViewAmountOrigin-[self traslateDeltaViewAmount];
        
        [viewAmount setHidden:NO];
        [viewAmount setCenter:centerViewAmount];
        
        [viewSearchContact setAlpha:0.0];
        
        [viewSearchValidate setHidden:NO];
    }];
    [_mailTextField resignFirstResponder];
    [amountTextField becomeFirstResponder];
}

- (CGFloat)traslateDeltaViewMail {
    return 20.0;
}

- (CGFloat)traslateDeltaViewAmount {
    return 90.0;
}

- (void)setUserInfos {
    UserInformationViewController *userInfo = [[self multiTargetManager] userInformationViewController];
    
    CustomNavigationViewController *navigController = [[self multiTargetManager] customNavigationViewControllerWithController:userInfo andMode:CustomNavigationModeBack];
    
    [[self navigationController] pushViewController:navigController
                                           animated:YES];
}

#pragma mark - Observing methods

- (void)willShowMenu:(NSNotification *)notification {
    _isEditingAmount = [amountTextField isFirstResponder];
    _isEditingMail = [_mailTextField isFirstResponder];
    
    [amountTextField resignFirstResponder];
    [_mailTextField resignFirstResponder];
}

- (void)willHideMenu:(NSNotification *)notification {
    if(_isEditingAmount) {
        [amountTextField becomeFirstResponder];
    }
    
    if(_isEditingMail) {
        [_mailTextField becomeFirstResponder];
    }
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == kAlertFlashizNotUgradedAccount) {
        [self setUserInfos];
    } else {
        if(buttonIndex==1){
            UITextField *textField = [alertView textFieldAtIndex:0];
            
            [self setComment:[textField text]];
            
            if([[self comment]isEqualToString:@""]){
                [[self commentButton]setSelected:NO];
            }else{
                [[self commentButton]setSelected:YES];
            }
        }
    }
}

#pragma mark - Action method

- (IBAction)addComment:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointSendComment];
    [amountTextField resignFirstResponder];
    ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"transferStep1ViewController_Comment_title" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]
                                                                    message:[LocalizationHelper stringForKey:@"transferStep1ViewController_Comment" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]
                                                                   delegate:self
                                                          cancelButtonTitle:[LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                          otherButtonTitles:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox], nil];
    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    [textField setText:[self comment]];
    [textField setPlaceholder:[LocalizationHelper stringForKey:@"transferStep1ViewController_Comment_title" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeYes];
    
    [alertView show];
    [alertView release];
}

- (IBAction)searchContact:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointSendSearch];
    ABPeoplePickerNavigationController *pickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
    
    [pickerNavigationController setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]];
    [pickerNavigationController setPeoplePickerDelegate:self];
    [self presentViewController:pickerNavigationController
                       animated:YES
                     completion:^{
                         
                     }];
    [pickerNavigationController release];
}

- (IBAction)validateSearch:(id)sender {
    
    [[StatisticsFactory sharedInstance] checkPointSendValidate];
    
    [validateButton setEnabled:NO];
    
    BOOL isUserTrial = [[[UserSession currentSession] user] isTrial];
    
    if(isUserTrial){
        [ConnectionServices updateIfStillTrial];
        isUserTrial = [[[UserSession currentSession] user] isTrial];
        [validateButton setEnabled:YES];
    }
    
    if(!isUserTrial) {
        
        NSString *amountText = [FZAmountHelper correctedAmountFromAmount:[amountTextField text]];
        
        NSString *amount = [NSString stringWithFormat:@"%.2f",[amountText doubleValue]];
        NSString *comment = [self comment];
        NSString *forUser = [[_mailTextField text] lowercaseString];
        NSString *fromUser = [[UserSession currentSession] userKey];
        NSString *type = TransactionsTypeMail;
        
        if ([amount isEqualToString:@"0.00"]) {
            
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                            message:[LocalizationHelper stringForKey:@"transferStep1ViewController_EmptyAmount" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]
                                                                           delegate:nil
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView show];
            [alertView release];
            [amountTextField setText:@""];
            
            [validateButton setEnabled:YES];
            
        }else{
            
            if([forUser length]==0) {
                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                message:[LocalizationHelper stringForKey:@"transferStep1ViewController_FillEmail" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]
                                                                               delegate:nil
                                                                      cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                      otherButtonTitles:nil];
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView show];
                [alertView release];
                
                [validateButton setEnabled:YES];
                
                return;
            }
            
            if([amount length]==0) {
                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                message:[LocalizationHelper stringForKey:@"transferStep1ViewController_FillAmount" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P]
                                                                               delegate:nil
                                                                      cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                      otherButtonTitles:nil];
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView show];
                [alertView release];
                
                [validateButton setEnabled:YES];
                
                return;
            }
            
            [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]];
            
            [amountTextField resignFirstResponder];
            
            if([[[[UserSession currentSession] user] account] balance] < [amountText doubleValue]) {
                [self automaticRefillWithAmount:amount comment:comment forUser:forUser fromUser:fromUser andType:type];
            } else {
                [self refillWithAmount:amount comment:comment forUser:forUser fromUser:fromUser andType:type];
            }
        }
    } else {
        if([[[UserSession currentSession] user] isUserUpgraded]) {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"registerCaptchaViewController_mail_notification" withComment:@"RegisterCaptchaViewController" inDefaultBundle:FZBundleP2P]
                                                                           delegate:self
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView setTag:kAlertFlashizNotValidatedAccount];
            [alertView show];
            [alertView release];
            
            [validateButton setEnabled:YES];
        } else {
            ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:nil
                                                                            message:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_valid_account" withComment:@"PaymentViewController" inDefaultBundle:FZBundlePayment]
                                                                           delegate:self
                                                                  cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                  otherButtonTitles:nil];
            [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
            [alertView setTag:kAlertFlashizNotUgradedAccount];
            [alertView show];
            [alertView release];
            
            [validateButton setEnabled:YES];
        }
    }
}

- (void)automaticRefillWithAmount:(NSString *)amount comment:(NSString *)comment forUser:(NSString *)forUser fromUser:(NSString *)fromUser andType:(NSString *)type {
    //Do nothing for Flashiz
    [self hideWaitingView];
    
    NSString *localizedSentence = [LocalizationHelper stringForKey:@"transferStep1ViewController_InsufficientAmount" withComment:@"TransferStep1ViewController" inDefaultBundle:FZBundleP2P];
    
    localizedSentence = [NSString stringWithFormat:localizedSentence,[[CurrenciesManager currentManager] formattedAmount:amount currency:[[[[UserSession currentSession] user] account] currency]]];
    
    ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                    message:localizedSentence
                                                                   delegate:nil
                                                          cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                          otherButtonTitles:nil];
    [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
    [alertView show];
    [alertView release];
    
    [validateButton setEnabled:YES];
}

- (void)refillWithAmount:(NSString *)amount comment:(NSString *)comment forUser:(NSString *)forUser fromUser:(NSString *)fromUser andType:(NSString *)type {
    /*
     #warning bypass server's call
     [self hideWaitingView];
     [self presentActionViewControllerWithAmount:amount];
     */
    
    [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]];
    
    [TransactionServices transfertMoney:amount
                            withComment:comment
                                forUser:forUser
                               fromUser:fromUser
                               withType:type
                           successBlock:^(id context) {
                               
                               FZP2PLog(@"transfertMoney success : %@",context);
                               
                               [self hideWaitingView];
                               
                               [self presentActionViewControllerWithAmount:amount];
                               
                               // TODO: need refactor
                               //[TestFlightHelper passTransferSendValidate];
                               
                               [validateButton setEnabled:YES];
                               
                           } failureBlock:^(Error *error) {
                               FZP2PLog(@"transfertMoney error : %@",error);
                               
                               [self hideWaitingView];
                               
                               [self displayAlertForError:error];
                               
                               [validateButton setEnabled:YES];
                           }];
}

- (void)presentActionViewControllerWithAmount:(NSString *)amount {
    [self presentActionViewControllerWithTitle:[NSString stringWithFormat:
                                                [LocalizationHelper stringForKey:@"transferHomeViewController_deal_success_with_amount" withComment:@"TransferHomeViewController" inDefaultBundle:FZBundleP2P],
                                                [[CurrenciesManager currentManager] formattedAmount:amount currency:
                                                 [[[[UserSession currentSession] user] account] currency]]
                                                ]
                            andBackgroundColor:[[ColorHelper sharedInstance] transferOneColor]
                        andBackgroundImageName:kBackgroundImageActionSuccessful
                                  inBundleName:FZBundleP2P
                                 andArrowImage: [FZUIImageWithImage imageNamed:@"arrow_right_red" inBundle:FZBundleP2P] andDelegate:self withCorrectiveDelta:0.0];
}

#pragma mark - ABPeoplePickerNavigationController delegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    ABMultiValueRef mail = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    int numberOfValues = (int)ABMultiValueGetCount(mail);
    
    if(numberOfValues>1) {
        CFRelease(mail);
        return YES;
    }
    
    for(NSInteger i=0;i<numberOfValues;i++) {
        CFTypeRef mailValue = ABMultiValueCopyValueAtIndex(mail, i);
        
        [_mailTextField setText:mailValue];
        
        CFRelease(mailValue);
        
        [self animateToStep2];
    }
    
    CFRelease(mail);
    
    [peoplePicker dismissViewControllerAnimated:YES
                                     completion:^{}];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    CFTypeRef mail = ABRecordCopyValue(person, property);
    CFIndex mailIndex = ABMultiValueGetIndexForIdentifier(mail, identifier);
    CFTypeRef mailValue = ABMultiValueCopyValueAtIndex(mail, mailIndex);
    
    [_mailTextField setText:mailValue];
    
    CFRelease(mailValue);
    CFRelease(mail);
    
    [peoplePicker dismissViewControllerAnimated:YES
                                     completion:nil];
    
    [self animateToStep2];
    
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES
                                     completion:nil];
    
}

#pragma mark - UITextField delegate method

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
        
        if(textField==amountTextField) {
            BOOL isValidAmount = [FZAmountHelper isValid:newString];
            
            if(!isValidAmount) {
                return NO;
            }
        }
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField!=_mailTextField) {
        _isEditingMail = NO;
        return YES;
    }
    
    NSString *emailValue = [textField text];
    BOOL isValidEmail = [self isEmailValid:emailValue];
    
    if(isValidEmail) {
        [textField resignFirstResponder];
        [textField setTextColor:[UIColor blackColor]];
        
        [self animateToStep2];
    }
    else {
        [textField setTextColor:[UIColor redColor]];
    }
    
    _isEditingAmount = NO;
    
    return NO;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if(textField ==_mailTextField) {
        [self animateToStep1];
    }
}

#pragma mark ActionSuccessfulViewController delegate

- (void)didValidate:(ActionSuccessfulViewController *)controller {
    
    [[StatisticsFactory sharedInstance] checkPointSendQRCodeDone];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - CustomNavigationViewControllerAction

-(void)didGoBack:(CustomNavigationViewController *)controller {
    
}

- (void)didClose:(CustomNavigationViewController *)controller {
    
    [[StatisticsFactory sharedInstance] checkPointSendQuit];
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
    
    [_comment release];
    [viewAmount release];
    [viewMail release];
    [_mailTextField release];
    [viewSearchContact release];
    [viewSearchValidate release];
    [amountTextField release];
    [_toLabel release];
    [amountLabel release];
    [searchFriendMailLabel release];
    [searchContactButton release];
    [validateButton release];
    [_lblCurrencyBefore release];
    [_lblCurrencyAfter release];
    [commentButton release];
    [_viewAmountTop release];
    [super dealloc];
}

@end
