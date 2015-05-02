//
//  HistoryViewController.h
//  iMobey
//
//  Created by Neopixl on 21/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <FZBlackBox/HeaderViewController.h>

#import "AccountBannerViewController.h"

@interface HistoryViewController : HeaderViewController <UITableViewDataSource, UITableViewDelegate, AccountBannerViewControllerDelegate>

@property (nonatomic) BOOL displayConfirmation;

@end
