//
//  YourLoyaltyProgramDetailsViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 19/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import <FZBlackBox/HeaderViewController.h>


//Domain
#import <FZAPI/LoyaltyProgram.h>
#import <FZAPI/LoyaltyCard.h>

@protocol YourLoyaltyProgramDetailsViewControllerDelegate <NSObject>

- (void)showYourProgramsAndRefreshAllPrograms:(BOOL)needRefresh;

@end

@interface YourLoyaltyProgramDetailsViewController : HeaderViewController

- (id)initWithLoyaltyCard:(LoyaltyCard *)card AndProgram:(LoyaltyProgram *)program;

@property (nonatomic, assign) id<YourLoyaltyProgramDetailsViewControllerDelegate> delegate;

@end
