//
//  TipViewController.m
//  FZBlackBox
//
//  Created by OlivierDemolliens on 8/11/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "FZTipViewController.h"

//TippingEngine
#import "FZTippingEngine.h"

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//LocalizationHelper
#import <FZBlackBox/LocalizationHelper.h>

//Currency manager
#import <FZAPI/CurrenciesManager.h>

//User session
#import <FZAPI/UserSession.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Button
#import <FZBlackBox/FZButton.h>

//Font
#import <FZBlackBox/FontHelper.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

#import <FZBlackBox/FZTargetManager.h>

@interface FZTipViewController () <UITextFieldDelegate>

//View
@property (retain, nonatomic) IBOutlet UIView *viewAmount;
@property (retain, nonatomic) IBOutlet UIView *viewTip;
@property (retain, nonatomic) IBOutlet UILabel *lblInvoiceAmountWithTipInside;
@property (retain, nonatomic) IBOutlet UITextField *textFieldTipAmount;
@property (retain, nonatomic) IBOutlet UIButton *btnNoTip;
@property (retain, nonatomic) IBOutlet UIButton *btnAddFirstRange;
@property (retain, nonatomic) IBOutlet UIButton *btnAddSecondRange;
@property (retain, nonatomic) IBOutlet UILabel *lblNoTip;
@property (retain, nonatomic) IBOutlet UILabel *lblAddFirstRange;
@property (retain, nonatomic) IBOutlet UILabel *lblAddSecondRange;
@property (retain, nonatomic) IBOutlet UILabel *lblPersonalizedTipValue;
@property (retain, nonatomic) IBOutlet FZButton *btnApplyTip;
@property (retain, nonatomic) IBOutlet UILabel *lblPercentageOfInvoice;

//Model
@property (retain, nonatomic) FZTipModel *tipModel;

@end

@implementation FZTipViewController
@synthesize delegate;
@synthesize tipModel;

#pragma mark Constructor

- (id)initWithInvoice:(Invoice *)invoice andTipAmount:(double)tipAmount
{
    self = [super initWithNibName:@"FZTipViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if (self) {
        [self setTipModel:[[FZTipModel alloc] initWithInvoice:invoice andTipAmount:tipAmount]];
    }
    return self;
}

#pragma mark View cycle life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
}

#pragma mark - setup view

