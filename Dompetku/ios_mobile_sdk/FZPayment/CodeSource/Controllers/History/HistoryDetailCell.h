//
//  HistoryDetailCell.h
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FZAPI/Transaction.h>

//Parent
#import <FZBlackBox/ReuseTableViewCell.h>

@protocol HistoryDetailCellDelegate <NSObject>

-(void)validatePendingTransaction:(Transaction*)transaction;

-(void)cancelPendingTransaction:(Transaction*)transaction;


@end

@interface HistoryDetailCell : ReuseTableViewCell

-(void)fillWithTransaction:(Transaction *)transaction;

-(void) showCreditorActionView:(BOOL)boolean;

-(void) showDebitorActionView:(BOOL)boolean;

-(void) commentIsOpen:(BOOL)open;

-(void) setAvatar:(UIImage *)image;

@property(assign,nonatomic)id<HistoryDetailCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lblComment;
@property (retain, nonatomic) IBOutlet UIView *indicatorColorView;

@property (retain, nonatomic) IBOutlet UIImageView *maskImageView;

@end
