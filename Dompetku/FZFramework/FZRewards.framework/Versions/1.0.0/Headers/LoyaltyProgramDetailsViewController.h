//
//  LoyaltyProgramDetailsViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 19/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/HeaderViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <FZBlackBox/LoyaltyProgramDetailsViewControllerDelegate.h>

//Domain
#import <FZAPI/LoyaltyProgram.h>

@interface LoyaltyProgramDetailsViewController : HeaderViewController

- (id)initWithProgram:(LoyaltyProgram *)program;

@property (nonatomic, assign) id<LoyaltyProgramDetailsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL fromAllPrograms;

@end
