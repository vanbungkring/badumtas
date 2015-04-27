//
//  HistoryDetailCell.m
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "HistoryDetailCell.h"

#import <FZAPI/UserSession.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Custom button
#import <FZBlackBox/FZButton.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

#define kCommentLimit 105

static NSDateFormatter *dateFormatter = nil;

@interface HistoryDetailCell()
{
    
}
@property (retain, nonatomic) IBOutlet UIImageView *imgViewLeft;
@property (retain, nonatomic) IBOutlet UILabel *lblDate;
@property (retain, nonatomic) IBOutlet UILabel *lblDescribe;
@property (retain, nonatomic) IBOutlet UILabel *lblAmount;

@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@property (retain, nonatomic) IBOutlet UIImageView *pendingValidateImageView;
@property (retain, nonatomic) IBOutlet UIImageView *pendingCancelImageView;


@property (retain, nonatomic) IBOutlet UIView *pendingCreditorActionView;
@property (retain, nonatomic) IBOutlet UIView *pendingDebitorActionView;


@property (retain, nonatomic) IBOutlet FZButton *pendingCreditorAcceptButton;
@property (retain, nonatomic) IBOutlet FZButton *pendingCreditorCancelButton;
@property (retain, nonatomic) IBOutlet FZButton *pendingDebitorCancelButton;

@property (retain, nonatomic) IBOutlet UIImageView *indicatorComment;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


//Model
@property(retain,nonatomic) Transaction *transaction;

@end

@implementation HistoryDetailCell


@synthesize delegate;

#define kDateFormat @"dd/MM"

#pragma mark - Customize

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if(nil==dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kDateFormat];
        
    }
    
    [[self indicatorComment] setHidden:YES];
    
    
    [_indicatorComment setImage:[FZUIImageWithImage imageNamed:@"icon_plus_micro" inBundle:FZBundlePayment]];
    [_maskImageView setImage:[FZUIImageWithImage imageNamed:@"mask_history_list_white" inBundle:FZBundlePayment]];
}


-(void) setAvatar:(UIImage *)image{
    [_activityIndicator stopAnimating];
    [[self imgViewLeft] setImage:image];
}


