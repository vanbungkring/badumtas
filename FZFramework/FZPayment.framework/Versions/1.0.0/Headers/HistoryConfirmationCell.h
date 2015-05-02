//
//  HistoryConfirmationCell.h
//  iMobey
//
//  Created by Neopixl on 28/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZAPI/Transaction.h>

//Parent
#import <FZBlackBox/ReuseTableViewCell.h>

@interface HistoryConfirmationCell : ReuseTableViewCell



-(void)fillWithTransaction:(Transaction *)transaction;

@end