- (void)setupView {
    
    //Several times used
    ColorHelper *colorHelper = [ColorHelper sharedInstance];
    FontHelper *fontHelper = [FontHelper sharedInstance];
    UIColor *whiteColor = [colorHelper whiteColor];
    UIFont *futuraCS20 = [fontHelper fontFuturaCondensedWithSize:20.0f];
    
    //Header
    [self setTitleHeader:[[LocalizationHelper stringForKey:@"tipViewController_navigation_title" withComment:@"FZTipViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    [self setTitleColor:whiteColor];
    [self setBackgroundColor:[colorHelper paymentCheckViewController_header_backgroundColor]];
    
    //Amount
    [[self lblInvoiceAmountWithTipInside] setTextColor:whiteColor];
    [[self lblInvoiceAmountWithTipInside] setFont:[fontHelper fontFuturaCondensedWithSize:45.0f]];
    [[self lblInvoiceAmountWithTipInside] setAdjustsFontSizeToFitWidth:YES];
    [[self lblInvoiceAmountWithTipInside] setMinimumScaleFactor:0.5];
    [[self viewAmount] setBackgroundColor:[colorHelper mainOneColor]];
    
    //Tip
    [[self viewTip] setBackgroundColor:whiteColor];
    [[self textFieldTipAmount] setTextAlignment:NSTextAlignmentRight];
    
    [[self lblNoTip] setTextColor:whiteColor];
    [[self lblAddFirstRange] setTextColor:whiteColor];
    [[self lblAddSecondRange] setTextColor:whiteColor];
    [[self lblPercentageOfInvoice] setTextColor:[colorHelper mainOneColor]];
    [[self textFieldTipAmount] setTextColor:[colorHelper mainOneColor]];
    
    [[self lblNoTip] setText:[[LocalizationHelper stringForKey:@"tipViewController_lblNoTip" withComment:@"FZTipViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    [[self lblAddFirstRange] setText: [[NSString stringWithFormat:@"%@%@",[LocalizationHelper stringForKey:@"tipViewController_lblAddFirstRange" withComment:@"FZTipViewController" inDefaultBundle:FZBundlePayment], [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[[self tipModel] firstRange]]]] uppercaseString]];
    [[self lblAddSecondRange] setText: [[NSString stringWithFormat:@"%@%@",[LocalizationHelper stringForKey:@"tipViewController_lblAddSecondRange" withComment:@"FZTipViewController" inDefaultBundle:FZBundlePayment], [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[[self tipModel] secondRange]]]] uppercaseString]];
        
    [[self lblNoTip] setFont:futuraCS20];
    [[self lblAddFirstRange] setFont:futuraCS20];
    [[self lblAddSecondRange] setFont:futuraCS20];
    [[self lblPercentageOfInvoice] setFont:futuraCS20];
    [[self textFieldTipAmount] setFont:[fontHelper fontFuturaCondensedWithSize:45.0f]];
    
    [[self btnNoTip] setBackgroundImage:[FZUIImageWithImage imageNamed:@"0_button" inBundle:FZBundlePayment] forState:UIControlStateNormal];
    [[self btnAddFirstRange] setBackgroundImage:[FZUIImageWithImage imageNamed:@"+_button" inBundle:FZBundlePayment] forState:UIControlStateNormal];
    [[self btnAddSecondRange] setBackgroundImage:[FZUIImageWithImage imageNamed:@"+_button" inBundle:FZBundlePayment] forState:UIControlStateNormal];
    
    //View (bottom)
    [[self view] setBackgroundColor:[colorHelper mainOneColor]];
    [[self lblPersonalizedTipValue] setText:[[LocalizationHelper stringForKey:@"tipViewController_lblPersonalizedTipValue" withComment:@"FZTipViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    [[self lblPersonalizedTipValue] setTextColor:whiteColor];
    [[self lblPersonalizedTipValue] setFont:futuraCS20];
    
    //Button
    [[self btnApplyTip] setBackgroundNormalColor:[colorHelper mainTwoColor]];
    [[self btnApplyTip] setBackgroundHighlightedColor:[colorHelper mainThreeColor]];
    [[self btnApplyTip] setTitleColor:whiteColor forState:UIControlStateNormal];
    [[self btnApplyTip] setTitleColor:[colorHelper mainOneColor] forState:UIControlStateHighlighted];
    [[self btnApplyTip] setTitle:[[LocalizationHelper stringForKey:@"tipViewController_btnApplyTip" withComment:@"FZTipViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[[self btnApplyTip] titleLabel] setFont:[fontHelper fontFuturaCondensedWithSize:25.0f]];
    
    //Init UI
    [[self lblInvoiceAmountWithTipInside] setText:[self formatInvoiceAmount:[[self tipModel] invoiceAmountWithTipInside]]];
    
    double tipAmount = [FZTippingEngine retrieveTipAmountWithCurrentInvoiceAmount:[[self tipModel] invoiceAmountWithTipInside] andInitialInvoiceAmount:[[self tipModel] initialInvoiceAmount]];
    
    [[self textFieldTipAmount] setText:[self formatInvoiceAmount:tipAmount]];
    
    [self computeTipPercentageRegardingInitialInvoiceAmount];
    
    //Set delegate
    [[self textFieldTipAmount] setDelegate:self];
}

- (void)centerTip {
    
    if ([[[self textFieldTipAmount] text] length] < 14) {
        
        //static font size
        [[self textFieldTipAmount] setAdjustsFontSizeToFitWidth:NO];
        [[self textFieldTipAmount] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:45.0f]];
        
        [[self lblPercentageOfInvoice] setAdjustsFontSizeToFitWidth:NO];
        [[self lblPercentageOfInvoice] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:20.0f]];
        
        //debug
        //[[self textFieldTipAmount] setBackgroundColor:[UIColor yellowColor]];
        //[[self lblPercentageOfInvoice] setBackgroundColor:[UIColor redColor]];
        
        [[self textFieldTipAmount] sizeToFit];
        [[self lblPercentageOfInvoice] sizeToFit];
        
        CGFloat screenSize = [[UIScreen mainScreen]bounds].size.width;
        
        CGRect textFieldTipAmountFrame = [[self textFieldTipAmount] frame];
        CGRect lblPercentageOfInvoiceFrame = [[self lblPercentageOfInvoice] frame];
        CGRect viewTipFrame = [[self viewTip] frame];
        
        float totalWidth = textFieldTipAmountFrame.size.width + lblPercentageOfInvoiceFrame.size.width + 10;//space between textFieldTipAmount and lblPercentageOfInvoice
        
        textFieldTipAmountFrame.origin.x = screenSize/2 - totalWidth/2;
        textFieldTipAmountFrame.origin.y = viewTipFrame.size.height/2 - textFieldTipAmountFrame.size.height/2;
        [[self textFieldTipAmount] setFrame:textFieldTipAmountFrame];
        
        lblPercentageOfInvoiceFrame.origin.x = textFieldTipAmountFrame.origin.x + textFieldTipAmountFrame.size.width + 10;
        lblPercentageOfInvoiceFrame.origin.y = textFieldTipAmountFrame.origin.y + textFieldTipAmountFrame.size.height - lblPercentageOfInvoiceFrame.size.height;
        [[self lblPercentageOfInvoice] setFrame:lblPercentageOfInvoiceFrame];
    } else {
        //set frame
        CGRect textFieldTipAmountFrame = [[self textFieldTipAmount] frame];
        textFieldTipAmountFrame.origin.x = 10;
        textFieldTipAmountFrame.size.width = 250;
        [[self textFieldTipAmount] setFrame:textFieldTipAmountFrame];
        
        CGRect lblPercentageOfInvoiceFrame = [[self lblPercentageOfInvoice] frame];
        lblPercentageOfInvoiceFrame.origin.x = textFieldTipAmountFrame.origin.x + textFieldTipAmountFrame.size.width + 10;
        lblPercentageOfInvoiceFrame.origin.y = textFieldTipAmountFrame.origin.y + textFieldTipAmountFrame.size.height - lblPercentageOfInvoiceFrame.size.height;
        lblPercentageOfInvoiceFrame.size.width = 50;
        [[self lblPercentageOfInvoice] setFrame:lblPercentageOfInvoiceFrame];
        
        //dynamic font size
        [[self textFieldTipAmount] setAdjustsFontSizeToFitWidth:YES];
        [[self textFieldTipAmount] setMinimumFontSize:11.0];
        
        [[self lblPercentageOfInvoice] setAdjustsFontSizeToFitWidth:YES];
        [[self lblPercentageOfInvoice] setMinimumScaleFactor:0.5];
        
    }
}

#pragma mark - private

- (void)computeTipPercentageRegardingInitialInvoiceAmount {
    //Compute
    double tipAmount = [FZTippingEngine retrieveTipAmountWithCurrentInvoiceAmount:[[self tipModel] invoiceAmountWithTipInside] andInitialInvoiceAmount:[[self tipModel] initialInvoiceAmount]];
    double percentageOfInvoice = [FZTippingEngine computePercentageOfInvoice:[[self tipModel] initialInvoiceAmount] regardingTipAmount:tipAmount];
    
    //Update UI
    NSString *percencageRounded = @"";
    if (percentageOfInvoice >= 1) {
        percencageRounded = [NSString stringWithFormat:@"(%.0f%%)",percentageOfInvoice];
    } else {
        percencageRounded = [NSString stringWithFormat:@"(%.1f%%)",percentageOfInvoice];
        percencageRounded = [percencageRounded stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    
    [[self lblPercentageOfInvoice] setText:percencageRounded];
    
    [self centerTip];
}

- (void)addAmount:(double)amountToAdd {
    //Resign textField
    [[self textFieldTipAmount] resignFirstResponder];
    
    //Get current amount
    double currentInvoiceAmount = [[self tipModel] invoiceAmountWithTipInside];
    
    //Apply the tip
    double newInvoiceAmount = [FZTippingEngine addAmount:amountToAdd toInvoiceAmount:currentInvoiceAmount];
    
    //Set the data
    [[self tipModel] setInvoiceAmountWithTipInside:newInvoiceAmount];
    
    //Update UI
    [[self lblInvoiceAmountWithTipInside] setText:[self formatInvoiceAmount:newInvoiceAmount]];
    
    [[self textFieldTipAmount] setText:[self formatInvoiceAmount:[FZTippingEngine retrieveTipAmountWithCurrentInvoiceAmount:newInvoiceAmount andInitialInvoiceAmount:[[self tipModel] initialInvoiceAmount]]]];
    
    [self computeTipPercentageRegardingInitialInvoiceAmount];
}

#pragma mark - Actions

- (IBAction)removeTip:(id)sender {
    //Resign textField
    [[self textFieldTipAmount] resignFirstResponder];
    
    //Set the data
    [[self tipModel] setInvoiceAmountWithTipInside:[[self tipModel] initialInvoiceAmount]];
    
    //Update the UI
    [[self lblInvoiceAmountWithTipInside] setText:[self formatInvoiceAmount:[[self tipModel] initialInvoiceAmount]]];
    
    [[self textFieldTipAmount] setText:[self formatInvoiceAmount:[FZTippingEngine retrieveTipAmountWithCurrentInvoiceAmount:[[self tipModel] invoiceAmountWithTipInside] andInitialInvoiceAmount:[[self tipModel] initialInvoiceAmount]]]];
    
    [self computeTipPercentageRegardingInitialInvoiceAmount];
}

- (IBAction)addFirstRange:(id)sender {
    [self addAmount:[[self tipModel] firstRange]];
}

- (IBAction)addSecondRange:(id)sender {
    [self addAmount:[[self tipModel] secondRange]];
}

- (IBAction)applyTip:(id)sender {
    [self backToPaymentWithTipAmount:[FZTippingEngine retrieveTipAmountWithCurrentInvoiceAmount:[[self tipModel] invoiceAmountWithTipInside] andInitialInvoiceAmount:[[self tipModel] initialInvoiceAmount]]];
}

- (IBAction)tapScreen:(id)sender {
    //Resign textField
    [[self textFieldTipAmount] resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *removedChar = [[textField text] substringWithRange:range];
    
    //do not remove IDR
    if ([removedChar isEqualToString:@"I"] || [removedChar isEqualToString:@"D"] || [removedChar isEqualToString:@"R"] || [removedChar isEqualToString:@","]) {
        return NO;
    }
    
    //manage the delete or insertion of a new value
    NSString *aText = nil;
    
    if([string length] > 0 && range.location >= [[textField text] length] - 1){//add char at the end of the string
        aText = [NSString stringWithFormat:@"%@%@",[textField text],string];
    } else if([string length] > 0 && range.location < [[textField text] length] - 1) {//add char at the middle or begining of the string
        aText = [NSString stringWithFormat:@"%@%@%@",[[textField text] substringToIndex:range.location],string,[[textField text] substringFromIndex:range.location]];
    } else if(range.location >= [[textField text] length] - 1){//remove last char of the string
        aText = [[textField text] substringToIndex:[[textField text] length] - 1];
    } else {//remove a char at the middle of the string
        aText =[NSString stringWithFormat:@"%@%@",[[textField text] substringToIndex:range.location],[[textField text] substringFromIndex:range.location + 1]];
    }
    
    NSString *amountWithoutCurrency = [aText stringByReplacingOccurrencesOfString:@"IDR " withString:@""];
    NSString *amountNoFormatted = [amountWithoutCurrency stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double tipAmount = [amountNoFormatted doubleValue];
    
    //Apply the tip
    double newInvoiceAmount = [FZTippingEngine addAmount:tipAmount toInvoiceAmount:[[self tipModel] initialInvoiceAmount]];
    
    //Set the data
    [[self tipModel] setInvoiceAmountWithTipInside:newInvoiceAmount];
    
    //Update UI
    [[self lblInvoiceAmountWithTipInside] setText:[self formatInvoiceAmount:newInvoiceAmount]];
    
    [[self textFieldTipAmount] setText:[self formatInvoiceAmount:tipAmount]];
    
    [self computeTipPercentageRegardingInitialInvoiceAmount];
    
    [[self textFieldTipAmount] resignFirstResponder];
    [[self textFieldTipAmount] becomeFirstResponder];
    
    [self setCursorAtPosition:range replacementString:string];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self centerTip];
}

- (void)setCursorAtPosition:(NSRange)range replacementString:(NSString *)string{
    
    UITextPosition *beginning = [[self textFieldTipAmount] beginningOfDocument];
    UITextPosition *start = nil;
    
    //manage the comma
    int stringLength = (int)[[[self textFieldTipAmount] text] length];
    int commaWhenAddingChar = stringLength - 9;
    int commaWhenRemovingChar = stringLength -7;
    int addComma = 0;
    
    if ([string length] == 0) {
        if (commaWhenRemovingChar % 4 == 0) {//the comma is every 4 chars
            addComma = -1;//move the cursor about 1 more step before
        }
        
        start = [[self textFieldTipAmount] positionFromPosition:beginning offset:range.location + addComma];
    } else {
        if (commaWhenAddingChar % 4 == 0 && commaWhenAddingChar != -4) {//the comma is every 4 chars
            addComma = 1;//move the cursor about 1 more step after
        }
        
        //exception
        if (range.location == 5 && stringLength == 5) {
            addComma = -1;
        }
        
        start = [[self textFieldTipAmount] positionFromPosition:beginning offset:range.location+1+addComma];
    }

    UITextRange *textRange = [[self textFieldTipAmount] textRangeFromPosition:start toPosition:start];
    
    [[self textFieldTipAmount] setSelectedTextRange:textRange];
}

#pragma mark - Utils

/*
 * Format the Invoice Amount
 * Rounded To Next Amount Rule
 *
 * x (Indonesia)
 * x.xx (Europe)
 */
- (NSString *)formatInvoiceAmount:(double)invoiceAmount {
    NSString *formattedInvoiceAmount = nil;
   
    if ([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) {
        formattedInvoiceAmount = [[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",invoiceAmount] currency:[[self tipModel] currency]];
    } else {
        formattedInvoiceAmount = [[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.0f",invoiceAmount] currency:[[self tipModel] currency]];
    }
    
    return formattedInvoiceAmount;
}

#pragma mark - Navigation Delegate

- (void)didGoBack:(CustomNavigationHeaderViewController *)controller {
    //do nothing
}

- (void)didClose:(CustomNavigationHeaderViewController *)controller {
    if ([[self delegate] respondsToSelector:@selector(cancelTip)]) {
        [delegate cancelTip];
    }
}

#pragma Delegate

- (void)backToPaymentWithTipAmount:(double)tipAmount {
    if ([[self delegate] respondsToSelector:@selector(backToPaymentWithTipAmount:)]) {
        [delegate backToPaymentWithTipAmount:tipAmount];
    }
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_lblInvoiceAmountWithTipInside release];
    [_textFieldTipAmount release];
    [_btnNoTip release];
    [_btnAddFirstRange release];
    [_btnAddSecondRange release];
    [_lblNoTip release];
    [_lblPersonalizedTipValue release];
    [_lblAddFirstRange release];
    [_lblAddSecondRange release];
    [_btnApplyTip release];
    [tipModel release];
    [_lblPercentageOfInvoice release];
    [_viewAmount release];
    [_viewTip release];
    [super dealloc];
}

@end