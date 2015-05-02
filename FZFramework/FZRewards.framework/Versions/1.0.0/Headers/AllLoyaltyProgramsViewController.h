//
//  AllLoyaltyProgramsViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 14/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/HeaderViewController.h>

//Fidelitiz navigation bar
#import "AllLoyaltyProgramsNavBarViewController.h"
#import "AllLoyaltyProgramsNavBarOpenedViewController.h"

//Program details
#import "LoyaltyProgramDetailsViewController.h"

@protocol AllLoyaltyProgramsViewControllerDelegate <NSObject>

- (void)setSgmCtrlProgramsToYourProgramsAndShowYourPrograms;

@end

@interface AllLoyaltyProgramsViewController : HeaderViewController
{
    
}

@property (nonatomic, assign) id<AllLoyaltyProgramsViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITableView *tableViewAllPrograms;

- (id)init;
- (void)loadAllPrograms;

@end
