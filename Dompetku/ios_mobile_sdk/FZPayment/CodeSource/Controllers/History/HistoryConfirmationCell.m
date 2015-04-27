//
//  HistoryConfirmationCell.m
//  iMobey
//
//  Created by Neopixl on 28/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "HistoryConfirmationCell.h"
#import <FZBlackBox/LocalizationHelper.h>

//Currency
#import <FZAPI/CurrenciesManager.h>


@interface HistoryConfirmationCell()

@property (retain, nonatomic) IBOutlet UILabel *destinationLabel;
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;


@property (retain, nonatomic) IBOutlet UILabel *thxLabel;


//Model
@property(retain,nonatomic) Transaction *transaction;

@end


@implementation HistoryConfirmationCell


-(void)fillWithTransaction:(Transaction *)transaction{
    [self setTransaction:transaction];
    [[self amountLabel] setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[[transaction amount] doubleValue]] currency:[transaction currency]]];
    
    [[self destinationLabel] setText:[transaction receiverInfo]];
    
    [[self thxLabel] setText:[LocalizationHelper stringForKey:@"thanks_you" withComment:@"HistoryConfirmationCell" inDefaultBundle:FZBundlePayment]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - MM

- (void)dealloc {
    [_thxLabel release]; _thxLabel = nil;
    [_transaction release]; _transaction = nil;
    [_destinationLabel release]; _destinationLabel = nil;
    [_amountLabel release]; _amountLabel = nil;
    
    [super dealloc];
}
@end
