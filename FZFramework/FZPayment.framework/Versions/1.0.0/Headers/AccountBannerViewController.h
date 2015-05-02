//
//  AccountBannerViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 14/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FZBlackBox/AccountBannerViewControllerDelegate.h>
#import <FZBlackBox/AccountBannerViewControllerBB.h>

@interface AccountBannerViewController : AccountBannerViewControllerBB

@property (retain, nonatomic) IBOutlet UIButton *btnGoToOrCloseHistoric;
@property (nonatomic, assign) id<AccountBannerViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrentBalance;
@property (assign, nonatomic, getter = isChangingAvatarRules) BOOL changeAvatarRules;

- (id)init;
- (id)initLight;
- (id)initShowAmount;

- (void)setBalance:(float)balance;

@end