-(void)fillWithTransaction:(Transaction *)transaction{
    [self setTransaction:transaction];
    [[self lblAmount] setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[[transaction amount] doubleValue]] currency:[transaction currency]]];
    [[self lblDate] setText:[dateFormatter stringFromDate:[transaction executionDate]]];
    [[self lblDescribe] setText:[transaction fullName]];
    [[self lblComment] setText:[transaction comment]];
    
    if([[transaction comment] length] > kCommentLimit){
        [[self indicatorComment] setHidden:NO];
    }
    
    //hide information by defaut
    [[self pendingValidateImageView] setHidden:YES];
    [[self pendingCancelImageView] setHidden:YES];
    [[self lblStatus] setHidden:YES];
    [[self pendingCreditorActionView] setHidden:YES];
    [[self pendingDebitorActionView] setHidden:YES];
    //localize action buttons
    
    [[self pendingCreditorAcceptButton] setTitle:[[LocalizationHelper stringForKey:@"accept" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[self pendingCreditorCancelButton] setTitle:[[LocalizationHelper stringForKey:@"cancel" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[self pendingDebitorCancelButton] setTitle:[[LocalizationHelper stringForKey:@"cancel" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];

    //button
    [[self pendingCreditorAcceptButton] setBackgroundNormalColor:[[ColorHelper sharedInstance] historyDetailCell_pendingCreditorAcceptButton_backgroundColor]];
    [[self pendingCreditorAcceptButton] setBackgroundHighlightedColor:[[ColorHelper sharedInstance] historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor]];
    
    [[self pendingCreditorCancelButton] setBackgroundNormalColor:[[ColorHelper sharedInstance] historyDetailCell_pendingCreditorCancelButton_backgroundColor]];
    [[self pendingCreditorCancelButton] setBackgroundHighlightedColor:[[ColorHelper sharedInstance] historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor]];
    
    [[self pendingDebitorCancelButton] setBackgroundNormalColor:[[ColorHelper sharedInstance] historyDetailCell_pendingDebitorCancelButton_backgroundColor]];
    [[self pendingDebitorCancelButton] setBackgroundHighlightedColor:[[ColorHelper sharedInstance] historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor]];
    
    //action views
    [[self pendingCreditorActionView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_pendingCreditorActionView_backgroundColor]];
    [[self pendingDebitorActionView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_pendingDebitorActionView_backgroundColor]];
    
    //pending
   if([transaction pending]){
     //[[self contentView] setBackgroundColor:[UIColor lightGrayColor]];
       [[self indicatorColorView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_indicatorColorView_pending_backgroundColor]];
       [[self lblAmount] setTextColor:[[ColorHelper sharedInstance] historyDetailCell_lblAmount_pending_textColor]];
       [[self pendingCancelImageView] setHidden:NO];
        
     if([transaction creditor] == [[[[UserSession currentSession] user] account] accountId]){
        //button confirm
        [[self pendingValidateImageView] setHidden:NO];
        [[self lblAmount] setText:[NSString stringWithFormat:@"+ %@",[[self lblAmount] text]]];
      }
      else{
         [[self lblAmount] setText:[NSString stringWithFormat:@"- %@",[[self lblAmount] text]]];
          
         //add img to cancel button
         UIImage *img = [FZUIImageWithImage imageNamed:@"icon_cross_white" inBundle:FZBundleBlackBox];
         UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
         [imgView setFrame:CGRectMake(_pendingDebitorCancelButton.frame.size.width-img.size.width - 10, _pendingDebitorCancelButton.frame.size.height/2-img.size.height/2, img.size.width, img.size.height)];
         [_pendingDebitorCancelButton addSubview:imgView];
         [imgView release];
      }
    }
    //canceled
    else if([transaction isCanceled]){
        [[self contentView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_contentView_canceled_backgroundColor]];
        [[self lblStatus] setHidden:NO];
        [[self lblStatus] setText:[LocalizationHelper stringForKey:@"canceled" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment]];
        [[self indicatorColorView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_indicatorColorView_pending_backgroundColor]];
        [[self lblAmount] setTextColor:[[ColorHelper sharedInstance] historyDetailCell_lblAmount_pending_textColor]];
    }
    else if([transaction isRefused]){
        [[self contentView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_contentView_refused_backgroundColor]];
        [[self lblStatus] setHidden:NO];
        [[self lblStatus] setText:[LocalizationHelper stringForKey:@"refused" withComment:@"HistoryDetailCell" inDefaultBundle:FZBundlePayment]];
        [[self indicatorColorView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_indicatorColorView_pending_backgroundColor]];
    }
    //input
    else if([transaction creditor] == [[[[UserSession currentSession] user] account] accountId]){
      //[[self contentView] setBackgroundColor:[UIColor greenColor]];
        [[self indicatorColorView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_indicatorColorView_credit_backgroundColor]];
        [[self lblAmount] setTextColor:[[ColorHelper sharedInstance] historyDetailCell_lblAmount_credit_textColor]];
        
        [[self lblAmount] setText:[NSString stringWithFormat:@"+ %@",[[self lblAmount] text]]];
    }
    //output
    else if([transaction debitor] == [[[[UserSession currentSession] user] account] accountId]){
      //[[self contentView] setBackgroundColor:[UIColor redColor]];
        [[self indicatorColorView] setBackgroundColor:[[ColorHelper sharedInstance] historyDetailCell_indicatorColorView_debit_backgroundColor]];
        [[self lblAmount] setTextColor:[[ColorHelper sharedInstance] historyDetailCell_lblAmount_debit_textColor]];
        
        [[self lblAmount] setText:[NSString stringWithFormat:@"- %@",[[self lblAmount] text]]];
    }
}

-(void) commentIsOpen:(BOOL)open{
  
    UIImage *img = open ? [FZUIImageWithImage imageNamed:@"icon_cross_micro" inBundle:FZBundleBlackBox] : [FZUIImageWithImage imageNamed:@"icon_plus_micro" inBundle:FZBundlePayment];
    
    [[self indicatorComment] setImage:img];
    
}

#pragma mark - Actions

- (IBAction)validatePendingTransaction:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(validatePendingTransaction:)]) {
        [delegate validatePendingTransaction:_transaction];
    }
}

- (IBAction)cancelPendingTransaction:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(cancelPendingTransaction:)]) {
        [delegate cancelPendingTransaction:_transaction];
    }
}


-(void) showCreditorActionView:(BOOL)boolean{
    [_pendingCreditorActionView setHidden:!boolean];
}

-(void) showDebitorActionView:(BOOL)boolean{
    [_pendingDebitorActionView setHidden:!boolean];
}

#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}



#pragma mark - MM

- (void)dealloc {
    
    [_activityIndicator release]; _activityIndicator = nil;
    [_maskImageView release];
    [_indicatorComment release];
    [_indicatorColorView release];
    [_pendingDebitorCancelButton release];
    [_pendingCreditorAcceptButton release];
    [_pendingCreditorCancelButton release];
    [_imgViewLeft release];
    [_lblStatus release];
    [_lblDate release];
    [_lblDescribe release];
    [_lblAmount release];
    [_pendingValidateImageView release];
    [_pendingCancelImageView release];
    
    [_lblComment release];
    
    [_transaction release];
    
    [_pendingCreditorActionView release];
    [_pendingDebitorActionView release];
        
    [super dealloc];
}

@end
